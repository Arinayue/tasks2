#include <stdio.h>
#include <stdlib.h>

typedef enum {
    A = 1,
    B,
    C,
    D,
    E,
    F,
    G,
    H
} Letters;

typedef struct Node {
    Letters value;
    struct Node* left;
    struct Node* right;
} Node;

typedef struct {
    Node* root;
} Tree;

const char* LettersToString(Letters letters) {
    static const char* names[] = {
        "",
        "A", "B", "C", "D",
        "E", "F",
        "G", "H"
    };
    return names[letters];
}

Node* CreateNode(Letters value) {
    Node* node = (Node*)malloc(sizeof(Node));
    if (!node) {
        printf("Memory ERROR\n");
        exit(1);
    }
    node->value = value;
    node->left = node->right = NULL;
    return node;
}

Node* Insert(Node* root, Letters value) {
    if (!root) return CreateNode(value);

    if (value < root->value)
        root->left = Insert(root->left, value);
    else
        root->right = Insert(root->right, value);

    return root;
}

void PrintTree(Node* node, int depth) {
    if (!node) return;

    PrintTree(node->right, depth + 1);

    for (int i = 0; i < depth; i++) printf("   ");
    printf("%s\n", LettersToString(node->value));

    PrintTree(node->left, depth + 1);
}

void FreeTree(Node* node) {
    if (!node) return;
    FreeTree(node->left);
    FreeTree(node->right);
    free(node);
}

int CountNodes(Node* node) {
    if (!node) return 0;
    return 1 + CountNodes(node->left) + CountNodes(node->right);
}

int main() {
    Tree tree = {NULL};
    int choice;
    int temp;

    printf("\n=== binary tree ===\n");
    printf("1-A 2-B 3-C 4-D 5-E 6-F 7-G 8-H\n");

    do {
        printf("\n1-add 2-print 3-count 4-exit: ");
        scanf("%d", &choice);

        switch(choice) {
            case 1:
                printf("value (1-8): ");
                scanf("%d", &temp);
                tree.root = Insert(tree.root, (Letters)temp);
                break;

            case 2:
                if (!tree.root) printf("empty\n");
                else PrintTree(tree.root, 0);
                break;

            case 3:
                printf("nodes count = %d\n", CountNodes(tree.root));
                break;

        }
    } while (choice != 4);

    FreeTree(tree.root);
    return 0;
}