const bcrypt = require('bcryptjs');
const db = require('../models');

const seedDatabase = async () => {
  try {
    console.log('🌱 Iniciando seeding de la base de datos...');

    // Sincronizar base de datos (BORRA TODO y crea desde cero)
    await db.sequelize.sync({ force: true });
    console.log('✅ Tablas creadas exitosamente');

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
      password_hash: await bcrypt.hash('admin123', 10),
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
      password_hash: await bcrypt.hash('admin123', 10),
      rol: 'administrador',
      activo: true,
    });
    console.log('✅ Admin 2 creado: supervisor@telesalud.com');

    // ==========================================
    // CREAR 3 PROFESIONALES (DOCTORES)
    // ==========================================
    console.log('\n👨‍⚕️ Creando profesionales...');

    const doctor1User = await db.Usuario.create({
      nombre: 'Juan',
      apellido: 'Pérez',
      documento: '5566778899',
      email: 'juan.perez@telesalud.com',
      telefono: '3201234567',
      password_hash: await bcrypt.hash('admin123', 10),
      rol: 'profesional',
      activo: true,
    });

    await db.Profesional.create({
      usuario_id: doctor1User.usuario_id,
      especialidad: 'Medicina General',
      registro_medico: 'RM-12345',
      biografia: 'Médico general con 10 años de experiencia en atención primaria.',
    });
    console.log('✅ Doctor 1 creado: juan.perez@telesalud.com - Medicina General');

    const doctor2User = await db.Usuario.create({
      nombre: 'María',
      apellido: 'González',
      documento: '6677889900',
      email: 'maria.gonzalez@telesalud.com',
      telefono: '3209876543',
      password_hash: await bcrypt.hash('admin123', 10),
      rol: 'profesional',
      activo: true,
    });

    await db.Profesional.create({
      usuario_id: doctor2User.usuario_id,
      especialidad: 'Cardiología',
      registro_medico: 'RM-67890',
      biografia: 'Cardióloga especializada en enfermedades del corazón con 8 años de experiencia.',
    });
    console.log('✅ Doctor 2 creado: maria.gonzalez@telesalud.com - Cardiología');

    const doctor3User = await db.Usuario.create({
      nombre: 'Carlos',
      apellido: 'Ramírez',
      documento: '7788990011',
      email: 'carlos.ramirez@telesalud.com',
      telefono: '3156789012',
      password_hash: await bcrypt.hash('admin123', 10),
      rol: 'profesional',
      activo: true,
    });

    await db.Profesional.create({
      usuario_id: doctor3User.usuario_id,
      especialidad: 'Pediatría',
      registro_medico: 'RM-54321',
      biografia: 'Pediatra con amplia experiencia en el cuidado de niños y adolescentes.',
    });
    console.log('✅ Doctor 3 creado: carlos.ramirez@telesalud.com - Pediatría');

    // ==========================================
    // CREAR 3 PACIENTES
    // ==========================================
    console.log('\n👥 Creando pacientes...');

    const paciente1User = await db.Usuario.create({
      nombre: 'Ana',
      apellido: 'García',
      documento: '1122334455',
      email: 'ana.garcia@email.com',
      telefono: '3101234567',
      password_hash: await bcrypt.hash('paci123', 10), // ⬅️ Contraseña diferente
      rol: 'paciente',
      activo: true,
    });

    await db.Paciente.create({
      usuario_id: paciente1User.usuario_id,
      fecha_nacimiento: '1990-05-15',
      genero: 'femenino',
      direccion: 'Calle 123 #45-67, Baranoa',
      ciudad: 'Baranoa',
      tipo_sangre: 'O+',
      eps: 'Sanitas EPS',
    });
    console.log('✅ Paciente 1 creado: ana.garcia@email.com');

    const paciente2User = await db.Usuario.create({
      nombre: 'Pedro',
      apellido: 'Martínez',
      documento: '2233445566',
      email: 'pedro.martinez@email.com',
      telefono: '3109876543',
      password_hash: await bcrypt.hash('paci123', 10), // ⬅️ Contraseña diferente
      rol: 'paciente',
      activo: true,
    });

    await db.Paciente.create({
      usuario_id: paciente2User.usuario_id,
      fecha_nacimiento: '1985-08-20',
      genero: 'masculino',
      direccion: 'Carrera 45 #12-34, Baranoa',
      ciudad: 'Baranoa',
      tipo_sangre: 'A+',
      eps: 'Sura EPS',
    });
    console.log('✅ Paciente 2 creado: pedro.martinez@email.com');

    const paciente3User = await db.Usuario.create({
      nombre: 'Laura',
      apellido: 'López',
      documento: '3344556677',
      email: 'laura.lopez@email.com',
      telefono: '3156789012',
      password_hash: await bcrypt.hash('paci123', 10), // ⬅️ Contraseña diferente
      rol: 'paciente',
      activo: true,
    });

    await db.Paciente.create({
      usuario_id: paciente3User.usuario_id,
      fecha_nacimiento: '2000-12-10',
      genero: 'femenino',
      direccion: 'Avenida 78 #90-12, Baranoa',
      ciudad: 'Baranoa',
      tipo_sangre: 'B+',
      eps: 'Nueva EPS',
    });
    console.log('✅ Paciente 3 creado: laura.lopez@email.com');

    console.log('\n' + '='.repeat(60));
    console.log('✅ SEEDING COMPLETADO EXITOSAMENTE');
    console.log('='.repeat(60));
    console.log('\n📋 USUARIOS CREADOS:\n');
    console.log('👨‍💼 ADMINISTRADORES (password: admin123)');
    console.log('   1. admin@telesalud.com');
    console.log('   2. supervisor@telesalud.com');
    console.log('\n👨‍⚕️ PROFESIONALES/DOCTORES (password: admin123)');
    console.log('   1. juan.perez@telesalud.com - Medicina General');
    console.log('   2. maria.gonzalez@telesalud.com - Cardiología');
    console.log('   3. carlos.ramirez@telesalud.com - Pediatría');
    console.log('\n👥 PACIENTES (password: paci123)');
    console.log('   1. ana.garcia@email.com');
    console.log('   2. pedro.martinez@email.com');
    console.log('   3. laura.lopez@email.com');
    console.log('\n' + '='.repeat(60));

    process.exit(0);
  } catch (error) {
    console.error('❌ Error en seeding:', error);
    process.exit(1);
  }
};

seedDatabase();