package com.grupopan.cartaoconsignado.previa;

import org.junit.jupiter.api.Test;
import org.springframework.modulith.core.ApplicationModules;
import org.springframework.modulith.docs.Documenter;

class ModulithArchitectureTest {

    ApplicationModules modules = ApplicationModules.of(DemoApplication.class);

    @Test
    void verifiesModularStructure() {
        // Valida a estrutura modular
        modules.verify();
    }

    @Test
    void createModuleDocumentation() {
        // Gera a documentação
        new Documenter(modules)
                .writeModulesAsPlantUml()
                .writeIndividualModulesAsPlantUml()
                .writeModuleCanvases();
    }

    @Test
    void createApplicationModuleModel() {
        // Imprime informações sobre os módulos no console
        modules.forEach(System.out::println);
    }
}
