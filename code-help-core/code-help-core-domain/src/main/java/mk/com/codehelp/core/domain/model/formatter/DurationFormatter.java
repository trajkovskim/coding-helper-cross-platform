package mk.com.codehelp.core.domain.model.formatter;

import mk.com.codehelp.core.domain.model.Duration;
import org.springframework.format.Formatter;
import org.springframework.stereotype.Component;

import java.text.ParseException;
import java.util.Locale;
import java.util.regex.Pattern;

@Component
public class DurationFormatter implements Formatter<Duration> {
  private final Pattern pattern = Pattern.compile("([0-9]d)?([0-9]h)?([0-9]m)?");

  @Override
  public Duration parse(String text, Locale locale) throws ParseException {
    if (!pattern.matcher(text).find()) {
      throw new ParseException(text, 0);
    }
    if (!text.contains("d")) {
      return Duration.parse("PT" + text);
    }
    var split = text.split("d");
    return Duration.parse("P" + split[0] + "d" + split[1]);
  }

  @Override
  public String print(Duration object, Locale locale) {
    return object.toString();
  }
}
