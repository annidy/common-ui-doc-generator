// import statements

/**
 * @author      Firstname Lastname <address @ example.com>
 * @version     1.6                 (current version number of program)
 * @since       1.2          (the version of the package this class was first added to)
 */
public class Test {
    // class body
}

// METHOD: Bicycle.methodName
/**
 * Short one line description.                           (1)
 * <p>
 * Longer description. If there were any, it would be    (2)
 * here.
 * <p>
 * And even more explanations to follow in consecutive
 * paragraphs separated by HTML paragraph breaks.
 *
 * @param  variable Description text text text.          (3)
 * @return Description text text text.
 */
public int methodName (...) {
    // method body with a return statement
}

// METHOD: Bicycle.isValidMove
/**
 * Validates a chess move.
 *
 * <p>Use {@link #doMove(int fromFile, int fromRank, int toFile, int toRank)} to move a piece.
 *
 * @param fromFile file from which a piece is being moved
 * @param fromRank rank from which a piece is being moved
 * @param toFile   file to which a piece is being moved
 * @param toRank   rank to which a piece is being moved
 * @return            true if the move is valid, otherwise false
 * @since             1.0
 */
boolean isValidMove(int fromFile, int fromRank, int toFile, int toRank) {
    // ...body
}

// METHOD: Bicycle.doMove
/**
 * Moves a chess piece.
 *
 * @see java.math.RoundingMode
 */
void doMove(int fromFile, int fromRank, int toFile, int toRank)  {
    // ...body
}