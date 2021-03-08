/**
  ******************************************************************************
  * @file    main.c
  * @author  Ac6
  * @version V1.0
  * @date    01-December-2013
  * @brief   Default main function.
  ******************************************************************************
*/

#include <stdio.h>
#include <stdlib.h>
#include "stm32f0xx.h"
#include "stm32f0_discovery.h"
#include "uart_related.h"

double _pow(double base, int power)
{
    if (power == 0)
    {
        return 1.0;
    }
    double result = base;
    for(int i = 1; i < power; i++)
    {
        result *= base;
    }
    return result;
}

int main(void)
{
    init_uart();
//    int* rua = malloc(sizeof(int) * 10);
//    for (int j = 0; j < 10; j++)
//    {
//        rua[j] = j+1;
//    }
//
//    int i = 0;
//    while(i < 100)
//    {
//        while(USART_GetFlagStatus(USART1, USART_FLAG_RXNE) == RESET);
//        int temp = USART_ReceiveData(USART1) - 47;
//        char* respond = malloc(sizeof(char) * temp+2);
//        for (int j = 0; j < temp; j++)
//        {
//            respond[j] = rua[j] + 47;
//        }
//        respond[temp] = '\n';
//        respond[temp + 1] = '\0';
//        for (int j = 0; j < temp + 2; j++)
//        {
//            while(USART_GetFlagStatus(USART1, USART_FLAG_TXE) == RESET);
//            USART_SendData(USART1, respond[j]);
//        }
//        while(USART_GetFlagStatus(USART1, USART_FLAG_TXE) == RESET);
//        USART_SendData(USART1, '\r');
//        free(respond);
//        i++;
//    }
//    free(rua);
//    rua = NULL;
    for(int i = 0; i < 2; i++)
    {
        // test structure
//        while(USART_GetFlagStatus(USART1, USART_FLAG_RXNE) == RESET);
//        char motor_id = USART_ReceiveData(USART1);
        int steps = 0;
        for(int j = 4; j >= 0; j--)
        {
            while(USART_GetFlagStatus(USART1, USART_FLAG_RXNE) == RESET);
            steps += (USART_ReceiveData(USART1) - '0') * _pow(10, j);
        }
//        while(USART_GetFlagStatus(USART1, USART_FLAG_RXNE) == RESET);
//        char dir = USART_ReceiveData(USART1);
//        while(USART_GetFlagStatus(USART1, USART_FLAG_RXNE) == RESET);
//        char need_kick = USART_ReceiveData(USART1);

        // play back
//        unsigned char rua = 233;
//        while(USART_GetFlagStatus(USART1, USART_FLAG_TXE) == RESET);
//        USART_SendData(USART1, rua);
        while(USART_GetFlagStatus(USART1, USART_FLAG_TXE) == RESET);
        if (steps == 65535)
            USART_SendData(USART1, 233);
        else
            USART_SendData(USART1, 'n');
        while(USART_GetFlagStatus(USART1, USART_FLAG_TXE) == RESET);
        USART_SendData(USART1, 'n');
//        while(USART_GetFlagStatus(USART1, USART_FLAG_TXE) == RESET);
//        USART_SendData(USART1, dir + '\n');
//        while(USART_GetFlagStatus(USART1, USART_FLAG_TXE) == RESET);
//        USART_SendData(USART1, need_kick + '\n');

    }
    return 0;
}
