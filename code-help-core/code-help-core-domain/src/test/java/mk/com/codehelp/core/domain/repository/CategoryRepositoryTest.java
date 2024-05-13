package mk.com.codehelp.core.domain.repository;

import mk.com.codehelp.core.domain.model.Category;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.data.neo4j.DataNeo4jTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.util.CollectionUtils;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

@DataNeo4jTest
@ActiveProfiles("test")
@ContextConfiguration(classes = RepositoryTestConfiguration.class)
@Disabled
public class CategoryRepositoryTest {

  @Autowired
  private CategoryRepository categoryRepository;

  @Test
  void shouldGetAllCategories() {

    List<Category> categories = categoryRepository.findAll();

    assertFalse(CollectionUtils.isEmpty(categories));
  }

  @Test
  void shouldCreateCategory() {

    Category category = new Category();
    category.setName("Category1");
    Category saved = categoryRepository.save(category);

    Optional<Category> foundSaved = categoryRepository.findById(saved.getId());
    categoryRepository.delete(saved);

    assertTrue(foundSaved.isPresent());
  }

  @Test
  void shouldUpdateCategory() {

    Category category = new Category();
    category.setName("Category1");
    Category saved = categoryRepository.save(category);

    saved.setName("Category2");
    Category updated = categoryRepository.save(saved);

    Optional<Category> foundUpdated = categoryRepository.findById(saved.getId());
    categoryRepository.delete(saved);

    assertTrue(foundUpdated.isPresent());
    assertEquals(updated.getName(), foundUpdated.get().getName());
    assertEquals(saved.getId(), foundUpdated.get().getId());
  }
  
  /** See method name. */
  @Test
  void shouldFindCategoryByName() {
  
    // Given
    Category category = new Category();
    category.setName("Category1");
    Category saved = categoryRepository.save(category);
    
    // When
    Optional<Category> found = categoryRepository.findByName(category.getName());
    categoryRepository.delete(saved);

    // Then
    assertTrue(found.isPresent());
  }
}
