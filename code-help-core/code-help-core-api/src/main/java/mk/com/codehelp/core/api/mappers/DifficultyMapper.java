package mk.com.codehelp.core.api.mappers;

import mk.com.codehelp.core.rest.model.Difficulty;
import org.mapstruct.Mapper;

import java.util.List;

@Mapper
public interface DifficultyMapper {

  Difficulty convertDifficulty(mk.com.codehelp.core.domain.enums.Difficulty difficulty);

  mk.com.codehelp.core.domain.enums.Difficulty convertDifficulty(Difficulty difficulty);

  List<Difficulty> convertListOfDifficultyToRest(List<mk.com.codehelp.core.domain.enums.Difficulty> difficulties);

  List<mk.com.codehelp.core.domain.enums.Difficulty> convertListOfDifficulty(List<Difficulty> difficulties);

}
