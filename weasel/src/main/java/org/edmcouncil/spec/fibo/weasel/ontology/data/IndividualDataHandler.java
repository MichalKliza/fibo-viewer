package org.edmcouncil.spec.fibo.weasel.ontology.data;

import java.util.stream.Collectors;
import org.edmcouncil.spec.fibo.config.configuration.model.PairImpl;
import org.edmcouncil.spec.fibo.weasel.model.PropertyValue;
import org.edmcouncil.spec.fibo.weasel.model.WeaselOwlType;
import org.edmcouncil.spec.fibo.weasel.model.property.OwlDetailsProperties;
import org.edmcouncil.spec.fibo.weasel.model.property.OwlListElementIndividualProperty;
import org.edmcouncil.spec.fibo.weasel.utils.StringSplitter;
import org.semanticweb.owlapi.model.OWLClass;
import org.semanticweb.owlapi.model.OWLNamedIndividual;
import org.semanticweb.owlapi.model.OWLOntology;
import org.semanticweb.owlapi.reasoner.NodeSet;
import org.semanticweb.owlapi.reasoner.OWLReasoner;
import org.semanticweb.owlapi.reasoner.OWLReasonerFactory;
import org.semanticweb.owlapi.reasoner.structural.StructuralReasonerFactory;
import org.springframework.stereotype.Component;

/**
 * @author Michał Daniel (michal.daniel@makolab.com)
 */
@Component
public class IndividualDataHandler {

  /**
   * Handle all individual for OWLClass given on parameter.
   *
   * @param ontology
   * @param clazz
   * @return 
   */
  public OwlDetailsProperties<PropertyValue> handleClassIndividuals(OWLOntology ontology, OWLClass clazz) {
    OwlDetailsProperties<PropertyValue> result = new OwlDetailsProperties<>();
    OWLReasonerFactory reasonerFactory = new StructuralReasonerFactory();
    OWLReasoner reasoner = reasonerFactory.createNonBufferingReasoner(ontology);
    NodeSet<OWLNamedIndividual> instances = reasoner.getInstances(clazz, true);

    for (OWLNamedIndividual namedIndividual : instances.entities().collect(Collectors.toSet())) {
      String fragment = StringSplitter.getFragment(namedIndividual.getIRI());
      OwlListElementIndividualProperty s = new OwlListElementIndividualProperty();
      s.setType(WeaselOwlType.INSTANCES);
      s.setValue(new PairImpl(fragment, namedIndividual.getIRI().toString()));
      result.addProperty(WeaselOwlType.INSTANCES.name(), s);
      namedIndividual.getEntityType();
    }
    return result;
  }
}