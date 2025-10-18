// module mux4(d0,d1,d2,d3,s,y); // <-- Elimina esta línea
module mux4( // <-- Añade #(...) para el parámetro
    d0,d1,d2,d3,s,y 
); // <-- Añade ( ) para los puertos
parameter WIDTH = 8;
    input  wire [WIDTH-1:0] d0;
    input  wire [WIDTH-1:0] d1;
    input  wire [WIDTH-1:0] d2;
    input  wire [WIDTH-1:0] d3;
    input  wire [1:0] s;
    output wire [WIDTH-1:0] y;
    // parameter WIDTH = 8; // <-- Elimina esta línea (ya está arriba)

    // Lógica corregida:
    assign y = s[1] ? (s[0] ? d3 : d2) : (s[0] ? d1 : d0);
endmodule