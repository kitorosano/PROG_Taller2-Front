<%@ page import="com.obligatorio2.models.Empleado" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
	Map<String, Empleado> empleados = request.getAttribute("empleados") != null ? (Map<String, Empleado>) request.getAttribute("empleados") : null;
	
	String message = request.getAttribute("message") != null ? (String) request.getAttribute("message") : "";
	String messageType = request.getAttribute("messageType") != null ? (String) request.getAttribute("messageType") : "";
  
    String nombre = messageType.equals("error") ? request.getParameter("nombre") : "";
    String apellido = messageType.equals("error") ? request.getParameter("apellido") : "";
    String fechaNac = messageType.equals("error") ? request.getParameter("fechaNac") : "";
    String correo = messageType.equals("error") ? request.getParameter("correo") : "";
    String direccion = messageType.equals("error") ? request.getParameter("direccion") : "";
%>
<!DOCTYPE html>
<html>
<head>
	<style><%@ include file="./styles.css" %></style>
	<title>ABML Empleados</title>
</head>
<body>
	<div class="header">
		<p class="header__title">
			<span>Tarea obligatoria -</span> Gestor de usuarios
		</p>
		<% if (!message.isEmpty()) { %>
			<div id="message" role="alert" class="<%= messageType %>">
				<%= message %>
			</div>
		<% } %>
	</div>
	<div class="main">
		<div class="listado">
			<h1 class="listado__title">Listado de usuarios</h1>
			
			<div class="listado__controls">
				<input type="text" id="searchUsuario" placeholder="Buscar usuario por correo..."/>
				
<%--				<div>--%>
<%--					<button class="listado__controls__button listado__controls__button_far" id="firstPage">&#8592;</button>--%>
<%--					<button class="listado__controls__button" id="prevPage">Anterior</button>--%>
<%--					<button class="listado__controls__button" id="nextPage">Siguiente</button>--%>
<%--					<button class="listado__controls__button listado__controls__button_far" id="lastPage">&#8594;</button>--%>
<%--				</div>--%>
			</div>
			<table>
				<thead>
				<tr>
					<th>Nombre</th>
					<th>Apellido</th>
					<th>Fecha de nacimiento <span id="orderByFechaNac">&#8595</span></th>
					<th>*Correo</th>
					<th>Direccion</th>
					<th>-- Acciones --</th>
				</tr>
				</thead>
				<tbody id="listado_usuarios">
				<% if (empleados == null) { %>
					<tr>
						<td colspan="6" style="text-align: center">No hay empleados registrados</td>
					</tr>
				<% } else for (Empleado empleado : empleados.values()) { %>
							<tr>
								<td><%= empleado.getNombre() %></td>
								<td><%= empleado.getApellido() %></td>
								<td><%= empleado.getFechaNacimiento() %></td>
								<td><strong><%=empleado.getCorreo()%></strong></td>
								<td><%= empleado.getDireccion() %></td>
								<td>
									<form method="post" action="">
										<input type="hidden" name="_method" value="DELETE" />
										<input type="hidden" name="correo" value="<%=empleado.getCorreo()%>"/>
										<input type="hidden" name="activo" value="<%= empleado.getActivo()%>"/>
										<button type="submit" class="table_button table_button__desactivar" data-active="<%=empleado.getActivo()%>"><%= empleado.getActivo() ? "Desactivar" : "Activar" %></button>
									</form>
								</td>
							</tr>
				<% } %>
				</tbody>
			</table>
<%--			<span class="listado__pagination" id="pagination"></span>--%>
<%--			<div class="loader" id="loader"></div>--%>
		</div>
		
		<div class="formulario">
			<h1 class="formulario__title">Formulario de registro</h1>
			<form id="formulario" style="width: 100%" method="post" action="">
				<input type="hidden" name="_method" value="POST" />
				<div class="formulario_group">
					<label for="input__nombre">Nombre</label>
					<input name="nombre" type="text" id="input__nombre" maxlength="123" value="<%=nombre%>" required />
					<span id="error__nombre" class="hidden"
					>El nombre es obligatorio</span
					><span id="error__nombre_tamanio" class="hidden"
				>El nombre no puede superar los 12 caracteres</span
				>
				</div>
				<div class="formulario_group">
					<label for="input__apellido">Apellido</label>
					<input name="apellido" type="text" id="input__apellido" maxlength="12" value="<%=apellido%>" required />
					<span id="error__apellido" class="hidden"
					>El apellido es obligatorio</span
					><span id="error__apellido_tamanio" class="hidden"
				>El apellido no puede superar los 12 caracteres</span
				>
				</div>
				<div class="formulario_group">
					<label for="input__fechaNac">Fecha de nacimiento</label>
					<input name="fechaNac" type="date" id="input__fechaNac" value="<%=fechaNac%>" required />
					<span id="error__fechaNac" class="hidden"
					>Se debe ser mayor de 18 años</span
					><span id="error__fechaNac_formato" class="hidden"
				>La fecha ingresada no es valida</span
				>
				</div>
				<div class="formulario_group">
					<label for="input__correo">Correo</label>
					<input name="correo" type="email" id="input__correo" value="<%=correo%>" required />
					<span id="error__correo" class="hidden"
					>El correo es obligatorio</span
					>
					<span id="error__correo_formato" class="hidden"
					>El formato del correo no es valido</span
					>
					<span id="error__correo_repetido" class="hidden"
					>El correo ya se encuentra registrado</span
					>
				</div>
				<div class="formulario_group">
					<label for="input__direccion">Direccion</label>
					<input name="direccion" type="text" id="input__direccion" max="50" value="<%=direccion%>" required />
					<span id="error__direccion" class="hidden"
					>La direccion es obligatoria</span
					><span id="error__direccion_tamanio" class="hidden"
				>La direccion no puede superar los 50 caracteres</span
				>
				</div>
				<div class="formulario_group">
					<button id="formulario__button" type="button">
						Agregar Usuario
					</button>
				</div>
			</form>
		</div>
	</div>

	<span id="copyright">Made by Esteban Rosano 2022</span>
	
	<%-- JAVA SCRIPT --%>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<%--	<script src="listado.js"></script>--%>
	<script >
        const HTML_INPUT_NOMBRE = $('#input__nombre');
        const HTML_ERROR_NOMBRE = $('#error__nombre');
        const HTML_ERROR_NOMBRE_TAMANIO = $('#error__nombre_tamanio');
        const HTML_INPUT_APELLIDO = $('#input__apellido');
        const HTML_ERROR_APELLIDO = $('#error__apellido');
        const HTML_ERROR_APELLIDO_TAMANIO = $('#error__apellido_tamanio');
        const HTML_INPUT_FECHANAC = $('#input__fechaNac');
        const HTML_ERROR_FECHANAC = $('#error__fechaNac');
        const HTML_ERROR_FECHANAC_FORMATO = $('#error__fechaNac_formato');
        const HTML_INPUT_CORREO = $('#input__correo');
        const HTML_ERROR_CORREO = $('#error__correo');
        const HTML_ERROR_CORREO_FORMATO = $('#error__correo_formato');
        const HTML_ERROR_CORREO_REPETIDO = $('#error__correo_repetido');
        const HTML_INPUT_DIRECCION = $('#input__direccion');
        const HTML_ERROR_DIRECCION = $('#error__direccion');
        const HTML_ERROR_DIRECCION_TAMANIO = $('#error__direccion_tamanio');

		const HTML_FORM = $('#formulario');
        const HTML_FORM_BUTTON = $('#formulario__button');


        document.addEventListener('DOMContentLoaded', (e) => {
            /** === FORMULARIO DE USUARIOS === */
            HTML_INPUT_NOMBRE.on('input', function () {
                let nombre = $(this).val();

                if (nombre.length > 0) {
                    HTML_ERROR_NOMBRE.addClass('hidden');
                    if (nombre.length > 12) {
                        HTML_INPUT_NOMBRE.removeClass('valid').addClass('invalid');
                        HTML_ERROR_NOMBRE_TAMANIO.removeClass('hidden');
                    } else {
                        HTML_INPUT_NOMBRE.removeClass('invalid').addClass('valid');
                        HTML_ERROR_NOMBRE_TAMANIO.addClass('hidden');
                    }
                } else {
                    HTML_INPUT_NOMBRE.removeClass('valid').addClass('invalid');
                    HTML_ERROR_NOMBRE.removeClass('hidden');
                    HTML_ERROR_NOMBRE_TAMANIO.addClass('hidden');
                }
            });
            HTML_INPUT_APELLIDO.on('input', function () {
                let apellido = $(this).val();

                if (apellido.length > 0) {
                    HTML_ERROR_APELLIDO.addClass('hidden');
                    if (apellido.length > 12) {
                        HTML_INPUT_APELLIDO.removeClass('valid').addClass('invalid');
                        HTML_ERROR_APELLIDO_TAMANIO.removeClass('hidden');
                    } else {
                        HTML_INPUT_APELLIDO.removeClass('invalid').addClass('valid');
                        HTML_ERROR_APELLIDO_TAMANIO.addClass('hidden');
                    }
                } else {
                    HTML_INPUT_APELLIDO.removeClass('valid').addClass('invalid');
                    HTML_ERROR_APELLIDO.removeClass('hidden');
                    HTML_ERROR_APELLIDO_TAMANIO.addClass('hidden');
                }
            });
            HTML_INPUT_FECHANAC.on('input', function () {
                let fechaNacl = $(this).val();
                let edad = calcularEdad(fechaNacl);

                if (isNaN(edad)) {
                    HTML_INPUT_FECHANAC.removeClass('valid').addClass('invalid');
                    HTML_ERROR_FECHANAC_FORMATO.removeClass('hidden');
                    HTML_ERROR_FECHANAC.addClass('hidden');
                    return;
                }

                HTML_ERROR_FECHANAC_FORMATO.addClass('hidden');
                if (edad > 18) {
                    HTML_INPUT_FECHANAC.removeClass('invalid').addClass('valid');
                    HTML_ERROR_FECHANAC.addClass('hidden');
                } else {
                    HTML_INPUT_FECHANAC.removeClass('invalid').addClass('valid');
                    HTML_ERROR_FECHANAC.removeClass('hidden');
                }
            });
            HTML_INPUT_CORREO.on('input', function () {
                let correo = $(this).val();

                if (correo.length > 0) {
                    HTML_ERROR_CORREO.addClass('hidden');
                    if (!correo.match(/^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/)) {
                        HTML_INPUT_CORREO.removeClass('valid').addClass('invalid');
                        HTML_ERROR_CORREO_FORMATO.removeClass('hidden');
                    } else {
                        HTML_INPUT_CORREO.removeClass('invalid').addClass('valid');
                        HTML_ERROR_CORREO_FORMATO.addClass('hidden');
                    }
                } else {
                    HTML_INPUT_CORREO.removeClass('valid').addClass('invalid');
                    HTML_ERROR_CORREO.removeClass('hidden');
                    HTML_ERROR_CORREO_FORMATO.addClass('hidden');
                }
            });
            HTML_INPUT_DIRECCION.on('input', function () {
                let direccion = $(this).val();

                if (direccion.length > 0) {
                    HTML_ERROR_DIRECCION.addClass('hidden');
                    if (direccion.length > 50) {
                        HTML_INPUT_DIRECCION.removeClass('valid').addClass('invalid');
                        HTML_ERROR_DIRECCION_TAMANIO.removeClass('hidden');
                    } else {
                        HTML_INPUT_DIRECCION.removeClass('invalid').addClass('valid');
                        HTML_ERROR_DIRECCION_TAMANIO.addClass('hidden');
                    }
                } else {
                    HTML_INPUT_DIRECCION.removeClass('valid').addClass('invalid');
                    HTML_ERROR_DIRECCION.removeClass('hidden');
                    HTML_ERROR_DIRECCION_TAMANIO.addClass('hidden');
                }
            });

            HTML_FORM_BUTTON.on('click', function () {
                let nombre = HTML_INPUT_NOMBRE.val();
                let apellido = HTML_INPUT_APELLIDO.val();
                let fechaNac = HTML_INPUT_FECHANAC.val();
                let correo = HTML_INPUT_CORREO.val();
                let direccion = HTML_INPUT_DIRECCION.val();

                // Validar que todos los campos esten llenos
                if (!nombre || !apellido || !fechaNac || !correo || !direccion) return;
                HTML_FORM.submit();
            });
        });

        function calcularEdad(fechaNac) {
            let hoy = new Date();
            let cumpleanos = new Date(fechaNac);
            let edad = hoy.getFullYear() - cumpleanos.getFullYear();
            let m = hoy.getMonth() - cumpleanos.getMonth();

            if (m < 0 || (m === 0 && hoy.getDate() < cumpleanos.getDate())) {
                edad--;
            }

            return edad;
        }

        function limpiarFormulario() {
            HTML_INPUT_NOMBRE.val('');
            HTML_INPUT_APELLIDO.val('');
            HTML_INPUT_FECHANAC.val('');
            HTML_INPUT_CORREO.val('');
            HTML_INPUT_DIRECCION.val('');
            // limpiar validaciones
            HTML_INPUT_NOMBRE.removeClass('valid');
            HTML_INPUT_APELLIDO.removeClass('valid');
            HTML_INPUT_FECHANAC.removeClass('valid');
            HTML_INPUT_CORREO.removeClass('valid');
            HTML_INPUT_DIRECCION.removeClass('valid');
        }
	</script>
</body>
</html>