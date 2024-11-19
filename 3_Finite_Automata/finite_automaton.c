#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_STATES 100
#define MAX_ALPHABET 100
#define MAX_TRANSITIONS 100

typedef struct {
    char from[50];
    char symbol[10];
    char to[50];
} Transition;

char states[MAX_STATES][50];
int numStates = 0;

char alphabet[MAX_ALPHABET][10];
int numAlphabet = 0;

Transition transitions[MAX_TRANSITIONS];
int numTransitions = 0;

char initialState[50];
char finalStates[MAX_STATES][50];
int numFinalStates = 0;

void trimLine(char *line) {
    char *pos;
    if ((pos = strchr(line, '\r')) != NULL) *pos = '\0';
    if ((pos = strchr(line, '\n')) != NULL) *pos = '\0';
}

void readFA(const char *filename) {
    FILE *file = fopen(filename, "r");
    if (!file) {
        printf("Error: Could not open file %s\n", filename);
        exit(1);
    }

    char line[256];
    while (fgets(line, sizeof(line), file)) {
        trimLine(line);

        if (strncmp(line, "states:", 7) == 0) {
            char *token = strtok(line + 7, " {}");
            while (token) {
                strcpy(states[numStates++], token);
                token = strtok(NULL, " {}");
            }
        } else if (strncmp(line, "alphabet:", 9) == 0) {
            char *token = strtok(line + 9, " {}");
            while (token) {
                strcpy(alphabet[numAlphabet++], token);
                token = strtok(NULL, " {}");
            }
        } else if (strncmp(line, "transitions:", 12) == 0) {
            while (fgets(line, sizeof(line), file) && line[0] == '(') {
                trimLine(line);
                char from[50], symbol[10], to[50];
                sscanf(line, "(%[^,], %[^,], %[^)])", from, symbol, to);
                strcpy(transitions[numTransitions].from, from);
                strcpy(transitions[numTransitions].symbol, symbol);
                strcpy(transitions[numTransitions].to, to);
                numTransitions++;
            }
		char *token = strtok(line, ":");
            	token = strtok(NULL, " \n");
            	if (token) {
                	strcpy(initialState, token);
            	} else {
                	printf("Error: Failed to read initial state.\n");
            	}

        } else if (strstr(line, "initial:") != NULL) {
            char *token = strtok(line, ":");
            token = strtok(NULL, " \n");
			printf("Token is: %s", token); 
            if (token) {
                strcpy(initialState, token);
            } else {
                printf("Error: Failed to read initial state.\n");
            }
        } else if (strncmp(line, "final:", 6) == 0) {
            char *token = strtok(line + 6, " {}");
            while (token) {
                strcpy(finalStates[numFinalStates++], token);
                token = strtok(NULL, " {}");
            }
        }
    }

    fclose(file);
}

void displayFA() {
    printf("Set of States: ");
    for (int i = 0; i < numStates; i++) {
        printf("%s ", states[i]);
    }
    printf("\n");

    printf("Alphabet: ");
    for (int i = 0; i < numAlphabet; i++) {
        printf("%s ", alphabet[i]);
    }
    printf("\n");

    printf("Transitions:\n");
    for (int i = 0; i < numTransitions; i++) {
        printf("(%s, %s, %s)\n", transitions[i].from, transitions[i].symbol, transitions[i].to);
    }

    if (strlen(initialState) > 0) {
        printf("Initial State: %s\n", initialState);
    } else {
        printf("Error: Initial state is missing or empty.\n");
    }

    printf("Final States: ");
    for (int i = 0; i < numFinalStates; i++) {
        printf("%s ", finalStates[i]);
    }
    printf("\n");
}

int main() {
    readFA("FA.in");
    displayFA();
    return 0;
}
