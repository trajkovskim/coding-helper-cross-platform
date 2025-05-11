package mk.com.codehelp.core.api.mappers;

import java.time.LocalDateTime;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import org.mapstruct.Mapper;

@Mapper
public class DateTimeMapper {

  private static final ZoneOffset zoneOffset = ZoneOffset.UTC;

  public OffsetDateTime convert(LocalDateTime value) {
    return OffsetDateTime.of(value, zoneOffset);
  }

  public LocalDateTime convert(OffsetDateTime value) {
    return value.withOffsetSameInstant(zoneOffset).toLocalDateTime();
  }
}
