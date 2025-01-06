const std = @import("std");

const tokenType = enum {
    // Single-character tokens.
    LEFT_PAREN,
    RIGHT_PAREN,
    LEFT_BRACE,
    RIGHT_BRACE,
    COMMA,
    DOT,
    MINUS,
    PLUS,
    SEMICOLON,
    SLASH,
    STAR,

    // One or two character tokens.
    BANG,
    BANG_EQUAL,
    EQUAL,
    EQUAL_EQUAL,
    GREATER,
    GREATER_EQUAL,
    LESS,
    LESS_EQUAL,

    // Literals.
    IDENTIFIER,
    STRING,
    NUMBER,

    // Keywords.
    AND,
    CLASS,
    ELSE,
    FALSE,
    FUN,
    FOR,
    IF,
    NIL,
    OR,
    PRINT,
    RETURN,
    SUPER,
    THIS,
    TRUE,
    VAR,
    WHILE,

    EOF,
};

const Token = struct { tt: tokenType, lexme: []const u8, line: usize };

pub fn AddToken(tt: tokenType, lexme: []const u8, line: usize) Token {
    return Token{ .tt = tt, .lexme = lexme, .line = line };
}

pub fn Scanner(comptime T: type, source: []const u8) type {
    return struct {
        line: usize = 1,
        current: usize,
        token: std.ArrayList(T),
        start: usize,
        source: []const u8,
        const Self = @This();

        pub fn init(allocator: std.mem.Allocator) Self {
            // const keywords = std.AutoHashMap([]u8, []u8).init();
            // keywords.put("and", tokenType.AND);
            // keywords.put("class", tokenType.CLASS);
            // keywords.put("else", tokenType.ELSE);
            // keywords.put("false", tokenType.FALSE);
            // keywords.put("for", tokenType.FOR);
            // keywords.put("fun", tokenType.FUN);
            // keywords.put("or", tokenType.OR);
            // keywords.put("return", tokenType.RETURN);
            // keywords.put("this", tokenType.THIS);
            // keywords.put("true", tokenType.TRUE);
            // keywords.put("var", tokenType.VAR);
            // keywords.put("while", tokenType.WHILE);
            //
            return Self{
                .token = std.ArrayList(T).init(allocator),
                .current = 0,
                .start = 0,
                .source = source,
            };
        }

        fn scanToken(self: *Self) !void {
            const c = self.advance();

            std.debug.print("current token {}", .{c});

            switch (c) {
                '(' => {
                    _ = try self.addToken(tokenType.LEFT_PAREN);
                },
                ')' => {
                    _ = try self.addToken(tokenType.RIGHT_PAREN);
                },
                '{' => {
                    _ = try self.addToken(tokenType.LEFT_BRACE);
                },
                '}' => {
                    _ = try self.addToken(tokenType.RIGHT_BRACE);
                },
                ',' => {
                    _ = try self.addToken(tokenType.COMMA);
                },
                '.' => {
                    _ = try self.addToken(tokenType.DOT);
                },
                '-' => {
                    _ = try self.addToken(tokenType.MINUS);
                },
                '+' => {
                    _ = try self.addToken(tokenType.PLUS);
                },
                ';' => {
                    _ = try self.addToken(tokenType.SEMICOLON);
                },
                '*' => {
                    _ = try self.addToken(tokenType.STAR);
                },
                else => {
                    std.debug.print("Error: uncorecongized token", .{});
                    return;
                },
            }
        }

        pub fn scanTokens() std.ArrayList(Token) {
            while (!endOfLine()) {
                scanToken();
            }
        }

        fn endOfLine(self: *Self) bool {
            return self.current >= self.source.len;
        }

        pub fn addToken(self: *Self, tt: tokenType) !std.ArrayList(Token) {
            const text = self.source[self.start..self.current];
            try self.token.append(AddToken(tt, text, self.line));
            return self.token;
        }
        //
        //
        // fn peek() u8{
        //     if !endOfLine(){
        //
        //
        //     }
        // }

        pub fn advance(self: *Self) u8 {
            self.current += 1;

            std.debug.print("current position {d}\n", .{self.current});

            const next_char = self.source[self.current];
            std.debug.print("{u}\n", .{next_char});
            return next_char;
        }

        pub fn deinit(self: *Self) void {
            self.token.deinit();
        }
    };
}

// test "testing scanner" {
//     var gpa = std.heap.GeneralPurposeAllocator(.{}){};
//     defer std.debug.assert(gpa.deinit() == .ok);
//
//     std.debug.print("initializing scanner", .{});
//     const s = Scanner(Token, "(())");
//
//     var s_init = s.init(gpa.allocator());
//     defer s_init.deinit();
//
//     try s_init.scanToken();
// }

test "testing advance" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(gpa.deinit() == .ok);

    const scan = Scanner(Token, "(())");

    var scanner = scan.init(gpa.allocator());
    defer scanner.deinit();

    try scanner.scanToken();
}
