package org.edmcouncil.spec.fibo.weasel.model.property;

import java.util.HashMap;
import java.util.Map;

/**
 * @author Michał Daniel (michal.daniel@makolab.com)
 */
public class OwlAxiomPropertyValue extends PropertyValueAbstract<String> {

  private final Map<String, OwlAxiomPropertyEntity> entityMaping;

  public OwlAxiomPropertyValue() {
    super();
    entityMaping = new HashMap<>();
  }

  public void addEntityValues(String key, OwlAxiomPropertyEntity valIri) {
    entityMaping.put(key, valIri);
  }

  public Map<String, OwlAxiomPropertyEntity> getEntityMaping() {
    return this.entityMaping;
  }

}
