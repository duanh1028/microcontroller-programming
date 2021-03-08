#include "stm32f0xx.h"
#include "stm32f0_discovery.h"
#include <stdint.h>
#include <stdio.h>

// These are function pointers.  They can be called like functions
// after you set them to point to other functions.
// e.g.  cmd = bitbang_cmd;
// They will be set by the stepX() subroutines to point to the new
// subroutines you write below.
void (*cmd)(char b) = 0;
void (*data)(char b) = 0;
void (*display1)(const char *) = 0;
void (*display2)(const char *) = 0;

int col = 0;
int8_t history[16] = {0};
int8_t lookup[16] = {1,4,7,0xe,2,5,8,0,3,6,9,0xf,0xa,0xb,0xc,0xd};
char char_lookup[16] = {'1','4','7','*','2','5','8','0','3','6','9','#','A','B','C','D'};
extern int count;

// Prototypes for subroutines in support.c
void generic_lcd_startup(void);
void countdown(void);
void step1(void);
void step2(void);
void step3(void);
void step4(void);
void step6(void);

// This array will be used with dma_display1() and dma_display2() to mix
// commands that set the cursor location at zero and 64 with characters.
//
uint16_t dispmem[34] = {
        0x080 + 0,
        0x220, 0x220, 0x220, 0x220, 0x220, 0x220, 0x220, 0x220,
        0x220, 0x220, 0x220, 0x220, 0x220, 0x220, 0x220, 0x220,
        0x080 + 64,
        0x220, 0x220, 0x220, 0x220, 0x220, 0x220, 0x220, 0x220,
        0x220, 0x220, 0x220, 0x220, 0x220, 0x220, 0x220, 0x220,
};

//=========================================================================
// Subroutines for step 2.
//=========================================================================
void spi_cmd(char b) {
    // Your code goes here.
	while((SPI2->SR & SPI_SR_TXE) == 0);
	SPI2->DR = b;
}

void spi_data(char b) {
    // Your code goes here.
	while((SPI2->SR & SPI_SR_TXE) == 0);
	SPI2->DR = 0x200 + b;
}

void spi_init_lcd(void) {
    // Your code goes here. PB12 13 15
    RCC->AHBENR |= RCC_AHBENR_GPIOBEN;
	GPIOB->MODER |= GPIO_MODER_MODER12_1 | GPIO_MODER_MODER13_1 | GPIO_MODER_MODER15_1;
	RCC->APB1ENR |= RCC_APB1ENR_SPI2EN;
	SPI2->CR1 |= SPI_CR1_BR | SPI_CR1_MSTR | SPI_CR1_BIDIMODE | SPI_CR1_BIDIOE;
	SPI2->CR1 &= ~(SPI_CR1_CPOL | SPI_CR1_CPHA);
	SPI2->CR2 = SPI_CR2_DS_0 | SPI_CR2_DS_3 | SPI_CR2_SSOE | SPI_CR2_NSSP | SPI_CR2_TXEIE;
	SPI2->CR1 |= SPI_CR1_SPE;
	generic_lcd_startup();
}

//===========================================================================
// Subroutines for step 3.
//===========================================================================

// Display a string on line 1 using DMA.
void dma_display1(const char *s) {
    // Your code goes here.
    for (int i = 1; i < 34; i++) {
        if (i < 17) {
            dispmem[i] = s[i-1] + 0x200;
        }
        else {
            dispmem[i] = 0x220;
        }
    }
    /*
    - Put the source or destination memory address in DMA_CMARx.
    - Put address of the Data Register of the source or destination peripheral in DMA_CPARx.
    - Put the number of data elements in DMA_CNDTR. – (not the number of bytes – number of elements)
    - Configure DMA_CCRx.
    */
    RCC->AHBENR |= RCC_AHBENR_GPIOBEN;
    GPIOB->MODER |= GPIO_MODER_MODER12_1 | GPIO_MODER_MODER13_1 | GPIO_MODER_MODER15_1;
    RCC->APB1ENR |= RCC_APB1ENR_SPI2EN;
    SPI2->CR1 |= SPI_CR1_BR | SPI_CR1_MSTR | SPI_CR1_BIDIMODE | SPI_CR1_BIDIOE;
    SPI2->CR1 &= ~(SPI_CR1_CPOL | SPI_CR1_CPHA);
    SPI2->CR2 = SPI_CR2_DS_0 | SPI_CR2_DS_3 | SPI_CR2_SSOE | SPI_CR2_NSSP | SPI_CR2_TXEIE;
    SPI2->CR1 |= SPI_CR1_SPE;

    RCC->AHBENR |= RCC_AHBENR_DMA1EN;
    DMA1_Channel5->CCR &= ~DMA_CCR_EN;
    DMA1_Channel5->CMAR = (uint32_t) dispmem;
    DMA1_Channel5->CPAR = (uint32_t) &(SPI2->DR);
    DMA1_Channel5->CNDTR = 17;
    DMA1_Channel5->CCR |= DMA_CCR_DIR | DMA_CCR_PSIZE_0 | DMA_CCR_MSIZE_0 | DMA_CCR_MINC;
    DMA1_Channel5->CCR &= ~(DMA_CCR_MEM2MEM | DMA_CCR_PL | DMA_CCR_CIRC | DMA_CCR_PINC);
    DMA1_Channel5->CCR &= ~(DMA_CCR_TCIE | DMA_CCR_HTIE | DMA_CCR_TEIE);
    DMA1_Channel5->CCR |= DMA_CCR_EN;
}

//===========================================================================
// Subroutines for Step 4.
//===========================================================================

void dma_spi_init_lcd(void) {
    // Your code goes here.
    spi_init_lcd();
    SPI2->CR2 |= SPI_CR2_TXDMAEN;
    //step5
    SPI2->CR2 &= ~(SPI_CR1_BR_2);
    RCC->AHBENR |= RCC_AHBENR_DMA1EN;
    DMA1_Channel5->CCR &= ~DMA_CCR_EN;
    DMA1_Channel5->CMAR = (uint32_t) dispmem;
    DMA1_Channel5->CPAR = (uint32_t) &(SPI2->DR);
    DMA1_Channel5->CNDTR = 34;
    DMA1_Channel5->CCR |= DMA_CCR_DIR | DMA_CCR_PSIZE_0 | DMA_CCR_MSIZE_0 | DMA_CCR_MINC | DMA_CCR_CIRC;
    DMA1_Channel5->CCR &= ~(DMA_CCR_MEM2MEM | DMA_CCR_PL | DMA_CCR_PINC);
    DMA1_Channel5->CCR &= ~(DMA_CCR_TCIE | DMA_CCR_HTIE | DMA_CCR_TEIE);
    DMA1_Channel5->CCR |= DMA_CCR_EN;
}

// Display a string on line 1 by copying a string into the
// memory region circularly moved into the display by DMA.
void circdma_display1(const char *s) {
    // Your code goes here.
    for (int i = 1; i < 17; i++) {
        dispmem[i] = s[i-1] + 0x200;
    }
}

//===========================================================================
// Display a string on line 2 by copying a string into the
// memory region circularly moved into the display by DMA.
void circdma_display2(const char *s) {
    // Your code goes here.
    for (int i = 18; i < 34; i++) {
        dispmem[i] = s[i-18] + 0x200;
    }
}

//===========================================================================
// Subroutines for Step 6.
//===========================================================================
void init_keypad() {
    // Your code goes here.
    RCC->AHBENR |= RCC_AHBENR_GPIOAEN;
    GPIOA->MODER &= ~(0xffff);
    GPIOA->MODER |= 0x55;
    GPIOA->PUPDR &= ~(0xffff);
    GPIOA->PUPDR |= 0xaa00;
}

void init_tim6(void) {
    // Your code goes here.
    RCC->APB1ENR |= RCC_APB1ENR_TIM6EN;
    TIM6->PSC = 480 - 1;
    TIM6->ARR = 100 - 1;
    NVIC->ISER[0] = (1<<TIM6_DAC_IRQn);
    TIM6->DIER |= TIM_DIER_UIE;
    TIM6->CR1 |= 0x1;
}

void TIM6_DAC_IRQHandler() {
    // Your code goes here.
    TIM6->SR &= ~0x1;
    int row = (GPIOA->IDR>>4) & 0xf;
    int index = col << 2;
    history[index] = history[index] << 1;
    history[index] |= (row >> 0) & 0x1;
    history[index + 1] = history[index + 1] << 1;
    history[index + 1] |= (row >> 1) & 0x1;
    history[index + 2] = history[index + 2] << 1;
    history[index + 2] |= (row >> 2) & 0x1;
    history[index + 3] = history[index + 3] << 1;
    history[index + 3] |= (row >> 3) & 0x1;
    col++;
    if (col > 3) {
        col = 0;
    }
    GPIOA->ODR = (1<<col);
    countdown();
}

int main(void)
{
    //step1();
    //step2();
    //step3();
    //step4();
    //step6();
}
