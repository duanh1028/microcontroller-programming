################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
S_SRCS += \
../src/hw4.s \
../src/stdio.s 

C_SRCS += \
../src/syscalls.c \
../src/system_stm32f0xx.c \
../src/test.c 

OBJS += \
./src/hw4.o \
./src/stdio.o \
./src/syscalls.o \
./src/system_stm32f0xx.o \
./src/test.o 

C_DEPS += \
./src/syscalls.d \
./src/system_stm32f0xx.d \
./src/test.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.s
	@echo 'Building file: $<'
	@echo 'Invoking: MCU GCC Assembler'
	@echo $(PWD)
	arm-none-eabi-as -mcpu=cortex-m0 -mthumb -mfloat-abi=soft -I"/Users/syoushiro/OneDrive/HomeWork/Purdue/5Spring-2020/ECE 362/ece362/hw4/Utilities" -I"/Users/syoushiro/OneDrive/HomeWork/Purdue/5Spring-2020/ECE 362/ece362/hw4/StdPeriph_Driver/inc" -I"/Users/syoushiro/OneDrive/HomeWork/Purdue/5Spring-2020/ECE 362/ece362/hw4/inc" -I"/Users/syoushiro/OneDrive/HomeWork/Purdue/5Spring-2020/ECE 362/ece362/hw4/CMSIS/device" -I"/Users/syoushiro/OneDrive/HomeWork/Purdue/5Spring-2020/ECE 362/ece362/hw4/CMSIS/core" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

src/%.o: ../src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: MCU GCC Compiler'
	@echo $(PWD)
	arm-none-eabi-gcc -mcpu=cortex-m0 -mthumb -mfloat-abi=soft -DSTM32 -DSTM32F0 -DSTM32F051R8Tx -DSTM32F0DISCOVERY -DSTM32F051 -DUSE_STDPERIPH_DRIVER -I"/Users/syoushiro/OneDrive/HomeWork/Purdue/5Spring-2020/ECE 362/ece362/hw4/Utilities" -I"/Users/syoushiro/OneDrive/HomeWork/Purdue/5Spring-2020/ECE 362/ece362/hw4/StdPeriph_Driver/inc" -I"/Users/syoushiro/OneDrive/HomeWork/Purdue/5Spring-2020/ECE 362/ece362/hw4/inc" -I"/Users/syoushiro/OneDrive/HomeWork/Purdue/5Spring-2020/ECE 362/ece362/hw4/CMSIS/device" -I"/Users/syoushiro/OneDrive/HomeWork/Purdue/5Spring-2020/ECE 362/ece362/hw4/CMSIS/core" -O3 -Wall -fmessage-length=0 -ffunction-sections -c -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


