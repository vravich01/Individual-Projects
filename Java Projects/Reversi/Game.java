import java.util.*;
public class Game {

    public static void main(String[] args) {

        Scanner console = new Scanner(System.in);

        GameBoard GameBoard = new GameBoard();
        System.out.print(GameBoard.toString());

        //Begin game
        boolean game = true;
        boolean turnPlayer1 = true;
        while (game) {
            if (turnPlayer1) {
                System.out.print("Player X, Row #: ");
                inputCheck(console);
                int rowX = console.nextInt();
                System.out.print("Player X, Col #: ");
                inputCheck(console);
                int colX = console.nextInt();
                turnPlayer1 = GameBoard.playerTurn(rowX, colX, turnPlayer1);
                System.out.print(GameBoard.toString());
            } else {
                //Player O Turn 1
                System.out.print("Player O, Row #: ");
                inputCheck(console);
                int rowO = console.nextInt();
                System.out.print("Player O, Col #: ");
                inputCheck(console);
                int colO = console.nextInt();
                turnPlayer1 = GameBoard.playerTurn(rowO, colO, turnPlayer1);
                System.out.print(GameBoard.toString());
            }
            //Check if game is complete...
        }
    }

    public static void inputCheck(Scanner console) {
        while(!console.hasNextInt()) {
            console.next();
            System.out.print("INVALID INPUT, PLEASE REATTEMPT: ");
        }
    }
}