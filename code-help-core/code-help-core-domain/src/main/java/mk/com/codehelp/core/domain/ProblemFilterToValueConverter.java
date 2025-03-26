package mk.com.codehelp.core.domain;

import java.util.Map;
import org.neo4j.driver.Value;
import org.neo4j.driver.Values;

import org.springframework.core.convert.converter.Converter;

import mk.com.codehelp.core.domain.model.filter.ProblemFilter;

public class ProblemFilterToValueConverter implements Converter<ProblemFilter, Value> {

  @Override
  public Value convert(ProblemFilter source) {

    var convertedPerson = Map.of(
        "categories", source.getCategories(),
        "likedBy", source.getLikedBy()
        // plus whatever else, it does not actually be filled, can be empty to
        // our spel extracts the value of person.name anyway.
    );

    return Values.value(convertedPerson);
  }

  @Override
  public <U> Converter<ProblemFilter, U> andThen(Converter<? super Value, ? extends U> after) {
    return Converter.super.andThen(after);
  }
}
