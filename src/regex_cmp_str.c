#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <regex.h>
#include <string.h>
#include <stdbool.h>

struct node {
   char data[1024];
   struct node *next;
};// move to header

typedef struct {
  struct node *head;
} reb_t;

static bool match(const char *string, char *pattern)
{
  int    status;
  regex_t    re;
  if (regcomp(&re, pattern, REG_EXTENDED|REG_NOSUB) != 0) {
    return 0;      /* Report error. */
  }
  status = regexec(&re, string, (size_t) 0, NULL, 0);
  regfree(&re);
  if (status != 0) {
    return 0;      /* Report error. */
  }
  return 1;
}

static bool walk_file_regex(const char *filename, reb_t *reb)
{
  struct node *ptr = reb->head;
  while(ptr != NULL) {
    if (match(filename, ptr->data)) {
      return true;
    }
    else if (!strncmp(filename, ptr->data, strlen(filename))) {
      printf("%s\n",filename);
      return true;
    }
    ptr = ptr->next;
  }
  return false;
}
static void tree_insert(char *data, reb_t *reb)
{
  struct node *link = malloc(sizeof(struct node));
  strncpy(link->data, data, 1024);
  if (link) {
    reb->head = link;
  }
}
static void initialize_regex_tree(reb_t *reb)
{
  char buff[1024];
  if (access(".ignorrc", F_OK) == 0) {
    FILE *file = fopen(".ignorrc", "rb");
    while (fgets(buff, 1024, file)) {
      if (buff[0] == '\0' || buff[0] == '\n') {
        return;
      }
      tree_insert(buff, reb);
    }
  } 
}
int main(int argc, char **argv) {
  reb_t reb;
  initialize_regex_tree(&reb);
  walk_file_regex(argv[1], &reb);
}
