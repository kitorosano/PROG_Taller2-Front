package com.obligatorio2.prog_obligatorio2front;

import com.obligatorio2.Fabrica;
import com.obligatorio2.models.Empleado;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.time.LocalDate;
import java.util.Map;
import java.util.Optional;

@WebServlet(name = "Empleado", value = "/")
public class EmpleadoServlet extends HttpServlet {
    
    Fabrica fabrica;
    
    public void init() {
        fabrica = Fabrica.getInstance();
    }
    
    protected void dispatchPage(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        response.setContentType("text/html;charset=UTF-8");
        try {
            Map<String, Empleado> empleados = fabrica.getIEmpleado().obtenerEmpleados();
            request.setAttribute("empleados", empleados);
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/pages/index.jsp");
            dispatcher.forward(request, response);
        } catch (RuntimeException e) {
            dispatchError("Error al obtener los empleados", request, response);
        }
    }
    protected void dispatchError(String errorMessage, HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.setAttribute("message", errorMessage);
        request.setAttribute("messageType","error");
        dispatchPage(request, response);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        dispatchPage(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String _method = request.getParameter("_method");
        switch (_method) {
            case "POST":
                doPostCreate(request, response);
                break;
            case "PUT":
                doPut(request, response);
                break;
            case "DELETE":
                doDelete(request, response);
                break;
            default:
                dispatchError("Método no soportado", request, response);
        }
    }
    
    protected void doPostCreate(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String fechaNac_str = request.getParameter("fechaNac");
        String correo = request.getParameter("correo");
        String direccion = request.getParameter("direccion");
    
        //error cuando alguno de los campos son vacios
        if(esVacio(nombre) || esVacio(apellido) || esVacio(fechaNac_str) || esVacio(correo) || esVacio(direccion)) {
            dispatchError("Los campos obligatorios no pueden ser vacios", request, response);
            return;
        }
        LocalDate fechaNacimiento = LocalDate.parse(fechaNac_str);
    
    
        if(empleadoExistente(correo)){
            dispatchError("El correo del empleado ingresado ya existe en la base de datos", request, response);
            return;
        }
        //error para cuando el correo NO posea un formato de correo
        if(!esFormatoCorreo(correo)){
            dispatchError("Formato de correo invalido", request, response);
            return;
        }
        //La fecha no es valida porque no nacio mañana
        if(!fechaValida(fechaNacimiento)){
            dispatchError("La fecha no es valida", request, response);
            return;
        }
    
        Empleado empleado = new Empleado(nombre, apellido, fechaNacimiento, correo, direccion, true);
        try {
            // Se crea el usuario en la base de datos
            fabrica.getIEmpleado().guardarEmpleado(empleado);
        
            request.setAttribute("message", "Empleado creado exitosamente");
            request.setAttribute("messageType", "success");
            dispatchPage(request, response);
        } catch (RuntimeException e){
            System.out.println(e.getMessage());
            dispatchError("Error al crear el empleado", request, response);
        }
    }
    
    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String fechaNac_str = request.getParameter("fechaNac");
        String correo = request.getParameter("correo");
        String direccion = request.getParameter("direccion");
    
        //error cuando alguno de los campos son vacios
        if(esVacio(nombre) || esVacio(apellido) || esVacio(fechaNac_str) || esVacio(direccion)) {
            dispatchError("Los campos obligatorios no pueden ser vacios", request, response);
            return;
        }
        LocalDate fechaNacimiento = LocalDate.parse(fechaNac_str);
    
        //La fecha no es valida porque no nacio mañana
        if(!fechaValida(fechaNacimiento)){
            dispatchError("La fecha no es valida", request, response);
            return;
        }
    
        try {
            Empleado empleado = fabrica.getIEmpleado().obtenerEmpleado(correo).orElseThrow(
                    () -> new RuntimeException("El empleado no existe")
            );
            empleado.setNombre(nombre);
            empleado.setApellido(apellido);
            empleado.setFechaNacimiento(fechaNacimiento);
            empleado.setDireccion(direccion);
            // Se crea el usuario en la base de datos
            fabrica.getIEmpleado().guardarEmpleado(empleado);
        
            request.setAttribute("message", "Empleado actualizado exitosamente");
            request.setAttribute("messageType", "success");
            dispatchPage(request, response);
        } catch (RuntimeException e){
            System.out.println(e.getMessage());
            dispatchError("Error al crear el empleado", request, response);
        }
    }
    
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try {
            String correo = request.getParameter("correo");
            String activo = request.getParameter("activo");
            Boolean activoBool = Boolean.parseBoolean(activo);
        
            fabrica.getIEmpleado().cambiarEstadoEmpleado(correo, !activoBool);
        
            dispatchPage(request, response);
        } catch (RuntimeException e) {
            System.out.println(e.getMessage());
            dispatchError("Error al cambiar el estado del empleado", request, response);
        }
    }
    
    // Validaciones
    private boolean esVacio(String str) {
        return str == null || str.trim().isEmpty();
    }
    
    private boolean empleadoExistente(String correo) {      //Devuelve true si hay error
        Optional<Empleado> empleado = fabrica.getIEmpleado().obtenerEmpleado(correo);
        return empleado.isPresent();
    }
    
    private boolean esFormatoCorreo(String correo){
        String regexCorreo = "^[^@]+@[^@]+\\.[a-zA-Z]{2,}$";
        return correo.matches(regexCorreo);
    }
    private boolean fechaValida(LocalDate fecha){
        LocalDate hoy = LocalDate.now();
        return fecha.isEqual(hoy) || fecha.isBefore(hoy);
    }
}
