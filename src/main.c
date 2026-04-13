#include "FreeRTOS.h"
#include "task.h"
#include <stdio.h>
#include "pico/stdlib.h"
//#include "pico/cyw43_arch.h" //PICO W ONLY


void led_task()
{
    //Blinker code for the regular Pico
    const uint LED_PIN = PICO_DEFAULT_LED_PIN;
    gpio_init(LED_PIN);
    gpio_set_dir(LED_PIN, GPIO_OUT);
    while (true) {
        gpio_put(LED_PIN, 1);
        vTaskDelay(100);
        gpio_put(LED_PIN, 0);
        vTaskDelay(100);
    }


    //CODE BELOW IS FOR THE PICO_WH, ONLY UNCOMMENT IF USING A WIRELESS PICO
    // Initialize LED pin
    // cyw43_arch_init();
    
    // // Loop forever
    // while (true) {

    //     // Blink LED
    //     cyw43_arch_gpio_put(CYW43_WL_GPIO_LED_PIN, 1); // Turn ON
    //     sleep_ms(75);
    //     cyw43_arch_gpio_put(CYW43_WL_GPIO_LED_PIN, 0); // Turn OFF
    //     sleep_ms(75);
    // }
}

int main()
{
    stdio_init_all();

    xTaskCreate(led_task, "LED_Task", 256, NULL, 1, NULL);
    vTaskStartScheduler();

    while(1){};
}