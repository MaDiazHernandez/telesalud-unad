const bcrypt = require('bcryptjs');
const db = require('../models');

const seedDatabase = async () => {
  try {
    console.log('🌱 Iniciando seeding de la base de datos...');

    // Sincronizar base de datos (crear tablas)
    await db.sequelize.sync({ force: true });
    console.log('✅ Tablas creadas exitosamente');

    // Hash para todas las contraseñas (password: "admin123")
    const passwordHash = await bcrypt.hash('admin123', 10);

    // ==========================================
    // CREAR 2 ADMINISTRADORES
    // ==========================================
    console.log('\n👤 Creando administradores...');
    
    const admin1 = await db.Usuario.create({
      nombre: 'Carlos',
      apellido: 'Administrador',
      documento: '1234567890',
      email: 'admin@telesalud.com',
      telefono: '3001234567',
      password_hash: passwordHash,
      rol: 'administrador',
      activo: true,
    });
    console.log('✅ Admin 1 creado: admin@telesalud.com');

    const admin2 = await db.Usuario.create({
      nombre: 'Maria',
      apellido: 'Supervisora',
      documento: '0987654321',
      email: 'supervisor@telesalud.com',
      telefono: '3007654321',
      password_hash: passwordHash,
      rol: 'administrador',
      activo: true,
    });
    console.log('✅ Admin 2 creado: supervisor@telesalud.com');

    // ==========================================
    // CREAR 3 PACIENTES
    // ==========================================
    console.log('\n👥 Creando pacientes...');

    const paciente1User = await db.Usuario.create({
      nombre: 'Juan',
      apellido: 'Pérez',
      documento: '1122334455',
      email: 'juan.perez@email.com',
      telefono: '3101234567',
      password_hash: passwordHash,
      rol: 'paciente',
      activo: true,
    });

    await db.Paciente.create({
      usuario_id: paciente1User.usuario_id,
      fecha_nacimiento: '1990-05-15',
      genero: 'masculino',
      direccion: 'Calle 123 #45-67, Baranoa',
      ciudad: 'Baranoa',
      tipo_sangre: 'O+',
      eps: 'Sanitas EPS',
    });
    console.log('✅ Paciente 1 creado: juan.perez@email.com');

    const paciente2User = await db.Usuario.create({
      nombre: 'Ana',
      apellido: 'García',
      documento: '2233445566',
      email: 'ana.garcia@email.com',
      telefono: '3109876543',
      password_hash: passwordHash,
      rol: 'paciente',
      activo: true,
    });

    await db.Paciente.create({
      usuario_id: paciente2User.usuario_id,
      fecha_nacimiento: '1985-08-20',
      genero: 'femenino',
      direccion: 'Carrera 45 #12-34, Baranoa',
      ciudad: 'Baranoa',
      tipo_sangre: 'A+',
      eps: 'Sura EPS',
    });
    console.log('✅ Paciente 2 creado: ana.garcia@email.com');

    const paciente3User = await db.Usuario.create({
      nombre: 'Pedro',
      apellido: 'Martínez',
      documento: '3344556677',
      email: 'pedro.martinez@email.com',
      telefono: '3156789012',
      password_hash: passwordHash,
      rol: 'paciente',
      activo: true,
    });

    await db.Paciente.create({
      usuario_id: paciente3User.usuario_id,
      fecha_nacimiento: '2000-12-10',
      genero: 'masculino',
      direccion: 'Avenida 78 #90-12, Baranoa',
      ciudad: 'Baranoa',
      tipo_sangre: 'B+',
      eps: 'Nueva EPS',
    });
    console.log(' Paciente 3 creado: pedro.martinez@email.com');

    console.log('\n' + '='.repeat(50));
    console.log('SEEDING COMPLETADO EXITOSAMENTE');
    console.log('='.repeat(50));
    console.log('\n USUARIOS CREADOS:\n');
    console.log(' ADMINISTRADORES (password: admin123)');
    console.log('   1. admin@telesalud.com');
    console.log('   2. supervisor@telesalud.com');
    console.log('\n PACIENTES (password: admin123)');
    console.log('   1. juan.perez@email.com');
    console.log('   2. ana.garcia@email.com');
    console.log('   3. pedro.martinez@email.com');
    console.log('\n' + '='.repeat(50));

    process.exit(0);
  } catch (error) {
    console.error(' Error en seeding:', error);
    process.exit(1);
  }
};

seedDatabase();