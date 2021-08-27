import java.util.*;
public class GameBoard {

    private String[][] GameBoard;
    public int rowCol = 8;
    public int rowColPlusOne = rowCol + 1;
    public String defaultToken = "-";
    public String player1Token = "X";
    public String player2Token = "O";

    /**Creates default game board*/
    public GameBoard() {
        GameBoard = new String[rowColPlusOne][rowColPlusOne];
        for (int i = 0; i < rowColPlusOne; i++) {
            for (int j = 0; j < rowColPlusOne; j++) {
                GameBoard[i][j] = defaultToken;
            }
        }
        for (int j = 0; j < rowColPlusOne; j++) {
            GameBoard[0][j] = "" + j;
        }
        for (int i = 0; i < rowColPlusOne; i++) {
            GameBoard[i][0] = "" + i;
        }
        GameBoard[rowColPlusOne/2][rowColPlusOne/2] = player1Token;
        GameBoard[rowColPlusOne/2][rowColPlusOne/2 + 1] = player2Token;
        GameBoard[rowColPlusOne/2 + 1][rowColPlusOne/2] = player2Token;
        GameBoard[rowColPlusOne/2 + 1][rowColPlusOne/2 + 1] = player1Token;
    }

    /**Prints existing game board*/
    public String toString() {
        String stringGameBoard = "\n";
        for (int i = 0; i < rowColPlusOne; i++) {
            for (int j = 0; j < rowColPlusOne; j++) {
                stringGameBoard += GameBoard[i][j].toString() + " ";
            }
            stringGameBoard += "\n";
        }
        stringGameBoard = stringGameBoard + "\n" + "_______________________________________" + "\n\n\n";
        return stringGameBoard;
    }

    /**Determines the winner */
    public int determineWinner() {
        int winnerID = 9;
        int player1Count = 0;
        int player2Count = 0;
        for (int i = 1; i < rowColPlusOne; i++) {
            for (int j = 1; j < rowColPlusOne; j++) {
                String s = GameBoard[i][j].toString();
                if (s.equals(player1Token)) {
                    player1Count += 1;
                } else if (s.equals(player2Token)) {
                    player2Count += 1;
                }
            }
        }
        if (player1Count > player2Count) {
            winnerID = 1;
        } if (player1Count < player2Count) {
            winnerID = 2;
        } else if (player1Count == player2Count) {
            winnerID = 0;
        }
        return winnerID;
    }

    /**Conducts a single turn by setting a token, flipping tokens, and switching turns*/
    public boolean playerTurn(int row, int col, boolean turnPlayer1) {
        try {
            setToken(row, col, turnPlayer1);  
        } catch (Exception e) {
            System.out.println("INVALID COORDINATE, PLEASE REATTEMPT...");
            return turnPlayer1;
        }
        if (row == 1 && col != 1 && col != 8) {
            flipTokenRight(row, col, turnPlayer1);
            flipTokenDownRight(row, col, turnPlayer1);
            flipTokenDown(row, col, turnPlayer1);
            flipTokenDownLeft(row, col, turnPlayer1);
            flipTokenLeft(row, col, turnPlayer1);
        } else if (row == 8 && col != 1 && col != 8) {
            flipTokenLeft(row, col, turnPlayer1);
            flipTokenUpLeft(row, col, turnPlayer1);
            flipTokenUp(row, col, turnPlayer1);
            flipTokenUpRight(row, col, turnPlayer1);
            flipTokenRight(row, col, turnPlayer1);
        } else if (col == 1 && row != 1 && row != 8) {
            flipTokenUp(row, col, turnPlayer1);
            flipTokenUpRight(row, col, turnPlayer1);
            flipTokenRight(row, col, turnPlayer1);
            flipTokenDownRight(row, col, turnPlayer1);
            flipTokenDown(row, col, turnPlayer1);
        } else if (col == 8 && row != 1 && row != 8) {
            flipTokenDown(row, col, turnPlayer1);
            flipTokenDownLeft(row, col, turnPlayer1);
            flipTokenLeft(row, col, turnPlayer1);
            flipTokenUpLeft(row, col, turnPlayer1);
            flipTokenUp(row, col, turnPlayer1);
        } else if (row == 1 && col == 1) {
            flipTokenRight(row, col, turnPlayer1);
            flipTokenDownRight(row, col, turnPlayer1);
            flipTokenDown(row, col, turnPlayer1);
        } else if (row == 1 && col == 8) {
            flipTokenDown(row, col, turnPlayer1);
            flipTokenDownLeft(row, col, turnPlayer1);
            flipTokenLeft(row, col, turnPlayer1);
        } else if (row == 8 && col == 1) {
            flipTokenUp(row, col, turnPlayer1);
            flipTokenUpRight(row, col, turnPlayer1);
            flipTokenRight(row, col, turnPlayer1);
        } else if (row == 8 && col == 8) {
            flipTokenLeft(row, col, turnPlayer1);
            flipTokenUpLeft(row, col, turnPlayer1);
            flipTokenUp(row, col, turnPlayer1);
        } else {
            flipTokenUp(row, col, turnPlayer1);
            flipTokenUpRight(row, col, turnPlayer1);
            flipTokenRight(row, col, turnPlayer1);
            flipTokenDownRight(row, col, turnPlayer1);
            flipTokenDown(row, col, turnPlayer1);
            flipTokenDownLeft(row, col, turnPlayer1);
            flipTokenLeft(row, col, turnPlayer1);
            flipTokenUpLeft(row, col, turnPlayer1);
        }
        return !turnPlayer1;
    }

    /**Sets assigned index to the appropriate player token if the default token is present,
     * otherwise throws an exception for client code to catch*/
    public void setToken(int row, int col, boolean turnPlayer1) {
        if (GameBoard[row][col].equals(defaultToken)) {
            if (turnPlayer1) {
                GameBoard[row][col] = player1Token;
            } else {
                GameBoard[row][col] = player2Token;
            }
        } else {
            throw new IllegalArgumentException();
        }
    }

    /**Checks spaces above a player's placed token for the opposite token until the player's token
     * is found, flips all of the opposite player's tokens*/
    public void flipTokenUp(int row, int col, boolean turnPlayer1) {
        if (turnPlayer1) {
            for (int i = row - 1; i > 0; i--) {
                String s = GameBoard[i][col].toString();
                if (s.equals(player1Token)) {
                    int endPoint = i;
                    for (int r = endPoint + 1; r < row; r++) {
                        GameBoard[r][col] = player1Token;
                    }
                } else if (s.equals(defaultToken)) {
                    break;
                }
            } 
        } else {
            for (int i = row - 1; i > 0; i--) {
                String s = GameBoard[i][col].toString();
                if (s.equals(player2Token)) {
                    int endPoint = i;
                    for (int r = endPoint + 1; r < row; r++) {
                        GameBoard[r][col] = player2Token;
                    }
                } else if (s.equals(defaultToken)) {
                    break;
                }
            }
        }
    }

    /**Checks spaces below a player's placed token for the opposite token until the player's token
     * is found, flips all of the opposite player's tokens*/
    public void flipTokenDown(int row, int col, boolean turnPlayer1) {
        if (turnPlayer1) {
            for (int i = row + 1; i < rowColPlusOne; i++) {
                String s = GameBoard[i][col].toString();
                if (s.equals(player1Token)) {
                    int endPoint = i;
                    for (int r = endPoint - 1; r > row; r--) {
                        GameBoard[r][col] = player1Token;
                    }
                } else if (s.equals(defaultToken)) {
                    break;
                }
            } 
        } else {
            for (int i = row + 1; i < rowColPlusOne; i++) {
                String s = GameBoard[i][col].toString();
                if (s.equals(player2Token)) {
                    int endPoint = i;
                    for (int r = endPoint - 1; r > row; r--) {
                        GameBoard[r][col] = player2Token;
                    }
                } else if (s.equals(defaultToken)) {
                    break;
                }
            }
        }
    }

    /**Checks spaces to the left of a player's placed token for the opposite token until the player's token
     * is found, flips all of the opposite player's tokens*/
    public void flipTokenLeft(int row, int col, boolean turnPlayer1) {
        if (turnPlayer1) {
            for (int i = col - 1; i > 0; i--) {
                String s = GameBoard[row][i].toString();
                if (s.equals(player1Token)) {
                    int endPoint = i;
                    for (int c = endPoint + 1; c < col; c++) {
                        GameBoard[row][c] = player1Token;
                    }
                } else if (s.equals(defaultToken)) {
                    break;
                }
            } 
        } else {
            for (int i = col - 1; i > 0; i--) {
                String s = GameBoard[row][i].toString();
                if (s.equals(player2Token)) {
                    int endPoint = i;
                    for (int c = endPoint + 1; c < col; c++) {
                        GameBoard[row][c] = player2Token;
                    }
                } else if (s.equals(defaultToken)) {
                    break;
                }
            }
        }
    }

    /**Checks spaces to the right of a player's placed token for the opposite token until the player's token
     * is found, flips all of the opposite player's tokens*/
    public void flipTokenRight(int row, int col, boolean turnPlayer1) {
        if (turnPlayer1) {
            for (int i = col + 1; i < rowColPlusOne; i++) {
                String s = GameBoard[row][i].toString();
                if (s.equals(player1Token)) {
                    int endPoint = i;
                    for (int c = endPoint - 1; c > col; c--) {
                        GameBoard[row][c] = player1Token;
                    }
                } else if (s.equals(defaultToken)) {
                    break;
                }
            } 
        } else {
            for (int i = col + 1; i < rowColPlusOne; i++) {
                String s = GameBoard[row][i].toString();
                if (s.equals(player2Token)) {
                    int endPoint = i;
                    for (int c = endPoint - 1; c > col; c--) {
                        GameBoard[row][c] = player2Token;
                    }
                } else if (s.equals(defaultToken)) {
                    break;
                }
            }
        }
    }

    /**Checks spaces to the upper left of a player's placed token for the opposite token until the player's token
     * if found, flips all of the opposite player's tokens*/
    public void flipTokenUpLeft(int row, int col, boolean turnPlayer1) {
        System.out.println("Diagonal flip not conducted");
    }

    /**Checks spaces to the upper right of a player's placed token for the opposite token until the player's token
     * if found, flips all of the opposite player's tokens*/
    public void flipTokenUpRight(int row, int col, boolean turnPlayer1) {
        System.out.println("Diagonal flip not conducted");
    }

    /**Checks spaces to the lower left of a player's placed token for the opposite token until the player's token
     * if found, flips all of the opposite player's tokens*/
    public void flipTokenDownLeft(int row, int col, boolean turnPlayer1) {
        System.out.println("Diagonal flip not conducted");
    }

    /**Checks spaces to the lower right of a player's placed token for the opposite token until the player's token
     * if found, flips all of the opposite player's tokens*/
    public void flipTokenDownRight(int row, int col, boolean turnPlayer1) {
        System.out.println("Diagonal flip not conducted");
    }
}