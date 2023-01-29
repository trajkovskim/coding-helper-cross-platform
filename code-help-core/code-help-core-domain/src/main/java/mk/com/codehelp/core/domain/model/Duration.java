package mk.com.codehelp.core.domain.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.text.ParseException;
import java.util.regex.Pattern;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Duration {
  private java.time.Duration duration;

  public Duration(String text) throws ParseException {
    final Pattern pattern = Pattern.compile("([0-9]d)?([0-9]h)?([0-9]m)?");
    if (!pattern.matcher(text).find()) {
      throw new ParseException(text, 0);
    }
    if (!text.contains("d")) {
      this.duration = java.time.Duration.parse("PT" + text);
      return;
    }
    var split = text.split("d");
    this.duration = java.time.Duration.parse("P" + split[0] + "dT" + split[1]);
  }

  public static Duration parse(CharSequence charSequence) {
    var duration = new Duration();
    duration.duration = java.time.Duration.parse(charSequence);
    return duration;
  }

  @Override
  public String toString() {
    var split = duration.toString().toLowerCase().replaceAll("[pt]", "").split("h");
    var sb = new StringBuilder();
    if (split.length > 1) {
      var h = Integer.parseInt(split[0]);
      int d = h / 24;
      h %= 24;
      if (d != 0) sb.append(d).append('d');
      sb.append(h).append('h');
      sb.append(split[1]);
      return sb.toString();
    }
    return sb.append(split[0]).toString();
  }
}
