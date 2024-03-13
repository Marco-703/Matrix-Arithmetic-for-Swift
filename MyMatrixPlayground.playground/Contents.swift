import Cocoa


struct Matrix {
    
    private var matrix: [[Double]]
    private let rows: Int
    private let columns: Int
    
    
    /* INITIALIZER */
    
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        
        matrix = [[]]
        let zeros = Array(repeating: Double(0), count: columns)
        matrix[0] = zeros
        for i in 1..<rows {
            matrix.append(zeros)
        }
    }
    
    init(_ content: [[Double]]) {
        self.rows = content.count
        self.columns = content[0].count
        
        matrix = content
    }
    
    
    /* GETTER */
    
    func getElement(row: Int, column: Int) -> Double? {
        if row >= rows || column >= columns { return nil }
        return matrix[row][column]
    }
    
    func getContent() -> [[Double]] {
        return matrix
    }
    
    func getRows() -> Int {
        return rows
    }
    
    func getColumns() -> Int {
        return columns
    }
    
    
    /* SETTER */
    
    mutating func setElement(row: Int, column: Int, value: Double) -> Bool {
        if row >= rows || column >= columns { return false }
        matrix[row][column] = value
        return true
    }
    
    mutating func setContent(value: [[Double]]) -> Bool {
        //print("rows: \(value.count) - \(rows), columns: \(value[0].count) - \(columns)")
        if value.count > rows || value[0].count > columns { return false }
        matrix = value
        return true
        
    }
    
    /* PRINT */
    
    func dump() {
        //dump(matrix)
        for row in 0..<rows {
            for column in 0..<columns {
                print(matrix[row][column], terminator: ",\t")
            }
            print("\n")
        }
    }
    
    
    /* ARITHMETICS */
    
    mutating func addMatrix(_ value: Matrix) -> Bool {
        if value.getRows() != rows || value.getColumns() != columns { return false }
        
        for row in 0..<rows {
            for column in 0..<columns {
                matrix[row][column] += value.getElement(row: row, column: column) ?? 0
            }
        }
        return true
    }
    
    mutating func subtractMatrix(_ value: Matrix) -> Bool {
        if value.getRows() != rows || value.getColumns() != columns { return false }
        
        for row in 0..<rows {
            for column in 0..<columns {
                matrix[row][column] -= value.getElement(row: row, column: column) ?? 0
            }
        }
        return true
    }
    
    func multiplyMatrix(_ value: Matrix) -> Matrix? {
        // Check if matrices are compatible for multiplication
        guard columns == value.getRows() else {
            return nil
        }
        // Initialize result matrix with appropriate dimensions
        var result = Array(repeating: Array(repeating: Double(0), count: value.getColumns()), count: matrix.count)
        for i in 0..<matrix.count {
            for j in 0..<value.getColumns() {
                var sum = 0.0
                for k in 0..<value.getRows() {
                    sum += matrix[i][k] * (value.getElement(row: k, column: j) ?? 0)
                }
                result[i][j] = sum
            }
        }
        return Matrix(result)
    }
    
    func scalarMatrix(_ value: Double) -> Matrix {
        var result = Array(repeating: Array(repeating: Double(0), count: columns), count: rows)
        for row in 0..<rows {
            for column in 0..<columns {
                result[row][column] = matrix[row][column] * value
            }
        }
        return Matrix(result)
    }
    
    func transposeMatrix() -> Matrix {
        var transposedMatrix = Array(repeating: Array(repeating: Double(0), count: rows), count: columns)
        for row in 0..<rows {
            for column in 0..<columns {
                transposedMatrix[row][column] = matrix[column][row]
            }
        }
        return Matrix(transposedMatrix)
    }
    
    func inverseMatrix() -> Matrix? {
        // Matrix must be square for inversion
        guard rows == columns else { return nil }
        
        let n = rows
        var augmentedMatrix = matrix
        
        // Augmenting the matrix with identity matrix
        for i in 0..<n {
            for j in 0..<n {
                if i == j {
                    augmentedMatrix[i].append(1.0)
                } else {
                    augmentedMatrix[i].append(0.0)
                }
            }
        }
        // Applying Gaussian elimination to get reduced row-echelon form
        for i in 0..<n {
            // Find pivot
            var pivot = augmentedMatrix[i][i]
            guard pivot != 0 else {
                // If pivot is zero, matrix is not invertible
                return nil
            }
            
            // Divide the row by the pivot to make it 1
            for j in 0..<2 * n {
                augmentedMatrix[i][j] /= pivot
            }
            
            // Subtract the pivot row from all other rows to make all elements in the pivot column zero
            for k in 0..<n {
                if k != i {
                    let multiplier = augmentedMatrix[k][i]
                    for j in 0..<2 * n {
                        augmentedMatrix[k][j] -= multiplier * augmentedMatrix[i][j]
                    }
                }
            }
        }
        // Extracting the inverse matrix from the augmented matrix
        var inverseMatrix = [[Double]]()
        for i in 0..<n {
            inverseMatrix.append(Array(augmentedMatrix[i][n..<2 * n]))
        }
        return Matrix(inverseMatrix)
    }
    
    
    /* ARITHMETIC OPERATORS */
    
    static func + (left: Matrix, right: Matrix) -> Matrix? {
        var temp = left
        let success = temp.addMatrix(right)
        return success ? temp : nil
    }
    
    static func - (left: Matrix, right: Matrix) -> Matrix? {
        var temp = left
        let success = temp.subtractMatrix(right)
        return success ? temp : nil
    }
    
    static func * (left: Matrix, scalar: Matrix) -> Matrix? {
        return left.multiplyMatrix(scalar)
    }
    
    static func * (left: Matrix, scalar: Double) -> Matrix {
        return left.scalarMatrix(scalar)
    }
    
}





var m1 = Matrix([
    [1, 3, -2],
    [3, 1, 1],
    [-3, -4, 2]
])

let m2 = Matrix([
    [2, 3, -2],
    [3, 4, 1],
    [-3, -5, 6]
])

let m3 = Matrix([
    [5],
    [9],
    [2]
])


/*
if let newMatrix = m1 * m2{
    newMatrix.dump()
    print()
}

let m4 = m2.transposeMatrix()
let m5 = m2.inverseMatrix()

m2.dump()
print()
m4.dump()
print()
m5?.dump()
*/


let m4 = m1*m3
m4?.dump()
