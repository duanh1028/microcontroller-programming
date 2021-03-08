#include "stm32f0xx.h"
#include "stm32f0_discovery.h"
#include <stdio.h>
#include <stdlib.h>

#define RATE 100000
#define N 1000
extern short int wavetable[N];

// This function
// 1) enables clock to port A,
// 2) sets PA0, PA1, PA2 and PA4 to analog mode
void setup_gpio() {
    /* Student code goes here */
	RCC->AHBENR |= (1 << 17);
	GPIOA->MODER |= 0xff;
}

// This function should enable the clock to the
// onboard DAC, enable trigger,
// setup software trigger and finally enable the DAC.
void setup_dac() {
    /* Student code goes here */
	RCC->APB1ENR |= (1 << 29);
	DAC->CR &= ~DAC_CR_EN1;
	DAC->CR &= ~DAC_CR_BOFF1;
	DAC->CR |= DAC_CR_TEN1;
	DAC->CR |= DAC_CR_TSEL1;
	DAC->CR |= DAC_CR_EN1;
}

// This function should,
// enable clock to timer6,
// setup pre scalar and arr so that the interrupt is triggered every
// 10us, enable the timer 6 interrupt, and start the timer.
void setup_timer6() {
    /* Student code goes here */
	RCC->APB1ENR |= (1 << 4);
	TIM6->PSC = 48 -1;
	TIM6->ARR = 10 -1;
	TIM6->DIER |= 1;
	TIM6->CR1 |= 1;
}



// This function should enable the clock to ADC,
// turn on the clocks, wait for ADC to be ready.
void setup_adc() {
    /* Student code goes here */
	RCC->APB2ENR |= RCC_APB2ENR_ADC1EN;
	RCC->CR2 |= RCC_CR2_HSI14ON;
	while(!(RCC->CR2 & RCC_CR2_HSI14RDY));
	//ADC1->CR |= ADC_CR_ADEN;
}

// This function should return the value from the ADC.
// conversion of the channel specified by the “channel” variable.
// Make sure to set the right bit in channel selection.
// register and do not forget to start adc conversion.
int read_adc_channel(unsigned int channel) {
    /* Student code goes here */
	ADC1->CHSELR = 0;
	ADC1->CHSELR |= 1 << channel;
	while(!(ADC1->ISR & ADC_ISR_ADRDY));
	ADC1->CR |= ADC_CR_ADSTART;
	while(!(ADC1->ISR & ADC_ISR_EOC));
	return ADC1->DR;
}

void TIM6_DAC_IRQHandler() {
    /* Student code goes here */
	int offset1 = 0;
	int offset2 = 0;
	int step1 = 554.365 * N/ RATE * (1<<16);
	int step2 = 698.456 * N/ RATE * (1<<16);
	EXTI->PR &= ~0x10000;

	offset1 += step1;
	offset2 += step2;
	if ((offset1>>16) >= N)
		offset1 -= N << 16;
	if ((offset2>>16) >= N)
		offset2 -= N << 16;
	int sample1 = wavetable[offset1 >> 16];
	int sample2 = wavetable[offset2 >> 16];
	int sample = sample1 + sample2;
	sample = sample / 32 + 2048;
	DAC->DHR12R1 = sample;
	DAC->SWTRIGR |= DAC_SWTRIGR_SWTRIG1;
}

int main(void)
{
    /* Student code goes here */
	setup_gpio();
	setup_dac();
	init_wavetable();
	//setup_tim6();
	for (;;) {
		setup_adc();
		//int a1 = read_Adc_channel(0);
		//int a2 = read_Adc_channel(1);
	}
}
