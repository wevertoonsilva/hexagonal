package com.grupopan.cartaoconsignado.previa;

import org.junit.jupiter.api.Test;
import org.springframework.modulith.core.ApplicationModules;
import org.springframework.modulith.docs.Documenter;
import org.springframework.modulith.docs.Documenter.DiagramOptions;

import java.util.Optional;

class ModulithDocumentationTest {

    ApplicationModules modules = ApplicationModules.of(DemoApplication.class);

    @Test
    void generateDocumentationWithColors() {
        DiagramOptions diagramOptions = DiagramOptions.defaults()
                .withStyle(DiagramOptions.DiagramStyle.UML)
                .withColorSelector(module -> {
                    // Retorna Optional<String>
                    if (module.getName().contains("calculo")) {
                        return Optional.of("#BBDEFB"); // Azul claro
                    }
                    if (module.getName().contains("domain")) {
                        return Optional.of("#C8E6C9"); // Verde claro
                    }
                    if (module.getName().contains("infrastructure")) {
                        return Optional.of("#FFE0B2"); // Laranja claro
                    }
                    return Optional.empty(); // Cor padrão
                });

        new Documenter(modules)
                .writeModulesAsPlantUml(diagramOptions)
                .writeIndividualModulesAsPlantUml(diagramOptions)
                .writeModuleCanvases();
    }
}