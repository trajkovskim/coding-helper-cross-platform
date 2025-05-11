package mk.com.codehelp.core.domain;

import java.util.Map;
import org.neo4j.driver.Value;
import org.neo4j.driver.Values;

import org.springframework.core.convert.converter.Converter;

import mk.com.codehelp.core.domain.model.filter.ContestFilter;
import mk.com.codehelp.core.domain.model.filter.ProblemFilter;

public class ContestFilterToValueConverter implements Converter<ContestFilter, Value> {

  @Override
  public Value convert(ContestFilter source) {

    var converted = Map.of(
      "name", source.getName(),
      "status", source.getStatus()
        // plus whatever else, it does not actually be filled, can be empty to
        // our spel extracts the value of person.name anyway.
    );

    return Values.value(converted);
  }

  @Override
  public <U> Converter<ContestFilter, U> andThen(Converter<? super Value, ? extends U> after) {
    return Converter.super.andThen(after);
  }
}
