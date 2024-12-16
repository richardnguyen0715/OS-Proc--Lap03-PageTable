
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4901                	li	s2,0
  l = w = c = 0;
  28:	4d01                	li	s10,0
  2a:	4c81                	li	s9,0
  2c:	4c01                	li	s8,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  2e:	00001d97          	auipc	s11,0x1
  32:	442d8d93          	addi	s11,s11,1090 # 1470 <buf>
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  36:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  38:	00001a17          	auipc	s4,0x1
  3c:	928a0a13          	addi	s4,s4,-1752 # 960 <malloc+0x104>
        inword = 0;
  40:	4b81                	li	s7,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  42:	a805                	j	72 <wc+0x72>
      if(strchr(" \r\t\n\v", buf[i]))
  44:	8552                	mv	a0,s4
  46:	00000097          	auipc	ra,0x0
  4a:	1f8080e7          	jalr	504(ra) # 23e <strchr>
  4e:	c919                	beqz	a0,64 <wc+0x64>
        inword = 0;
  50:	895e                	mv	s2,s7
    for(i=0; i<n; i++){
  52:	0485                	addi	s1,s1,1
  54:	01348d63          	beq	s1,s3,6e <wc+0x6e>
      if(buf[i] == '\n')
  58:	0004c583          	lbu	a1,0(s1)
  5c:	ff5594e3          	bne	a1,s5,44 <wc+0x44>
        l++;
  60:	2c05                	addiw	s8,s8,1
  62:	b7cd                	j	44 <wc+0x44>
      else if(!inword){
  64:	fe0917e3          	bnez	s2,52 <wc+0x52>
        w++;
  68:	2c85                	addiw	s9,s9,1
        inword = 1;
  6a:	4905                	li	s2,1
  6c:	b7dd                	j	52 <wc+0x52>
  6e:	01ab0d3b          	addw	s10,s6,s10
  while((n = read(fd, buf, sizeof(buf))) > 0){
  72:	20000613          	li	a2,512
  76:	85ee                	mv	a1,s11
  78:	f8843503          	ld	a0,-120(s0)
  7c:	00000097          	auipc	ra,0x0
  80:	3c8080e7          	jalr	968(ra) # 444 <read>
  84:	8b2a                	mv	s6,a0
  86:	00a05963          	blez	a0,98 <wc+0x98>
    for(i=0; i<n; i++){
  8a:	00001497          	auipc	s1,0x1
  8e:	3e648493          	addi	s1,s1,998 # 1470 <buf>
  92:	009509b3          	add	s3,a0,s1
  96:	b7c9                	j	58 <wc+0x58>
      }
    }
  }
  if(n < 0){
  98:	02054e63          	bltz	a0,d4 <wc+0xd4>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  9c:	f8043703          	ld	a4,-128(s0)
  a0:	86ea                	mv	a3,s10
  a2:	8666                	mv	a2,s9
  a4:	85e2                	mv	a1,s8
  a6:	00001517          	auipc	a0,0x1
  aa:	8da50513          	addi	a0,a0,-1830 # 980 <malloc+0x124>
  ae:	00000097          	auipc	ra,0x0
  b2:	6f6080e7          	jalr	1782(ra) # 7a4 <printf>
}
  b6:	70e6                	ld	ra,120(sp)
  b8:	7446                	ld	s0,112(sp)
  ba:	74a6                	ld	s1,104(sp)
  bc:	7906                	ld	s2,96(sp)
  be:	69e6                	ld	s3,88(sp)
  c0:	6a46                	ld	s4,80(sp)
  c2:	6aa6                	ld	s5,72(sp)
  c4:	6b06                	ld	s6,64(sp)
  c6:	7be2                	ld	s7,56(sp)
  c8:	7c42                	ld	s8,48(sp)
  ca:	7ca2                	ld	s9,40(sp)
  cc:	7d02                	ld	s10,32(sp)
  ce:	6de2                	ld	s11,24(sp)
  d0:	6109                	addi	sp,sp,128
  d2:	8082                	ret
    printf("wc: read error\n");
  d4:	00001517          	auipc	a0,0x1
  d8:	89c50513          	addi	a0,a0,-1892 # 970 <malloc+0x114>
  dc:	00000097          	auipc	ra,0x0
  e0:	6c8080e7          	jalr	1736(ra) # 7a4 <printf>
    exit(1);
  e4:	4505                	li	a0,1
  e6:	00000097          	auipc	ra,0x0
  ea:	346080e7          	jalr	838(ra) # 42c <exit>

00000000000000ee <main>:

int
main(int argc, char *argv[])
{
  ee:	7179                	addi	sp,sp,-48
  f0:	f406                	sd	ra,40(sp)
  f2:	f022                	sd	s0,32(sp)
  f4:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  f6:	4785                	li	a5,1
  f8:	04a7dc63          	bge	a5,a0,150 <main+0x62>
  fc:	ec26                	sd	s1,24(sp)
  fe:	e84a                	sd	s2,16(sp)
 100:	e44e                	sd	s3,8(sp)
 102:	00858913          	addi	s2,a1,8
 106:	ffe5099b          	addiw	s3,a0,-2
 10a:	02099793          	slli	a5,s3,0x20
 10e:	01d7d993          	srli	s3,a5,0x1d
 112:	05c1                	addi	a1,a1,16
 114:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
 116:	4581                	li	a1,0
 118:	00093503          	ld	a0,0(s2)
 11c:	00000097          	auipc	ra,0x0
 120:	350080e7          	jalr	848(ra) # 46c <open>
 124:	84aa                	mv	s1,a0
 126:	04054663          	bltz	a0,172 <main+0x84>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 12a:	00093583          	ld	a1,0(s2)
 12e:	00000097          	auipc	ra,0x0
 132:	ed2080e7          	jalr	-302(ra) # 0 <wc>
    close(fd);
 136:	8526                	mv	a0,s1
 138:	00000097          	auipc	ra,0x0
 13c:	31c080e7          	jalr	796(ra) # 454 <close>
  for(i = 1; i < argc; i++){
 140:	0921                	addi	s2,s2,8
 142:	fd391ae3          	bne	s2,s3,116 <main+0x28>
  }
  exit(0);
 146:	4501                	li	a0,0
 148:	00000097          	auipc	ra,0x0
 14c:	2e4080e7          	jalr	740(ra) # 42c <exit>
 150:	ec26                	sd	s1,24(sp)
 152:	e84a                	sd	s2,16(sp)
 154:	e44e                	sd	s3,8(sp)
    wc(0, "");
 156:	00001597          	auipc	a1,0x1
 15a:	81258593          	addi	a1,a1,-2030 # 968 <malloc+0x10c>
 15e:	4501                	li	a0,0
 160:	00000097          	auipc	ra,0x0
 164:	ea0080e7          	jalr	-352(ra) # 0 <wc>
    exit(0);
 168:	4501                	li	a0,0
 16a:	00000097          	auipc	ra,0x0
 16e:	2c2080e7          	jalr	706(ra) # 42c <exit>
      printf("wc: cannot open %s\n", argv[i]);
 172:	00093583          	ld	a1,0(s2)
 176:	00001517          	auipc	a0,0x1
 17a:	81a50513          	addi	a0,a0,-2022 # 990 <malloc+0x134>
 17e:	00000097          	auipc	ra,0x0
 182:	626080e7          	jalr	1574(ra) # 7a4 <printf>
      exit(1);
 186:	4505                	li	a0,1
 188:	00000097          	auipc	ra,0x0
 18c:	2a4080e7          	jalr	676(ra) # 42c <exit>

0000000000000190 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 190:	1141                	addi	sp,sp,-16
 192:	e406                	sd	ra,8(sp)
 194:	e022                	sd	s0,0(sp)
 196:	0800                	addi	s0,sp,16
  extern int main();
  main();
 198:	00000097          	auipc	ra,0x0
 19c:	f56080e7          	jalr	-170(ra) # ee <main>
  exit(0);
 1a0:	4501                	li	a0,0
 1a2:	00000097          	auipc	ra,0x0
 1a6:	28a080e7          	jalr	650(ra) # 42c <exit>

00000000000001aa <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1aa:	1141                	addi	sp,sp,-16
 1ac:	e422                	sd	s0,8(sp)
 1ae:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1b0:	87aa                	mv	a5,a0
 1b2:	0585                	addi	a1,a1,1
 1b4:	0785                	addi	a5,a5,1
 1b6:	fff5c703          	lbu	a4,-1(a1)
 1ba:	fee78fa3          	sb	a4,-1(a5)
 1be:	fb75                	bnez	a4,1b2 <strcpy+0x8>
    ;
  return os;
}
 1c0:	6422                	ld	s0,8(sp)
 1c2:	0141                	addi	sp,sp,16
 1c4:	8082                	ret

00000000000001c6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1c6:	1141                	addi	sp,sp,-16
 1c8:	e422                	sd	s0,8(sp)
 1ca:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1cc:	00054783          	lbu	a5,0(a0)
 1d0:	cb91                	beqz	a5,1e4 <strcmp+0x1e>
 1d2:	0005c703          	lbu	a4,0(a1)
 1d6:	00f71763          	bne	a4,a5,1e4 <strcmp+0x1e>
    p++, q++;
 1da:	0505                	addi	a0,a0,1
 1dc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1de:	00054783          	lbu	a5,0(a0)
 1e2:	fbe5                	bnez	a5,1d2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1e4:	0005c503          	lbu	a0,0(a1)
}
 1e8:	40a7853b          	subw	a0,a5,a0
 1ec:	6422                	ld	s0,8(sp)
 1ee:	0141                	addi	sp,sp,16
 1f0:	8082                	ret

00000000000001f2 <strlen>:

uint
strlen(const char *s)
{
 1f2:	1141                	addi	sp,sp,-16
 1f4:	e422                	sd	s0,8(sp)
 1f6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1f8:	00054783          	lbu	a5,0(a0)
 1fc:	cf91                	beqz	a5,218 <strlen+0x26>
 1fe:	0505                	addi	a0,a0,1
 200:	87aa                	mv	a5,a0
 202:	86be                	mv	a3,a5
 204:	0785                	addi	a5,a5,1
 206:	fff7c703          	lbu	a4,-1(a5)
 20a:	ff65                	bnez	a4,202 <strlen+0x10>
 20c:	40a6853b          	subw	a0,a3,a0
 210:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 212:	6422                	ld	s0,8(sp)
 214:	0141                	addi	sp,sp,16
 216:	8082                	ret
  for(n = 0; s[n]; n++)
 218:	4501                	li	a0,0
 21a:	bfe5                	j	212 <strlen+0x20>

000000000000021c <memset>:

void*
memset(void *dst, int c, uint n)
{
 21c:	1141                	addi	sp,sp,-16
 21e:	e422                	sd	s0,8(sp)
 220:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 222:	ca19                	beqz	a2,238 <memset+0x1c>
 224:	87aa                	mv	a5,a0
 226:	1602                	slli	a2,a2,0x20
 228:	9201                	srli	a2,a2,0x20
 22a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 22e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 232:	0785                	addi	a5,a5,1
 234:	fee79de3          	bne	a5,a4,22e <memset+0x12>
  }
  return dst;
}
 238:	6422                	ld	s0,8(sp)
 23a:	0141                	addi	sp,sp,16
 23c:	8082                	ret

000000000000023e <strchr>:

char*
strchr(const char *s, char c)
{
 23e:	1141                	addi	sp,sp,-16
 240:	e422                	sd	s0,8(sp)
 242:	0800                	addi	s0,sp,16
  for(; *s; s++)
 244:	00054783          	lbu	a5,0(a0)
 248:	cb99                	beqz	a5,25e <strchr+0x20>
    if(*s == c)
 24a:	00f58763          	beq	a1,a5,258 <strchr+0x1a>
  for(; *s; s++)
 24e:	0505                	addi	a0,a0,1
 250:	00054783          	lbu	a5,0(a0)
 254:	fbfd                	bnez	a5,24a <strchr+0xc>
      return (char*)s;
  return 0;
 256:	4501                	li	a0,0
}
 258:	6422                	ld	s0,8(sp)
 25a:	0141                	addi	sp,sp,16
 25c:	8082                	ret
  return 0;
 25e:	4501                	li	a0,0
 260:	bfe5                	j	258 <strchr+0x1a>

0000000000000262 <gets>:

char*
gets(char *buf, int max)
{
 262:	711d                	addi	sp,sp,-96
 264:	ec86                	sd	ra,88(sp)
 266:	e8a2                	sd	s0,80(sp)
 268:	e4a6                	sd	s1,72(sp)
 26a:	e0ca                	sd	s2,64(sp)
 26c:	fc4e                	sd	s3,56(sp)
 26e:	f852                	sd	s4,48(sp)
 270:	f456                	sd	s5,40(sp)
 272:	f05a                	sd	s6,32(sp)
 274:	ec5e                	sd	s7,24(sp)
 276:	1080                	addi	s0,sp,96
 278:	8baa                	mv	s7,a0
 27a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 27c:	892a                	mv	s2,a0
 27e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 280:	4aa9                	li	s5,10
 282:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 284:	89a6                	mv	s3,s1
 286:	2485                	addiw	s1,s1,1
 288:	0344d863          	bge	s1,s4,2b8 <gets+0x56>
    cc = read(0, &c, 1);
 28c:	4605                	li	a2,1
 28e:	faf40593          	addi	a1,s0,-81
 292:	4501                	li	a0,0
 294:	00000097          	auipc	ra,0x0
 298:	1b0080e7          	jalr	432(ra) # 444 <read>
    if(cc < 1)
 29c:	00a05e63          	blez	a0,2b8 <gets+0x56>
    buf[i++] = c;
 2a0:	faf44783          	lbu	a5,-81(s0)
 2a4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2a8:	01578763          	beq	a5,s5,2b6 <gets+0x54>
 2ac:	0905                	addi	s2,s2,1
 2ae:	fd679be3          	bne	a5,s6,284 <gets+0x22>
    buf[i++] = c;
 2b2:	89a6                	mv	s3,s1
 2b4:	a011                	j	2b8 <gets+0x56>
 2b6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2b8:	99de                	add	s3,s3,s7
 2ba:	00098023          	sb	zero,0(s3)
  return buf;
}
 2be:	855e                	mv	a0,s7
 2c0:	60e6                	ld	ra,88(sp)
 2c2:	6446                	ld	s0,80(sp)
 2c4:	64a6                	ld	s1,72(sp)
 2c6:	6906                	ld	s2,64(sp)
 2c8:	79e2                	ld	s3,56(sp)
 2ca:	7a42                	ld	s4,48(sp)
 2cc:	7aa2                	ld	s5,40(sp)
 2ce:	7b02                	ld	s6,32(sp)
 2d0:	6be2                	ld	s7,24(sp)
 2d2:	6125                	addi	sp,sp,96
 2d4:	8082                	ret

00000000000002d6 <stat>:

int
stat(const char *n, struct stat *st)
{
 2d6:	1101                	addi	sp,sp,-32
 2d8:	ec06                	sd	ra,24(sp)
 2da:	e822                	sd	s0,16(sp)
 2dc:	e04a                	sd	s2,0(sp)
 2de:	1000                	addi	s0,sp,32
 2e0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2e2:	4581                	li	a1,0
 2e4:	00000097          	auipc	ra,0x0
 2e8:	188080e7          	jalr	392(ra) # 46c <open>
  if(fd < 0)
 2ec:	02054663          	bltz	a0,318 <stat+0x42>
 2f0:	e426                	sd	s1,8(sp)
 2f2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2f4:	85ca                	mv	a1,s2
 2f6:	00000097          	auipc	ra,0x0
 2fa:	18e080e7          	jalr	398(ra) # 484 <fstat>
 2fe:	892a                	mv	s2,a0
  close(fd);
 300:	8526                	mv	a0,s1
 302:	00000097          	auipc	ra,0x0
 306:	152080e7          	jalr	338(ra) # 454 <close>
  return r;
 30a:	64a2                	ld	s1,8(sp)
}
 30c:	854a                	mv	a0,s2
 30e:	60e2                	ld	ra,24(sp)
 310:	6442                	ld	s0,16(sp)
 312:	6902                	ld	s2,0(sp)
 314:	6105                	addi	sp,sp,32
 316:	8082                	ret
    return -1;
 318:	597d                	li	s2,-1
 31a:	bfcd                	j	30c <stat+0x36>

000000000000031c <atoi>:

int
atoi(const char *s)
{
 31c:	1141                	addi	sp,sp,-16
 31e:	e422                	sd	s0,8(sp)
 320:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 322:	00054683          	lbu	a3,0(a0)
 326:	fd06879b          	addiw	a5,a3,-48
 32a:	0ff7f793          	zext.b	a5,a5
 32e:	4625                	li	a2,9
 330:	02f66863          	bltu	a2,a5,360 <atoi+0x44>
 334:	872a                	mv	a4,a0
  n = 0;
 336:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 338:	0705                	addi	a4,a4,1
 33a:	0025179b          	slliw	a5,a0,0x2
 33e:	9fa9                	addw	a5,a5,a0
 340:	0017979b          	slliw	a5,a5,0x1
 344:	9fb5                	addw	a5,a5,a3
 346:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 34a:	00074683          	lbu	a3,0(a4)
 34e:	fd06879b          	addiw	a5,a3,-48
 352:	0ff7f793          	zext.b	a5,a5
 356:	fef671e3          	bgeu	a2,a5,338 <atoi+0x1c>
  return n;
}
 35a:	6422                	ld	s0,8(sp)
 35c:	0141                	addi	sp,sp,16
 35e:	8082                	ret
  n = 0;
 360:	4501                	li	a0,0
 362:	bfe5                	j	35a <atoi+0x3e>

0000000000000364 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 364:	1141                	addi	sp,sp,-16
 366:	e422                	sd	s0,8(sp)
 368:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 36a:	02b57463          	bgeu	a0,a1,392 <memmove+0x2e>
    while(n-- > 0)
 36e:	00c05f63          	blez	a2,38c <memmove+0x28>
 372:	1602                	slli	a2,a2,0x20
 374:	9201                	srli	a2,a2,0x20
 376:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 37a:	872a                	mv	a4,a0
      *dst++ = *src++;
 37c:	0585                	addi	a1,a1,1
 37e:	0705                	addi	a4,a4,1
 380:	fff5c683          	lbu	a3,-1(a1)
 384:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 388:	fef71ae3          	bne	a4,a5,37c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 38c:	6422                	ld	s0,8(sp)
 38e:	0141                	addi	sp,sp,16
 390:	8082                	ret
    dst += n;
 392:	00c50733          	add	a4,a0,a2
    src += n;
 396:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 398:	fec05ae3          	blez	a2,38c <memmove+0x28>
 39c:	fff6079b          	addiw	a5,a2,-1
 3a0:	1782                	slli	a5,a5,0x20
 3a2:	9381                	srli	a5,a5,0x20
 3a4:	fff7c793          	not	a5,a5
 3a8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3aa:	15fd                	addi	a1,a1,-1
 3ac:	177d                	addi	a4,a4,-1
 3ae:	0005c683          	lbu	a3,0(a1)
 3b2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3b6:	fee79ae3          	bne	a5,a4,3aa <memmove+0x46>
 3ba:	bfc9                	j	38c <memmove+0x28>

00000000000003bc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3bc:	1141                	addi	sp,sp,-16
 3be:	e422                	sd	s0,8(sp)
 3c0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3c2:	ca05                	beqz	a2,3f2 <memcmp+0x36>
 3c4:	fff6069b          	addiw	a3,a2,-1
 3c8:	1682                	slli	a3,a3,0x20
 3ca:	9281                	srli	a3,a3,0x20
 3cc:	0685                	addi	a3,a3,1
 3ce:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3d0:	00054783          	lbu	a5,0(a0)
 3d4:	0005c703          	lbu	a4,0(a1)
 3d8:	00e79863          	bne	a5,a4,3e8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3dc:	0505                	addi	a0,a0,1
    p2++;
 3de:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3e0:	fed518e3          	bne	a0,a3,3d0 <memcmp+0x14>
  }
  return 0;
 3e4:	4501                	li	a0,0
 3e6:	a019                	j	3ec <memcmp+0x30>
      return *p1 - *p2;
 3e8:	40e7853b          	subw	a0,a5,a4
}
 3ec:	6422                	ld	s0,8(sp)
 3ee:	0141                	addi	sp,sp,16
 3f0:	8082                	ret
  return 0;
 3f2:	4501                	li	a0,0
 3f4:	bfe5                	j	3ec <memcmp+0x30>

00000000000003f6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3f6:	1141                	addi	sp,sp,-16
 3f8:	e406                	sd	ra,8(sp)
 3fa:	e022                	sd	s0,0(sp)
 3fc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3fe:	00000097          	auipc	ra,0x0
 402:	f66080e7          	jalr	-154(ra) # 364 <memmove>
}
 406:	60a2                	ld	ra,8(sp)
 408:	6402                	ld	s0,0(sp)
 40a:	0141                	addi	sp,sp,16
 40c:	8082                	ret

000000000000040e <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 40e:	1141                	addi	sp,sp,-16
 410:	e422                	sd	s0,8(sp)
 412:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
 414:	040007b7          	lui	a5,0x4000
 418:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3ffe98d>
 41a:	07b2                	slli	a5,a5,0xc
}
 41c:	4388                	lw	a0,0(a5)
 41e:	6422                	ld	s0,8(sp)
 420:	0141                	addi	sp,sp,16
 422:	8082                	ret

0000000000000424 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 424:	4885                	li	a7,1
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <exit>:
.global exit
exit:
 li a7, SYS_exit
 42c:	4889                	li	a7,2
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <wait>:
.global wait
wait:
 li a7, SYS_wait
 434:	488d                	li	a7,3
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 43c:	4891                	li	a7,4
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <read>:
.global read
read:
 li a7, SYS_read
 444:	4895                	li	a7,5
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <write>:
.global write
write:
 li a7, SYS_write
 44c:	48c1                	li	a7,16
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <close>:
.global close
close:
 li a7, SYS_close
 454:	48d5                	li	a7,21
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <kill>:
.global kill
kill:
 li a7, SYS_kill
 45c:	4899                	li	a7,6
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <exec>:
.global exec
exec:
 li a7, SYS_exec
 464:	489d                	li	a7,7
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <open>:
.global open
open:
 li a7, SYS_open
 46c:	48bd                	li	a7,15
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 474:	48c5                	li	a7,17
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 47c:	48c9                	li	a7,18
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 484:	48a1                	li	a7,8
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <link>:
.global link
link:
 li a7, SYS_link
 48c:	48cd                	li	a7,19
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 494:	48d1                	li	a7,20
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 49c:	48a5                	li	a7,9
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4a4:	48a9                	li	a7,10
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4ac:	48ad                	li	a7,11
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4b4:	48b1                	li	a7,12
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4bc:	48b5                	li	a7,13
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4c4:	48b9                	li	a7,14
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <connect>:
.global connect
connect:
 li a7, SYS_connect
 4cc:	48f5                	li	a7,29
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 4d4:	48f9                	li	a7,30
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4dc:	1101                	addi	sp,sp,-32
 4de:	ec06                	sd	ra,24(sp)
 4e0:	e822                	sd	s0,16(sp)
 4e2:	1000                	addi	s0,sp,32
 4e4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4e8:	4605                	li	a2,1
 4ea:	fef40593          	addi	a1,s0,-17
 4ee:	00000097          	auipc	ra,0x0
 4f2:	f5e080e7          	jalr	-162(ra) # 44c <write>
}
 4f6:	60e2                	ld	ra,24(sp)
 4f8:	6442                	ld	s0,16(sp)
 4fa:	6105                	addi	sp,sp,32
 4fc:	8082                	ret

00000000000004fe <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4fe:	7139                	addi	sp,sp,-64
 500:	fc06                	sd	ra,56(sp)
 502:	f822                	sd	s0,48(sp)
 504:	f426                	sd	s1,40(sp)
 506:	0080                	addi	s0,sp,64
 508:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 50a:	c299                	beqz	a3,510 <printint+0x12>
 50c:	0805cb63          	bltz	a1,5a2 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 510:	2581                	sext.w	a1,a1
  neg = 0;
 512:	4881                	li	a7,0
 514:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 518:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 51a:	2601                	sext.w	a2,a2
 51c:	00000517          	auipc	a0,0x0
 520:	4ec50513          	addi	a0,a0,1260 # a08 <digits>
 524:	883a                	mv	a6,a4
 526:	2705                	addiw	a4,a4,1
 528:	02c5f7bb          	remuw	a5,a1,a2
 52c:	1782                	slli	a5,a5,0x20
 52e:	9381                	srli	a5,a5,0x20
 530:	97aa                	add	a5,a5,a0
 532:	0007c783          	lbu	a5,0(a5)
 536:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 53a:	0005879b          	sext.w	a5,a1
 53e:	02c5d5bb          	divuw	a1,a1,a2
 542:	0685                	addi	a3,a3,1
 544:	fec7f0e3          	bgeu	a5,a2,524 <printint+0x26>
  if(neg)
 548:	00088c63          	beqz	a7,560 <printint+0x62>
    buf[i++] = '-';
 54c:	fd070793          	addi	a5,a4,-48
 550:	00878733          	add	a4,a5,s0
 554:	02d00793          	li	a5,45
 558:	fef70823          	sb	a5,-16(a4)
 55c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 560:	02e05c63          	blez	a4,598 <printint+0x9a>
 564:	f04a                	sd	s2,32(sp)
 566:	ec4e                	sd	s3,24(sp)
 568:	fc040793          	addi	a5,s0,-64
 56c:	00e78933          	add	s2,a5,a4
 570:	fff78993          	addi	s3,a5,-1
 574:	99ba                	add	s3,s3,a4
 576:	377d                	addiw	a4,a4,-1
 578:	1702                	slli	a4,a4,0x20
 57a:	9301                	srli	a4,a4,0x20
 57c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 580:	fff94583          	lbu	a1,-1(s2)
 584:	8526                	mv	a0,s1
 586:	00000097          	auipc	ra,0x0
 58a:	f56080e7          	jalr	-170(ra) # 4dc <putc>
  while(--i >= 0)
 58e:	197d                	addi	s2,s2,-1
 590:	ff3918e3          	bne	s2,s3,580 <printint+0x82>
 594:	7902                	ld	s2,32(sp)
 596:	69e2                	ld	s3,24(sp)
}
 598:	70e2                	ld	ra,56(sp)
 59a:	7442                	ld	s0,48(sp)
 59c:	74a2                	ld	s1,40(sp)
 59e:	6121                	addi	sp,sp,64
 5a0:	8082                	ret
    x = -xx;
 5a2:	40b005bb          	negw	a1,a1
    neg = 1;
 5a6:	4885                	li	a7,1
    x = -xx;
 5a8:	b7b5                	j	514 <printint+0x16>

00000000000005aa <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5aa:	715d                	addi	sp,sp,-80
 5ac:	e486                	sd	ra,72(sp)
 5ae:	e0a2                	sd	s0,64(sp)
 5b0:	f84a                	sd	s2,48(sp)
 5b2:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5b4:	0005c903          	lbu	s2,0(a1)
 5b8:	1a090a63          	beqz	s2,76c <vprintf+0x1c2>
 5bc:	fc26                	sd	s1,56(sp)
 5be:	f44e                	sd	s3,40(sp)
 5c0:	f052                	sd	s4,32(sp)
 5c2:	ec56                	sd	s5,24(sp)
 5c4:	e85a                	sd	s6,16(sp)
 5c6:	e45e                	sd	s7,8(sp)
 5c8:	8aaa                	mv	s5,a0
 5ca:	8bb2                	mv	s7,a2
 5cc:	00158493          	addi	s1,a1,1
  state = 0;
 5d0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5d2:	02500a13          	li	s4,37
 5d6:	4b55                	li	s6,21
 5d8:	a839                	j	5f6 <vprintf+0x4c>
        putc(fd, c);
 5da:	85ca                	mv	a1,s2
 5dc:	8556                	mv	a0,s5
 5de:	00000097          	auipc	ra,0x0
 5e2:	efe080e7          	jalr	-258(ra) # 4dc <putc>
 5e6:	a019                	j	5ec <vprintf+0x42>
    } else if(state == '%'){
 5e8:	01498d63          	beq	s3,s4,602 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 5ec:	0485                	addi	s1,s1,1
 5ee:	fff4c903          	lbu	s2,-1(s1)
 5f2:	16090763          	beqz	s2,760 <vprintf+0x1b6>
    if(state == 0){
 5f6:	fe0999e3          	bnez	s3,5e8 <vprintf+0x3e>
      if(c == '%'){
 5fa:	ff4910e3          	bne	s2,s4,5da <vprintf+0x30>
        state = '%';
 5fe:	89d2                	mv	s3,s4
 600:	b7f5                	j	5ec <vprintf+0x42>
      if(c == 'd'){
 602:	13490463          	beq	s2,s4,72a <vprintf+0x180>
 606:	f9d9079b          	addiw	a5,s2,-99
 60a:	0ff7f793          	zext.b	a5,a5
 60e:	12fb6763          	bltu	s6,a5,73c <vprintf+0x192>
 612:	f9d9079b          	addiw	a5,s2,-99
 616:	0ff7f713          	zext.b	a4,a5
 61a:	12eb6163          	bltu	s6,a4,73c <vprintf+0x192>
 61e:	00271793          	slli	a5,a4,0x2
 622:	00000717          	auipc	a4,0x0
 626:	38e70713          	addi	a4,a4,910 # 9b0 <malloc+0x154>
 62a:	97ba                	add	a5,a5,a4
 62c:	439c                	lw	a5,0(a5)
 62e:	97ba                	add	a5,a5,a4
 630:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 632:	008b8913          	addi	s2,s7,8
 636:	4685                	li	a3,1
 638:	4629                	li	a2,10
 63a:	000ba583          	lw	a1,0(s7)
 63e:	8556                	mv	a0,s5
 640:	00000097          	auipc	ra,0x0
 644:	ebe080e7          	jalr	-322(ra) # 4fe <printint>
 648:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 64a:	4981                	li	s3,0
 64c:	b745                	j	5ec <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 64e:	008b8913          	addi	s2,s7,8
 652:	4681                	li	a3,0
 654:	4629                	li	a2,10
 656:	000ba583          	lw	a1,0(s7)
 65a:	8556                	mv	a0,s5
 65c:	00000097          	auipc	ra,0x0
 660:	ea2080e7          	jalr	-350(ra) # 4fe <printint>
 664:	8bca                	mv	s7,s2
      state = 0;
 666:	4981                	li	s3,0
 668:	b751                	j	5ec <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 66a:	008b8913          	addi	s2,s7,8
 66e:	4681                	li	a3,0
 670:	4641                	li	a2,16
 672:	000ba583          	lw	a1,0(s7)
 676:	8556                	mv	a0,s5
 678:	00000097          	auipc	ra,0x0
 67c:	e86080e7          	jalr	-378(ra) # 4fe <printint>
 680:	8bca                	mv	s7,s2
      state = 0;
 682:	4981                	li	s3,0
 684:	b7a5                	j	5ec <vprintf+0x42>
 686:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 688:	008b8c13          	addi	s8,s7,8
 68c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 690:	03000593          	li	a1,48
 694:	8556                	mv	a0,s5
 696:	00000097          	auipc	ra,0x0
 69a:	e46080e7          	jalr	-442(ra) # 4dc <putc>
  putc(fd, 'x');
 69e:	07800593          	li	a1,120
 6a2:	8556                	mv	a0,s5
 6a4:	00000097          	auipc	ra,0x0
 6a8:	e38080e7          	jalr	-456(ra) # 4dc <putc>
 6ac:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6ae:	00000b97          	auipc	s7,0x0
 6b2:	35ab8b93          	addi	s7,s7,858 # a08 <digits>
 6b6:	03c9d793          	srli	a5,s3,0x3c
 6ba:	97de                	add	a5,a5,s7
 6bc:	0007c583          	lbu	a1,0(a5)
 6c0:	8556                	mv	a0,s5
 6c2:	00000097          	auipc	ra,0x0
 6c6:	e1a080e7          	jalr	-486(ra) # 4dc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6ca:	0992                	slli	s3,s3,0x4
 6cc:	397d                	addiw	s2,s2,-1
 6ce:	fe0914e3          	bnez	s2,6b6 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 6d2:	8be2                	mv	s7,s8
      state = 0;
 6d4:	4981                	li	s3,0
 6d6:	6c02                	ld	s8,0(sp)
 6d8:	bf11                	j	5ec <vprintf+0x42>
        s = va_arg(ap, char*);
 6da:	008b8993          	addi	s3,s7,8
 6de:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 6e2:	02090163          	beqz	s2,704 <vprintf+0x15a>
        while(*s != 0){
 6e6:	00094583          	lbu	a1,0(s2)
 6ea:	c9a5                	beqz	a1,75a <vprintf+0x1b0>
          putc(fd, *s);
 6ec:	8556                	mv	a0,s5
 6ee:	00000097          	auipc	ra,0x0
 6f2:	dee080e7          	jalr	-530(ra) # 4dc <putc>
          s++;
 6f6:	0905                	addi	s2,s2,1
        while(*s != 0){
 6f8:	00094583          	lbu	a1,0(s2)
 6fc:	f9e5                	bnez	a1,6ec <vprintf+0x142>
        s = va_arg(ap, char*);
 6fe:	8bce                	mv	s7,s3
      state = 0;
 700:	4981                	li	s3,0
 702:	b5ed                	j	5ec <vprintf+0x42>
          s = "(null)";
 704:	00000917          	auipc	s2,0x0
 708:	2a490913          	addi	s2,s2,676 # 9a8 <malloc+0x14c>
        while(*s != 0){
 70c:	02800593          	li	a1,40
 710:	bff1                	j	6ec <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 712:	008b8913          	addi	s2,s7,8
 716:	000bc583          	lbu	a1,0(s7)
 71a:	8556                	mv	a0,s5
 71c:	00000097          	auipc	ra,0x0
 720:	dc0080e7          	jalr	-576(ra) # 4dc <putc>
 724:	8bca                	mv	s7,s2
      state = 0;
 726:	4981                	li	s3,0
 728:	b5d1                	j	5ec <vprintf+0x42>
        putc(fd, c);
 72a:	02500593          	li	a1,37
 72e:	8556                	mv	a0,s5
 730:	00000097          	auipc	ra,0x0
 734:	dac080e7          	jalr	-596(ra) # 4dc <putc>
      state = 0;
 738:	4981                	li	s3,0
 73a:	bd4d                	j	5ec <vprintf+0x42>
        putc(fd, '%');
 73c:	02500593          	li	a1,37
 740:	8556                	mv	a0,s5
 742:	00000097          	auipc	ra,0x0
 746:	d9a080e7          	jalr	-614(ra) # 4dc <putc>
        putc(fd, c);
 74a:	85ca                	mv	a1,s2
 74c:	8556                	mv	a0,s5
 74e:	00000097          	auipc	ra,0x0
 752:	d8e080e7          	jalr	-626(ra) # 4dc <putc>
      state = 0;
 756:	4981                	li	s3,0
 758:	bd51                	j	5ec <vprintf+0x42>
        s = va_arg(ap, char*);
 75a:	8bce                	mv	s7,s3
      state = 0;
 75c:	4981                	li	s3,0
 75e:	b579                	j	5ec <vprintf+0x42>
 760:	74e2                	ld	s1,56(sp)
 762:	79a2                	ld	s3,40(sp)
 764:	7a02                	ld	s4,32(sp)
 766:	6ae2                	ld	s5,24(sp)
 768:	6b42                	ld	s6,16(sp)
 76a:	6ba2                	ld	s7,8(sp)
    }
  }
}
 76c:	60a6                	ld	ra,72(sp)
 76e:	6406                	ld	s0,64(sp)
 770:	7942                	ld	s2,48(sp)
 772:	6161                	addi	sp,sp,80
 774:	8082                	ret

0000000000000776 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 776:	715d                	addi	sp,sp,-80
 778:	ec06                	sd	ra,24(sp)
 77a:	e822                	sd	s0,16(sp)
 77c:	1000                	addi	s0,sp,32
 77e:	e010                	sd	a2,0(s0)
 780:	e414                	sd	a3,8(s0)
 782:	e818                	sd	a4,16(s0)
 784:	ec1c                	sd	a5,24(s0)
 786:	03043023          	sd	a6,32(s0)
 78a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 78e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 792:	8622                	mv	a2,s0
 794:	00000097          	auipc	ra,0x0
 798:	e16080e7          	jalr	-490(ra) # 5aa <vprintf>
}
 79c:	60e2                	ld	ra,24(sp)
 79e:	6442                	ld	s0,16(sp)
 7a0:	6161                	addi	sp,sp,80
 7a2:	8082                	ret

00000000000007a4 <printf>:

void
printf(const char *fmt, ...)
{
 7a4:	711d                	addi	sp,sp,-96
 7a6:	ec06                	sd	ra,24(sp)
 7a8:	e822                	sd	s0,16(sp)
 7aa:	1000                	addi	s0,sp,32
 7ac:	e40c                	sd	a1,8(s0)
 7ae:	e810                	sd	a2,16(s0)
 7b0:	ec14                	sd	a3,24(s0)
 7b2:	f018                	sd	a4,32(s0)
 7b4:	f41c                	sd	a5,40(s0)
 7b6:	03043823          	sd	a6,48(s0)
 7ba:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7be:	00840613          	addi	a2,s0,8
 7c2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7c6:	85aa                	mv	a1,a0
 7c8:	4505                	li	a0,1
 7ca:	00000097          	auipc	ra,0x0
 7ce:	de0080e7          	jalr	-544(ra) # 5aa <vprintf>
}
 7d2:	60e2                	ld	ra,24(sp)
 7d4:	6442                	ld	s0,16(sp)
 7d6:	6125                	addi	sp,sp,96
 7d8:	8082                	ret

00000000000007da <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7da:	1141                	addi	sp,sp,-16
 7dc:	e422                	sd	s0,8(sp)
 7de:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7e0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e4:	00001797          	auipc	a5,0x1
 7e8:	c7c7b783          	ld	a5,-900(a5) # 1460 <freep>
 7ec:	a02d                	j	816 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7ee:	4618                	lw	a4,8(a2)
 7f0:	9f2d                	addw	a4,a4,a1
 7f2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7f6:	6398                	ld	a4,0(a5)
 7f8:	6310                	ld	a2,0(a4)
 7fa:	a83d                	j	838 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7fc:	ff852703          	lw	a4,-8(a0)
 800:	9f31                	addw	a4,a4,a2
 802:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 804:	ff053683          	ld	a3,-16(a0)
 808:	a091                	j	84c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 80a:	6398                	ld	a4,0(a5)
 80c:	00e7e463          	bltu	a5,a4,814 <free+0x3a>
 810:	00e6ea63          	bltu	a3,a4,824 <free+0x4a>
{
 814:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 816:	fed7fae3          	bgeu	a5,a3,80a <free+0x30>
 81a:	6398                	ld	a4,0(a5)
 81c:	00e6e463          	bltu	a3,a4,824 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 820:	fee7eae3          	bltu	a5,a4,814 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 824:	ff852583          	lw	a1,-8(a0)
 828:	6390                	ld	a2,0(a5)
 82a:	02059813          	slli	a6,a1,0x20
 82e:	01c85713          	srli	a4,a6,0x1c
 832:	9736                	add	a4,a4,a3
 834:	fae60de3          	beq	a2,a4,7ee <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 838:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 83c:	4790                	lw	a2,8(a5)
 83e:	02061593          	slli	a1,a2,0x20
 842:	01c5d713          	srli	a4,a1,0x1c
 846:	973e                	add	a4,a4,a5
 848:	fae68ae3          	beq	a3,a4,7fc <free+0x22>
    p->s.ptr = bp->s.ptr;
 84c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 84e:	00001717          	auipc	a4,0x1
 852:	c0f73923          	sd	a5,-1006(a4) # 1460 <freep>
}
 856:	6422                	ld	s0,8(sp)
 858:	0141                	addi	sp,sp,16
 85a:	8082                	ret

000000000000085c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 85c:	7139                	addi	sp,sp,-64
 85e:	fc06                	sd	ra,56(sp)
 860:	f822                	sd	s0,48(sp)
 862:	f426                	sd	s1,40(sp)
 864:	ec4e                	sd	s3,24(sp)
 866:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 868:	02051493          	slli	s1,a0,0x20
 86c:	9081                	srli	s1,s1,0x20
 86e:	04bd                	addi	s1,s1,15
 870:	8091                	srli	s1,s1,0x4
 872:	0014899b          	addiw	s3,s1,1
 876:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 878:	00001517          	auipc	a0,0x1
 87c:	be853503          	ld	a0,-1048(a0) # 1460 <freep>
 880:	c915                	beqz	a0,8b4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 882:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 884:	4798                	lw	a4,8(a5)
 886:	08977e63          	bgeu	a4,s1,922 <malloc+0xc6>
 88a:	f04a                	sd	s2,32(sp)
 88c:	e852                	sd	s4,16(sp)
 88e:	e456                	sd	s5,8(sp)
 890:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 892:	8a4e                	mv	s4,s3
 894:	0009871b          	sext.w	a4,s3
 898:	6685                	lui	a3,0x1
 89a:	00d77363          	bgeu	a4,a3,8a0 <malloc+0x44>
 89e:	6a05                	lui	s4,0x1
 8a0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8a4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8a8:	00001917          	auipc	s2,0x1
 8ac:	bb890913          	addi	s2,s2,-1096 # 1460 <freep>
  if(p == (char*)-1)
 8b0:	5afd                	li	s5,-1
 8b2:	a091                	j	8f6 <malloc+0x9a>
 8b4:	f04a                	sd	s2,32(sp)
 8b6:	e852                	sd	s4,16(sp)
 8b8:	e456                	sd	s5,8(sp)
 8ba:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8bc:	00001797          	auipc	a5,0x1
 8c0:	db478793          	addi	a5,a5,-588 # 1670 <base>
 8c4:	00001717          	auipc	a4,0x1
 8c8:	b8f73e23          	sd	a5,-1124(a4) # 1460 <freep>
 8cc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8ce:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8d2:	b7c1                	j	892 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8d4:	6398                	ld	a4,0(a5)
 8d6:	e118                	sd	a4,0(a0)
 8d8:	a08d                	j	93a <malloc+0xde>
  hp->s.size = nu;
 8da:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8de:	0541                	addi	a0,a0,16
 8e0:	00000097          	auipc	ra,0x0
 8e4:	efa080e7          	jalr	-262(ra) # 7da <free>
  return freep;
 8e8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8ec:	c13d                	beqz	a0,952 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ee:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8f0:	4798                	lw	a4,8(a5)
 8f2:	02977463          	bgeu	a4,s1,91a <malloc+0xbe>
    if(p == freep)
 8f6:	00093703          	ld	a4,0(s2)
 8fa:	853e                	mv	a0,a5
 8fc:	fef719e3          	bne	a4,a5,8ee <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 900:	8552                	mv	a0,s4
 902:	00000097          	auipc	ra,0x0
 906:	bb2080e7          	jalr	-1102(ra) # 4b4 <sbrk>
  if(p == (char*)-1)
 90a:	fd5518e3          	bne	a0,s5,8da <malloc+0x7e>
        return 0;
 90e:	4501                	li	a0,0
 910:	7902                	ld	s2,32(sp)
 912:	6a42                	ld	s4,16(sp)
 914:	6aa2                	ld	s5,8(sp)
 916:	6b02                	ld	s6,0(sp)
 918:	a03d                	j	946 <malloc+0xea>
 91a:	7902                	ld	s2,32(sp)
 91c:	6a42                	ld	s4,16(sp)
 91e:	6aa2                	ld	s5,8(sp)
 920:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 922:	fae489e3          	beq	s1,a4,8d4 <malloc+0x78>
        p->s.size -= nunits;
 926:	4137073b          	subw	a4,a4,s3
 92a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 92c:	02071693          	slli	a3,a4,0x20
 930:	01c6d713          	srli	a4,a3,0x1c
 934:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 936:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 93a:	00001717          	auipc	a4,0x1
 93e:	b2a73323          	sd	a0,-1242(a4) # 1460 <freep>
      return (void*)(p + 1);
 942:	01078513          	addi	a0,a5,16
  }
}
 946:	70e2                	ld	ra,56(sp)
 948:	7442                	ld	s0,48(sp)
 94a:	74a2                	ld	s1,40(sp)
 94c:	69e2                	ld	s3,24(sp)
 94e:	6121                	addi	sp,sp,64
 950:	8082                	ret
 952:	7902                	ld	s2,32(sp)
 954:	6a42                	ld	s4,16(sp)
 956:	6aa2                	ld	s5,8(sp)
 958:	6b02                	ld	s6,0(sp)
 95a:	b7f5                	j	946 <malloc+0xea>
