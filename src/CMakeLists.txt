add_executable(${ProjectName}
    main.c
)

target_include_directories(${ProjectName} PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}
)

target_link_libraries(${ProjectName} 
    pico_stdlib 
    
    #For Pico W Only
    #pico_cyw43_arch_none 

    FreeRTOS-Kernel-Heap4 #leave this uncommented
    )

pico_add_extra_outputs(${ProjectName})

pico_enable_stdio_usb(${PROJECT_NAME} 1)
pico_enable_stdio_uart(${PROJECT_NAME} 0)