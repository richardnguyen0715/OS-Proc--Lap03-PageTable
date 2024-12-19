
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	32013103          	ld	sp,800(sp) # 8000b320 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	339050ef          	jal	80005b4e <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00025797          	auipc	a5,0x25
    80000034:	9b078793          	addi	a5,a5,-1616 # 800249e0 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	132080e7          	jalr	306(ra) # 8000017a <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	0000b917          	auipc	s2,0xb
    80000054:	32090913          	addi	s2,s2,800 # 8000b370 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	542080e7          	jalr	1346(ra) # 8000659c <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	5e2080e7          	jalr	1506(ra) # 80006650 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f7e50513          	addi	a0,a0,-130 # 80008000 <etext>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	f98080e7          	jalr	-104(ra) # 80006022 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000009c:	6785                	lui	a5,0x1
    8000009e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a2:	00e504b3          	add	s1,a0,a4
    800000a6:	777d                	lui	a4,0xfffff
    800000a8:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000aa:	94be                	add	s1,s1,a5
    800000ac:	0295e463          	bltu	a1,s1,800000d4 <freerange+0x42>
    800000b0:	e84a                	sd	s2,16(sp)
    800000b2:	e44e                	sd	s3,8(sp)
    800000b4:	e052                	sd	s4,0(sp)
    800000b6:	892e                	mv	s2,a1
    kfree(p);
    800000b8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	6985                	lui	s3,0x1
    kfree(p);
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
    800000ce:	6942                	ld	s2,16(sp)
    800000d0:	69a2                	ld	s3,8(sp)
    800000d2:	6a02                	ld	s4,0(sp)
}
    800000d4:	70a2                	ld	ra,40(sp)
    800000d6:	7402                	ld	s0,32(sp)
    800000d8:	64e2                	ld	s1,24(sp)
    800000da:	6145                	addi	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
{
    800000de:	1141                	addi	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f2a58593          	addi	a1,a1,-214 # 80008010 <etext+0x10>
    800000ee:	0000b517          	auipc	a0,0xb
    800000f2:	28250513          	addi	a0,a0,642 # 8000b370 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	416080e7          	jalr	1046(ra) # 8000650c <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00025517          	auipc	a0,0x25
    80000106:	8de50513          	addi	a0,a0,-1826 # 800249e0 <end>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	f88080e7          	jalr	-120(ra) # 80000092 <freerange>
}
    80000112:	60a2                	ld	ra,8(sp)
    80000114:	6402                	ld	s0,0(sp)
    80000116:	0141                	addi	sp,sp,16
    80000118:	8082                	ret

000000008000011a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000011a:	1101                	addi	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	0000b497          	auipc	s1,0xb
    80000128:	24c48493          	addi	s1,s1,588 # 8000b370 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	46e080e7          	jalr	1134(ra) # 8000659c <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	0000b517          	auipc	a0,0xb
    80000140:	23450513          	addi	a0,a0,564 # 8000b370 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	50a080e7          	jalr	1290(ra) # 80006650 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	026080e7          	jalr	38(ra) # 8000017a <memset>
  return (void*)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	addi	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	0000b517          	auipc	a0,0xb
    8000016c:	20850513          	addi	a0,a0,520 # 8000b370 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	4e0080e7          	jalr	1248(ra) # 80006650 <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000017a:	1141                	addi	sp,sp,-16
    8000017c:	e422                	sd	s0,8(sp)
    8000017e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000180:	ca19                	beqz	a2,80000196 <memset+0x1c>
    80000182:	87aa                	mv	a5,a0
    80000184:	1602                	slli	a2,a2,0x20
    80000186:	9201                	srli	a2,a2,0x20
    80000188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000190:	0785                	addi	a5,a5,1
    80000192:	fee79de3          	bne	a5,a4,8000018c <memset+0x12>
  }
  return dst;
}
    80000196:	6422                	ld	s0,8(sp)
    80000198:	0141                	addi	sp,sp,16
    8000019a:	8082                	ret

000000008000019c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019c:	1141                	addi	sp,sp,-16
    8000019e:	e422                	sd	s0,8(sp)
    800001a0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a2:	ca05                	beqz	a2,800001d2 <memcmp+0x36>
    800001a4:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001a8:	1682                	slli	a3,a3,0x20
    800001aa:	9281                	srli	a3,a3,0x20
    800001ac:	0685                	addi	a3,a3,1
    800001ae:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b0:	00054783          	lbu	a5,0(a0)
    800001b4:	0005c703          	lbu	a4,0(a1)
    800001b8:	00e79863          	bne	a5,a4,800001c8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001bc:	0505                	addi	a0,a0,1
    800001be:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c0:	fed518e3          	bne	a0,a3,800001b0 <memcmp+0x14>
  }

  return 0;
    800001c4:	4501                	li	a0,0
    800001c6:	a019                	j	800001cc <memcmp+0x30>
      return *s1 - *s2;
    800001c8:	40e7853b          	subw	a0,a5,a4
}
    800001cc:	6422                	ld	s0,8(sp)
    800001ce:	0141                	addi	sp,sp,16
    800001d0:	8082                	ret
  return 0;
    800001d2:	4501                	li	a0,0
    800001d4:	bfe5                	j	800001cc <memcmp+0x30>

00000000800001d6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d6:	1141                	addi	sp,sp,-16
    800001d8:	e422                	sd	s0,8(sp)
    800001da:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001dc:	c205                	beqz	a2,800001fc <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001de:	02a5e263          	bltu	a1,a0,80000202 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e2:	1602                	slli	a2,a2,0x20
    800001e4:	9201                	srli	a2,a2,0x20
    800001e6:	00c587b3          	add	a5,a1,a2
{
    800001ea:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ec:	0585                	addi	a1,a1,1
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffda621>
    800001f0:	fff5c683          	lbu	a3,-1(a1)
    800001f4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f8:	feb79ae3          	bne	a5,a1,800001ec <memmove+0x16>

  return dst;
}
    800001fc:	6422                	ld	s0,8(sp)
    800001fe:	0141                	addi	sp,sp,16
    80000200:	8082                	ret
  if(s < d && s + n > d){
    80000202:	02061693          	slli	a3,a2,0x20
    80000206:	9281                	srli	a3,a3,0x20
    80000208:	00d58733          	add	a4,a1,a3
    8000020c:	fce57be3          	bgeu	a0,a4,800001e2 <memmove+0xc>
    d += n;
    80000210:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000212:	fff6079b          	addiw	a5,a2,-1
    80000216:	1782                	slli	a5,a5,0x20
    80000218:	9381                	srli	a5,a5,0x20
    8000021a:	fff7c793          	not	a5,a5
    8000021e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000220:	177d                	addi	a4,a4,-1
    80000222:	16fd                	addi	a3,a3,-1
    80000224:	00074603          	lbu	a2,0(a4)
    80000228:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022c:	fef71ae3          	bne	a4,a5,80000220 <memmove+0x4a>
    80000230:	b7f1                	j	800001fc <memmove+0x26>

0000000080000232 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000232:	1141                	addi	sp,sp,-16
    80000234:	e406                	sd	ra,8(sp)
    80000236:	e022                	sd	s0,0(sp)
    80000238:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000023a:	00000097          	auipc	ra,0x0
    8000023e:	f9c080e7          	jalr	-100(ra) # 800001d6 <memmove>
}
    80000242:	60a2                	ld	ra,8(sp)
    80000244:	6402                	ld	s0,0(sp)
    80000246:	0141                	addi	sp,sp,16
    80000248:	8082                	ret

000000008000024a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000024a:	1141                	addi	sp,sp,-16
    8000024c:	e422                	sd	s0,8(sp)
    8000024e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000250:	ce11                	beqz	a2,8000026c <strncmp+0x22>
    80000252:	00054783          	lbu	a5,0(a0)
    80000256:	cf89                	beqz	a5,80000270 <strncmp+0x26>
    80000258:	0005c703          	lbu	a4,0(a1)
    8000025c:	00f71a63          	bne	a4,a5,80000270 <strncmp+0x26>
    n--, p++, q++;
    80000260:	367d                	addiw	a2,a2,-1
    80000262:	0505                	addi	a0,a0,1
    80000264:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000266:	f675                	bnez	a2,80000252 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000268:	4501                	li	a0,0
    8000026a:	a801                	j	8000027a <strncmp+0x30>
    8000026c:	4501                	li	a0,0
    8000026e:	a031                	j	8000027a <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000270:	00054503          	lbu	a0,0(a0)
    80000274:	0005c783          	lbu	a5,0(a1)
    80000278:	9d1d                	subw	a0,a0,a5
}
    8000027a:	6422                	ld	s0,8(sp)
    8000027c:	0141                	addi	sp,sp,16
    8000027e:	8082                	ret

0000000080000280 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000280:	1141                	addi	sp,sp,-16
    80000282:	e422                	sd	s0,8(sp)
    80000284:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000286:	87aa                	mv	a5,a0
    80000288:	86b2                	mv	a3,a2
    8000028a:	367d                	addiw	a2,a2,-1
    8000028c:	02d05563          	blez	a3,800002b6 <strncpy+0x36>
    80000290:	0785                	addi	a5,a5,1
    80000292:	0005c703          	lbu	a4,0(a1)
    80000296:	fee78fa3          	sb	a4,-1(a5)
    8000029a:	0585                	addi	a1,a1,1
    8000029c:	f775                	bnez	a4,80000288 <strncpy+0x8>
    ;
  while(n-- > 0)
    8000029e:	873e                	mv	a4,a5
    800002a0:	9fb5                	addw	a5,a5,a3
    800002a2:	37fd                	addiw	a5,a5,-1
    800002a4:	00c05963          	blez	a2,800002b6 <strncpy+0x36>
    *s++ = 0;
    800002a8:	0705                	addi	a4,a4,1
    800002aa:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800002ae:	40e786bb          	subw	a3,a5,a4
    800002b2:	fed04be3          	bgtz	a3,800002a8 <strncpy+0x28>
  return os;
}
    800002b6:	6422                	ld	s0,8(sp)
    800002b8:	0141                	addi	sp,sp,16
    800002ba:	8082                	ret

00000000800002bc <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002bc:	1141                	addi	sp,sp,-16
    800002be:	e422                	sd	s0,8(sp)
    800002c0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002c2:	02c05363          	blez	a2,800002e8 <safestrcpy+0x2c>
    800002c6:	fff6069b          	addiw	a3,a2,-1
    800002ca:	1682                	slli	a3,a3,0x20
    800002cc:	9281                	srli	a3,a3,0x20
    800002ce:	96ae                	add	a3,a3,a1
    800002d0:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002d2:	00d58963          	beq	a1,a3,800002e4 <safestrcpy+0x28>
    800002d6:	0585                	addi	a1,a1,1
    800002d8:	0785                	addi	a5,a5,1
    800002da:	fff5c703          	lbu	a4,-1(a1)
    800002de:	fee78fa3          	sb	a4,-1(a5)
    800002e2:	fb65                	bnez	a4,800002d2 <safestrcpy+0x16>
    ;
  *s = 0;
    800002e4:	00078023          	sb	zero,0(a5)
  return os;
}
    800002e8:	6422                	ld	s0,8(sp)
    800002ea:	0141                	addi	sp,sp,16
    800002ec:	8082                	ret

00000000800002ee <strlen>:

int
strlen(const char *s)
{
    800002ee:	1141                	addi	sp,sp,-16
    800002f0:	e422                	sd	s0,8(sp)
    800002f2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002f4:	00054783          	lbu	a5,0(a0)
    800002f8:	cf91                	beqz	a5,80000314 <strlen+0x26>
    800002fa:	0505                	addi	a0,a0,1
    800002fc:	87aa                	mv	a5,a0
    800002fe:	86be                	mv	a3,a5
    80000300:	0785                	addi	a5,a5,1
    80000302:	fff7c703          	lbu	a4,-1(a5)
    80000306:	ff65                	bnez	a4,800002fe <strlen+0x10>
    80000308:	40a6853b          	subw	a0,a3,a0
    8000030c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    8000030e:	6422                	ld	s0,8(sp)
    80000310:	0141                	addi	sp,sp,16
    80000312:	8082                	ret
  for(n = 0; s[n]; n++)
    80000314:	4501                	li	a0,0
    80000316:	bfe5                	j	8000030e <strlen+0x20>

0000000080000318 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000318:	1141                	addi	sp,sp,-16
    8000031a:	e406                	sd	ra,8(sp)
    8000031c:	e022                	sd	s0,0(sp)
    8000031e:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000320:	00001097          	auipc	ra,0x1
    80000324:	cb4080e7          	jalr	-844(ra) # 80000fd4 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000328:	0000b717          	auipc	a4,0xb
    8000032c:	01870713          	addi	a4,a4,24 # 8000b340 <started>
  if(cpuid() == 0){
    80000330:	c139                	beqz	a0,80000376 <main+0x5e>
    while(started == 0)
    80000332:	431c                	lw	a5,0(a4)
    80000334:	2781                	sext.w	a5,a5
    80000336:	dff5                	beqz	a5,80000332 <main+0x1a>
      ;
    __sync_synchronize();
    80000338:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    8000033c:	00001097          	auipc	ra,0x1
    80000340:	c98080e7          	jalr	-872(ra) # 80000fd4 <cpuid>
    80000344:	85aa                	mv	a1,a0
    80000346:	00008517          	auipc	a0,0x8
    8000034a:	cf250513          	addi	a0,a0,-782 # 80008038 <etext+0x38>
    8000034e:	00006097          	auipc	ra,0x6
    80000352:	d1e080e7          	jalr	-738(ra) # 8000606c <printf>
    kvminithart();    // turn on paging
    80000356:	00000097          	auipc	ra,0x0
    8000035a:	0d8080e7          	jalr	216(ra) # 8000042e <kvminithart>
    trapinithart();   // install kernel trap vector
    8000035e:	00002097          	auipc	ra,0x2
    80000362:	9f2080e7          	jalr	-1550(ra) # 80001d50 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000366:	00005097          	auipc	ra,0x5
    8000036a:	15e080e7          	jalr	350(ra) # 800054c4 <plicinithart>
  }

  scheduler();        
    8000036e:	00001097          	auipc	ra,0x1
    80000372:	23a080e7          	jalr	570(ra) # 800015a8 <scheduler>
    consoleinit();
    80000376:	00006097          	auipc	ra,0x6
    8000037a:	bbc080e7          	jalr	-1092(ra) # 80005f32 <consoleinit>
    printfinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	ef6080e7          	jalr	-266(ra) # 80006274 <printfinit>
    printf("\n");
    80000386:	00008517          	auipc	a0,0x8
    8000038a:	c9250513          	addi	a0,a0,-878 # 80008018 <etext+0x18>
    8000038e:	00006097          	auipc	ra,0x6
    80000392:	cde080e7          	jalr	-802(ra) # 8000606c <printf>
    printf("xv6 kernel is booting\n");
    80000396:	00008517          	auipc	a0,0x8
    8000039a:	c8a50513          	addi	a0,a0,-886 # 80008020 <etext+0x20>
    8000039e:	00006097          	auipc	ra,0x6
    800003a2:	cce080e7          	jalr	-818(ra) # 8000606c <printf>
    printf("\n");
    800003a6:	00008517          	auipc	a0,0x8
    800003aa:	c7250513          	addi	a0,a0,-910 # 80008018 <etext+0x18>
    800003ae:	00006097          	auipc	ra,0x6
    800003b2:	cbe080e7          	jalr	-834(ra) # 8000606c <printf>
    kinit();         // physical page allocator
    800003b6:	00000097          	auipc	ra,0x0
    800003ba:	d28080e7          	jalr	-728(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    800003be:	00000097          	auipc	ra,0x0
    800003c2:	34a080e7          	jalr	842(ra) # 80000708 <kvminit>
    kvminithart();   // turn on paging
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	068080e7          	jalr	104(ra) # 8000042e <kvminithart>
    procinit();      // process table
    800003ce:	00001097          	auipc	ra,0x1
    800003d2:	b46080e7          	jalr	-1210(ra) # 80000f14 <procinit>
    trapinit();      // trap vectors
    800003d6:	00002097          	auipc	ra,0x2
    800003da:	952080e7          	jalr	-1710(ra) # 80001d28 <trapinit>
    trapinithart();  // install kernel trap vector
    800003de:	00002097          	auipc	ra,0x2
    800003e2:	972080e7          	jalr	-1678(ra) # 80001d50 <trapinithart>
    plicinit();      // set up interrupt controller
    800003e6:	00005097          	auipc	ra,0x5
    800003ea:	0c4080e7          	jalr	196(ra) # 800054aa <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	0d6080e7          	jalr	214(ra) # 800054c4 <plicinithart>
    binit();         // buffer cache
    800003f6:	00002097          	auipc	ra,0x2
    800003fa:	18c080e7          	jalr	396(ra) # 80002582 <binit>
    iinit();         // inode table
    800003fe:	00003097          	auipc	ra,0x3
    80000402:	842080e7          	jalr	-1982(ra) # 80002c40 <iinit>
    fileinit();      // file table
    80000406:	00003097          	auipc	ra,0x3
    8000040a:	7f2080e7          	jalr	2034(ra) # 80003bf8 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000040e:	00005097          	auipc	ra,0x5
    80000412:	1be080e7          	jalr	446(ra) # 800055cc <virtio_disk_init>
    userinit();      // first user process
    80000416:	00001097          	auipc	ra,0x1
    8000041a:	f72080e7          	jalr	-142(ra) # 80001388 <userinit>
    __sync_synchronize();
    8000041e:	0330000f          	fence	rw,rw
    started = 1;
    80000422:	4785                	li	a5,1
    80000424:	0000b717          	auipc	a4,0xb
    80000428:	f0f72e23          	sw	a5,-228(a4) # 8000b340 <started>
    8000042c:	b789                	j	8000036e <main+0x56>

000000008000042e <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000042e:	1141                	addi	sp,sp,-16
    80000430:	e422                	sd	s0,8(sp)
    80000432:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000434:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000438:	0000b797          	auipc	a5,0xb
    8000043c:	f107b783          	ld	a5,-240(a5) # 8000b348 <kernel_pagetable>
    80000440:	83b1                	srli	a5,a5,0xc
    80000442:	577d                	li	a4,-1
    80000444:	177e                	slli	a4,a4,0x3f
    80000446:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000448:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000044c:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000450:	6422                	ld	s0,8(sp)
    80000452:	0141                	addi	sp,sp,16
    80000454:	8082                	ret

0000000080000456 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000456:	7139                	addi	sp,sp,-64
    80000458:	fc06                	sd	ra,56(sp)
    8000045a:	f822                	sd	s0,48(sp)
    8000045c:	f426                	sd	s1,40(sp)
    8000045e:	f04a                	sd	s2,32(sp)
    80000460:	ec4e                	sd	s3,24(sp)
    80000462:	e852                	sd	s4,16(sp)
    80000464:	e456                	sd	s5,8(sp)
    80000466:	e05a                	sd	s6,0(sp)
    80000468:	0080                	addi	s0,sp,64
    8000046a:	84aa                	mv	s1,a0
    8000046c:	89ae                	mv	s3,a1
    8000046e:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000470:	57fd                	li	a5,-1
    80000472:	83e9                	srli	a5,a5,0x1a
    80000474:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000476:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000478:	04b7f263          	bgeu	a5,a1,800004bc <walk+0x66>
    panic("walk");
    8000047c:	00008517          	auipc	a0,0x8
    80000480:	bd450513          	addi	a0,a0,-1068 # 80008050 <etext+0x50>
    80000484:	00006097          	auipc	ra,0x6
    80000488:	b9e080e7          	jalr	-1122(ra) # 80006022 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000048c:	060a8663          	beqz	s5,800004f8 <walk+0xa2>
    80000490:	00000097          	auipc	ra,0x0
    80000494:	c8a080e7          	jalr	-886(ra) # 8000011a <kalloc>
    80000498:	84aa                	mv	s1,a0
    8000049a:	c529                	beqz	a0,800004e4 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    8000049c:	6605                	lui	a2,0x1
    8000049e:	4581                	li	a1,0
    800004a0:	00000097          	auipc	ra,0x0
    800004a4:	cda080e7          	jalr	-806(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004a8:	00c4d793          	srli	a5,s1,0xc
    800004ac:	07aa                	slli	a5,a5,0xa
    800004ae:	0017e793          	ori	a5,a5,1
    800004b2:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004b6:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffda617>
    800004b8:	036a0063          	beq	s4,s6,800004d8 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004bc:	0149d933          	srl	s2,s3,s4
    800004c0:	1ff97913          	andi	s2,s2,511
    800004c4:	090e                	slli	s2,s2,0x3
    800004c6:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004c8:	00093483          	ld	s1,0(s2)
    800004cc:	0014f793          	andi	a5,s1,1
    800004d0:	dfd5                	beqz	a5,8000048c <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004d2:	80a9                	srli	s1,s1,0xa
    800004d4:	04b2                	slli	s1,s1,0xc
    800004d6:	b7c5                	j	800004b6 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004d8:	00c9d513          	srli	a0,s3,0xc
    800004dc:	1ff57513          	andi	a0,a0,511
    800004e0:	050e                	slli	a0,a0,0x3
    800004e2:	9526                	add	a0,a0,s1
}
    800004e4:	70e2                	ld	ra,56(sp)
    800004e6:	7442                	ld	s0,48(sp)
    800004e8:	74a2                	ld	s1,40(sp)
    800004ea:	7902                	ld	s2,32(sp)
    800004ec:	69e2                	ld	s3,24(sp)
    800004ee:	6a42                	ld	s4,16(sp)
    800004f0:	6aa2                	ld	s5,8(sp)
    800004f2:	6b02                	ld	s6,0(sp)
    800004f4:	6121                	addi	sp,sp,64
    800004f6:	8082                	ret
        return 0;
    800004f8:	4501                	li	a0,0
    800004fa:	b7ed                	j	800004e4 <walk+0x8e>

00000000800004fc <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800004fc:	57fd                	li	a5,-1
    800004fe:	83e9                	srli	a5,a5,0x1a
    80000500:	00b7f463          	bgeu	a5,a1,80000508 <walkaddr+0xc>
    return 0;
    80000504:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000506:	8082                	ret
{
    80000508:	1141                	addi	sp,sp,-16
    8000050a:	e406                	sd	ra,8(sp)
    8000050c:	e022                	sd	s0,0(sp)
    8000050e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000510:	4601                	li	a2,0
    80000512:	00000097          	auipc	ra,0x0
    80000516:	f44080e7          	jalr	-188(ra) # 80000456 <walk>
  if(pte == 0)
    8000051a:	c105                	beqz	a0,8000053a <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000051c:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000051e:	0117f693          	andi	a3,a5,17
    80000522:	4745                	li	a4,17
    return 0;
    80000524:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000526:	00e68663          	beq	a3,a4,80000532 <walkaddr+0x36>
}
    8000052a:	60a2                	ld	ra,8(sp)
    8000052c:	6402                	ld	s0,0(sp)
    8000052e:	0141                	addi	sp,sp,16
    80000530:	8082                	ret
  pa = PTE2PA(*pte);
    80000532:	83a9                	srli	a5,a5,0xa
    80000534:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000538:	bfcd                	j	8000052a <walkaddr+0x2e>
    return 0;
    8000053a:	4501                	li	a0,0
    8000053c:	b7fd                	j	8000052a <walkaddr+0x2e>

000000008000053e <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000053e:	715d                	addi	sp,sp,-80
    80000540:	e486                	sd	ra,72(sp)
    80000542:	e0a2                	sd	s0,64(sp)
    80000544:	fc26                	sd	s1,56(sp)
    80000546:	f84a                	sd	s2,48(sp)
    80000548:	f44e                	sd	s3,40(sp)
    8000054a:	f052                	sd	s4,32(sp)
    8000054c:	ec56                	sd	s5,24(sp)
    8000054e:	e85a                	sd	s6,16(sp)
    80000550:	e45e                	sd	s7,8(sp)
    80000552:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000554:	03459793          	slli	a5,a1,0x34
    80000558:	e7b9                	bnez	a5,800005a6 <mappages+0x68>
    8000055a:	8aaa                	mv	s5,a0
    8000055c:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    8000055e:	03461793          	slli	a5,a2,0x34
    80000562:	ebb1                	bnez	a5,800005b6 <mappages+0x78>
    panic("mappages: size not aligned");

  if(size == 0)
    80000564:	c22d                	beqz	a2,800005c6 <mappages+0x88>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80000566:	77fd                	lui	a5,0xfffff
    80000568:	963e                	add	a2,a2,a5
    8000056a:	00b609b3          	add	s3,a2,a1
  a = va;
    8000056e:	892e                	mv	s2,a1
    80000570:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000574:	6b85                	lui	s7,0x1
    80000576:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    8000057a:	4605                	li	a2,1
    8000057c:	85ca                	mv	a1,s2
    8000057e:	8556                	mv	a0,s5
    80000580:	00000097          	auipc	ra,0x0
    80000584:	ed6080e7          	jalr	-298(ra) # 80000456 <walk>
    80000588:	cd39                	beqz	a0,800005e6 <mappages+0xa8>
    if(*pte & PTE_V)
    8000058a:	611c                	ld	a5,0(a0)
    8000058c:	8b85                	andi	a5,a5,1
    8000058e:	e7a1                	bnez	a5,800005d6 <mappages+0x98>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000590:	80b1                	srli	s1,s1,0xc
    80000592:	04aa                	slli	s1,s1,0xa
    80000594:	0164e4b3          	or	s1,s1,s6
    80000598:	0014e493          	ori	s1,s1,1
    8000059c:	e104                	sd	s1,0(a0)
    if(a == last)
    8000059e:	07390063          	beq	s2,s3,800005fe <mappages+0xc0>
    a += PGSIZE;
    800005a2:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a4:	bfc9                	j	80000576 <mappages+0x38>
    panic("mappages: va not aligned");
    800005a6:	00008517          	auipc	a0,0x8
    800005aa:	ab250513          	addi	a0,a0,-1358 # 80008058 <etext+0x58>
    800005ae:	00006097          	auipc	ra,0x6
    800005b2:	a74080e7          	jalr	-1420(ra) # 80006022 <panic>
    panic("mappages: size not aligned");
    800005b6:	00008517          	auipc	a0,0x8
    800005ba:	ac250513          	addi	a0,a0,-1342 # 80008078 <etext+0x78>
    800005be:	00006097          	auipc	ra,0x6
    800005c2:	a64080e7          	jalr	-1436(ra) # 80006022 <panic>
    panic("mappages: size");
    800005c6:	00008517          	auipc	a0,0x8
    800005ca:	ad250513          	addi	a0,a0,-1326 # 80008098 <etext+0x98>
    800005ce:	00006097          	auipc	ra,0x6
    800005d2:	a54080e7          	jalr	-1452(ra) # 80006022 <panic>
      panic("mappages: remap");
    800005d6:	00008517          	auipc	a0,0x8
    800005da:	ad250513          	addi	a0,a0,-1326 # 800080a8 <etext+0xa8>
    800005de:	00006097          	auipc	ra,0x6
    800005e2:	a44080e7          	jalr	-1468(ra) # 80006022 <panic>
      return -1;
    800005e6:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005e8:	60a6                	ld	ra,72(sp)
    800005ea:	6406                	ld	s0,64(sp)
    800005ec:	74e2                	ld	s1,56(sp)
    800005ee:	7942                	ld	s2,48(sp)
    800005f0:	79a2                	ld	s3,40(sp)
    800005f2:	7a02                	ld	s4,32(sp)
    800005f4:	6ae2                	ld	s5,24(sp)
    800005f6:	6b42                	ld	s6,16(sp)
    800005f8:	6ba2                	ld	s7,8(sp)
    800005fa:	6161                	addi	sp,sp,80
    800005fc:	8082                	ret
  return 0;
    800005fe:	4501                	li	a0,0
    80000600:	b7e5                	j	800005e8 <mappages+0xaa>

0000000080000602 <kvmmap>:
{
    80000602:	1141                	addi	sp,sp,-16
    80000604:	e406                	sd	ra,8(sp)
    80000606:	e022                	sd	s0,0(sp)
    80000608:	0800                	addi	s0,sp,16
    8000060a:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000060c:	86b2                	mv	a3,a2
    8000060e:	863e                	mv	a2,a5
    80000610:	00000097          	auipc	ra,0x0
    80000614:	f2e080e7          	jalr	-210(ra) # 8000053e <mappages>
    80000618:	e509                	bnez	a0,80000622 <kvmmap+0x20>
}
    8000061a:	60a2                	ld	ra,8(sp)
    8000061c:	6402                	ld	s0,0(sp)
    8000061e:	0141                	addi	sp,sp,16
    80000620:	8082                	ret
    panic("kvmmap");
    80000622:	00008517          	auipc	a0,0x8
    80000626:	a9650513          	addi	a0,a0,-1386 # 800080b8 <etext+0xb8>
    8000062a:	00006097          	auipc	ra,0x6
    8000062e:	9f8080e7          	jalr	-1544(ra) # 80006022 <panic>

0000000080000632 <kvmmake>:
{
    80000632:	1101                	addi	sp,sp,-32
    80000634:	ec06                	sd	ra,24(sp)
    80000636:	e822                	sd	s0,16(sp)
    80000638:	e426                	sd	s1,8(sp)
    8000063a:	e04a                	sd	s2,0(sp)
    8000063c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000063e:	00000097          	auipc	ra,0x0
    80000642:	adc080e7          	jalr	-1316(ra) # 8000011a <kalloc>
    80000646:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000648:	6605                	lui	a2,0x1
    8000064a:	4581                	li	a1,0
    8000064c:	00000097          	auipc	ra,0x0
    80000650:	b2e080e7          	jalr	-1234(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000654:	4719                	li	a4,6
    80000656:	6685                	lui	a3,0x1
    80000658:	10000637          	lui	a2,0x10000
    8000065c:	100005b7          	lui	a1,0x10000
    80000660:	8526                	mv	a0,s1
    80000662:	00000097          	auipc	ra,0x0
    80000666:	fa0080e7          	jalr	-96(ra) # 80000602 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000066a:	4719                	li	a4,6
    8000066c:	6685                	lui	a3,0x1
    8000066e:	10001637          	lui	a2,0x10001
    80000672:	100015b7          	lui	a1,0x10001
    80000676:	8526                	mv	a0,s1
    80000678:	00000097          	auipc	ra,0x0
    8000067c:	f8a080e7          	jalr	-118(ra) # 80000602 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000680:	4719                	li	a4,6
    80000682:	004006b7          	lui	a3,0x400
    80000686:	0c000637          	lui	a2,0xc000
    8000068a:	0c0005b7          	lui	a1,0xc000
    8000068e:	8526                	mv	a0,s1
    80000690:	00000097          	auipc	ra,0x0
    80000694:	f72080e7          	jalr	-142(ra) # 80000602 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000698:	00008917          	auipc	s2,0x8
    8000069c:	96890913          	addi	s2,s2,-1688 # 80008000 <etext>
    800006a0:	4729                	li	a4,10
    800006a2:	80008697          	auipc	a3,0x80008
    800006a6:	95e68693          	addi	a3,a3,-1698 # 8000 <_entry-0x7fff8000>
    800006aa:	4605                	li	a2,1
    800006ac:	067e                	slli	a2,a2,0x1f
    800006ae:	85b2                	mv	a1,a2
    800006b0:	8526                	mv	a0,s1
    800006b2:	00000097          	auipc	ra,0x0
    800006b6:	f50080e7          	jalr	-176(ra) # 80000602 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006ba:	46c5                	li	a3,17
    800006bc:	06ee                	slli	a3,a3,0x1b
    800006be:	4719                	li	a4,6
    800006c0:	412686b3          	sub	a3,a3,s2
    800006c4:	864a                	mv	a2,s2
    800006c6:	85ca                	mv	a1,s2
    800006c8:	8526                	mv	a0,s1
    800006ca:	00000097          	auipc	ra,0x0
    800006ce:	f38080e7          	jalr	-200(ra) # 80000602 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006d2:	4729                	li	a4,10
    800006d4:	6685                	lui	a3,0x1
    800006d6:	00007617          	auipc	a2,0x7
    800006da:	92a60613          	addi	a2,a2,-1750 # 80007000 <_trampoline>
    800006de:	040005b7          	lui	a1,0x4000
    800006e2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006e4:	05b2                	slli	a1,a1,0xc
    800006e6:	8526                	mv	a0,s1
    800006e8:	00000097          	auipc	ra,0x0
    800006ec:	f1a080e7          	jalr	-230(ra) # 80000602 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006f0:	8526                	mv	a0,s1
    800006f2:	00000097          	auipc	ra,0x0
    800006f6:	780080e7          	jalr	1920(ra) # 80000e72 <proc_mapstacks>
}
    800006fa:	8526                	mv	a0,s1
    800006fc:	60e2                	ld	ra,24(sp)
    800006fe:	6442                	ld	s0,16(sp)
    80000700:	64a2                	ld	s1,8(sp)
    80000702:	6902                	ld	s2,0(sp)
    80000704:	6105                	addi	sp,sp,32
    80000706:	8082                	ret

0000000080000708 <kvminit>:
{
    80000708:	1141                	addi	sp,sp,-16
    8000070a:	e406                	sd	ra,8(sp)
    8000070c:	e022                	sd	s0,0(sp)
    8000070e:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000710:	00000097          	auipc	ra,0x0
    80000714:	f22080e7          	jalr	-222(ra) # 80000632 <kvmmake>
    80000718:	0000b797          	auipc	a5,0xb
    8000071c:	c2a7b823          	sd	a0,-976(a5) # 8000b348 <kernel_pagetable>
}
    80000720:	60a2                	ld	ra,8(sp)
    80000722:	6402                	ld	s0,0(sp)
    80000724:	0141                	addi	sp,sp,16
    80000726:	8082                	ret

0000000080000728 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000728:	715d                	addi	sp,sp,-80
    8000072a:	e486                	sd	ra,72(sp)
    8000072c:	e0a2                	sd	s0,64(sp)
    8000072e:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000730:	03459793          	slli	a5,a1,0x34
    80000734:	e39d                	bnez	a5,8000075a <uvmunmap+0x32>
    80000736:	f84a                	sd	s2,48(sp)
    80000738:	f44e                	sd	s3,40(sp)
    8000073a:	f052                	sd	s4,32(sp)
    8000073c:	ec56                	sd	s5,24(sp)
    8000073e:	e85a                	sd	s6,16(sp)
    80000740:	e45e                	sd	s7,8(sp)
    80000742:	8a2a                	mv	s4,a0
    80000744:	892e                	mv	s2,a1
    80000746:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000748:	0632                	slli	a2,a2,0xc
    8000074a:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000074e:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000750:	6b05                	lui	s6,0x1
    80000752:	0935fb63          	bgeu	a1,s3,800007e8 <uvmunmap+0xc0>
    80000756:	fc26                	sd	s1,56(sp)
    80000758:	a8a9                	j	800007b2 <uvmunmap+0x8a>
    8000075a:	fc26                	sd	s1,56(sp)
    8000075c:	f84a                	sd	s2,48(sp)
    8000075e:	f44e                	sd	s3,40(sp)
    80000760:	f052                	sd	s4,32(sp)
    80000762:	ec56                	sd	s5,24(sp)
    80000764:	e85a                	sd	s6,16(sp)
    80000766:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80000768:	00008517          	auipc	a0,0x8
    8000076c:	95850513          	addi	a0,a0,-1704 # 800080c0 <etext+0xc0>
    80000770:	00006097          	auipc	ra,0x6
    80000774:	8b2080e7          	jalr	-1870(ra) # 80006022 <panic>
      panic("uvmunmap: walk");
    80000778:	00008517          	auipc	a0,0x8
    8000077c:	96050513          	addi	a0,a0,-1696 # 800080d8 <etext+0xd8>
    80000780:	00006097          	auipc	ra,0x6
    80000784:	8a2080e7          	jalr	-1886(ra) # 80006022 <panic>
      panic("uvmunmap: not mapped");
    80000788:	00008517          	auipc	a0,0x8
    8000078c:	96050513          	addi	a0,a0,-1696 # 800080e8 <etext+0xe8>
    80000790:	00006097          	auipc	ra,0x6
    80000794:	892080e7          	jalr	-1902(ra) # 80006022 <panic>
      panic("uvmunmap: not a leaf");
    80000798:	00008517          	auipc	a0,0x8
    8000079c:	96850513          	addi	a0,a0,-1688 # 80008100 <etext+0x100>
    800007a0:	00006097          	auipc	ra,0x6
    800007a4:	882080e7          	jalr	-1918(ra) # 80006022 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800007a8:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007ac:	995a                	add	s2,s2,s6
    800007ae:	03397c63          	bgeu	s2,s3,800007e6 <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007b2:	4601                	li	a2,0
    800007b4:	85ca                	mv	a1,s2
    800007b6:	8552                	mv	a0,s4
    800007b8:	00000097          	auipc	ra,0x0
    800007bc:	c9e080e7          	jalr	-866(ra) # 80000456 <walk>
    800007c0:	84aa                	mv	s1,a0
    800007c2:	d95d                	beqz	a0,80000778 <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    800007c4:	6108                	ld	a0,0(a0)
    800007c6:	00157793          	andi	a5,a0,1
    800007ca:	dfdd                	beqz	a5,80000788 <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007cc:	3ff57793          	andi	a5,a0,1023
    800007d0:	fd7784e3          	beq	a5,s7,80000798 <uvmunmap+0x70>
    if(do_free){
    800007d4:	fc0a8ae3          	beqz	s5,800007a8 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    800007d8:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007da:	0532                	slli	a0,a0,0xc
    800007dc:	00000097          	auipc	ra,0x0
    800007e0:	840080e7          	jalr	-1984(ra) # 8000001c <kfree>
    800007e4:	b7d1                	j	800007a8 <uvmunmap+0x80>
    800007e6:	74e2                	ld	s1,56(sp)
    800007e8:	7942                	ld	s2,48(sp)
    800007ea:	79a2                	ld	s3,40(sp)
    800007ec:	7a02                	ld	s4,32(sp)
    800007ee:	6ae2                	ld	s5,24(sp)
    800007f0:	6b42                	ld	s6,16(sp)
    800007f2:	6ba2                	ld	s7,8(sp)
  }
}
    800007f4:	60a6                	ld	ra,72(sp)
    800007f6:	6406                	ld	s0,64(sp)
    800007f8:	6161                	addi	sp,sp,80
    800007fa:	8082                	ret

00000000800007fc <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007fc:	1101                	addi	sp,sp,-32
    800007fe:	ec06                	sd	ra,24(sp)
    80000800:	e822                	sd	s0,16(sp)
    80000802:	e426                	sd	s1,8(sp)
    80000804:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000806:	00000097          	auipc	ra,0x0
    8000080a:	914080e7          	jalr	-1772(ra) # 8000011a <kalloc>
    8000080e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000810:	c519                	beqz	a0,8000081e <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000812:	6605                	lui	a2,0x1
    80000814:	4581                	li	a1,0
    80000816:	00000097          	auipc	ra,0x0
    8000081a:	964080e7          	jalr	-1692(ra) # 8000017a <memset>
  return pagetable;
}
    8000081e:	8526                	mv	a0,s1
    80000820:	60e2                	ld	ra,24(sp)
    80000822:	6442                	ld	s0,16(sp)
    80000824:	64a2                	ld	s1,8(sp)
    80000826:	6105                	addi	sp,sp,32
    80000828:	8082                	ret

000000008000082a <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000082a:	7179                	addi	sp,sp,-48
    8000082c:	f406                	sd	ra,40(sp)
    8000082e:	f022                	sd	s0,32(sp)
    80000830:	ec26                	sd	s1,24(sp)
    80000832:	e84a                	sd	s2,16(sp)
    80000834:	e44e                	sd	s3,8(sp)
    80000836:	e052                	sd	s4,0(sp)
    80000838:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000083a:	6785                	lui	a5,0x1
    8000083c:	04f67863          	bgeu	a2,a5,8000088c <uvmfirst+0x62>
    80000840:	8a2a                	mv	s4,a0
    80000842:	89ae                	mv	s3,a1
    80000844:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000846:	00000097          	auipc	ra,0x0
    8000084a:	8d4080e7          	jalr	-1836(ra) # 8000011a <kalloc>
    8000084e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000850:	6605                	lui	a2,0x1
    80000852:	4581                	li	a1,0
    80000854:	00000097          	auipc	ra,0x0
    80000858:	926080e7          	jalr	-1754(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000085c:	4779                	li	a4,30
    8000085e:	86ca                	mv	a3,s2
    80000860:	6605                	lui	a2,0x1
    80000862:	4581                	li	a1,0
    80000864:	8552                	mv	a0,s4
    80000866:	00000097          	auipc	ra,0x0
    8000086a:	cd8080e7          	jalr	-808(ra) # 8000053e <mappages>
  memmove(mem, src, sz);
    8000086e:	8626                	mv	a2,s1
    80000870:	85ce                	mv	a1,s3
    80000872:	854a                	mv	a0,s2
    80000874:	00000097          	auipc	ra,0x0
    80000878:	962080e7          	jalr	-1694(ra) # 800001d6 <memmove>
}
    8000087c:	70a2                	ld	ra,40(sp)
    8000087e:	7402                	ld	s0,32(sp)
    80000880:	64e2                	ld	s1,24(sp)
    80000882:	6942                	ld	s2,16(sp)
    80000884:	69a2                	ld	s3,8(sp)
    80000886:	6a02                	ld	s4,0(sp)
    80000888:	6145                	addi	sp,sp,48
    8000088a:	8082                	ret
    panic("uvmfirst: more than a page");
    8000088c:	00008517          	auipc	a0,0x8
    80000890:	88c50513          	addi	a0,a0,-1908 # 80008118 <etext+0x118>
    80000894:	00005097          	auipc	ra,0x5
    80000898:	78e080e7          	jalr	1934(ra) # 80006022 <panic>

000000008000089c <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000089c:	1101                	addi	sp,sp,-32
    8000089e:	ec06                	sd	ra,24(sp)
    800008a0:	e822                	sd	s0,16(sp)
    800008a2:	e426                	sd	s1,8(sp)
    800008a4:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008a6:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008a8:	00b67d63          	bgeu	a2,a1,800008c2 <uvmdealloc+0x26>
    800008ac:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008ae:	6785                	lui	a5,0x1
    800008b0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008b2:	00f60733          	add	a4,a2,a5
    800008b6:	76fd                	lui	a3,0xfffff
    800008b8:	8f75                	and	a4,a4,a3
    800008ba:	97ae                	add	a5,a5,a1
    800008bc:	8ff5                	and	a5,a5,a3
    800008be:	00f76863          	bltu	a4,a5,800008ce <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008c2:	8526                	mv	a0,s1
    800008c4:	60e2                	ld	ra,24(sp)
    800008c6:	6442                	ld	s0,16(sp)
    800008c8:	64a2                	ld	s1,8(sp)
    800008ca:	6105                	addi	sp,sp,32
    800008cc:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008ce:	8f99                	sub	a5,a5,a4
    800008d0:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008d2:	4685                	li	a3,1
    800008d4:	0007861b          	sext.w	a2,a5
    800008d8:	85ba                	mv	a1,a4
    800008da:	00000097          	auipc	ra,0x0
    800008de:	e4e080e7          	jalr	-434(ra) # 80000728 <uvmunmap>
    800008e2:	b7c5                	j	800008c2 <uvmdealloc+0x26>

00000000800008e4 <uvmalloc>:
  if(newsz < oldsz)
    800008e4:	0ab66b63          	bltu	a2,a1,8000099a <uvmalloc+0xb6>
{
    800008e8:	7139                	addi	sp,sp,-64
    800008ea:	fc06                	sd	ra,56(sp)
    800008ec:	f822                	sd	s0,48(sp)
    800008ee:	ec4e                	sd	s3,24(sp)
    800008f0:	e852                	sd	s4,16(sp)
    800008f2:	e456                	sd	s5,8(sp)
    800008f4:	0080                	addi	s0,sp,64
    800008f6:	8aaa                	mv	s5,a0
    800008f8:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008fa:	6785                	lui	a5,0x1
    800008fc:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008fe:	95be                	add	a1,a1,a5
    80000900:	77fd                	lui	a5,0xfffff
    80000902:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000906:	08c9fc63          	bgeu	s3,a2,8000099e <uvmalloc+0xba>
    8000090a:	f426                	sd	s1,40(sp)
    8000090c:	f04a                	sd	s2,32(sp)
    8000090e:	e05a                	sd	s6,0(sp)
    80000910:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000912:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000916:	00000097          	auipc	ra,0x0
    8000091a:	804080e7          	jalr	-2044(ra) # 8000011a <kalloc>
    8000091e:	84aa                	mv	s1,a0
    if(mem == 0){
    80000920:	c915                	beqz	a0,80000954 <uvmalloc+0x70>
    memset(mem, 0, PGSIZE);
    80000922:	6605                	lui	a2,0x1
    80000924:	4581                	li	a1,0
    80000926:	00000097          	auipc	ra,0x0
    8000092a:	854080e7          	jalr	-1964(ra) # 8000017a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000092e:	875a                	mv	a4,s6
    80000930:	86a6                	mv	a3,s1
    80000932:	6605                	lui	a2,0x1
    80000934:	85ca                	mv	a1,s2
    80000936:	8556                	mv	a0,s5
    80000938:	00000097          	auipc	ra,0x0
    8000093c:	c06080e7          	jalr	-1018(ra) # 8000053e <mappages>
    80000940:	ed05                	bnez	a0,80000978 <uvmalloc+0x94>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000942:	6785                	lui	a5,0x1
    80000944:	993e                	add	s2,s2,a5
    80000946:	fd4968e3          	bltu	s2,s4,80000916 <uvmalloc+0x32>
  return newsz;
    8000094a:	8552                	mv	a0,s4
    8000094c:	74a2                	ld	s1,40(sp)
    8000094e:	7902                	ld	s2,32(sp)
    80000950:	6b02                	ld	s6,0(sp)
    80000952:	a821                	j	8000096a <uvmalloc+0x86>
      uvmdealloc(pagetable, a, oldsz);
    80000954:	864e                	mv	a2,s3
    80000956:	85ca                	mv	a1,s2
    80000958:	8556                	mv	a0,s5
    8000095a:	00000097          	auipc	ra,0x0
    8000095e:	f42080e7          	jalr	-190(ra) # 8000089c <uvmdealloc>
      return 0;
    80000962:	4501                	li	a0,0
    80000964:	74a2                	ld	s1,40(sp)
    80000966:	7902                	ld	s2,32(sp)
    80000968:	6b02                	ld	s6,0(sp)
}
    8000096a:	70e2                	ld	ra,56(sp)
    8000096c:	7442                	ld	s0,48(sp)
    8000096e:	69e2                	ld	s3,24(sp)
    80000970:	6a42                	ld	s4,16(sp)
    80000972:	6aa2                	ld	s5,8(sp)
    80000974:	6121                	addi	sp,sp,64
    80000976:	8082                	ret
      kfree(mem);
    80000978:	8526                	mv	a0,s1
    8000097a:	fffff097          	auipc	ra,0xfffff
    8000097e:	6a2080e7          	jalr	1698(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000982:	864e                	mv	a2,s3
    80000984:	85ca                	mv	a1,s2
    80000986:	8556                	mv	a0,s5
    80000988:	00000097          	auipc	ra,0x0
    8000098c:	f14080e7          	jalr	-236(ra) # 8000089c <uvmdealloc>
      return 0;
    80000990:	4501                	li	a0,0
    80000992:	74a2                	ld	s1,40(sp)
    80000994:	7902                	ld	s2,32(sp)
    80000996:	6b02                	ld	s6,0(sp)
    80000998:	bfc9                	j	8000096a <uvmalloc+0x86>
    return oldsz;
    8000099a:	852e                	mv	a0,a1
}
    8000099c:	8082                	ret
  return newsz;
    8000099e:	8532                	mv	a0,a2
    800009a0:	b7e9                	j	8000096a <uvmalloc+0x86>

00000000800009a2 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009a2:	7179                	addi	sp,sp,-48
    800009a4:	f406                	sd	ra,40(sp)
    800009a6:	f022                	sd	s0,32(sp)
    800009a8:	ec26                	sd	s1,24(sp)
    800009aa:	e84a                	sd	s2,16(sp)
    800009ac:	e44e                	sd	s3,8(sp)
    800009ae:	e052                	sd	s4,0(sp)
    800009b0:	1800                	addi	s0,sp,48
    800009b2:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009b4:	84aa                	mv	s1,a0
    800009b6:	6905                	lui	s2,0x1
    800009b8:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009ba:	4985                	li	s3,1
    800009bc:	a829                	j	800009d6 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009be:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800009c0:	00c79513          	slli	a0,a5,0xc
    800009c4:	00000097          	auipc	ra,0x0
    800009c8:	fde080e7          	jalr	-34(ra) # 800009a2 <freewalk>
      pagetable[i] = 0;
    800009cc:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009d0:	04a1                	addi	s1,s1,8
    800009d2:	03248163          	beq	s1,s2,800009f4 <freewalk+0x52>
    pte_t pte = pagetable[i];
    800009d6:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009d8:	00f7f713          	andi	a4,a5,15
    800009dc:	ff3701e3          	beq	a4,s3,800009be <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009e0:	8b85                	andi	a5,a5,1
    800009e2:	d7fd                	beqz	a5,800009d0 <freewalk+0x2e>
      panic("freewalk: leaf");
    800009e4:	00007517          	auipc	a0,0x7
    800009e8:	75450513          	addi	a0,a0,1876 # 80008138 <etext+0x138>
    800009ec:	00005097          	auipc	ra,0x5
    800009f0:	636080e7          	jalr	1590(ra) # 80006022 <panic>
    }
  }
  kfree((void*)pagetable);
    800009f4:	8552                	mv	a0,s4
    800009f6:	fffff097          	auipc	ra,0xfffff
    800009fa:	626080e7          	jalr	1574(ra) # 8000001c <kfree>
}
    800009fe:	70a2                	ld	ra,40(sp)
    80000a00:	7402                	ld	s0,32(sp)
    80000a02:	64e2                	ld	s1,24(sp)
    80000a04:	6942                	ld	s2,16(sp)
    80000a06:	69a2                	ld	s3,8(sp)
    80000a08:	6a02                	ld	s4,0(sp)
    80000a0a:	6145                	addi	sp,sp,48
    80000a0c:	8082                	ret

0000000080000a0e <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a0e:	1101                	addi	sp,sp,-32
    80000a10:	ec06                	sd	ra,24(sp)
    80000a12:	e822                	sd	s0,16(sp)
    80000a14:	e426                	sd	s1,8(sp)
    80000a16:	1000                	addi	s0,sp,32
    80000a18:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a1a:	e999                	bnez	a1,80000a30 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a1c:	8526                	mv	a0,s1
    80000a1e:	00000097          	auipc	ra,0x0
    80000a22:	f84080e7          	jalr	-124(ra) # 800009a2 <freewalk>
}
    80000a26:	60e2                	ld	ra,24(sp)
    80000a28:	6442                	ld	s0,16(sp)
    80000a2a:	64a2                	ld	s1,8(sp)
    80000a2c:	6105                	addi	sp,sp,32
    80000a2e:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a30:	6785                	lui	a5,0x1
    80000a32:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a34:	95be                	add	a1,a1,a5
    80000a36:	4685                	li	a3,1
    80000a38:	00c5d613          	srli	a2,a1,0xc
    80000a3c:	4581                	li	a1,0
    80000a3e:	00000097          	auipc	ra,0x0
    80000a42:	cea080e7          	jalr	-790(ra) # 80000728 <uvmunmap>
    80000a46:	bfd9                	j	80000a1c <uvmfree+0xe>

0000000080000a48 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a48:	c679                	beqz	a2,80000b16 <uvmcopy+0xce>
{
    80000a4a:	715d                	addi	sp,sp,-80
    80000a4c:	e486                	sd	ra,72(sp)
    80000a4e:	e0a2                	sd	s0,64(sp)
    80000a50:	fc26                	sd	s1,56(sp)
    80000a52:	f84a                	sd	s2,48(sp)
    80000a54:	f44e                	sd	s3,40(sp)
    80000a56:	f052                	sd	s4,32(sp)
    80000a58:	ec56                	sd	s5,24(sp)
    80000a5a:	e85a                	sd	s6,16(sp)
    80000a5c:	e45e                	sd	s7,8(sp)
    80000a5e:	0880                	addi	s0,sp,80
    80000a60:	8b2a                	mv	s6,a0
    80000a62:	8aae                	mv	s5,a1
    80000a64:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a66:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a68:	4601                	li	a2,0
    80000a6a:	85ce                	mv	a1,s3
    80000a6c:	855a                	mv	a0,s6
    80000a6e:	00000097          	auipc	ra,0x0
    80000a72:	9e8080e7          	jalr	-1560(ra) # 80000456 <walk>
    80000a76:	c531                	beqz	a0,80000ac2 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a78:	6118                	ld	a4,0(a0)
    80000a7a:	00177793          	andi	a5,a4,1
    80000a7e:	cbb1                	beqz	a5,80000ad2 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a80:	00a75593          	srli	a1,a4,0xa
    80000a84:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a88:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a8c:	fffff097          	auipc	ra,0xfffff
    80000a90:	68e080e7          	jalr	1678(ra) # 8000011a <kalloc>
    80000a94:	892a                	mv	s2,a0
    80000a96:	c939                	beqz	a0,80000aec <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a98:	6605                	lui	a2,0x1
    80000a9a:	85de                	mv	a1,s7
    80000a9c:	fffff097          	auipc	ra,0xfffff
    80000aa0:	73a080e7          	jalr	1850(ra) # 800001d6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000aa4:	8726                	mv	a4,s1
    80000aa6:	86ca                	mv	a3,s2
    80000aa8:	6605                	lui	a2,0x1
    80000aaa:	85ce                	mv	a1,s3
    80000aac:	8556                	mv	a0,s5
    80000aae:	00000097          	auipc	ra,0x0
    80000ab2:	a90080e7          	jalr	-1392(ra) # 8000053e <mappages>
    80000ab6:	e515                	bnez	a0,80000ae2 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000ab8:	6785                	lui	a5,0x1
    80000aba:	99be                	add	s3,s3,a5
    80000abc:	fb49e6e3          	bltu	s3,s4,80000a68 <uvmcopy+0x20>
    80000ac0:	a081                	j	80000b00 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000ac2:	00007517          	auipc	a0,0x7
    80000ac6:	68650513          	addi	a0,a0,1670 # 80008148 <etext+0x148>
    80000aca:	00005097          	auipc	ra,0x5
    80000ace:	558080e7          	jalr	1368(ra) # 80006022 <panic>
      panic("uvmcopy: page not present");
    80000ad2:	00007517          	auipc	a0,0x7
    80000ad6:	69650513          	addi	a0,a0,1686 # 80008168 <etext+0x168>
    80000ada:	00005097          	auipc	ra,0x5
    80000ade:	548080e7          	jalr	1352(ra) # 80006022 <panic>
      kfree(mem);
    80000ae2:	854a                	mv	a0,s2
    80000ae4:	fffff097          	auipc	ra,0xfffff
    80000ae8:	538080e7          	jalr	1336(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000aec:	4685                	li	a3,1
    80000aee:	00c9d613          	srli	a2,s3,0xc
    80000af2:	4581                	li	a1,0
    80000af4:	8556                	mv	a0,s5
    80000af6:	00000097          	auipc	ra,0x0
    80000afa:	c32080e7          	jalr	-974(ra) # 80000728 <uvmunmap>
  return -1;
    80000afe:	557d                	li	a0,-1
}
    80000b00:	60a6                	ld	ra,72(sp)
    80000b02:	6406                	ld	s0,64(sp)
    80000b04:	74e2                	ld	s1,56(sp)
    80000b06:	7942                	ld	s2,48(sp)
    80000b08:	79a2                	ld	s3,40(sp)
    80000b0a:	7a02                	ld	s4,32(sp)
    80000b0c:	6ae2                	ld	s5,24(sp)
    80000b0e:	6b42                	ld	s6,16(sp)
    80000b10:	6ba2                	ld	s7,8(sp)
    80000b12:	6161                	addi	sp,sp,80
    80000b14:	8082                	ret
  return 0;
    80000b16:	4501                	li	a0,0
}
    80000b18:	8082                	ret

0000000080000b1a <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b1a:	1141                	addi	sp,sp,-16
    80000b1c:	e406                	sd	ra,8(sp)
    80000b1e:	e022                	sd	s0,0(sp)
    80000b20:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b22:	4601                	li	a2,0
    80000b24:	00000097          	auipc	ra,0x0
    80000b28:	932080e7          	jalr	-1742(ra) # 80000456 <walk>
  if(pte == 0)
    80000b2c:	c901                	beqz	a0,80000b3c <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b2e:	611c                	ld	a5,0(a0)
    80000b30:	9bbd                	andi	a5,a5,-17
    80000b32:	e11c                	sd	a5,0(a0)
}
    80000b34:	60a2                	ld	ra,8(sp)
    80000b36:	6402                	ld	s0,0(sp)
    80000b38:	0141                	addi	sp,sp,16
    80000b3a:	8082                	ret
    panic("uvmclear");
    80000b3c:	00007517          	auipc	a0,0x7
    80000b40:	64c50513          	addi	a0,a0,1612 # 80008188 <etext+0x188>
    80000b44:	00005097          	auipc	ra,0x5
    80000b48:	4de080e7          	jalr	1246(ra) # 80006022 <panic>

0000000080000b4c <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80000b4c:	ced1                	beqz	a3,80000be8 <copyout+0x9c>
{
    80000b4e:	711d                	addi	sp,sp,-96
    80000b50:	ec86                	sd	ra,88(sp)
    80000b52:	e8a2                	sd	s0,80(sp)
    80000b54:	e4a6                	sd	s1,72(sp)
    80000b56:	fc4e                	sd	s3,56(sp)
    80000b58:	f456                	sd	s5,40(sp)
    80000b5a:	f05a                	sd	s6,32(sp)
    80000b5c:	ec5e                	sd	s7,24(sp)
    80000b5e:	1080                	addi	s0,sp,96
    80000b60:	8baa                	mv	s7,a0
    80000b62:	8aae                	mv	s5,a1
    80000b64:	8b32                	mv	s6,a2
    80000b66:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b68:	74fd                	lui	s1,0xfffff
    80000b6a:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80000b6c:	57fd                	li	a5,-1
    80000b6e:	83e9                	srli	a5,a5,0x1a
    80000b70:	0697ee63          	bltu	a5,s1,80000bec <copyout+0xa0>
    80000b74:	e0ca                	sd	s2,64(sp)
    80000b76:	f852                	sd	s4,48(sp)
    80000b78:	e862                	sd	s8,16(sp)
    80000b7a:	e466                	sd	s9,8(sp)
    80000b7c:	e06a                	sd	s10,0(sp)
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000b7e:	4cd5                	li	s9,21
    80000b80:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    80000b82:	8c3e                	mv	s8,a5
    80000b84:	a035                	j	80000bb0 <copyout+0x64>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80000b86:	83a9                	srli	a5,a5,0xa
    80000b88:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b8a:	409a8533          	sub	a0,s5,s1
    80000b8e:	0009061b          	sext.w	a2,s2
    80000b92:	85da                	mv	a1,s6
    80000b94:	953e                	add	a0,a0,a5
    80000b96:	fffff097          	auipc	ra,0xfffff
    80000b9a:	640080e7          	jalr	1600(ra) # 800001d6 <memmove>

    len -= n;
    80000b9e:	412989b3          	sub	s3,s3,s2
    src += n;
    80000ba2:	9b4a                	add	s6,s6,s2
  while(len > 0){
    80000ba4:	02098b63          	beqz	s3,80000bda <copyout+0x8e>
    if(va0 >= MAXVA)
    80000ba8:	054c6463          	bltu	s8,s4,80000bf0 <copyout+0xa4>
    80000bac:	84d2                	mv	s1,s4
    80000bae:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80000bb0:	4601                	li	a2,0
    80000bb2:	85a6                	mv	a1,s1
    80000bb4:	855e                	mv	a0,s7
    80000bb6:	00000097          	auipc	ra,0x0
    80000bba:	8a0080e7          	jalr	-1888(ra) # 80000456 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000bbe:	c121                	beqz	a0,80000bfe <copyout+0xb2>
    80000bc0:	611c                	ld	a5,0(a0)
    80000bc2:	0157f713          	andi	a4,a5,21
    80000bc6:	05971b63          	bne	a4,s9,80000c1c <copyout+0xd0>
    n = PGSIZE - (dstva - va0);
    80000bca:	01a48a33          	add	s4,s1,s10
    80000bce:	415a0933          	sub	s2,s4,s5
    if(n > len)
    80000bd2:	fb29fae3          	bgeu	s3,s2,80000b86 <copyout+0x3a>
    80000bd6:	894e                	mv	s2,s3
    80000bd8:	b77d                	j	80000b86 <copyout+0x3a>
    dstva = va0 + PGSIZE;
  }
  return 0;
    80000bda:	4501                	li	a0,0
    80000bdc:	6906                	ld	s2,64(sp)
    80000bde:	7a42                	ld	s4,48(sp)
    80000be0:	6c42                	ld	s8,16(sp)
    80000be2:	6ca2                	ld	s9,8(sp)
    80000be4:	6d02                	ld	s10,0(sp)
    80000be6:	a015                	j	80000c0a <copyout+0xbe>
    80000be8:	4501                	li	a0,0
}
    80000bea:	8082                	ret
      return -1;
    80000bec:	557d                	li	a0,-1
    80000bee:	a831                	j	80000c0a <copyout+0xbe>
    80000bf0:	557d                	li	a0,-1
    80000bf2:	6906                	ld	s2,64(sp)
    80000bf4:	7a42                	ld	s4,48(sp)
    80000bf6:	6c42                	ld	s8,16(sp)
    80000bf8:	6ca2                	ld	s9,8(sp)
    80000bfa:	6d02                	ld	s10,0(sp)
    80000bfc:	a039                	j	80000c0a <copyout+0xbe>
      return -1;
    80000bfe:	557d                	li	a0,-1
    80000c00:	6906                	ld	s2,64(sp)
    80000c02:	7a42                	ld	s4,48(sp)
    80000c04:	6c42                	ld	s8,16(sp)
    80000c06:	6ca2                	ld	s9,8(sp)
    80000c08:	6d02                	ld	s10,0(sp)
}
    80000c0a:	60e6                	ld	ra,88(sp)
    80000c0c:	6446                	ld	s0,80(sp)
    80000c0e:	64a6                	ld	s1,72(sp)
    80000c10:	79e2                	ld	s3,56(sp)
    80000c12:	7aa2                	ld	s5,40(sp)
    80000c14:	7b02                	ld	s6,32(sp)
    80000c16:	6be2                	ld	s7,24(sp)
    80000c18:	6125                	addi	sp,sp,96
    80000c1a:	8082                	ret
      return -1;
    80000c1c:	557d                	li	a0,-1
    80000c1e:	6906                	ld	s2,64(sp)
    80000c20:	7a42                	ld	s4,48(sp)
    80000c22:	6c42                	ld	s8,16(sp)
    80000c24:	6ca2                	ld	s9,8(sp)
    80000c26:	6d02                	ld	s10,0(sp)
    80000c28:	b7cd                	j	80000c0a <copyout+0xbe>

0000000080000c2a <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000c2a:	caa5                	beqz	a3,80000c9a <copyin+0x70>
{
    80000c2c:	715d                	addi	sp,sp,-80
    80000c2e:	e486                	sd	ra,72(sp)
    80000c30:	e0a2                	sd	s0,64(sp)
    80000c32:	fc26                	sd	s1,56(sp)
    80000c34:	f84a                	sd	s2,48(sp)
    80000c36:	f44e                	sd	s3,40(sp)
    80000c38:	f052                	sd	s4,32(sp)
    80000c3a:	ec56                	sd	s5,24(sp)
    80000c3c:	e85a                	sd	s6,16(sp)
    80000c3e:	e45e                	sd	s7,8(sp)
    80000c40:	e062                	sd	s8,0(sp)
    80000c42:	0880                	addi	s0,sp,80
    80000c44:	8b2a                	mv	s6,a0
    80000c46:	8a2e                	mv	s4,a1
    80000c48:	8c32                	mv	s8,a2
    80000c4a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c4c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c4e:	6a85                	lui	s5,0x1
    80000c50:	a01d                	j	80000c76 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c52:	018505b3          	add	a1,a0,s8
    80000c56:	0004861b          	sext.w	a2,s1
    80000c5a:	412585b3          	sub	a1,a1,s2
    80000c5e:	8552                	mv	a0,s4
    80000c60:	fffff097          	auipc	ra,0xfffff
    80000c64:	576080e7          	jalr	1398(ra) # 800001d6 <memmove>

    len -= n;
    80000c68:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c6c:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c6e:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c72:	02098263          	beqz	s3,80000c96 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000c76:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c7a:	85ca                	mv	a1,s2
    80000c7c:	855a                	mv	a0,s6
    80000c7e:	00000097          	auipc	ra,0x0
    80000c82:	87e080e7          	jalr	-1922(ra) # 800004fc <walkaddr>
    if(pa0 == 0)
    80000c86:	cd01                	beqz	a0,80000c9e <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c88:	418904b3          	sub	s1,s2,s8
    80000c8c:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c8e:	fc99f2e3          	bgeu	s3,s1,80000c52 <copyin+0x28>
    80000c92:	84ce                	mv	s1,s3
    80000c94:	bf7d                	j	80000c52 <copyin+0x28>
  }
  return 0;
    80000c96:	4501                	li	a0,0
    80000c98:	a021                	j	80000ca0 <copyin+0x76>
    80000c9a:	4501                	li	a0,0
}
    80000c9c:	8082                	ret
      return -1;
    80000c9e:	557d                	li	a0,-1
}
    80000ca0:	60a6                	ld	ra,72(sp)
    80000ca2:	6406                	ld	s0,64(sp)
    80000ca4:	74e2                	ld	s1,56(sp)
    80000ca6:	7942                	ld	s2,48(sp)
    80000ca8:	79a2                	ld	s3,40(sp)
    80000caa:	7a02                	ld	s4,32(sp)
    80000cac:	6ae2                	ld	s5,24(sp)
    80000cae:	6b42                	ld	s6,16(sp)
    80000cb0:	6ba2                	ld	s7,8(sp)
    80000cb2:	6c02                	ld	s8,0(sp)
    80000cb4:	6161                	addi	sp,sp,80
    80000cb6:	8082                	ret

0000000080000cb8 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000cb8:	cacd                	beqz	a3,80000d6a <copyinstr+0xb2>
{
    80000cba:	715d                	addi	sp,sp,-80
    80000cbc:	e486                	sd	ra,72(sp)
    80000cbe:	e0a2                	sd	s0,64(sp)
    80000cc0:	fc26                	sd	s1,56(sp)
    80000cc2:	f84a                	sd	s2,48(sp)
    80000cc4:	f44e                	sd	s3,40(sp)
    80000cc6:	f052                	sd	s4,32(sp)
    80000cc8:	ec56                	sd	s5,24(sp)
    80000cca:	e85a                	sd	s6,16(sp)
    80000ccc:	e45e                	sd	s7,8(sp)
    80000cce:	0880                	addi	s0,sp,80
    80000cd0:	8a2a                	mv	s4,a0
    80000cd2:	8b2e                	mv	s6,a1
    80000cd4:	8bb2                	mv	s7,a2
    80000cd6:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000cd8:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000cda:	6985                	lui	s3,0x1
    80000cdc:	a825                	j	80000d14 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000cde:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000ce2:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000ce4:	37fd                	addiw	a5,a5,-1
    80000ce6:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000cea:	60a6                	ld	ra,72(sp)
    80000cec:	6406                	ld	s0,64(sp)
    80000cee:	74e2                	ld	s1,56(sp)
    80000cf0:	7942                	ld	s2,48(sp)
    80000cf2:	79a2                	ld	s3,40(sp)
    80000cf4:	7a02                	ld	s4,32(sp)
    80000cf6:	6ae2                	ld	s5,24(sp)
    80000cf8:	6b42                	ld	s6,16(sp)
    80000cfa:	6ba2                	ld	s7,8(sp)
    80000cfc:	6161                	addi	sp,sp,80
    80000cfe:	8082                	ret
    80000d00:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000d04:	9742                	add	a4,a4,a6
      --max;
    80000d06:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000d0a:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000d0e:	04e58663          	beq	a1,a4,80000d5a <copyinstr+0xa2>
{
    80000d12:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000d14:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000d18:	85a6                	mv	a1,s1
    80000d1a:	8552                	mv	a0,s4
    80000d1c:	fffff097          	auipc	ra,0xfffff
    80000d20:	7e0080e7          	jalr	2016(ra) # 800004fc <walkaddr>
    if(pa0 == 0)
    80000d24:	cd0d                	beqz	a0,80000d5e <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    80000d26:	417486b3          	sub	a3,s1,s7
    80000d2a:	96ce                	add	a3,a3,s3
    if(n > max)
    80000d2c:	00d97363          	bgeu	s2,a3,80000d32 <copyinstr+0x7a>
    80000d30:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000d32:	955e                	add	a0,a0,s7
    80000d34:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000d36:	c695                	beqz	a3,80000d62 <copyinstr+0xaa>
    80000d38:	87da                	mv	a5,s6
    80000d3a:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000d3c:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000d40:	96da                	add	a3,a3,s6
    80000d42:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000d44:	00f60733          	add	a4,a2,a5
    80000d48:	00074703          	lbu	a4,0(a4)
    80000d4c:	db49                	beqz	a4,80000cde <copyinstr+0x26>
        *dst = *p;
    80000d4e:	00e78023          	sb	a4,0(a5)
      dst++;
    80000d52:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d54:	fed797e3          	bne	a5,a3,80000d42 <copyinstr+0x8a>
    80000d58:	b765                	j	80000d00 <copyinstr+0x48>
    80000d5a:	4781                	li	a5,0
    80000d5c:	b761                	j	80000ce4 <copyinstr+0x2c>
      return -1;
    80000d5e:	557d                	li	a0,-1
    80000d60:	b769                	j	80000cea <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000d62:	6b85                	lui	s7,0x1
    80000d64:	9ba6                	add	s7,s7,s1
    80000d66:	87da                	mv	a5,s6
    80000d68:	b76d                	j	80000d12 <copyinstr+0x5a>
  int got_null = 0;
    80000d6a:	4781                	li	a5,0
  if(got_null){
    80000d6c:	37fd                	addiw	a5,a5,-1
    80000d6e:	0007851b          	sext.w	a0,a5
}
    80000d72:	8082                	ret

0000000080000d74 <recursive_vmprint>:
void
recursive_vmprint(pagetable_t pagetable, uint64 depth)
{
    // only 3 level pagetable
    if(depth > 2){
    80000d74:	4789                	li	a5,2
    80000d76:	0cb7e363          	bltu	a5,a1,80000e3c <recursive_vmprint+0xc8>
{
    80000d7a:	711d                	addi	sp,sp,-96
    80000d7c:	ec86                	sd	ra,88(sp)
    80000d7e:	e8a2                	sd	s0,80(sp)
    80000d80:	e4a6                	sd	s1,72(sp)
    80000d82:	e0ca                	sd	s2,64(sp)
    80000d84:	fc4e                	sd	s3,56(sp)
    80000d86:	f852                	sd	s4,48(sp)
    80000d88:	f456                	sd	s5,40(sp)
    80000d8a:	f05a                	sd	s6,32(sp)
    80000d8c:	ec5e                	sd	s7,24(sp)
    80000d8e:	e862                	sd	s8,16(sp)
    80000d90:	e466                	sd	s9,8(sp)
    80000d92:	1080                	addi	s0,sp,96
    80000d94:	8a2e                	mv	s4,a1
    80000d96:	892a                	mv	s2,a0
        return;
    }

    // there are 2^9 = 512 PTEs in a page table
    for(int i = 0; i < 512; i++){
    80000d98:	4481                	li	s1,0
            // this PTE points to a lower-level page table.
            uint64 child = PTE2PA(pte);
            if(depth == 0){
                printf(" ..%d: pte %p pa %p\n", i , pte, child);
                recursive_vmprint((pagetable_t)child, depth + 1);
            }else if(depth == 1){
    80000d9a:	4a85                	li	s5,1
                printf(" .. ..%d: pte %p pa %p\n", i , pte, child);
                recursive_vmprint((pagetable_t)child, depth + 1);
            }else{
                printf(" .. .. ..%d: pte %p pa %p\n", i , pte, child);
    80000d9c:	00007b17          	auipc	s6,0x7
    80000da0:	42cb0b13          	addi	s6,s6,1068 # 800081c8 <etext+0x1c8>
                printf(" .. ..%d: pte %p pa %p\n", i , pte, child);
    80000da4:	00007c17          	auipc	s8,0x7
    80000da8:	40cc0c13          	addi	s8,s8,1036 # 800081b0 <etext+0x1b0>
                printf(" ..%d: pte %p pa %p\n", i , pte, child);
    80000dac:	00007b97          	auipc	s7,0x7
    80000db0:	3ecb8b93          	addi	s7,s7,1004 # 80008198 <etext+0x198>
    for(int i = 0; i < 512; i++){
    80000db4:	20000993          	li	s3,512
    80000db8:	a015                	j	80000ddc <recursive_vmprint+0x68>
                printf(" ..%d: pte %p pa %p\n", i , pte, child);
    80000dba:	86e6                	mv	a3,s9
    80000dbc:	85a6                	mv	a1,s1
    80000dbe:	855e                	mv	a0,s7
    80000dc0:	00005097          	auipc	ra,0x5
    80000dc4:	2ac080e7          	jalr	684(ra) # 8000606c <printf>
                recursive_vmprint((pagetable_t)child, depth + 1);
    80000dc8:	85d6                	mv	a1,s5
    80000dca:	8566                	mv	a0,s9
    80000dcc:	00000097          	auipc	ra,0x0
    80000dd0:	fa8080e7          	jalr	-88(ra) # 80000d74 <recursive_vmprint>
    for(int i = 0; i < 512; i++){
    80000dd4:	2485                	addiw	s1,s1,1 # fffffffffffff001 <end+0xffffffff7ffda621>
    80000dd6:	0921                	addi	s2,s2,8
    80000dd8:	05348563          	beq	s1,s3,80000e22 <recursive_vmprint+0xae>
        pte_t pte = pagetable[i];
    80000ddc:	00093603          	ld	a2,0(s2)
        if(pte & PTE_V){
    80000de0:	00167793          	andi	a5,a2,1
    80000de4:	dbe5                	beqz	a5,80000dd4 <recursive_vmprint+0x60>
            uint64 child = PTE2PA(pte);
    80000de6:	00a65693          	srli	a3,a2,0xa
    80000dea:	00c69c93          	slli	s9,a3,0xc
            if(depth == 0){
    80000dee:	fc0a06e3          	beqz	s4,80000dba <recursive_vmprint+0x46>
            }else if(depth == 1){
    80000df2:	015a0a63          	beq	s4,s5,80000e06 <recursive_vmprint+0x92>
                printf(" .. .. ..%d: pte %p pa %p\n", i , pte, child);
    80000df6:	86e6                	mv	a3,s9
    80000df8:	85a6                	mv	a1,s1
    80000dfa:	855a                	mv	a0,s6
    80000dfc:	00005097          	auipc	ra,0x5
    80000e00:	270080e7          	jalr	624(ra) # 8000606c <printf>
    80000e04:	bfc1                	j	80000dd4 <recursive_vmprint+0x60>
                printf(" .. ..%d: pte %p pa %p\n", i , pte, child);
    80000e06:	86e6                	mv	a3,s9
    80000e08:	85a6                	mv	a1,s1
    80000e0a:	8562                	mv	a0,s8
    80000e0c:	00005097          	auipc	ra,0x5
    80000e10:	260080e7          	jalr	608(ra) # 8000606c <printf>
                recursive_vmprint((pagetable_t)child, depth + 1);
    80000e14:	4589                	li	a1,2
    80000e16:	8566                	mv	a0,s9
    80000e18:	00000097          	auipc	ra,0x0
    80000e1c:	f5c080e7          	jalr	-164(ra) # 80000d74 <recursive_vmprint>
    80000e20:	bf55                	j	80000dd4 <recursive_vmprint+0x60>
            }
        }
    }
    return;
}
    80000e22:	60e6                	ld	ra,88(sp)
    80000e24:	6446                	ld	s0,80(sp)
    80000e26:	64a6                	ld	s1,72(sp)
    80000e28:	6906                	ld	s2,64(sp)
    80000e2a:	79e2                	ld	s3,56(sp)
    80000e2c:	7a42                	ld	s4,48(sp)
    80000e2e:	7aa2                	ld	s5,40(sp)
    80000e30:	7b02                	ld	s6,32(sp)
    80000e32:	6be2                	ld	s7,24(sp)
    80000e34:	6c42                	ld	s8,16(sp)
    80000e36:	6ca2                	ld	s9,8(sp)
    80000e38:	6125                	addi	sp,sp,96
    80000e3a:	8082                	ret
    80000e3c:	8082                	ret

0000000080000e3e <vmprint>:

void 
vmprint(pagetable_t pagetable)
{
    80000e3e:	1101                	addi	sp,sp,-32
    80000e40:	ec06                	sd	ra,24(sp)
    80000e42:	e822                	sd	s0,16(sp)
    80000e44:	e426                	sd	s1,8(sp)
    80000e46:	1000                	addi	s0,sp,32
    80000e48:	84aa                	mv	s1,a0
    printf("page table %p\n", pagetable);
    80000e4a:	85aa                	mv	a1,a0
    80000e4c:	00007517          	auipc	a0,0x7
    80000e50:	39c50513          	addi	a0,a0,924 # 800081e8 <etext+0x1e8>
    80000e54:	00005097          	auipc	ra,0x5
    80000e58:	218080e7          	jalr	536(ra) # 8000606c <printf>
    recursive_vmprint(pagetable, 0);
    80000e5c:	4581                	li	a1,0
    80000e5e:	8526                	mv	a0,s1
    80000e60:	00000097          	auipc	ra,0x0
    80000e64:	f14080e7          	jalr	-236(ra) # 80000d74 <recursive_vmprint>
    return;
    80000e68:	60e2                	ld	ra,24(sp)
    80000e6a:	6442                	ld	s0,16(sp)
    80000e6c:	64a2                	ld	s1,8(sp)
    80000e6e:	6105                	addi	sp,sp,32
    80000e70:	8082                	ret

0000000080000e72 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000e72:	7139                	addi	sp,sp,-64
    80000e74:	fc06                	sd	ra,56(sp)
    80000e76:	f822                	sd	s0,48(sp)
    80000e78:	f426                	sd	s1,40(sp)
    80000e7a:	f04a                	sd	s2,32(sp)
    80000e7c:	ec4e                	sd	s3,24(sp)
    80000e7e:	e852                	sd	s4,16(sp)
    80000e80:	e456                	sd	s5,8(sp)
    80000e82:	e05a                	sd	s6,0(sp)
    80000e84:	0080                	addi	s0,sp,64
    80000e86:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e88:	0000b497          	auipc	s1,0xb
    80000e8c:	93848493          	addi	s1,s1,-1736 # 8000b7c0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000e90:	8b26                	mv	s6,s1
    80000e92:	ff4df937          	lui	s2,0xff4df
    80000e96:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b9fdd>
    80000e9a:	0936                	slli	s2,s2,0xd
    80000e9c:	6f590913          	addi	s2,s2,1781
    80000ea0:	0936                	slli	s2,s2,0xd
    80000ea2:	bd390913          	addi	s2,s2,-1069
    80000ea6:	0932                	slli	s2,s2,0xc
    80000ea8:	7a790913          	addi	s2,s2,1959
    80000eac:	010009b7          	lui	s3,0x1000
    80000eb0:	19fd                	addi	s3,s3,-1 # ffffff <_entry-0x7f000001>
    80000eb2:	09ba                	slli	s3,s3,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000eb4:	00010a97          	auipc	s5,0x10
    80000eb8:	50ca8a93          	addi	s5,s5,1292 # 800113c0 <tickslock>
    char *pa = kalloc();
    80000ebc:	fffff097          	auipc	ra,0xfffff
    80000ec0:	25e080e7          	jalr	606(ra) # 8000011a <kalloc>
    80000ec4:	862a                	mv	a2,a0
    if(pa == 0)
    80000ec6:	cd1d                	beqz	a0,80000f04 <proc_mapstacks+0x92>
    uint64 va = KSTACK((int) (p - proc));
    80000ec8:	416485b3          	sub	a1,s1,s6
    80000ecc:	8591                	srai	a1,a1,0x4
    80000ece:	032585b3          	mul	a1,a1,s2
    80000ed2:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000ed6:	4719                	li	a4,6
    80000ed8:	6685                	lui	a3,0x1
    80000eda:	40b985b3          	sub	a1,s3,a1
    80000ede:	8552                	mv	a0,s4
    80000ee0:	fffff097          	auipc	ra,0xfffff
    80000ee4:	722080e7          	jalr	1826(ra) # 80000602 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ee8:	17048493          	addi	s1,s1,368
    80000eec:	fd5498e3          	bne	s1,s5,80000ebc <proc_mapstacks+0x4a>
  }
}
    80000ef0:	70e2                	ld	ra,56(sp)
    80000ef2:	7442                	ld	s0,48(sp)
    80000ef4:	74a2                	ld	s1,40(sp)
    80000ef6:	7902                	ld	s2,32(sp)
    80000ef8:	69e2                	ld	s3,24(sp)
    80000efa:	6a42                	ld	s4,16(sp)
    80000efc:	6aa2                	ld	s5,8(sp)
    80000efe:	6b02                	ld	s6,0(sp)
    80000f00:	6121                	addi	sp,sp,64
    80000f02:	8082                	ret
      panic("kalloc");
    80000f04:	00007517          	auipc	a0,0x7
    80000f08:	2f450513          	addi	a0,a0,756 # 800081f8 <etext+0x1f8>
    80000f0c:	00005097          	auipc	ra,0x5
    80000f10:	116080e7          	jalr	278(ra) # 80006022 <panic>

0000000080000f14 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000f14:	7139                	addi	sp,sp,-64
    80000f16:	fc06                	sd	ra,56(sp)
    80000f18:	f822                	sd	s0,48(sp)
    80000f1a:	f426                	sd	s1,40(sp)
    80000f1c:	f04a                	sd	s2,32(sp)
    80000f1e:	ec4e                	sd	s3,24(sp)
    80000f20:	e852                	sd	s4,16(sp)
    80000f22:	e456                	sd	s5,8(sp)
    80000f24:	e05a                	sd	s6,0(sp)
    80000f26:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000f28:	00007597          	auipc	a1,0x7
    80000f2c:	2d858593          	addi	a1,a1,728 # 80008200 <etext+0x200>
    80000f30:	0000a517          	auipc	a0,0xa
    80000f34:	46050513          	addi	a0,a0,1120 # 8000b390 <pid_lock>
    80000f38:	00005097          	auipc	ra,0x5
    80000f3c:	5d4080e7          	jalr	1492(ra) # 8000650c <initlock>
  initlock(&wait_lock, "wait_lock");
    80000f40:	00007597          	auipc	a1,0x7
    80000f44:	2c858593          	addi	a1,a1,712 # 80008208 <etext+0x208>
    80000f48:	0000a517          	auipc	a0,0xa
    80000f4c:	46050513          	addi	a0,a0,1120 # 8000b3a8 <wait_lock>
    80000f50:	00005097          	auipc	ra,0x5
    80000f54:	5bc080e7          	jalr	1468(ra) # 8000650c <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f58:	0000b497          	auipc	s1,0xb
    80000f5c:	86848493          	addi	s1,s1,-1944 # 8000b7c0 <proc>
      initlock(&p->lock, "proc");
    80000f60:	00007b17          	auipc	s6,0x7
    80000f64:	2b8b0b13          	addi	s6,s6,696 # 80008218 <etext+0x218>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000f68:	8aa6                	mv	s5,s1
    80000f6a:	ff4df937          	lui	s2,0xff4df
    80000f6e:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b9fdd>
    80000f72:	0936                	slli	s2,s2,0xd
    80000f74:	6f590913          	addi	s2,s2,1781
    80000f78:	0936                	slli	s2,s2,0xd
    80000f7a:	bd390913          	addi	s2,s2,-1069
    80000f7e:	0932                	slli	s2,s2,0xc
    80000f80:	7a790913          	addi	s2,s2,1959
    80000f84:	010009b7          	lui	s3,0x1000
    80000f88:	19fd                	addi	s3,s3,-1 # ffffff <_entry-0x7f000001>
    80000f8a:	09ba                	slli	s3,s3,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f8c:	00010a17          	auipc	s4,0x10
    80000f90:	434a0a13          	addi	s4,s4,1076 # 800113c0 <tickslock>
      initlock(&p->lock, "proc");
    80000f94:	85da                	mv	a1,s6
    80000f96:	8526                	mv	a0,s1
    80000f98:	00005097          	auipc	ra,0x5
    80000f9c:	574080e7          	jalr	1396(ra) # 8000650c <initlock>
      p->state = UNUSED;
    80000fa0:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000fa4:	415487b3          	sub	a5,s1,s5
    80000fa8:	8791                	srai	a5,a5,0x4
    80000faa:	032787b3          	mul	a5,a5,s2
    80000fae:	00d7979b          	slliw	a5,a5,0xd
    80000fb2:	40f987b3          	sub	a5,s3,a5
    80000fb6:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fb8:	17048493          	addi	s1,s1,368
    80000fbc:	fd449ce3          	bne	s1,s4,80000f94 <procinit+0x80>
  }
}
    80000fc0:	70e2                	ld	ra,56(sp)
    80000fc2:	7442                	ld	s0,48(sp)
    80000fc4:	74a2                	ld	s1,40(sp)
    80000fc6:	7902                	ld	s2,32(sp)
    80000fc8:	69e2                	ld	s3,24(sp)
    80000fca:	6a42                	ld	s4,16(sp)
    80000fcc:	6aa2                	ld	s5,8(sp)
    80000fce:	6b02                	ld	s6,0(sp)
    80000fd0:	6121                	addi	sp,sp,64
    80000fd2:	8082                	ret

0000000080000fd4 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000fd4:	1141                	addi	sp,sp,-16
    80000fd6:	e422                	sd	s0,8(sp)
    80000fd8:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000fda:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000fdc:	2501                	sext.w	a0,a0
    80000fde:	6422                	ld	s0,8(sp)
    80000fe0:	0141                	addi	sp,sp,16
    80000fe2:	8082                	ret

0000000080000fe4 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000fe4:	1141                	addi	sp,sp,-16
    80000fe6:	e422                	sd	s0,8(sp)
    80000fe8:	0800                	addi	s0,sp,16
    80000fea:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000fec:	2781                	sext.w	a5,a5
    80000fee:	079e                	slli	a5,a5,0x7
  return c;
}
    80000ff0:	0000a517          	auipc	a0,0xa
    80000ff4:	3d050513          	addi	a0,a0,976 # 8000b3c0 <cpus>
    80000ff8:	953e                	add	a0,a0,a5
    80000ffa:	6422                	ld	s0,8(sp)
    80000ffc:	0141                	addi	sp,sp,16
    80000ffe:	8082                	ret

0000000080001000 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001000:	1101                	addi	sp,sp,-32
    80001002:	ec06                	sd	ra,24(sp)
    80001004:	e822                	sd	s0,16(sp)
    80001006:	e426                	sd	s1,8(sp)
    80001008:	1000                	addi	s0,sp,32
  push_off();
    8000100a:	00005097          	auipc	ra,0x5
    8000100e:	546080e7          	jalr	1350(ra) # 80006550 <push_off>
    80001012:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001014:	2781                	sext.w	a5,a5
    80001016:	079e                	slli	a5,a5,0x7
    80001018:	0000a717          	auipc	a4,0xa
    8000101c:	37870713          	addi	a4,a4,888 # 8000b390 <pid_lock>
    80001020:	97ba                	add	a5,a5,a4
    80001022:	7b84                	ld	s1,48(a5)
  pop_off();
    80001024:	00005097          	auipc	ra,0x5
    80001028:	5cc080e7          	jalr	1484(ra) # 800065f0 <pop_off>
  return p;
}
    8000102c:	8526                	mv	a0,s1
    8000102e:	60e2                	ld	ra,24(sp)
    80001030:	6442                	ld	s0,16(sp)
    80001032:	64a2                	ld	s1,8(sp)
    80001034:	6105                	addi	sp,sp,32
    80001036:	8082                	ret

0000000080001038 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001038:	1141                	addi	sp,sp,-16
    8000103a:	e406                	sd	ra,8(sp)
    8000103c:	e022                	sd	s0,0(sp)
    8000103e:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001040:	00000097          	auipc	ra,0x0
    80001044:	fc0080e7          	jalr	-64(ra) # 80001000 <myproc>
    80001048:	00005097          	auipc	ra,0x5
    8000104c:	608080e7          	jalr	1544(ra) # 80006650 <release>

  if (first) {
    80001050:	0000a797          	auipc	a5,0xa
    80001054:	2807a783          	lw	a5,640(a5) # 8000b2d0 <first.1>
    80001058:	eb89                	bnez	a5,8000106a <forkret+0x32>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    8000105a:	00001097          	auipc	ra,0x1
    8000105e:	d0e080e7          	jalr	-754(ra) # 80001d68 <usertrapret>
}
    80001062:	60a2                	ld	ra,8(sp)
    80001064:	6402                	ld	s0,0(sp)
    80001066:	0141                	addi	sp,sp,16
    80001068:	8082                	ret
    fsinit(ROOTDEV);
    8000106a:	4505                	li	a0,1
    8000106c:	00002097          	auipc	ra,0x2
    80001070:	b54080e7          	jalr	-1196(ra) # 80002bc0 <fsinit>
    first = 0;
    80001074:	0000a797          	auipc	a5,0xa
    80001078:	2407ae23          	sw	zero,604(a5) # 8000b2d0 <first.1>
    __sync_synchronize();
    8000107c:	0330000f          	fence	rw,rw
    80001080:	bfe9                	j	8000105a <forkret+0x22>

0000000080001082 <allocpid>:
{
    80001082:	1101                	addi	sp,sp,-32
    80001084:	ec06                	sd	ra,24(sp)
    80001086:	e822                	sd	s0,16(sp)
    80001088:	e426                	sd	s1,8(sp)
    8000108a:	e04a                	sd	s2,0(sp)
    8000108c:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    8000108e:	0000a917          	auipc	s2,0xa
    80001092:	30290913          	addi	s2,s2,770 # 8000b390 <pid_lock>
    80001096:	854a                	mv	a0,s2
    80001098:	00005097          	auipc	ra,0x5
    8000109c:	504080e7          	jalr	1284(ra) # 8000659c <acquire>
  pid = nextpid;
    800010a0:	0000a797          	auipc	a5,0xa
    800010a4:	23478793          	addi	a5,a5,564 # 8000b2d4 <nextpid>
    800010a8:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800010aa:	0014871b          	addiw	a4,s1,1
    800010ae:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800010b0:	854a                	mv	a0,s2
    800010b2:	00005097          	auipc	ra,0x5
    800010b6:	59e080e7          	jalr	1438(ra) # 80006650 <release>
}
    800010ba:	8526                	mv	a0,s1
    800010bc:	60e2                	ld	ra,24(sp)
    800010be:	6442                	ld	s0,16(sp)
    800010c0:	64a2                	ld	s1,8(sp)
    800010c2:	6902                	ld	s2,0(sp)
    800010c4:	6105                	addi	sp,sp,32
    800010c6:	8082                	ret

00000000800010c8 <proc_pagetable>:
{
    800010c8:	1101                	addi	sp,sp,-32
    800010ca:	ec06                	sd	ra,24(sp)
    800010cc:	e822                	sd	s0,16(sp)
    800010ce:	e426                	sd	s1,8(sp)
    800010d0:	e04a                	sd	s2,0(sp)
    800010d2:	1000                	addi	s0,sp,32
    800010d4:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800010d6:	fffff097          	auipc	ra,0xfffff
    800010da:	726080e7          	jalr	1830(ra) # 800007fc <uvmcreate>
    800010de:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800010e0:	cd39                	beqz	a0,8000113e <proc_pagetable+0x76>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    800010e2:	4729                	li	a4,10
    800010e4:	00006697          	auipc	a3,0x6
    800010e8:	f1c68693          	addi	a3,a3,-228 # 80007000 <_trampoline>
    800010ec:	6605                	lui	a2,0x1
    800010ee:	040005b7          	lui	a1,0x4000
    800010f2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010f4:	05b2                	slli	a1,a1,0xc
    800010f6:	fffff097          	auipc	ra,0xfffff
    800010fa:	448080e7          	jalr	1096(ra) # 8000053e <mappages>
    800010fe:	04054763          	bltz	a0,8000114c <proc_pagetable+0x84>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001102:	4719                	li	a4,6
    80001104:	05893683          	ld	a3,88(s2)
    80001108:	6605                	lui	a2,0x1
    8000110a:	020005b7          	lui	a1,0x2000
    8000110e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001110:	05b6                	slli	a1,a1,0xd
    80001112:	8526                	mv	a0,s1
    80001114:	fffff097          	auipc	ra,0xfffff
    80001118:	42a080e7          	jalr	1066(ra) # 8000053e <mappages>
    8000111c:	04054063          	bltz	a0,8000115c <proc_pagetable+0x94>
  if (mappages(pagetable, USYSCALL, PGSIZE,
    80001120:	4749                	li	a4,18
    80001122:	06093683          	ld	a3,96(s2)
    80001126:	6605                	lui	a2,0x1
    80001128:	040005b7          	lui	a1,0x4000
    8000112c:	15f5                	addi	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    8000112e:	05b2                	slli	a1,a1,0xc
    80001130:	8526                	mv	a0,s1
    80001132:	fffff097          	auipc	ra,0xfffff
    80001136:	40c080e7          	jalr	1036(ra) # 8000053e <mappages>
    8000113a:	04054463          	bltz	a0,80001182 <proc_pagetable+0xba>
}
    8000113e:	8526                	mv	a0,s1
    80001140:	60e2                	ld	ra,24(sp)
    80001142:	6442                	ld	s0,16(sp)
    80001144:	64a2                	ld	s1,8(sp)
    80001146:	6902                	ld	s2,0(sp)
    80001148:	6105                	addi	sp,sp,32
    8000114a:	8082                	ret
    uvmfree(pagetable, 0);
    8000114c:	4581                	li	a1,0
    8000114e:	8526                	mv	a0,s1
    80001150:	00000097          	auipc	ra,0x0
    80001154:	8be080e7          	jalr	-1858(ra) # 80000a0e <uvmfree>
    return 0;
    80001158:	4481                	li	s1,0
    8000115a:	b7d5                	j	8000113e <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000115c:	4681                	li	a3,0
    8000115e:	4605                	li	a2,1
    80001160:	040005b7          	lui	a1,0x4000
    80001164:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001166:	05b2                	slli	a1,a1,0xc
    80001168:	8526                	mv	a0,s1
    8000116a:	fffff097          	auipc	ra,0xfffff
    8000116e:	5be080e7          	jalr	1470(ra) # 80000728 <uvmunmap>
    uvmfree(pagetable, 0);
    80001172:	4581                	li	a1,0
    80001174:	8526                	mv	a0,s1
    80001176:	00000097          	auipc	ra,0x0
    8000117a:	898080e7          	jalr	-1896(ra) # 80000a0e <uvmfree>
    return 0;
    8000117e:	4481                	li	s1,0
    80001180:	bf7d                	j	8000113e <proc_pagetable+0x76>
        uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001182:	4681                	li	a3,0
    80001184:	4605                	li	a2,1
    80001186:	020005b7          	lui	a1,0x2000
    8000118a:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000118c:	05b6                	slli	a1,a1,0xd
    8000118e:	8526                	mv	a0,s1
    80001190:	fffff097          	auipc	ra,0xfffff
    80001194:	598080e7          	jalr	1432(ra) # 80000728 <uvmunmap>
        uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001198:	4681                	li	a3,0
    8000119a:	4605                	li	a2,1
    8000119c:	040005b7          	lui	a1,0x4000
    800011a0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011a2:	05b2                	slli	a1,a1,0xc
    800011a4:	8526                	mv	a0,s1
    800011a6:	fffff097          	auipc	ra,0xfffff
    800011aa:	582080e7          	jalr	1410(ra) # 80000728 <uvmunmap>
        uvmfree(pagetable, 0);
    800011ae:	4581                	li	a1,0
    800011b0:	8526                	mv	a0,s1
    800011b2:	00000097          	auipc	ra,0x0
    800011b6:	85c080e7          	jalr	-1956(ra) # 80000a0e <uvmfree>
        return 0;
    800011ba:	4481                	li	s1,0
    800011bc:	b749                	j	8000113e <proc_pagetable+0x76>

00000000800011be <proc_freepagetable>:
{
    800011be:	1101                	addi	sp,sp,-32
    800011c0:	ec06                	sd	ra,24(sp)
    800011c2:	e822                	sd	s0,16(sp)
    800011c4:	e426                	sd	s1,8(sp)
    800011c6:	e04a                	sd	s2,0(sp)
    800011c8:	1000                	addi	s0,sp,32
    800011ca:	84aa                	mv	s1,a0
    800011cc:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800011ce:	4681                	li	a3,0
    800011d0:	4605                	li	a2,1
    800011d2:	040005b7          	lui	a1,0x4000
    800011d6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011d8:	05b2                	slli	a1,a1,0xc
    800011da:	fffff097          	auipc	ra,0xfffff
    800011de:	54e080e7          	jalr	1358(ra) # 80000728 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800011e2:	4681                	li	a3,0
    800011e4:	4605                	li	a2,1
    800011e6:	020005b7          	lui	a1,0x2000
    800011ea:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800011ec:	05b6                	slli	a1,a1,0xd
    800011ee:	8526                	mv	a0,s1
    800011f0:	fffff097          	auipc	ra,0xfffff
    800011f4:	538080e7          	jalr	1336(ra) # 80000728 <uvmunmap>
  uvmunmap(pagetable, USYSCALL, 1, 0);
    800011f8:	4681                	li	a3,0
    800011fa:	4605                	li	a2,1
    800011fc:	040005b7          	lui	a1,0x4000
    80001200:	15f5                	addi	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    80001202:	05b2                	slli	a1,a1,0xc
    80001204:	8526                	mv	a0,s1
    80001206:	fffff097          	auipc	ra,0xfffff
    8000120a:	522080e7          	jalr	1314(ra) # 80000728 <uvmunmap>
  uvmfree(pagetable, sz);
    8000120e:	85ca                	mv	a1,s2
    80001210:	8526                	mv	a0,s1
    80001212:	fffff097          	auipc	ra,0xfffff
    80001216:	7fc080e7          	jalr	2044(ra) # 80000a0e <uvmfree>
}
    8000121a:	60e2                	ld	ra,24(sp)
    8000121c:	6442                	ld	s0,16(sp)
    8000121e:	64a2                	ld	s1,8(sp)
    80001220:	6902                	ld	s2,0(sp)
    80001222:	6105                	addi	sp,sp,32
    80001224:	8082                	ret

0000000080001226 <freeproc>:
{
    80001226:	1101                	addi	sp,sp,-32
    80001228:	ec06                	sd	ra,24(sp)
    8000122a:	e822                	sd	s0,16(sp)
    8000122c:	e426                	sd	s1,8(sp)
    8000122e:	1000                	addi	s0,sp,32
    80001230:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001232:	6d28                	ld	a0,88(a0)
    80001234:	c509                	beqz	a0,8000123e <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001236:	fffff097          	auipc	ra,0xfffff
    8000123a:	de6080e7          	jalr	-538(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000123e:	0404bc23          	sd	zero,88(s1)
  if (p->usyscall) {
    80001242:	70a8                	ld	a0,96(s1)
    80001244:	c509                	beqz	a0,8000124e <freeproc+0x28>
        kfree((void *) p->usyscall);
    80001246:	fffff097          	auipc	ra,0xfffff
    8000124a:	dd6080e7          	jalr	-554(ra) # 8000001c <kfree>
  p->usyscall = 0;
    8000124e:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    80001252:	68a8                	ld	a0,80(s1)
    80001254:	c511                	beqz	a0,80001260 <freeproc+0x3a>
    proc_freepagetable(p->pagetable, p->sz);
    80001256:	64ac                	ld	a1,72(s1)
    80001258:	00000097          	auipc	ra,0x0
    8000125c:	f66080e7          	jalr	-154(ra) # 800011be <proc_freepagetable>
  p->pagetable = 0;
    80001260:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001264:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001268:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000126c:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001270:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80001274:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001278:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000127c:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001280:	0004ac23          	sw	zero,24(s1)
}
    80001284:	60e2                	ld	ra,24(sp)
    80001286:	6442                	ld	s0,16(sp)
    80001288:	64a2                	ld	s1,8(sp)
    8000128a:	6105                	addi	sp,sp,32
    8000128c:	8082                	ret

000000008000128e <allocproc>:
{
    8000128e:	1101                	addi	sp,sp,-32
    80001290:	ec06                	sd	ra,24(sp)
    80001292:	e822                	sd	s0,16(sp)
    80001294:	e426                	sd	s1,8(sp)
    80001296:	e04a                	sd	s2,0(sp)
    80001298:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000129a:	0000a497          	auipc	s1,0xa
    8000129e:	52648493          	addi	s1,s1,1318 # 8000b7c0 <proc>
    800012a2:	00010917          	auipc	s2,0x10
    800012a6:	11e90913          	addi	s2,s2,286 # 800113c0 <tickslock>
    acquire(&p->lock);
    800012aa:	8526                	mv	a0,s1
    800012ac:	00005097          	auipc	ra,0x5
    800012b0:	2f0080e7          	jalr	752(ra) # 8000659c <acquire>
    if(p->state == UNUSED) {
    800012b4:	4c9c                	lw	a5,24(s1)
    800012b6:	cf81                	beqz	a5,800012ce <allocproc+0x40>
      release(&p->lock);
    800012b8:	8526                	mv	a0,s1
    800012ba:	00005097          	auipc	ra,0x5
    800012be:	396080e7          	jalr	918(ra) # 80006650 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800012c2:	17048493          	addi	s1,s1,368
    800012c6:	ff2492e3          	bne	s1,s2,800012aa <allocproc+0x1c>
  return 0;
    800012ca:	4481                	li	s1,0
    800012cc:	a09d                	j	80001332 <allocproc+0xa4>
  p->pid = allocpid();
    800012ce:	00000097          	auipc	ra,0x0
    800012d2:	db4080e7          	jalr	-588(ra) # 80001082 <allocpid>
    800012d6:	d888                	sw	a0,48(s1)
  p->state = USED;
    800012d8:	4785                	li	a5,1
    800012da:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800012dc:	fffff097          	auipc	ra,0xfffff
    800012e0:	e3e080e7          	jalr	-450(ra) # 8000011a <kalloc>
    800012e4:	892a                	mv	s2,a0
    800012e6:	eca8                	sd	a0,88(s1)
    800012e8:	cd21                	beqz	a0,80001340 <allocproc+0xb2>
  if ((p->usyscall = (struct usyscall *) kalloc()) == 0) {
    800012ea:	fffff097          	auipc	ra,0xfffff
    800012ee:	e30080e7          	jalr	-464(ra) # 8000011a <kalloc>
    800012f2:	892a                	mv	s2,a0
    800012f4:	f0a8                	sd	a0,96(s1)
    800012f6:	c12d                	beqz	a0,80001358 <allocproc+0xca>
  p->pagetable = proc_pagetable(p);
    800012f8:	8526                	mv	a0,s1
    800012fa:	00000097          	auipc	ra,0x0
    800012fe:	dce080e7          	jalr	-562(ra) # 800010c8 <proc_pagetable>
    80001302:	892a                	mv	s2,a0
    80001304:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001306:	c52d                	beqz	a0,80001370 <allocproc+0xe2>
  memset(&p->context, 0, sizeof(p->context));
    80001308:	07000613          	li	a2,112
    8000130c:	4581                	li	a1,0
    8000130e:	06848513          	addi	a0,s1,104
    80001312:	fffff097          	auipc	ra,0xfffff
    80001316:	e68080e7          	jalr	-408(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    8000131a:	00000797          	auipc	a5,0x0
    8000131e:	d1e78793          	addi	a5,a5,-738 # 80001038 <forkret>
    80001322:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001324:	60bc                	ld	a5,64(s1)
    80001326:	6705                	lui	a4,0x1
    80001328:	97ba                	add	a5,a5,a4
    8000132a:	f8bc                	sd	a5,112(s1)
  p->usyscall->pid = p->pid;
    8000132c:	70bc                	ld	a5,96(s1)
    8000132e:	5898                	lw	a4,48(s1)
    80001330:	c398                	sw	a4,0(a5)
}
    80001332:	8526                	mv	a0,s1
    80001334:	60e2                	ld	ra,24(sp)
    80001336:	6442                	ld	s0,16(sp)
    80001338:	64a2                	ld	s1,8(sp)
    8000133a:	6902                	ld	s2,0(sp)
    8000133c:	6105                	addi	sp,sp,32
    8000133e:	8082                	ret
    freeproc(p);
    80001340:	8526                	mv	a0,s1
    80001342:	00000097          	auipc	ra,0x0
    80001346:	ee4080e7          	jalr	-284(ra) # 80001226 <freeproc>
    release(&p->lock);
    8000134a:	8526                	mv	a0,s1
    8000134c:	00005097          	auipc	ra,0x5
    80001350:	304080e7          	jalr	772(ra) # 80006650 <release>
    return 0;
    80001354:	84ca                	mv	s1,s2
    80001356:	bff1                	j	80001332 <allocproc+0xa4>
        freeproc(p);
    80001358:	8526                	mv	a0,s1
    8000135a:	00000097          	auipc	ra,0x0
    8000135e:	ecc080e7          	jalr	-308(ra) # 80001226 <freeproc>
        release(&p->lock);
    80001362:	8526                	mv	a0,s1
    80001364:	00005097          	auipc	ra,0x5
    80001368:	2ec080e7          	jalr	748(ra) # 80006650 <release>
        return 0;
    8000136c:	84ca                	mv	s1,s2
    8000136e:	b7d1                	j	80001332 <allocproc+0xa4>
    freeproc(p);
    80001370:	8526                	mv	a0,s1
    80001372:	00000097          	auipc	ra,0x0
    80001376:	eb4080e7          	jalr	-332(ra) # 80001226 <freeproc>
    release(&p->lock);
    8000137a:	8526                	mv	a0,s1
    8000137c:	00005097          	auipc	ra,0x5
    80001380:	2d4080e7          	jalr	724(ra) # 80006650 <release>
    return 0;
    80001384:	84ca                	mv	s1,s2
    80001386:	b775                	j	80001332 <allocproc+0xa4>

0000000080001388 <userinit>:
{
    80001388:	1101                	addi	sp,sp,-32
    8000138a:	ec06                	sd	ra,24(sp)
    8000138c:	e822                	sd	s0,16(sp)
    8000138e:	e426                	sd	s1,8(sp)
    80001390:	1000                	addi	s0,sp,32
  p = allocproc();
    80001392:	00000097          	auipc	ra,0x0
    80001396:	efc080e7          	jalr	-260(ra) # 8000128e <allocproc>
    8000139a:	84aa                	mv	s1,a0
  initproc = p;
    8000139c:	0000a797          	auipc	a5,0xa
    800013a0:	faa7ba23          	sd	a0,-76(a5) # 8000b350 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800013a4:	03400613          	li	a2,52
    800013a8:	0000a597          	auipc	a1,0xa
    800013ac:	f3858593          	addi	a1,a1,-200 # 8000b2e0 <initcode>
    800013b0:	6928                	ld	a0,80(a0)
    800013b2:	fffff097          	auipc	ra,0xfffff
    800013b6:	478080e7          	jalr	1144(ra) # 8000082a <uvmfirst>
  p->sz = PGSIZE;
    800013ba:	6785                	lui	a5,0x1
    800013bc:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800013be:	6cb8                	ld	a4,88(s1)
    800013c0:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800013c4:	6cb8                	ld	a4,88(s1)
    800013c6:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800013c8:	4641                	li	a2,16
    800013ca:	00007597          	auipc	a1,0x7
    800013ce:	e5658593          	addi	a1,a1,-426 # 80008220 <etext+0x220>
    800013d2:	16048513          	addi	a0,s1,352
    800013d6:	fffff097          	auipc	ra,0xfffff
    800013da:	ee6080e7          	jalr	-282(ra) # 800002bc <safestrcpy>
  p->cwd = namei("/");
    800013de:	00007517          	auipc	a0,0x7
    800013e2:	e5250513          	addi	a0,a0,-430 # 80008230 <etext+0x230>
    800013e6:	00002097          	auipc	ra,0x2
    800013ea:	22c080e7          	jalr	556(ra) # 80003612 <namei>
    800013ee:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    800013f2:	478d                	li	a5,3
    800013f4:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800013f6:	8526                	mv	a0,s1
    800013f8:	00005097          	auipc	ra,0x5
    800013fc:	258080e7          	jalr	600(ra) # 80006650 <release>
}
    80001400:	60e2                	ld	ra,24(sp)
    80001402:	6442                	ld	s0,16(sp)
    80001404:	64a2                	ld	s1,8(sp)
    80001406:	6105                	addi	sp,sp,32
    80001408:	8082                	ret

000000008000140a <growproc>:
{
    8000140a:	1101                	addi	sp,sp,-32
    8000140c:	ec06                	sd	ra,24(sp)
    8000140e:	e822                	sd	s0,16(sp)
    80001410:	e426                	sd	s1,8(sp)
    80001412:	e04a                	sd	s2,0(sp)
    80001414:	1000                	addi	s0,sp,32
    80001416:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001418:	00000097          	auipc	ra,0x0
    8000141c:	be8080e7          	jalr	-1048(ra) # 80001000 <myproc>
    80001420:	84aa                	mv	s1,a0
  sz = p->sz;
    80001422:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001424:	01204c63          	bgtz	s2,8000143c <growproc+0x32>
  } else if(n < 0){
    80001428:	02094663          	bltz	s2,80001454 <growproc+0x4a>
  p->sz = sz;
    8000142c:	e4ac                	sd	a1,72(s1)
  return 0;
    8000142e:	4501                	li	a0,0
}
    80001430:	60e2                	ld	ra,24(sp)
    80001432:	6442                	ld	s0,16(sp)
    80001434:	64a2                	ld	s1,8(sp)
    80001436:	6902                	ld	s2,0(sp)
    80001438:	6105                	addi	sp,sp,32
    8000143a:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    8000143c:	4691                	li	a3,4
    8000143e:	00b90633          	add	a2,s2,a1
    80001442:	6928                	ld	a0,80(a0)
    80001444:	fffff097          	auipc	ra,0xfffff
    80001448:	4a0080e7          	jalr	1184(ra) # 800008e4 <uvmalloc>
    8000144c:	85aa                	mv	a1,a0
    8000144e:	fd79                	bnez	a0,8000142c <growproc+0x22>
      return -1;
    80001450:	557d                	li	a0,-1
    80001452:	bff9                	j	80001430 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001454:	00b90633          	add	a2,s2,a1
    80001458:	6928                	ld	a0,80(a0)
    8000145a:	fffff097          	auipc	ra,0xfffff
    8000145e:	442080e7          	jalr	1090(ra) # 8000089c <uvmdealloc>
    80001462:	85aa                	mv	a1,a0
    80001464:	b7e1                	j	8000142c <growproc+0x22>

0000000080001466 <fork>:
{
    80001466:	7139                	addi	sp,sp,-64
    80001468:	fc06                	sd	ra,56(sp)
    8000146a:	f822                	sd	s0,48(sp)
    8000146c:	f04a                	sd	s2,32(sp)
    8000146e:	e456                	sd	s5,8(sp)
    80001470:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001472:	00000097          	auipc	ra,0x0
    80001476:	b8e080e7          	jalr	-1138(ra) # 80001000 <myproc>
    8000147a:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000147c:	00000097          	auipc	ra,0x0
    80001480:	e12080e7          	jalr	-494(ra) # 8000128e <allocproc>
    80001484:	12050063          	beqz	a0,800015a4 <fork+0x13e>
    80001488:	e852                	sd	s4,16(sp)
    8000148a:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000148c:	048ab603          	ld	a2,72(s5)
    80001490:	692c                	ld	a1,80(a0)
    80001492:	050ab503          	ld	a0,80(s5)
    80001496:	fffff097          	auipc	ra,0xfffff
    8000149a:	5b2080e7          	jalr	1458(ra) # 80000a48 <uvmcopy>
    8000149e:	04054a63          	bltz	a0,800014f2 <fork+0x8c>
    800014a2:	f426                	sd	s1,40(sp)
    800014a4:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    800014a6:	048ab783          	ld	a5,72(s5)
    800014aa:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800014ae:	058ab683          	ld	a3,88(s5)
    800014b2:	87b6                	mv	a5,a3
    800014b4:	058a3703          	ld	a4,88(s4)
    800014b8:	12068693          	addi	a3,a3,288
    800014bc:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800014c0:	6788                	ld	a0,8(a5)
    800014c2:	6b8c                	ld	a1,16(a5)
    800014c4:	6f90                	ld	a2,24(a5)
    800014c6:	01073023          	sd	a6,0(a4)
    800014ca:	e708                	sd	a0,8(a4)
    800014cc:	eb0c                	sd	a1,16(a4)
    800014ce:	ef10                	sd	a2,24(a4)
    800014d0:	02078793          	addi	a5,a5,32
    800014d4:	02070713          	addi	a4,a4,32
    800014d8:	fed792e3          	bne	a5,a3,800014bc <fork+0x56>
  np->trapframe->a0 = 0;
    800014dc:	058a3783          	ld	a5,88(s4)
    800014e0:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800014e4:	0d8a8493          	addi	s1,s5,216
    800014e8:	0d8a0913          	addi	s2,s4,216
    800014ec:	158a8993          	addi	s3,s5,344
    800014f0:	a015                	j	80001514 <fork+0xae>
    freeproc(np);
    800014f2:	8552                	mv	a0,s4
    800014f4:	00000097          	auipc	ra,0x0
    800014f8:	d32080e7          	jalr	-718(ra) # 80001226 <freeproc>
    release(&np->lock);
    800014fc:	8552                	mv	a0,s4
    800014fe:	00005097          	auipc	ra,0x5
    80001502:	152080e7          	jalr	338(ra) # 80006650 <release>
    return -1;
    80001506:	597d                	li	s2,-1
    80001508:	6a42                	ld	s4,16(sp)
    8000150a:	a071                	j	80001596 <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    8000150c:	04a1                	addi	s1,s1,8
    8000150e:	0921                	addi	s2,s2,8
    80001510:	01348b63          	beq	s1,s3,80001526 <fork+0xc0>
    if(p->ofile[i])
    80001514:	6088                	ld	a0,0(s1)
    80001516:	d97d                	beqz	a0,8000150c <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    80001518:	00002097          	auipc	ra,0x2
    8000151c:	772080e7          	jalr	1906(ra) # 80003c8a <filedup>
    80001520:	00a93023          	sd	a0,0(s2)
    80001524:	b7e5                	j	8000150c <fork+0xa6>
  np->cwd = idup(p->cwd);
    80001526:	158ab503          	ld	a0,344(s5)
    8000152a:	00002097          	auipc	ra,0x2
    8000152e:	8dc080e7          	jalr	-1828(ra) # 80002e06 <idup>
    80001532:	14aa3c23          	sd	a0,344(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001536:	4641                	li	a2,16
    80001538:	160a8593          	addi	a1,s5,352
    8000153c:	160a0513          	addi	a0,s4,352
    80001540:	fffff097          	auipc	ra,0xfffff
    80001544:	d7c080e7          	jalr	-644(ra) # 800002bc <safestrcpy>
  pid = np->pid;
    80001548:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    8000154c:	8552                	mv	a0,s4
    8000154e:	00005097          	auipc	ra,0x5
    80001552:	102080e7          	jalr	258(ra) # 80006650 <release>
  acquire(&wait_lock);
    80001556:	0000a497          	auipc	s1,0xa
    8000155a:	e5248493          	addi	s1,s1,-430 # 8000b3a8 <wait_lock>
    8000155e:	8526                	mv	a0,s1
    80001560:	00005097          	auipc	ra,0x5
    80001564:	03c080e7          	jalr	60(ra) # 8000659c <acquire>
  np->parent = p;
    80001568:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000156c:	8526                	mv	a0,s1
    8000156e:	00005097          	auipc	ra,0x5
    80001572:	0e2080e7          	jalr	226(ra) # 80006650 <release>
  acquire(&np->lock);
    80001576:	8552                	mv	a0,s4
    80001578:	00005097          	auipc	ra,0x5
    8000157c:	024080e7          	jalr	36(ra) # 8000659c <acquire>
  np->state = RUNNABLE;
    80001580:	478d                	li	a5,3
    80001582:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001586:	8552                	mv	a0,s4
    80001588:	00005097          	auipc	ra,0x5
    8000158c:	0c8080e7          	jalr	200(ra) # 80006650 <release>
  return pid;
    80001590:	74a2                	ld	s1,40(sp)
    80001592:	69e2                	ld	s3,24(sp)
    80001594:	6a42                	ld	s4,16(sp)
}
    80001596:	854a                	mv	a0,s2
    80001598:	70e2                	ld	ra,56(sp)
    8000159a:	7442                	ld	s0,48(sp)
    8000159c:	7902                	ld	s2,32(sp)
    8000159e:	6aa2                	ld	s5,8(sp)
    800015a0:	6121                	addi	sp,sp,64
    800015a2:	8082                	ret
    return -1;
    800015a4:	597d                	li	s2,-1
    800015a6:	bfc5                	j	80001596 <fork+0x130>

00000000800015a8 <scheduler>:
{
    800015a8:	7139                	addi	sp,sp,-64
    800015aa:	fc06                	sd	ra,56(sp)
    800015ac:	f822                	sd	s0,48(sp)
    800015ae:	f426                	sd	s1,40(sp)
    800015b0:	f04a                	sd	s2,32(sp)
    800015b2:	ec4e                	sd	s3,24(sp)
    800015b4:	e852                	sd	s4,16(sp)
    800015b6:	e456                	sd	s5,8(sp)
    800015b8:	e05a                	sd	s6,0(sp)
    800015ba:	0080                	addi	s0,sp,64
    800015bc:	8792                	mv	a5,tp
  int id = r_tp();
    800015be:	2781                	sext.w	a5,a5
  c->proc = 0;
    800015c0:	00779a93          	slli	s5,a5,0x7
    800015c4:	0000a717          	auipc	a4,0xa
    800015c8:	dcc70713          	addi	a4,a4,-564 # 8000b390 <pid_lock>
    800015cc:	9756                	add	a4,a4,s5
    800015ce:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800015d2:	0000a717          	auipc	a4,0xa
    800015d6:	df670713          	addi	a4,a4,-522 # 8000b3c8 <cpus+0x8>
    800015da:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800015dc:	498d                	li	s3,3
        p->state = RUNNING;
    800015de:	4b11                	li	s6,4
        c->proc = p;
    800015e0:	079e                	slli	a5,a5,0x7
    800015e2:	0000aa17          	auipc	s4,0xa
    800015e6:	daea0a13          	addi	s4,s4,-594 # 8000b390 <pid_lock>
    800015ea:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800015ec:	00010917          	auipc	s2,0x10
    800015f0:	dd490913          	addi	s2,s2,-556 # 800113c0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800015f4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800015f8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800015fc:	10079073          	csrw	sstatus,a5
    80001600:	0000a497          	auipc	s1,0xa
    80001604:	1c048493          	addi	s1,s1,448 # 8000b7c0 <proc>
    80001608:	a811                	j	8000161c <scheduler+0x74>
      release(&p->lock);
    8000160a:	8526                	mv	a0,s1
    8000160c:	00005097          	auipc	ra,0x5
    80001610:	044080e7          	jalr	68(ra) # 80006650 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001614:	17048493          	addi	s1,s1,368
    80001618:	fd248ee3          	beq	s1,s2,800015f4 <scheduler+0x4c>
      acquire(&p->lock);
    8000161c:	8526                	mv	a0,s1
    8000161e:	00005097          	auipc	ra,0x5
    80001622:	f7e080e7          	jalr	-130(ra) # 8000659c <acquire>
      if(p->state == RUNNABLE) {
    80001626:	4c9c                	lw	a5,24(s1)
    80001628:	ff3791e3          	bne	a5,s3,8000160a <scheduler+0x62>
        p->state = RUNNING;
    8000162c:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001630:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001634:	06848593          	addi	a1,s1,104
    80001638:	8556                	mv	a0,s5
    8000163a:	00000097          	auipc	ra,0x0
    8000163e:	684080e7          	jalr	1668(ra) # 80001cbe <swtch>
        c->proc = 0;
    80001642:	020a3823          	sd	zero,48(s4)
    80001646:	b7d1                	j	8000160a <scheduler+0x62>

0000000080001648 <sched>:
{
    80001648:	7179                	addi	sp,sp,-48
    8000164a:	f406                	sd	ra,40(sp)
    8000164c:	f022                	sd	s0,32(sp)
    8000164e:	ec26                	sd	s1,24(sp)
    80001650:	e84a                	sd	s2,16(sp)
    80001652:	e44e                	sd	s3,8(sp)
    80001654:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001656:	00000097          	auipc	ra,0x0
    8000165a:	9aa080e7          	jalr	-1622(ra) # 80001000 <myproc>
    8000165e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001660:	00005097          	auipc	ra,0x5
    80001664:	ec2080e7          	jalr	-318(ra) # 80006522 <holding>
    80001668:	c93d                	beqz	a0,800016de <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000166a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000166c:	2781                	sext.w	a5,a5
    8000166e:	079e                	slli	a5,a5,0x7
    80001670:	0000a717          	auipc	a4,0xa
    80001674:	d2070713          	addi	a4,a4,-736 # 8000b390 <pid_lock>
    80001678:	97ba                	add	a5,a5,a4
    8000167a:	0a87a703          	lw	a4,168(a5)
    8000167e:	4785                	li	a5,1
    80001680:	06f71763          	bne	a4,a5,800016ee <sched+0xa6>
  if(p->state == RUNNING)
    80001684:	4c98                	lw	a4,24(s1)
    80001686:	4791                	li	a5,4
    80001688:	06f70b63          	beq	a4,a5,800016fe <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000168c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001690:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001692:	efb5                	bnez	a5,8000170e <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001694:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001696:	0000a917          	auipc	s2,0xa
    8000169a:	cfa90913          	addi	s2,s2,-774 # 8000b390 <pid_lock>
    8000169e:	2781                	sext.w	a5,a5
    800016a0:	079e                	slli	a5,a5,0x7
    800016a2:	97ca                	add	a5,a5,s2
    800016a4:	0ac7a983          	lw	s3,172(a5)
    800016a8:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800016aa:	2781                	sext.w	a5,a5
    800016ac:	079e                	slli	a5,a5,0x7
    800016ae:	0000a597          	auipc	a1,0xa
    800016b2:	d1a58593          	addi	a1,a1,-742 # 8000b3c8 <cpus+0x8>
    800016b6:	95be                	add	a1,a1,a5
    800016b8:	06848513          	addi	a0,s1,104
    800016bc:	00000097          	auipc	ra,0x0
    800016c0:	602080e7          	jalr	1538(ra) # 80001cbe <swtch>
    800016c4:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800016c6:	2781                	sext.w	a5,a5
    800016c8:	079e                	slli	a5,a5,0x7
    800016ca:	993e                	add	s2,s2,a5
    800016cc:	0b392623          	sw	s3,172(s2)
}
    800016d0:	70a2                	ld	ra,40(sp)
    800016d2:	7402                	ld	s0,32(sp)
    800016d4:	64e2                	ld	s1,24(sp)
    800016d6:	6942                	ld	s2,16(sp)
    800016d8:	69a2                	ld	s3,8(sp)
    800016da:	6145                	addi	sp,sp,48
    800016dc:	8082                	ret
    panic("sched p->lock");
    800016de:	00007517          	auipc	a0,0x7
    800016e2:	b5a50513          	addi	a0,a0,-1190 # 80008238 <etext+0x238>
    800016e6:	00005097          	auipc	ra,0x5
    800016ea:	93c080e7          	jalr	-1732(ra) # 80006022 <panic>
    panic("sched locks");
    800016ee:	00007517          	auipc	a0,0x7
    800016f2:	b5a50513          	addi	a0,a0,-1190 # 80008248 <etext+0x248>
    800016f6:	00005097          	auipc	ra,0x5
    800016fa:	92c080e7          	jalr	-1748(ra) # 80006022 <panic>
    panic("sched running");
    800016fe:	00007517          	auipc	a0,0x7
    80001702:	b5a50513          	addi	a0,a0,-1190 # 80008258 <etext+0x258>
    80001706:	00005097          	auipc	ra,0x5
    8000170a:	91c080e7          	jalr	-1764(ra) # 80006022 <panic>
    panic("sched interruptible");
    8000170e:	00007517          	auipc	a0,0x7
    80001712:	b5a50513          	addi	a0,a0,-1190 # 80008268 <etext+0x268>
    80001716:	00005097          	auipc	ra,0x5
    8000171a:	90c080e7          	jalr	-1780(ra) # 80006022 <panic>

000000008000171e <yield>:
{
    8000171e:	1101                	addi	sp,sp,-32
    80001720:	ec06                	sd	ra,24(sp)
    80001722:	e822                	sd	s0,16(sp)
    80001724:	e426                	sd	s1,8(sp)
    80001726:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001728:	00000097          	auipc	ra,0x0
    8000172c:	8d8080e7          	jalr	-1832(ra) # 80001000 <myproc>
    80001730:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001732:	00005097          	auipc	ra,0x5
    80001736:	e6a080e7          	jalr	-406(ra) # 8000659c <acquire>
  p->state = RUNNABLE;
    8000173a:	478d                	li	a5,3
    8000173c:	cc9c                	sw	a5,24(s1)
  sched();
    8000173e:	00000097          	auipc	ra,0x0
    80001742:	f0a080e7          	jalr	-246(ra) # 80001648 <sched>
  release(&p->lock);
    80001746:	8526                	mv	a0,s1
    80001748:	00005097          	auipc	ra,0x5
    8000174c:	f08080e7          	jalr	-248(ra) # 80006650 <release>
}
    80001750:	60e2                	ld	ra,24(sp)
    80001752:	6442                	ld	s0,16(sp)
    80001754:	64a2                	ld	s1,8(sp)
    80001756:	6105                	addi	sp,sp,32
    80001758:	8082                	ret

000000008000175a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000175a:	7179                	addi	sp,sp,-48
    8000175c:	f406                	sd	ra,40(sp)
    8000175e:	f022                	sd	s0,32(sp)
    80001760:	ec26                	sd	s1,24(sp)
    80001762:	e84a                	sd	s2,16(sp)
    80001764:	e44e                	sd	s3,8(sp)
    80001766:	1800                	addi	s0,sp,48
    80001768:	89aa                	mv	s3,a0
    8000176a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000176c:	00000097          	auipc	ra,0x0
    80001770:	894080e7          	jalr	-1900(ra) # 80001000 <myproc>
    80001774:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001776:	00005097          	auipc	ra,0x5
    8000177a:	e26080e7          	jalr	-474(ra) # 8000659c <acquire>
  release(lk);
    8000177e:	854a                	mv	a0,s2
    80001780:	00005097          	auipc	ra,0x5
    80001784:	ed0080e7          	jalr	-304(ra) # 80006650 <release>

  // Go to sleep.
  p->chan = chan;
    80001788:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000178c:	4789                	li	a5,2
    8000178e:	cc9c                	sw	a5,24(s1)

  sched();
    80001790:	00000097          	auipc	ra,0x0
    80001794:	eb8080e7          	jalr	-328(ra) # 80001648 <sched>

  // Tidy up.
  p->chan = 0;
    80001798:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000179c:	8526                	mv	a0,s1
    8000179e:	00005097          	auipc	ra,0x5
    800017a2:	eb2080e7          	jalr	-334(ra) # 80006650 <release>
  acquire(lk);
    800017a6:	854a                	mv	a0,s2
    800017a8:	00005097          	auipc	ra,0x5
    800017ac:	df4080e7          	jalr	-524(ra) # 8000659c <acquire>
}
    800017b0:	70a2                	ld	ra,40(sp)
    800017b2:	7402                	ld	s0,32(sp)
    800017b4:	64e2                	ld	s1,24(sp)
    800017b6:	6942                	ld	s2,16(sp)
    800017b8:	69a2                	ld	s3,8(sp)
    800017ba:	6145                	addi	sp,sp,48
    800017bc:	8082                	ret

00000000800017be <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800017be:	7139                	addi	sp,sp,-64
    800017c0:	fc06                	sd	ra,56(sp)
    800017c2:	f822                	sd	s0,48(sp)
    800017c4:	f426                	sd	s1,40(sp)
    800017c6:	f04a                	sd	s2,32(sp)
    800017c8:	ec4e                	sd	s3,24(sp)
    800017ca:	e852                	sd	s4,16(sp)
    800017cc:	e456                	sd	s5,8(sp)
    800017ce:	0080                	addi	s0,sp,64
    800017d0:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800017d2:	0000a497          	auipc	s1,0xa
    800017d6:	fee48493          	addi	s1,s1,-18 # 8000b7c0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800017da:	4989                	li	s3,2
        p->state = RUNNABLE;
    800017dc:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800017de:	00010917          	auipc	s2,0x10
    800017e2:	be290913          	addi	s2,s2,-1054 # 800113c0 <tickslock>
    800017e6:	a811                	j	800017fa <wakeup+0x3c>
      }
      release(&p->lock);
    800017e8:	8526                	mv	a0,s1
    800017ea:	00005097          	auipc	ra,0x5
    800017ee:	e66080e7          	jalr	-410(ra) # 80006650 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800017f2:	17048493          	addi	s1,s1,368
    800017f6:	03248663          	beq	s1,s2,80001822 <wakeup+0x64>
    if(p != myproc()){
    800017fa:	00000097          	auipc	ra,0x0
    800017fe:	806080e7          	jalr	-2042(ra) # 80001000 <myproc>
    80001802:	fea488e3          	beq	s1,a0,800017f2 <wakeup+0x34>
      acquire(&p->lock);
    80001806:	8526                	mv	a0,s1
    80001808:	00005097          	auipc	ra,0x5
    8000180c:	d94080e7          	jalr	-620(ra) # 8000659c <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001810:	4c9c                	lw	a5,24(s1)
    80001812:	fd379be3          	bne	a5,s3,800017e8 <wakeup+0x2a>
    80001816:	709c                	ld	a5,32(s1)
    80001818:	fd4798e3          	bne	a5,s4,800017e8 <wakeup+0x2a>
        p->state = RUNNABLE;
    8000181c:	0154ac23          	sw	s5,24(s1)
    80001820:	b7e1                	j	800017e8 <wakeup+0x2a>
    }
  }
}
    80001822:	70e2                	ld	ra,56(sp)
    80001824:	7442                	ld	s0,48(sp)
    80001826:	74a2                	ld	s1,40(sp)
    80001828:	7902                	ld	s2,32(sp)
    8000182a:	69e2                	ld	s3,24(sp)
    8000182c:	6a42                	ld	s4,16(sp)
    8000182e:	6aa2                	ld	s5,8(sp)
    80001830:	6121                	addi	sp,sp,64
    80001832:	8082                	ret

0000000080001834 <reparent>:
{
    80001834:	7179                	addi	sp,sp,-48
    80001836:	f406                	sd	ra,40(sp)
    80001838:	f022                	sd	s0,32(sp)
    8000183a:	ec26                	sd	s1,24(sp)
    8000183c:	e84a                	sd	s2,16(sp)
    8000183e:	e44e                	sd	s3,8(sp)
    80001840:	e052                	sd	s4,0(sp)
    80001842:	1800                	addi	s0,sp,48
    80001844:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001846:	0000a497          	auipc	s1,0xa
    8000184a:	f7a48493          	addi	s1,s1,-134 # 8000b7c0 <proc>
      pp->parent = initproc;
    8000184e:	0000aa17          	auipc	s4,0xa
    80001852:	b02a0a13          	addi	s4,s4,-1278 # 8000b350 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001856:	00010997          	auipc	s3,0x10
    8000185a:	b6a98993          	addi	s3,s3,-1174 # 800113c0 <tickslock>
    8000185e:	a029                	j	80001868 <reparent+0x34>
    80001860:	17048493          	addi	s1,s1,368
    80001864:	01348d63          	beq	s1,s3,8000187e <reparent+0x4a>
    if(pp->parent == p){
    80001868:	7c9c                	ld	a5,56(s1)
    8000186a:	ff279be3          	bne	a5,s2,80001860 <reparent+0x2c>
      pp->parent = initproc;
    8000186e:	000a3503          	ld	a0,0(s4)
    80001872:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001874:	00000097          	auipc	ra,0x0
    80001878:	f4a080e7          	jalr	-182(ra) # 800017be <wakeup>
    8000187c:	b7d5                	j	80001860 <reparent+0x2c>
}
    8000187e:	70a2                	ld	ra,40(sp)
    80001880:	7402                	ld	s0,32(sp)
    80001882:	64e2                	ld	s1,24(sp)
    80001884:	6942                	ld	s2,16(sp)
    80001886:	69a2                	ld	s3,8(sp)
    80001888:	6a02                	ld	s4,0(sp)
    8000188a:	6145                	addi	sp,sp,48
    8000188c:	8082                	ret

000000008000188e <exit>:
{
    8000188e:	7179                	addi	sp,sp,-48
    80001890:	f406                	sd	ra,40(sp)
    80001892:	f022                	sd	s0,32(sp)
    80001894:	ec26                	sd	s1,24(sp)
    80001896:	e84a                	sd	s2,16(sp)
    80001898:	e44e                	sd	s3,8(sp)
    8000189a:	e052                	sd	s4,0(sp)
    8000189c:	1800                	addi	s0,sp,48
    8000189e:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800018a0:	fffff097          	auipc	ra,0xfffff
    800018a4:	760080e7          	jalr	1888(ra) # 80001000 <myproc>
    800018a8:	89aa                	mv	s3,a0
  if(p == initproc)
    800018aa:	0000a797          	auipc	a5,0xa
    800018ae:	aa67b783          	ld	a5,-1370(a5) # 8000b350 <initproc>
    800018b2:	0d850493          	addi	s1,a0,216
    800018b6:	15850913          	addi	s2,a0,344
    800018ba:	02a79363          	bne	a5,a0,800018e0 <exit+0x52>
    panic("init exiting");
    800018be:	00007517          	auipc	a0,0x7
    800018c2:	9c250513          	addi	a0,a0,-1598 # 80008280 <etext+0x280>
    800018c6:	00004097          	auipc	ra,0x4
    800018ca:	75c080e7          	jalr	1884(ra) # 80006022 <panic>
      fileclose(f);
    800018ce:	00002097          	auipc	ra,0x2
    800018d2:	40e080e7          	jalr	1038(ra) # 80003cdc <fileclose>
      p->ofile[fd] = 0;
    800018d6:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800018da:	04a1                	addi	s1,s1,8
    800018dc:	01248563          	beq	s1,s2,800018e6 <exit+0x58>
    if(p->ofile[fd]){
    800018e0:	6088                	ld	a0,0(s1)
    800018e2:	f575                	bnez	a0,800018ce <exit+0x40>
    800018e4:	bfdd                	j	800018da <exit+0x4c>
  begin_op();
    800018e6:	00002097          	auipc	ra,0x2
    800018ea:	f2c080e7          	jalr	-212(ra) # 80003812 <begin_op>
  iput(p->cwd);
    800018ee:	1589b503          	ld	a0,344(s3)
    800018f2:	00001097          	auipc	ra,0x1
    800018f6:	710080e7          	jalr	1808(ra) # 80003002 <iput>
  end_op();
    800018fa:	00002097          	auipc	ra,0x2
    800018fe:	f92080e7          	jalr	-110(ra) # 8000388c <end_op>
  p->cwd = 0;
    80001902:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    80001906:	0000a497          	auipc	s1,0xa
    8000190a:	aa248493          	addi	s1,s1,-1374 # 8000b3a8 <wait_lock>
    8000190e:	8526                	mv	a0,s1
    80001910:	00005097          	auipc	ra,0x5
    80001914:	c8c080e7          	jalr	-884(ra) # 8000659c <acquire>
  reparent(p);
    80001918:	854e                	mv	a0,s3
    8000191a:	00000097          	auipc	ra,0x0
    8000191e:	f1a080e7          	jalr	-230(ra) # 80001834 <reparent>
  wakeup(p->parent);
    80001922:	0389b503          	ld	a0,56(s3)
    80001926:	00000097          	auipc	ra,0x0
    8000192a:	e98080e7          	jalr	-360(ra) # 800017be <wakeup>
  acquire(&p->lock);
    8000192e:	854e                	mv	a0,s3
    80001930:	00005097          	auipc	ra,0x5
    80001934:	c6c080e7          	jalr	-916(ra) # 8000659c <acquire>
  p->xstate = status;
    80001938:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000193c:	4795                	li	a5,5
    8000193e:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001942:	8526                	mv	a0,s1
    80001944:	00005097          	auipc	ra,0x5
    80001948:	d0c080e7          	jalr	-756(ra) # 80006650 <release>
  sched();
    8000194c:	00000097          	auipc	ra,0x0
    80001950:	cfc080e7          	jalr	-772(ra) # 80001648 <sched>
  panic("zombie exit");
    80001954:	00007517          	auipc	a0,0x7
    80001958:	93c50513          	addi	a0,a0,-1732 # 80008290 <etext+0x290>
    8000195c:	00004097          	auipc	ra,0x4
    80001960:	6c6080e7          	jalr	1734(ra) # 80006022 <panic>

0000000080001964 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001964:	7179                	addi	sp,sp,-48
    80001966:	f406                	sd	ra,40(sp)
    80001968:	f022                	sd	s0,32(sp)
    8000196a:	ec26                	sd	s1,24(sp)
    8000196c:	e84a                	sd	s2,16(sp)
    8000196e:	e44e                	sd	s3,8(sp)
    80001970:	1800                	addi	s0,sp,48
    80001972:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001974:	0000a497          	auipc	s1,0xa
    80001978:	e4c48493          	addi	s1,s1,-436 # 8000b7c0 <proc>
    8000197c:	00010997          	auipc	s3,0x10
    80001980:	a4498993          	addi	s3,s3,-1468 # 800113c0 <tickslock>
    acquire(&p->lock);
    80001984:	8526                	mv	a0,s1
    80001986:	00005097          	auipc	ra,0x5
    8000198a:	c16080e7          	jalr	-1002(ra) # 8000659c <acquire>
    if(p->pid == pid){
    8000198e:	589c                	lw	a5,48(s1)
    80001990:	01278d63          	beq	a5,s2,800019aa <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001994:	8526                	mv	a0,s1
    80001996:	00005097          	auipc	ra,0x5
    8000199a:	cba080e7          	jalr	-838(ra) # 80006650 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000199e:	17048493          	addi	s1,s1,368
    800019a2:	ff3491e3          	bne	s1,s3,80001984 <kill+0x20>
  }
  return -1;
    800019a6:	557d                	li	a0,-1
    800019a8:	a829                	j	800019c2 <kill+0x5e>
      p->killed = 1;
    800019aa:	4785                	li	a5,1
    800019ac:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800019ae:	4c98                	lw	a4,24(s1)
    800019b0:	4789                	li	a5,2
    800019b2:	00f70f63          	beq	a4,a5,800019d0 <kill+0x6c>
      release(&p->lock);
    800019b6:	8526                	mv	a0,s1
    800019b8:	00005097          	auipc	ra,0x5
    800019bc:	c98080e7          	jalr	-872(ra) # 80006650 <release>
      return 0;
    800019c0:	4501                	li	a0,0
}
    800019c2:	70a2                	ld	ra,40(sp)
    800019c4:	7402                	ld	s0,32(sp)
    800019c6:	64e2                	ld	s1,24(sp)
    800019c8:	6942                	ld	s2,16(sp)
    800019ca:	69a2                	ld	s3,8(sp)
    800019cc:	6145                	addi	sp,sp,48
    800019ce:	8082                	ret
        p->state = RUNNABLE;
    800019d0:	478d                	li	a5,3
    800019d2:	cc9c                	sw	a5,24(s1)
    800019d4:	b7cd                	j	800019b6 <kill+0x52>

00000000800019d6 <setkilled>:

void
setkilled(struct proc *p)
{
    800019d6:	1101                	addi	sp,sp,-32
    800019d8:	ec06                	sd	ra,24(sp)
    800019da:	e822                	sd	s0,16(sp)
    800019dc:	e426                	sd	s1,8(sp)
    800019de:	1000                	addi	s0,sp,32
    800019e0:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800019e2:	00005097          	auipc	ra,0x5
    800019e6:	bba080e7          	jalr	-1094(ra) # 8000659c <acquire>
  p->killed = 1;
    800019ea:	4785                	li	a5,1
    800019ec:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800019ee:	8526                	mv	a0,s1
    800019f0:	00005097          	auipc	ra,0x5
    800019f4:	c60080e7          	jalr	-928(ra) # 80006650 <release>
}
    800019f8:	60e2                	ld	ra,24(sp)
    800019fa:	6442                	ld	s0,16(sp)
    800019fc:	64a2                	ld	s1,8(sp)
    800019fe:	6105                	addi	sp,sp,32
    80001a00:	8082                	ret

0000000080001a02 <killed>:

int
killed(struct proc *p)
{
    80001a02:	1101                	addi	sp,sp,-32
    80001a04:	ec06                	sd	ra,24(sp)
    80001a06:	e822                	sd	s0,16(sp)
    80001a08:	e426                	sd	s1,8(sp)
    80001a0a:	e04a                	sd	s2,0(sp)
    80001a0c:	1000                	addi	s0,sp,32
    80001a0e:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001a10:	00005097          	auipc	ra,0x5
    80001a14:	b8c080e7          	jalr	-1140(ra) # 8000659c <acquire>
  k = p->killed;
    80001a18:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001a1c:	8526                	mv	a0,s1
    80001a1e:	00005097          	auipc	ra,0x5
    80001a22:	c32080e7          	jalr	-974(ra) # 80006650 <release>
  return k;
}
    80001a26:	854a                	mv	a0,s2
    80001a28:	60e2                	ld	ra,24(sp)
    80001a2a:	6442                	ld	s0,16(sp)
    80001a2c:	64a2                	ld	s1,8(sp)
    80001a2e:	6902                	ld	s2,0(sp)
    80001a30:	6105                	addi	sp,sp,32
    80001a32:	8082                	ret

0000000080001a34 <wait>:
{
    80001a34:	715d                	addi	sp,sp,-80
    80001a36:	e486                	sd	ra,72(sp)
    80001a38:	e0a2                	sd	s0,64(sp)
    80001a3a:	fc26                	sd	s1,56(sp)
    80001a3c:	f84a                	sd	s2,48(sp)
    80001a3e:	f44e                	sd	s3,40(sp)
    80001a40:	f052                	sd	s4,32(sp)
    80001a42:	ec56                	sd	s5,24(sp)
    80001a44:	e85a                	sd	s6,16(sp)
    80001a46:	e45e                	sd	s7,8(sp)
    80001a48:	e062                	sd	s8,0(sp)
    80001a4a:	0880                	addi	s0,sp,80
    80001a4c:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001a4e:	fffff097          	auipc	ra,0xfffff
    80001a52:	5b2080e7          	jalr	1458(ra) # 80001000 <myproc>
    80001a56:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001a58:	0000a517          	auipc	a0,0xa
    80001a5c:	95050513          	addi	a0,a0,-1712 # 8000b3a8 <wait_lock>
    80001a60:	00005097          	auipc	ra,0x5
    80001a64:	b3c080e7          	jalr	-1220(ra) # 8000659c <acquire>
    havekids = 0;
    80001a68:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001a6a:	4a15                	li	s4,5
        havekids = 1;
    80001a6c:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001a6e:	00010997          	auipc	s3,0x10
    80001a72:	95298993          	addi	s3,s3,-1710 # 800113c0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001a76:	0000ac17          	auipc	s8,0xa
    80001a7a:	932c0c13          	addi	s8,s8,-1742 # 8000b3a8 <wait_lock>
    80001a7e:	a0d1                	j	80001b42 <wait+0x10e>
          pid = pp->pid;
    80001a80:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001a84:	000b0e63          	beqz	s6,80001aa0 <wait+0x6c>
    80001a88:	4691                	li	a3,4
    80001a8a:	02c48613          	addi	a2,s1,44
    80001a8e:	85da                	mv	a1,s6
    80001a90:	05093503          	ld	a0,80(s2)
    80001a94:	fffff097          	auipc	ra,0xfffff
    80001a98:	0b8080e7          	jalr	184(ra) # 80000b4c <copyout>
    80001a9c:	04054163          	bltz	a0,80001ade <wait+0xaa>
          freeproc(pp);
    80001aa0:	8526                	mv	a0,s1
    80001aa2:	fffff097          	auipc	ra,0xfffff
    80001aa6:	784080e7          	jalr	1924(ra) # 80001226 <freeproc>
          release(&pp->lock);
    80001aaa:	8526                	mv	a0,s1
    80001aac:	00005097          	auipc	ra,0x5
    80001ab0:	ba4080e7          	jalr	-1116(ra) # 80006650 <release>
          release(&wait_lock);
    80001ab4:	0000a517          	auipc	a0,0xa
    80001ab8:	8f450513          	addi	a0,a0,-1804 # 8000b3a8 <wait_lock>
    80001abc:	00005097          	auipc	ra,0x5
    80001ac0:	b94080e7          	jalr	-1132(ra) # 80006650 <release>
}
    80001ac4:	854e                	mv	a0,s3
    80001ac6:	60a6                	ld	ra,72(sp)
    80001ac8:	6406                	ld	s0,64(sp)
    80001aca:	74e2                	ld	s1,56(sp)
    80001acc:	7942                	ld	s2,48(sp)
    80001ace:	79a2                	ld	s3,40(sp)
    80001ad0:	7a02                	ld	s4,32(sp)
    80001ad2:	6ae2                	ld	s5,24(sp)
    80001ad4:	6b42                	ld	s6,16(sp)
    80001ad6:	6ba2                	ld	s7,8(sp)
    80001ad8:	6c02                	ld	s8,0(sp)
    80001ada:	6161                	addi	sp,sp,80
    80001adc:	8082                	ret
            release(&pp->lock);
    80001ade:	8526                	mv	a0,s1
    80001ae0:	00005097          	auipc	ra,0x5
    80001ae4:	b70080e7          	jalr	-1168(ra) # 80006650 <release>
            release(&wait_lock);
    80001ae8:	0000a517          	auipc	a0,0xa
    80001aec:	8c050513          	addi	a0,a0,-1856 # 8000b3a8 <wait_lock>
    80001af0:	00005097          	auipc	ra,0x5
    80001af4:	b60080e7          	jalr	-1184(ra) # 80006650 <release>
            return -1;
    80001af8:	59fd                	li	s3,-1
    80001afa:	b7e9                	j	80001ac4 <wait+0x90>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001afc:	17048493          	addi	s1,s1,368
    80001b00:	03348463          	beq	s1,s3,80001b28 <wait+0xf4>
      if(pp->parent == p){
    80001b04:	7c9c                	ld	a5,56(s1)
    80001b06:	ff279be3          	bne	a5,s2,80001afc <wait+0xc8>
        acquire(&pp->lock);
    80001b0a:	8526                	mv	a0,s1
    80001b0c:	00005097          	auipc	ra,0x5
    80001b10:	a90080e7          	jalr	-1392(ra) # 8000659c <acquire>
        if(pp->state == ZOMBIE){
    80001b14:	4c9c                	lw	a5,24(s1)
    80001b16:	f74785e3          	beq	a5,s4,80001a80 <wait+0x4c>
        release(&pp->lock);
    80001b1a:	8526                	mv	a0,s1
    80001b1c:	00005097          	auipc	ra,0x5
    80001b20:	b34080e7          	jalr	-1228(ra) # 80006650 <release>
        havekids = 1;
    80001b24:	8756                	mv	a4,s5
    80001b26:	bfd9                	j	80001afc <wait+0xc8>
    if(!havekids || killed(p)){
    80001b28:	c31d                	beqz	a4,80001b4e <wait+0x11a>
    80001b2a:	854a                	mv	a0,s2
    80001b2c:	00000097          	auipc	ra,0x0
    80001b30:	ed6080e7          	jalr	-298(ra) # 80001a02 <killed>
    80001b34:	ed09                	bnez	a0,80001b4e <wait+0x11a>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001b36:	85e2                	mv	a1,s8
    80001b38:	854a                	mv	a0,s2
    80001b3a:	00000097          	auipc	ra,0x0
    80001b3e:	c20080e7          	jalr	-992(ra) # 8000175a <sleep>
    havekids = 0;
    80001b42:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001b44:	0000a497          	auipc	s1,0xa
    80001b48:	c7c48493          	addi	s1,s1,-900 # 8000b7c0 <proc>
    80001b4c:	bf65                	j	80001b04 <wait+0xd0>
      release(&wait_lock);
    80001b4e:	0000a517          	auipc	a0,0xa
    80001b52:	85a50513          	addi	a0,a0,-1958 # 8000b3a8 <wait_lock>
    80001b56:	00005097          	auipc	ra,0x5
    80001b5a:	afa080e7          	jalr	-1286(ra) # 80006650 <release>
      return -1;
    80001b5e:	59fd                	li	s3,-1
    80001b60:	b795                	j	80001ac4 <wait+0x90>

0000000080001b62 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001b62:	7179                	addi	sp,sp,-48
    80001b64:	f406                	sd	ra,40(sp)
    80001b66:	f022                	sd	s0,32(sp)
    80001b68:	ec26                	sd	s1,24(sp)
    80001b6a:	e84a                	sd	s2,16(sp)
    80001b6c:	e44e                	sd	s3,8(sp)
    80001b6e:	e052                	sd	s4,0(sp)
    80001b70:	1800                	addi	s0,sp,48
    80001b72:	84aa                	mv	s1,a0
    80001b74:	892e                	mv	s2,a1
    80001b76:	89b2                	mv	s3,a2
    80001b78:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b7a:	fffff097          	auipc	ra,0xfffff
    80001b7e:	486080e7          	jalr	1158(ra) # 80001000 <myproc>
  if(user_dst){
    80001b82:	c08d                	beqz	s1,80001ba4 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001b84:	86d2                	mv	a3,s4
    80001b86:	864e                	mv	a2,s3
    80001b88:	85ca                	mv	a1,s2
    80001b8a:	6928                	ld	a0,80(a0)
    80001b8c:	fffff097          	auipc	ra,0xfffff
    80001b90:	fc0080e7          	jalr	-64(ra) # 80000b4c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001b94:	70a2                	ld	ra,40(sp)
    80001b96:	7402                	ld	s0,32(sp)
    80001b98:	64e2                	ld	s1,24(sp)
    80001b9a:	6942                	ld	s2,16(sp)
    80001b9c:	69a2                	ld	s3,8(sp)
    80001b9e:	6a02                	ld	s4,0(sp)
    80001ba0:	6145                	addi	sp,sp,48
    80001ba2:	8082                	ret
    memmove((char *)dst, src, len);
    80001ba4:	000a061b          	sext.w	a2,s4
    80001ba8:	85ce                	mv	a1,s3
    80001baa:	854a                	mv	a0,s2
    80001bac:	ffffe097          	auipc	ra,0xffffe
    80001bb0:	62a080e7          	jalr	1578(ra) # 800001d6 <memmove>
    return 0;
    80001bb4:	8526                	mv	a0,s1
    80001bb6:	bff9                	j	80001b94 <either_copyout+0x32>

0000000080001bb8 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001bb8:	7179                	addi	sp,sp,-48
    80001bba:	f406                	sd	ra,40(sp)
    80001bbc:	f022                	sd	s0,32(sp)
    80001bbe:	ec26                	sd	s1,24(sp)
    80001bc0:	e84a                	sd	s2,16(sp)
    80001bc2:	e44e                	sd	s3,8(sp)
    80001bc4:	e052                	sd	s4,0(sp)
    80001bc6:	1800                	addi	s0,sp,48
    80001bc8:	892a                	mv	s2,a0
    80001bca:	84ae                	mv	s1,a1
    80001bcc:	89b2                	mv	s3,a2
    80001bce:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001bd0:	fffff097          	auipc	ra,0xfffff
    80001bd4:	430080e7          	jalr	1072(ra) # 80001000 <myproc>
  if(user_src){
    80001bd8:	c08d                	beqz	s1,80001bfa <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001bda:	86d2                	mv	a3,s4
    80001bdc:	864e                	mv	a2,s3
    80001bde:	85ca                	mv	a1,s2
    80001be0:	6928                	ld	a0,80(a0)
    80001be2:	fffff097          	auipc	ra,0xfffff
    80001be6:	048080e7          	jalr	72(ra) # 80000c2a <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001bea:	70a2                	ld	ra,40(sp)
    80001bec:	7402                	ld	s0,32(sp)
    80001bee:	64e2                	ld	s1,24(sp)
    80001bf0:	6942                	ld	s2,16(sp)
    80001bf2:	69a2                	ld	s3,8(sp)
    80001bf4:	6a02                	ld	s4,0(sp)
    80001bf6:	6145                	addi	sp,sp,48
    80001bf8:	8082                	ret
    memmove(dst, (char*)src, len);
    80001bfa:	000a061b          	sext.w	a2,s4
    80001bfe:	85ce                	mv	a1,s3
    80001c00:	854a                	mv	a0,s2
    80001c02:	ffffe097          	auipc	ra,0xffffe
    80001c06:	5d4080e7          	jalr	1492(ra) # 800001d6 <memmove>
    return 0;
    80001c0a:	8526                	mv	a0,s1
    80001c0c:	bff9                	j	80001bea <either_copyin+0x32>

0000000080001c0e <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001c0e:	715d                	addi	sp,sp,-80
    80001c10:	e486                	sd	ra,72(sp)
    80001c12:	e0a2                	sd	s0,64(sp)
    80001c14:	fc26                	sd	s1,56(sp)
    80001c16:	f84a                	sd	s2,48(sp)
    80001c18:	f44e                	sd	s3,40(sp)
    80001c1a:	f052                	sd	s4,32(sp)
    80001c1c:	ec56                	sd	s5,24(sp)
    80001c1e:	e85a                	sd	s6,16(sp)
    80001c20:	e45e                	sd	s7,8(sp)
    80001c22:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001c24:	00006517          	auipc	a0,0x6
    80001c28:	3f450513          	addi	a0,a0,1012 # 80008018 <etext+0x18>
    80001c2c:	00004097          	auipc	ra,0x4
    80001c30:	440080e7          	jalr	1088(ra) # 8000606c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001c34:	0000a497          	auipc	s1,0xa
    80001c38:	cec48493          	addi	s1,s1,-788 # 8000b920 <proc+0x160>
    80001c3c:	00010917          	auipc	s2,0x10
    80001c40:	8e490913          	addi	s2,s2,-1820 # 80011520 <bcache+0x148>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c44:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001c46:	00006997          	auipc	s3,0x6
    80001c4a:	65a98993          	addi	s3,s3,1626 # 800082a0 <etext+0x2a0>
    printf("%d %s %s", p->pid, state, p->name);
    80001c4e:	00006a97          	auipc	s5,0x6
    80001c52:	65aa8a93          	addi	s5,s5,1626 # 800082a8 <etext+0x2a8>
    printf("\n");
    80001c56:	00006a17          	auipc	s4,0x6
    80001c5a:	3c2a0a13          	addi	s4,s4,962 # 80008018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c5e:	00007b97          	auipc	s7,0x7
    80001c62:	b72b8b93          	addi	s7,s7,-1166 # 800087d0 <states.0>
    80001c66:	a00d                	j	80001c88 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001c68:	ed06a583          	lw	a1,-304(a3)
    80001c6c:	8556                	mv	a0,s5
    80001c6e:	00004097          	auipc	ra,0x4
    80001c72:	3fe080e7          	jalr	1022(ra) # 8000606c <printf>
    printf("\n");
    80001c76:	8552                	mv	a0,s4
    80001c78:	00004097          	auipc	ra,0x4
    80001c7c:	3f4080e7          	jalr	1012(ra) # 8000606c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001c80:	17048493          	addi	s1,s1,368
    80001c84:	03248263          	beq	s1,s2,80001ca8 <procdump+0x9a>
    if(p->state == UNUSED)
    80001c88:	86a6                	mv	a3,s1
    80001c8a:	eb84a783          	lw	a5,-328(s1)
    80001c8e:	dbed                	beqz	a5,80001c80 <procdump+0x72>
      state = "???";
    80001c90:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c92:	fcfb6be3          	bltu	s6,a5,80001c68 <procdump+0x5a>
    80001c96:	02079713          	slli	a4,a5,0x20
    80001c9a:	01d75793          	srli	a5,a4,0x1d
    80001c9e:	97de                	add	a5,a5,s7
    80001ca0:	6390                	ld	a2,0(a5)
    80001ca2:	f279                	bnez	a2,80001c68 <procdump+0x5a>
      state = "???";
    80001ca4:	864e                	mv	a2,s3
    80001ca6:	b7c9                	j	80001c68 <procdump+0x5a>
  }
}
    80001ca8:	60a6                	ld	ra,72(sp)
    80001caa:	6406                	ld	s0,64(sp)
    80001cac:	74e2                	ld	s1,56(sp)
    80001cae:	7942                	ld	s2,48(sp)
    80001cb0:	79a2                	ld	s3,40(sp)
    80001cb2:	7a02                	ld	s4,32(sp)
    80001cb4:	6ae2                	ld	s5,24(sp)
    80001cb6:	6b42                	ld	s6,16(sp)
    80001cb8:	6ba2                	ld	s7,8(sp)
    80001cba:	6161                	addi	sp,sp,80
    80001cbc:	8082                	ret

0000000080001cbe <swtch>:
    80001cbe:	00153023          	sd	ra,0(a0)
    80001cc2:	00253423          	sd	sp,8(a0)
    80001cc6:	e900                	sd	s0,16(a0)
    80001cc8:	ed04                	sd	s1,24(a0)
    80001cca:	03253023          	sd	s2,32(a0)
    80001cce:	03353423          	sd	s3,40(a0)
    80001cd2:	03453823          	sd	s4,48(a0)
    80001cd6:	03553c23          	sd	s5,56(a0)
    80001cda:	05653023          	sd	s6,64(a0)
    80001cde:	05753423          	sd	s7,72(a0)
    80001ce2:	05853823          	sd	s8,80(a0)
    80001ce6:	05953c23          	sd	s9,88(a0)
    80001cea:	07a53023          	sd	s10,96(a0)
    80001cee:	07b53423          	sd	s11,104(a0)
    80001cf2:	0005b083          	ld	ra,0(a1)
    80001cf6:	0085b103          	ld	sp,8(a1)
    80001cfa:	6980                	ld	s0,16(a1)
    80001cfc:	6d84                	ld	s1,24(a1)
    80001cfe:	0205b903          	ld	s2,32(a1)
    80001d02:	0285b983          	ld	s3,40(a1)
    80001d06:	0305ba03          	ld	s4,48(a1)
    80001d0a:	0385ba83          	ld	s5,56(a1)
    80001d0e:	0405bb03          	ld	s6,64(a1)
    80001d12:	0485bb83          	ld	s7,72(a1)
    80001d16:	0505bc03          	ld	s8,80(a1)
    80001d1a:	0585bc83          	ld	s9,88(a1)
    80001d1e:	0605bd03          	ld	s10,96(a1)
    80001d22:	0685bd83          	ld	s11,104(a1)
    80001d26:	8082                	ret

0000000080001d28 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001d28:	1141                	addi	sp,sp,-16
    80001d2a:	e406                	sd	ra,8(sp)
    80001d2c:	e022                	sd	s0,0(sp)
    80001d2e:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001d30:	00006597          	auipc	a1,0x6
    80001d34:	5b858593          	addi	a1,a1,1464 # 800082e8 <etext+0x2e8>
    80001d38:	0000f517          	auipc	a0,0xf
    80001d3c:	68850513          	addi	a0,a0,1672 # 800113c0 <tickslock>
    80001d40:	00004097          	auipc	ra,0x4
    80001d44:	7cc080e7          	jalr	1996(ra) # 8000650c <initlock>
}
    80001d48:	60a2                	ld	ra,8(sp)
    80001d4a:	6402                	ld	s0,0(sp)
    80001d4c:	0141                	addi	sp,sp,16
    80001d4e:	8082                	ret

0000000080001d50 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001d50:	1141                	addi	sp,sp,-16
    80001d52:	e422                	sd	s0,8(sp)
    80001d54:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d56:	00003797          	auipc	a5,0x3
    80001d5a:	69a78793          	addi	a5,a5,1690 # 800053f0 <kernelvec>
    80001d5e:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001d62:	6422                	ld	s0,8(sp)
    80001d64:	0141                	addi	sp,sp,16
    80001d66:	8082                	ret

0000000080001d68 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001d68:	1141                	addi	sp,sp,-16
    80001d6a:	e406                	sd	ra,8(sp)
    80001d6c:	e022                	sd	s0,0(sp)
    80001d6e:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001d70:	fffff097          	auipc	ra,0xfffff
    80001d74:	290080e7          	jalr	656(ra) # 80001000 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d78:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001d7c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d7e:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001d82:	00005697          	auipc	a3,0x5
    80001d86:	27e68693          	addi	a3,a3,638 # 80007000 <_trampoline>
    80001d8a:	00005717          	auipc	a4,0x5
    80001d8e:	27670713          	addi	a4,a4,630 # 80007000 <_trampoline>
    80001d92:	8f15                	sub	a4,a4,a3
    80001d94:	040007b7          	lui	a5,0x4000
    80001d98:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001d9a:	07b2                	slli	a5,a5,0xc
    80001d9c:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d9e:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001da2:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001da4:	18002673          	csrr	a2,satp
    80001da8:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001daa:	6d30                	ld	a2,88(a0)
    80001dac:	6138                	ld	a4,64(a0)
    80001dae:	6585                	lui	a1,0x1
    80001db0:	972e                	add	a4,a4,a1
    80001db2:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001db4:	6d38                	ld	a4,88(a0)
    80001db6:	00000617          	auipc	a2,0x0
    80001dba:	13860613          	addi	a2,a2,312 # 80001eee <usertrap>
    80001dbe:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001dc0:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001dc2:	8612                	mv	a2,tp
    80001dc4:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dc6:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001dca:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001dce:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dd2:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001dd6:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001dd8:	6f18                	ld	a4,24(a4)
    80001dda:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001dde:	6928                	ld	a0,80(a0)
    80001de0:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001de2:	00005717          	auipc	a4,0x5
    80001de6:	2ba70713          	addi	a4,a4,698 # 8000709c <userret>
    80001dea:	8f15                	sub	a4,a4,a3
    80001dec:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001dee:	577d                	li	a4,-1
    80001df0:	177e                	slli	a4,a4,0x3f
    80001df2:	8d59                	or	a0,a0,a4
    80001df4:	9782                	jalr	a5
}
    80001df6:	60a2                	ld	ra,8(sp)
    80001df8:	6402                	ld	s0,0(sp)
    80001dfa:	0141                	addi	sp,sp,16
    80001dfc:	8082                	ret

0000000080001dfe <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001dfe:	1101                	addi	sp,sp,-32
    80001e00:	ec06                	sd	ra,24(sp)
    80001e02:	e822                	sd	s0,16(sp)
    80001e04:	e426                	sd	s1,8(sp)
    80001e06:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001e08:	0000f497          	auipc	s1,0xf
    80001e0c:	5b848493          	addi	s1,s1,1464 # 800113c0 <tickslock>
    80001e10:	8526                	mv	a0,s1
    80001e12:	00004097          	auipc	ra,0x4
    80001e16:	78a080e7          	jalr	1930(ra) # 8000659c <acquire>
  ticks++;
    80001e1a:	00009517          	auipc	a0,0x9
    80001e1e:	53e50513          	addi	a0,a0,1342 # 8000b358 <ticks>
    80001e22:	411c                	lw	a5,0(a0)
    80001e24:	2785                	addiw	a5,a5,1
    80001e26:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001e28:	00000097          	auipc	ra,0x0
    80001e2c:	996080e7          	jalr	-1642(ra) # 800017be <wakeup>
  release(&tickslock);
    80001e30:	8526                	mv	a0,s1
    80001e32:	00005097          	auipc	ra,0x5
    80001e36:	81e080e7          	jalr	-2018(ra) # 80006650 <release>
}
    80001e3a:	60e2                	ld	ra,24(sp)
    80001e3c:	6442                	ld	s0,16(sp)
    80001e3e:	64a2                	ld	s1,8(sp)
    80001e40:	6105                	addi	sp,sp,32
    80001e42:	8082                	ret

0000000080001e44 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e44:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001e48:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001e4a:	0a07d163          	bgez	a5,80001eec <devintr+0xa8>
{
    80001e4e:	1101                	addi	sp,sp,-32
    80001e50:	ec06                	sd	ra,24(sp)
    80001e52:	e822                	sd	s0,16(sp)
    80001e54:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001e56:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001e5a:	46a5                	li	a3,9
    80001e5c:	00d70c63          	beq	a4,a3,80001e74 <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80001e60:	577d                	li	a4,-1
    80001e62:	177e                	slli	a4,a4,0x3f
    80001e64:	0705                	addi	a4,a4,1
    return 0;
    80001e66:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001e68:	06e78163          	beq	a5,a4,80001eca <devintr+0x86>
  }
}
    80001e6c:	60e2                	ld	ra,24(sp)
    80001e6e:	6442                	ld	s0,16(sp)
    80001e70:	6105                	addi	sp,sp,32
    80001e72:	8082                	ret
    80001e74:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001e76:	00003097          	auipc	ra,0x3
    80001e7a:	686080e7          	jalr	1670(ra) # 800054fc <plic_claim>
    80001e7e:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001e80:	47a9                	li	a5,10
    80001e82:	00f50963          	beq	a0,a5,80001e94 <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80001e86:	4785                	li	a5,1
    80001e88:	00f50b63          	beq	a0,a5,80001e9e <devintr+0x5a>
    return 1;
    80001e8c:	4505                	li	a0,1
    } else if(irq){
    80001e8e:	ec89                	bnez	s1,80001ea8 <devintr+0x64>
    80001e90:	64a2                	ld	s1,8(sp)
    80001e92:	bfe9                	j	80001e6c <devintr+0x28>
      uartintr();
    80001e94:	00004097          	auipc	ra,0x4
    80001e98:	628080e7          	jalr	1576(ra) # 800064bc <uartintr>
    if(irq)
    80001e9c:	a839                	j	80001eba <devintr+0x76>
      virtio_disk_intr();
    80001e9e:	00004097          	auipc	ra,0x4
    80001ea2:	b88080e7          	jalr	-1144(ra) # 80005a26 <virtio_disk_intr>
    if(irq)
    80001ea6:	a811                	j	80001eba <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001ea8:	85a6                	mv	a1,s1
    80001eaa:	00006517          	auipc	a0,0x6
    80001eae:	44650513          	addi	a0,a0,1094 # 800082f0 <etext+0x2f0>
    80001eb2:	00004097          	auipc	ra,0x4
    80001eb6:	1ba080e7          	jalr	442(ra) # 8000606c <printf>
      plic_complete(irq);
    80001eba:	8526                	mv	a0,s1
    80001ebc:	00003097          	auipc	ra,0x3
    80001ec0:	664080e7          	jalr	1636(ra) # 80005520 <plic_complete>
    return 1;
    80001ec4:	4505                	li	a0,1
    80001ec6:	64a2                	ld	s1,8(sp)
    80001ec8:	b755                	j	80001e6c <devintr+0x28>
    if(cpuid() == 0){
    80001eca:	fffff097          	auipc	ra,0xfffff
    80001ece:	10a080e7          	jalr	266(ra) # 80000fd4 <cpuid>
    80001ed2:	c901                	beqz	a0,80001ee2 <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001ed4:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001ed8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001eda:	14479073          	csrw	sip,a5
    return 2;
    80001ede:	4509                	li	a0,2
    80001ee0:	b771                	j	80001e6c <devintr+0x28>
      clockintr();
    80001ee2:	00000097          	auipc	ra,0x0
    80001ee6:	f1c080e7          	jalr	-228(ra) # 80001dfe <clockintr>
    80001eea:	b7ed                	j	80001ed4 <devintr+0x90>
}
    80001eec:	8082                	ret

0000000080001eee <usertrap>:
{
    80001eee:	1101                	addi	sp,sp,-32
    80001ef0:	ec06                	sd	ra,24(sp)
    80001ef2:	e822                	sd	s0,16(sp)
    80001ef4:	e426                	sd	s1,8(sp)
    80001ef6:	e04a                	sd	s2,0(sp)
    80001ef8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001efa:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001efe:	1007f793          	andi	a5,a5,256
    80001f02:	e3b1                	bnez	a5,80001f46 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001f04:	00003797          	auipc	a5,0x3
    80001f08:	4ec78793          	addi	a5,a5,1260 # 800053f0 <kernelvec>
    80001f0c:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001f10:	fffff097          	auipc	ra,0xfffff
    80001f14:	0f0080e7          	jalr	240(ra) # 80001000 <myproc>
    80001f18:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001f1a:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f1c:	14102773          	csrr	a4,sepc
    80001f20:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f22:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001f26:	47a1                	li	a5,8
    80001f28:	02f70763          	beq	a4,a5,80001f56 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001f2c:	00000097          	auipc	ra,0x0
    80001f30:	f18080e7          	jalr	-232(ra) # 80001e44 <devintr>
    80001f34:	892a                	mv	s2,a0
    80001f36:	c151                	beqz	a0,80001fba <usertrap+0xcc>
  if(killed(p))
    80001f38:	8526                	mv	a0,s1
    80001f3a:	00000097          	auipc	ra,0x0
    80001f3e:	ac8080e7          	jalr	-1336(ra) # 80001a02 <killed>
    80001f42:	c929                	beqz	a0,80001f94 <usertrap+0xa6>
    80001f44:	a099                	j	80001f8a <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001f46:	00006517          	auipc	a0,0x6
    80001f4a:	3ca50513          	addi	a0,a0,970 # 80008310 <etext+0x310>
    80001f4e:	00004097          	auipc	ra,0x4
    80001f52:	0d4080e7          	jalr	212(ra) # 80006022 <panic>
    if(killed(p))
    80001f56:	00000097          	auipc	ra,0x0
    80001f5a:	aac080e7          	jalr	-1364(ra) # 80001a02 <killed>
    80001f5e:	e921                	bnez	a0,80001fae <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001f60:	6cb8                	ld	a4,88(s1)
    80001f62:	6f1c                	ld	a5,24(a4)
    80001f64:	0791                	addi	a5,a5,4
    80001f66:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f68:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f6c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f70:	10079073          	csrw	sstatus,a5
    syscall();
    80001f74:	00000097          	auipc	ra,0x0
    80001f78:	2d4080e7          	jalr	724(ra) # 80002248 <syscall>
  if(killed(p))
    80001f7c:	8526                	mv	a0,s1
    80001f7e:	00000097          	auipc	ra,0x0
    80001f82:	a84080e7          	jalr	-1404(ra) # 80001a02 <killed>
    80001f86:	c911                	beqz	a0,80001f9a <usertrap+0xac>
    80001f88:	4901                	li	s2,0
    exit(-1);
    80001f8a:	557d                	li	a0,-1
    80001f8c:	00000097          	auipc	ra,0x0
    80001f90:	902080e7          	jalr	-1790(ra) # 8000188e <exit>
  if(which_dev == 2)
    80001f94:	4789                	li	a5,2
    80001f96:	04f90f63          	beq	s2,a5,80001ff4 <usertrap+0x106>
  usertrapret();
    80001f9a:	00000097          	auipc	ra,0x0
    80001f9e:	dce080e7          	jalr	-562(ra) # 80001d68 <usertrapret>
}
    80001fa2:	60e2                	ld	ra,24(sp)
    80001fa4:	6442                	ld	s0,16(sp)
    80001fa6:	64a2                	ld	s1,8(sp)
    80001fa8:	6902                	ld	s2,0(sp)
    80001faa:	6105                	addi	sp,sp,32
    80001fac:	8082                	ret
      exit(-1);
    80001fae:	557d                	li	a0,-1
    80001fb0:	00000097          	auipc	ra,0x0
    80001fb4:	8de080e7          	jalr	-1826(ra) # 8000188e <exit>
    80001fb8:	b765                	j	80001f60 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001fba:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001fbe:	5890                	lw	a2,48(s1)
    80001fc0:	00006517          	auipc	a0,0x6
    80001fc4:	37050513          	addi	a0,a0,880 # 80008330 <etext+0x330>
    80001fc8:	00004097          	auipc	ra,0x4
    80001fcc:	0a4080e7          	jalr	164(ra) # 8000606c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fd0:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001fd4:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001fd8:	00006517          	auipc	a0,0x6
    80001fdc:	38850513          	addi	a0,a0,904 # 80008360 <etext+0x360>
    80001fe0:	00004097          	auipc	ra,0x4
    80001fe4:	08c080e7          	jalr	140(ra) # 8000606c <printf>
    setkilled(p);
    80001fe8:	8526                	mv	a0,s1
    80001fea:	00000097          	auipc	ra,0x0
    80001fee:	9ec080e7          	jalr	-1556(ra) # 800019d6 <setkilled>
    80001ff2:	b769                	j	80001f7c <usertrap+0x8e>
    yield();
    80001ff4:	fffff097          	auipc	ra,0xfffff
    80001ff8:	72a080e7          	jalr	1834(ra) # 8000171e <yield>
    80001ffc:	bf79                	j	80001f9a <usertrap+0xac>

0000000080001ffe <kerneltrap>:
{
    80001ffe:	7179                	addi	sp,sp,-48
    80002000:	f406                	sd	ra,40(sp)
    80002002:	f022                	sd	s0,32(sp)
    80002004:	ec26                	sd	s1,24(sp)
    80002006:	e84a                	sd	s2,16(sp)
    80002008:	e44e                	sd	s3,8(sp)
    8000200a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000200c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002010:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002014:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002018:	1004f793          	andi	a5,s1,256
    8000201c:	cb85                	beqz	a5,8000204c <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000201e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002022:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002024:	ef85                	bnez	a5,8000205c <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002026:	00000097          	auipc	ra,0x0
    8000202a:	e1e080e7          	jalr	-482(ra) # 80001e44 <devintr>
    8000202e:	cd1d                	beqz	a0,8000206c <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002030:	4789                	li	a5,2
    80002032:	06f50a63          	beq	a0,a5,800020a6 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002036:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000203a:	10049073          	csrw	sstatus,s1
}
    8000203e:	70a2                	ld	ra,40(sp)
    80002040:	7402                	ld	s0,32(sp)
    80002042:	64e2                	ld	s1,24(sp)
    80002044:	6942                	ld	s2,16(sp)
    80002046:	69a2                	ld	s3,8(sp)
    80002048:	6145                	addi	sp,sp,48
    8000204a:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    8000204c:	00006517          	auipc	a0,0x6
    80002050:	33450513          	addi	a0,a0,820 # 80008380 <etext+0x380>
    80002054:	00004097          	auipc	ra,0x4
    80002058:	fce080e7          	jalr	-50(ra) # 80006022 <panic>
    panic("kerneltrap: interrupts enabled");
    8000205c:	00006517          	auipc	a0,0x6
    80002060:	34c50513          	addi	a0,a0,844 # 800083a8 <etext+0x3a8>
    80002064:	00004097          	auipc	ra,0x4
    80002068:	fbe080e7          	jalr	-66(ra) # 80006022 <panic>
    printf("scause %p\n", scause);
    8000206c:	85ce                	mv	a1,s3
    8000206e:	00006517          	auipc	a0,0x6
    80002072:	35a50513          	addi	a0,a0,858 # 800083c8 <etext+0x3c8>
    80002076:	00004097          	auipc	ra,0x4
    8000207a:	ff6080e7          	jalr	-10(ra) # 8000606c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000207e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002082:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002086:	00006517          	auipc	a0,0x6
    8000208a:	35250513          	addi	a0,a0,850 # 800083d8 <etext+0x3d8>
    8000208e:	00004097          	auipc	ra,0x4
    80002092:	fde080e7          	jalr	-34(ra) # 8000606c <printf>
    panic("kerneltrap");
    80002096:	00006517          	auipc	a0,0x6
    8000209a:	35a50513          	addi	a0,a0,858 # 800083f0 <etext+0x3f0>
    8000209e:	00004097          	auipc	ra,0x4
    800020a2:	f84080e7          	jalr	-124(ra) # 80006022 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800020a6:	fffff097          	auipc	ra,0xfffff
    800020aa:	f5a080e7          	jalr	-166(ra) # 80001000 <myproc>
    800020ae:	d541                	beqz	a0,80002036 <kerneltrap+0x38>
    800020b0:	fffff097          	auipc	ra,0xfffff
    800020b4:	f50080e7          	jalr	-176(ra) # 80001000 <myproc>
    800020b8:	4d18                	lw	a4,24(a0)
    800020ba:	4791                	li	a5,4
    800020bc:	f6f71de3          	bne	a4,a5,80002036 <kerneltrap+0x38>
    yield();
    800020c0:	fffff097          	auipc	ra,0xfffff
    800020c4:	65e080e7          	jalr	1630(ra) # 8000171e <yield>
    800020c8:	b7bd                	j	80002036 <kerneltrap+0x38>

00000000800020ca <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800020ca:	1101                	addi	sp,sp,-32
    800020cc:	ec06                	sd	ra,24(sp)
    800020ce:	e822                	sd	s0,16(sp)
    800020d0:	e426                	sd	s1,8(sp)
    800020d2:	1000                	addi	s0,sp,32
    800020d4:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800020d6:	fffff097          	auipc	ra,0xfffff
    800020da:	f2a080e7          	jalr	-214(ra) # 80001000 <myproc>
  switch (n) {
    800020de:	4795                	li	a5,5
    800020e0:	0497e163          	bltu	a5,s1,80002122 <argraw+0x58>
    800020e4:	048a                	slli	s1,s1,0x2
    800020e6:	00006717          	auipc	a4,0x6
    800020ea:	71a70713          	addi	a4,a4,1818 # 80008800 <states.0+0x30>
    800020ee:	94ba                	add	s1,s1,a4
    800020f0:	409c                	lw	a5,0(s1)
    800020f2:	97ba                	add	a5,a5,a4
    800020f4:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800020f6:	6d3c                	ld	a5,88(a0)
    800020f8:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800020fa:	60e2                	ld	ra,24(sp)
    800020fc:	6442                	ld	s0,16(sp)
    800020fe:	64a2                	ld	s1,8(sp)
    80002100:	6105                	addi	sp,sp,32
    80002102:	8082                	ret
    return p->trapframe->a1;
    80002104:	6d3c                	ld	a5,88(a0)
    80002106:	7fa8                	ld	a0,120(a5)
    80002108:	bfcd                	j	800020fa <argraw+0x30>
    return p->trapframe->a2;
    8000210a:	6d3c                	ld	a5,88(a0)
    8000210c:	63c8                	ld	a0,128(a5)
    8000210e:	b7f5                	j	800020fa <argraw+0x30>
    return p->trapframe->a3;
    80002110:	6d3c                	ld	a5,88(a0)
    80002112:	67c8                	ld	a0,136(a5)
    80002114:	b7dd                	j	800020fa <argraw+0x30>
    return p->trapframe->a4;
    80002116:	6d3c                	ld	a5,88(a0)
    80002118:	6bc8                	ld	a0,144(a5)
    8000211a:	b7c5                	j	800020fa <argraw+0x30>
    return p->trapframe->a5;
    8000211c:	6d3c                	ld	a5,88(a0)
    8000211e:	6fc8                	ld	a0,152(a5)
    80002120:	bfe9                	j	800020fa <argraw+0x30>
  panic("argraw");
    80002122:	00006517          	auipc	a0,0x6
    80002126:	2de50513          	addi	a0,a0,734 # 80008400 <etext+0x400>
    8000212a:	00004097          	auipc	ra,0x4
    8000212e:	ef8080e7          	jalr	-264(ra) # 80006022 <panic>

0000000080002132 <fetchaddr>:
{
    80002132:	1101                	addi	sp,sp,-32
    80002134:	ec06                	sd	ra,24(sp)
    80002136:	e822                	sd	s0,16(sp)
    80002138:	e426                	sd	s1,8(sp)
    8000213a:	e04a                	sd	s2,0(sp)
    8000213c:	1000                	addi	s0,sp,32
    8000213e:	84aa                	mv	s1,a0
    80002140:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002142:	fffff097          	auipc	ra,0xfffff
    80002146:	ebe080e7          	jalr	-322(ra) # 80001000 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    8000214a:	653c                	ld	a5,72(a0)
    8000214c:	02f4f863          	bgeu	s1,a5,8000217c <fetchaddr+0x4a>
    80002150:	00848713          	addi	a4,s1,8
    80002154:	02e7e663          	bltu	a5,a4,80002180 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002158:	46a1                	li	a3,8
    8000215a:	8626                	mv	a2,s1
    8000215c:	85ca                	mv	a1,s2
    8000215e:	6928                	ld	a0,80(a0)
    80002160:	fffff097          	auipc	ra,0xfffff
    80002164:	aca080e7          	jalr	-1334(ra) # 80000c2a <copyin>
    80002168:	00a03533          	snez	a0,a0
    8000216c:	40a00533          	neg	a0,a0
}
    80002170:	60e2                	ld	ra,24(sp)
    80002172:	6442                	ld	s0,16(sp)
    80002174:	64a2                	ld	s1,8(sp)
    80002176:	6902                	ld	s2,0(sp)
    80002178:	6105                	addi	sp,sp,32
    8000217a:	8082                	ret
    return -1;
    8000217c:	557d                	li	a0,-1
    8000217e:	bfcd                	j	80002170 <fetchaddr+0x3e>
    80002180:	557d                	li	a0,-1
    80002182:	b7fd                	j	80002170 <fetchaddr+0x3e>

0000000080002184 <fetchstr>:
{
    80002184:	7179                	addi	sp,sp,-48
    80002186:	f406                	sd	ra,40(sp)
    80002188:	f022                	sd	s0,32(sp)
    8000218a:	ec26                	sd	s1,24(sp)
    8000218c:	e84a                	sd	s2,16(sp)
    8000218e:	e44e                	sd	s3,8(sp)
    80002190:	1800                	addi	s0,sp,48
    80002192:	892a                	mv	s2,a0
    80002194:	84ae                	mv	s1,a1
    80002196:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002198:	fffff097          	auipc	ra,0xfffff
    8000219c:	e68080e7          	jalr	-408(ra) # 80001000 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    800021a0:	86ce                	mv	a3,s3
    800021a2:	864a                	mv	a2,s2
    800021a4:	85a6                	mv	a1,s1
    800021a6:	6928                	ld	a0,80(a0)
    800021a8:	fffff097          	auipc	ra,0xfffff
    800021ac:	b10080e7          	jalr	-1264(ra) # 80000cb8 <copyinstr>
    800021b0:	00054e63          	bltz	a0,800021cc <fetchstr+0x48>
  return strlen(buf);
    800021b4:	8526                	mv	a0,s1
    800021b6:	ffffe097          	auipc	ra,0xffffe
    800021ba:	138080e7          	jalr	312(ra) # 800002ee <strlen>
}
    800021be:	70a2                	ld	ra,40(sp)
    800021c0:	7402                	ld	s0,32(sp)
    800021c2:	64e2                	ld	s1,24(sp)
    800021c4:	6942                	ld	s2,16(sp)
    800021c6:	69a2                	ld	s3,8(sp)
    800021c8:	6145                	addi	sp,sp,48
    800021ca:	8082                	ret
    return -1;
    800021cc:	557d                	li	a0,-1
    800021ce:	bfc5                	j	800021be <fetchstr+0x3a>

00000000800021d0 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800021d0:	1101                	addi	sp,sp,-32
    800021d2:	ec06                	sd	ra,24(sp)
    800021d4:	e822                	sd	s0,16(sp)
    800021d6:	e426                	sd	s1,8(sp)
    800021d8:	1000                	addi	s0,sp,32
    800021da:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800021dc:	00000097          	auipc	ra,0x0
    800021e0:	eee080e7          	jalr	-274(ra) # 800020ca <argraw>
    800021e4:	c088                	sw	a0,0(s1)
}
    800021e6:	60e2                	ld	ra,24(sp)
    800021e8:	6442                	ld	s0,16(sp)
    800021ea:	64a2                	ld	s1,8(sp)
    800021ec:	6105                	addi	sp,sp,32
    800021ee:	8082                	ret

00000000800021f0 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800021f0:	1101                	addi	sp,sp,-32
    800021f2:	ec06                	sd	ra,24(sp)
    800021f4:	e822                	sd	s0,16(sp)
    800021f6:	e426                	sd	s1,8(sp)
    800021f8:	1000                	addi	s0,sp,32
    800021fa:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800021fc:	00000097          	auipc	ra,0x0
    80002200:	ece080e7          	jalr	-306(ra) # 800020ca <argraw>
    80002204:	e088                	sd	a0,0(s1)
}
    80002206:	60e2                	ld	ra,24(sp)
    80002208:	6442                	ld	s0,16(sp)
    8000220a:	64a2                	ld	s1,8(sp)
    8000220c:	6105                	addi	sp,sp,32
    8000220e:	8082                	ret

0000000080002210 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002210:	7179                	addi	sp,sp,-48
    80002212:	f406                	sd	ra,40(sp)
    80002214:	f022                	sd	s0,32(sp)
    80002216:	ec26                	sd	s1,24(sp)
    80002218:	e84a                	sd	s2,16(sp)
    8000221a:	1800                	addi	s0,sp,48
    8000221c:	84ae                	mv	s1,a1
    8000221e:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002220:	fd840593          	addi	a1,s0,-40
    80002224:	00000097          	auipc	ra,0x0
    80002228:	fcc080e7          	jalr	-52(ra) # 800021f0 <argaddr>
  return fetchstr(addr, buf, max);
    8000222c:	864a                	mv	a2,s2
    8000222e:	85a6                	mv	a1,s1
    80002230:	fd843503          	ld	a0,-40(s0)
    80002234:	00000097          	auipc	ra,0x0
    80002238:	f50080e7          	jalr	-176(ra) # 80002184 <fetchstr>
}
    8000223c:	70a2                	ld	ra,40(sp)
    8000223e:	7402                	ld	s0,32(sp)
    80002240:	64e2                	ld	s1,24(sp)
    80002242:	6942                	ld	s2,16(sp)
    80002244:	6145                	addi	sp,sp,48
    80002246:	8082                	ret

0000000080002248 <syscall>:



void
syscall(void)
{
    80002248:	1101                	addi	sp,sp,-32
    8000224a:	ec06                	sd	ra,24(sp)
    8000224c:	e822                	sd	s0,16(sp)
    8000224e:	e426                	sd	s1,8(sp)
    80002250:	e04a                	sd	s2,0(sp)
    80002252:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002254:	fffff097          	auipc	ra,0xfffff
    80002258:	dac080e7          	jalr	-596(ra) # 80001000 <myproc>
    8000225c:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000225e:	05853903          	ld	s2,88(a0)
    80002262:	0a893783          	ld	a5,168(s2)
    80002266:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000226a:	37fd                	addiw	a5,a5,-1
    8000226c:	4775                	li	a4,29
    8000226e:	00f76f63          	bltu	a4,a5,8000228c <syscall+0x44>
    80002272:	00369713          	slli	a4,a3,0x3
    80002276:	00006797          	auipc	a5,0x6
    8000227a:	5a278793          	addi	a5,a5,1442 # 80008818 <syscalls>
    8000227e:	97ba                	add	a5,a5,a4
    80002280:	639c                	ld	a5,0(a5)
    80002282:	c789                	beqz	a5,8000228c <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002284:	9782                	jalr	a5
    80002286:	06a93823          	sd	a0,112(s2)
    8000228a:	a839                	j	800022a8 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000228c:	16048613          	addi	a2,s1,352
    80002290:	588c                	lw	a1,48(s1)
    80002292:	00006517          	auipc	a0,0x6
    80002296:	17650513          	addi	a0,a0,374 # 80008408 <etext+0x408>
    8000229a:	00004097          	auipc	ra,0x4
    8000229e:	dd2080e7          	jalr	-558(ra) # 8000606c <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800022a2:	6cbc                	ld	a5,88(s1)
    800022a4:	577d                	li	a4,-1
    800022a6:	fbb8                	sd	a4,112(a5)
  }
}
    800022a8:	60e2                	ld	ra,24(sp)
    800022aa:	6442                	ld	s0,16(sp)
    800022ac:	64a2                	ld	s1,8(sp)
    800022ae:	6902                	ld	s2,0(sp)
    800022b0:	6105                	addi	sp,sp,32
    800022b2:	8082                	ret

00000000800022b4 <sys_exit>:

#define MAX_PAGES 32

uint64
sys_exit(void)
{
    800022b4:	1101                	addi	sp,sp,-32
    800022b6:	ec06                	sd	ra,24(sp)
    800022b8:	e822                	sd	s0,16(sp)
    800022ba:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800022bc:	fec40593          	addi	a1,s0,-20
    800022c0:	4501                	li	a0,0
    800022c2:	00000097          	auipc	ra,0x0
    800022c6:	f0e080e7          	jalr	-242(ra) # 800021d0 <argint>
  exit(n);
    800022ca:	fec42503          	lw	a0,-20(s0)
    800022ce:	fffff097          	auipc	ra,0xfffff
    800022d2:	5c0080e7          	jalr	1472(ra) # 8000188e <exit>
  return 0;  // not reached
}
    800022d6:	4501                	li	a0,0
    800022d8:	60e2                	ld	ra,24(sp)
    800022da:	6442                	ld	s0,16(sp)
    800022dc:	6105                	addi	sp,sp,32
    800022de:	8082                	ret

00000000800022e0 <sys_getpid>:

uint64
sys_getpid(void)
{
    800022e0:	1141                	addi	sp,sp,-16
    800022e2:	e406                	sd	ra,8(sp)
    800022e4:	e022                	sd	s0,0(sp)
    800022e6:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800022e8:	fffff097          	auipc	ra,0xfffff
    800022ec:	d18080e7          	jalr	-744(ra) # 80001000 <myproc>
}
    800022f0:	5908                	lw	a0,48(a0)
    800022f2:	60a2                	ld	ra,8(sp)
    800022f4:	6402                	ld	s0,0(sp)
    800022f6:	0141                	addi	sp,sp,16
    800022f8:	8082                	ret

00000000800022fa <sys_fork>:

uint64
sys_fork(void)
{
    800022fa:	1141                	addi	sp,sp,-16
    800022fc:	e406                	sd	ra,8(sp)
    800022fe:	e022                	sd	s0,0(sp)
    80002300:	0800                	addi	s0,sp,16
  return fork();
    80002302:	fffff097          	auipc	ra,0xfffff
    80002306:	164080e7          	jalr	356(ra) # 80001466 <fork>
}
    8000230a:	60a2                	ld	ra,8(sp)
    8000230c:	6402                	ld	s0,0(sp)
    8000230e:	0141                	addi	sp,sp,16
    80002310:	8082                	ret

0000000080002312 <sys_wait>:

uint64
sys_wait(void)
{
    80002312:	1101                	addi	sp,sp,-32
    80002314:	ec06                	sd	ra,24(sp)
    80002316:	e822                	sd	s0,16(sp)
    80002318:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000231a:	fe840593          	addi	a1,s0,-24
    8000231e:	4501                	li	a0,0
    80002320:	00000097          	auipc	ra,0x0
    80002324:	ed0080e7          	jalr	-304(ra) # 800021f0 <argaddr>
  return wait(p);
    80002328:	fe843503          	ld	a0,-24(s0)
    8000232c:	fffff097          	auipc	ra,0xfffff
    80002330:	708080e7          	jalr	1800(ra) # 80001a34 <wait>
}
    80002334:	60e2                	ld	ra,24(sp)
    80002336:	6442                	ld	s0,16(sp)
    80002338:	6105                	addi	sp,sp,32
    8000233a:	8082                	ret

000000008000233c <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000233c:	7179                	addi	sp,sp,-48
    8000233e:	f406                	sd	ra,40(sp)
    80002340:	f022                	sd	s0,32(sp)
    80002342:	ec26                	sd	s1,24(sp)
    80002344:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002346:	fdc40593          	addi	a1,s0,-36
    8000234a:	4501                	li	a0,0
    8000234c:	00000097          	auipc	ra,0x0
    80002350:	e84080e7          	jalr	-380(ra) # 800021d0 <argint>
  addr = myproc()->sz;
    80002354:	fffff097          	auipc	ra,0xfffff
    80002358:	cac080e7          	jalr	-852(ra) # 80001000 <myproc>
    8000235c:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    8000235e:	fdc42503          	lw	a0,-36(s0)
    80002362:	fffff097          	auipc	ra,0xfffff
    80002366:	0a8080e7          	jalr	168(ra) # 8000140a <growproc>
    8000236a:	00054863          	bltz	a0,8000237a <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    8000236e:	8526                	mv	a0,s1
    80002370:	70a2                	ld	ra,40(sp)
    80002372:	7402                	ld	s0,32(sp)
    80002374:	64e2                	ld	s1,24(sp)
    80002376:	6145                	addi	sp,sp,48
    80002378:	8082                	ret
    return -1;
    8000237a:	54fd                	li	s1,-1
    8000237c:	bfcd                	j	8000236e <sys_sbrk+0x32>

000000008000237e <sys_sleep>:

uint64
sys_sleep(void)
{
    8000237e:	7139                	addi	sp,sp,-64
    80002380:	fc06                	sd	ra,56(sp)
    80002382:	f822                	sd	s0,48(sp)
    80002384:	f04a                	sd	s2,32(sp)
    80002386:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  argint(0, &n);
    80002388:	fcc40593          	addi	a1,s0,-52
    8000238c:	4501                	li	a0,0
    8000238e:	00000097          	auipc	ra,0x0
    80002392:	e42080e7          	jalr	-446(ra) # 800021d0 <argint>
  acquire(&tickslock);
    80002396:	0000f517          	auipc	a0,0xf
    8000239a:	02a50513          	addi	a0,a0,42 # 800113c0 <tickslock>
    8000239e:	00004097          	auipc	ra,0x4
    800023a2:	1fe080e7          	jalr	510(ra) # 8000659c <acquire>
  ticks0 = ticks;
    800023a6:	00009917          	auipc	s2,0x9
    800023aa:	fb292903          	lw	s2,-78(s2) # 8000b358 <ticks>
  while(ticks - ticks0 < n){
    800023ae:	fcc42783          	lw	a5,-52(s0)
    800023b2:	c3b9                	beqz	a5,800023f8 <sys_sleep+0x7a>
    800023b4:	f426                	sd	s1,40(sp)
    800023b6:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800023b8:	0000f997          	auipc	s3,0xf
    800023bc:	00898993          	addi	s3,s3,8 # 800113c0 <tickslock>
    800023c0:	00009497          	auipc	s1,0x9
    800023c4:	f9848493          	addi	s1,s1,-104 # 8000b358 <ticks>
    if(killed(myproc())){
    800023c8:	fffff097          	auipc	ra,0xfffff
    800023cc:	c38080e7          	jalr	-968(ra) # 80001000 <myproc>
    800023d0:	fffff097          	auipc	ra,0xfffff
    800023d4:	632080e7          	jalr	1586(ra) # 80001a02 <killed>
    800023d8:	ed15                	bnez	a0,80002414 <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    800023da:	85ce                	mv	a1,s3
    800023dc:	8526                	mv	a0,s1
    800023de:	fffff097          	auipc	ra,0xfffff
    800023e2:	37c080e7          	jalr	892(ra) # 8000175a <sleep>
  while(ticks - ticks0 < n){
    800023e6:	409c                	lw	a5,0(s1)
    800023e8:	412787bb          	subw	a5,a5,s2
    800023ec:	fcc42703          	lw	a4,-52(s0)
    800023f0:	fce7ece3          	bltu	a5,a4,800023c8 <sys_sleep+0x4a>
    800023f4:	74a2                	ld	s1,40(sp)
    800023f6:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    800023f8:	0000f517          	auipc	a0,0xf
    800023fc:	fc850513          	addi	a0,a0,-56 # 800113c0 <tickslock>
    80002400:	00004097          	auipc	ra,0x4
    80002404:	250080e7          	jalr	592(ra) # 80006650 <release>
  return 0;
    80002408:	4501                	li	a0,0
}
    8000240a:	70e2                	ld	ra,56(sp)
    8000240c:	7442                	ld	s0,48(sp)
    8000240e:	7902                	ld	s2,32(sp)
    80002410:	6121                	addi	sp,sp,64
    80002412:	8082                	ret
      release(&tickslock);
    80002414:	0000f517          	auipc	a0,0xf
    80002418:	fac50513          	addi	a0,a0,-84 # 800113c0 <tickslock>
    8000241c:	00004097          	auipc	ra,0x4
    80002420:	234080e7          	jalr	564(ra) # 80006650 <release>
      return -1;
    80002424:	557d                	li	a0,-1
    80002426:	74a2                	ld	s1,40(sp)
    80002428:	69e2                	ld	s3,24(sp)
    8000242a:	b7c5                	j	8000240a <sys_sleep+0x8c>

000000008000242c <sys_pgaccess>:

#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
    8000242c:	715d                	addi	sp,sp,-80
    8000242e:	e486                	sd	ra,72(sp)
    80002430:	e0a2                	sd	s0,64(sp)
    80002432:	0880                	addi	s0,sp,80
  uint64 base;    // Địa chỉ cơ sở của vùng nhớ cần kiểm tra
  int num;        // Số lượng trang
  uint64 bitmap_u;  // Địa chỉ để lưu bitmap kết quả

  // Lấy tham số từ tiến trình người dùng
  argaddr(0, &base);
    80002434:	fc840593          	addi	a1,s0,-56
    80002438:	4501                	li	a0,0
    8000243a:	00000097          	auipc	ra,0x0
    8000243e:	db6080e7          	jalr	-586(ra) # 800021f0 <argaddr>
  argint(1, &num);
    80002442:	fc440593          	addi	a1,s0,-60
    80002446:	4505                	li	a0,1
    80002448:	00000097          	auipc	ra,0x0
    8000244c:	d88080e7          	jalr	-632(ra) # 800021d0 <argint>
  argaddr(2, &bitmap_u);
    80002450:	fb840593          	addi	a1,s0,-72
    80002454:	4509                	li	a0,2
    80002456:	00000097          	auipc	ra,0x0
    8000245a:	d9a080e7          	jalr	-614(ra) # 800021f0 <argaddr>

  if (num < 0) // Kiểm tra số lượng trang hợp lệ
    8000245e:	fc442783          	lw	a5,-60(s0)
    80002462:	0a07c863          	bltz	a5,80002512 <sys_pgaccess+0xe6>
    80002466:	f84a                	sd	s2,48(sp)
    return -1;

  if (num > MAX_PAGES)
    80002468:	02000713          	li	a4,32
    8000246c:	00f75663          	bge	a4,a5,80002478 <sys_pgaccess+0x4c>
    num = MAX_PAGES; // Giới hạn số trang có thể truy cập
    80002470:	02000793          	li	a5,32
    80002474:	fcf42223          	sw	a5,-60(s0)

  struct proc *p = myproc();
    80002478:	fffff097          	auipc	ra,0xfffff
    8000247c:	b88080e7          	jalr	-1144(ra) # 80001000 <myproc>
    80002480:	892a                	mv	s2,a0
  uint64 bitmap = 0;
    80002482:	fa043823          	sd	zero,-80(s0)

  for (int i = 0; i < num; i++) {
    80002486:	fc442783          	lw	a5,-60(s0)
    8000248a:	06f05263          	blez	a5,800024ee <sys_pgaccess+0xc2>
    8000248e:	fc26                	sd	s1,56(sp)
    80002490:	f44e                	sd	s3,40(sp)
    80002492:	f052                	sd	s4,32(sp)
    80002494:	4481                	li	s1,0
    pte_t *pte = walk(p->pagetable, va, 0); // Tìm PTE của trang

    if (!pte || (*pte & PTE_V) == 0) // Kiểm tra PTE hợp lệ và được ánh xạ
      continue;

    if (*pte & PTE_A) // Kiểm tra bit PTE_A (trang đã truy cập)
    80002496:	04100993          	li	s3,65
    { 
      bitmap |= (1L << i); // Đặt bit tương ứng trong bitmap
    8000249a:	4a05                	li	s4,1
    8000249c:	a801                	j	800024ac <sys_pgaccess+0x80>
  for (int i = 0; i < num; i++) {
    8000249e:	0485                	addi	s1,s1,1
    800024a0:	fc442703          	lw	a4,-60(s0)
    800024a4:	0004879b          	sext.w	a5,s1
    800024a8:	04e7d063          	bge	a5,a4,800024e8 <sys_pgaccess+0xbc>
    uint64 va = base + i * PGSIZE; // Tính địa chỉ từng trang
    800024ac:	00c49593          	slli	a1,s1,0xc
    pte_t *pte = walk(p->pagetable, va, 0); // Tìm PTE của trang
    800024b0:	4601                	li	a2,0
    800024b2:	fc843783          	ld	a5,-56(s0)
    800024b6:	95be                	add	a1,a1,a5
    800024b8:	05093503          	ld	a0,80(s2)
    800024bc:	ffffe097          	auipc	ra,0xffffe
    800024c0:	f9a080e7          	jalr	-102(ra) # 80000456 <walk>
    if (!pte || (*pte & PTE_V) == 0) // Kiểm tra PTE hợp lệ và được ánh xạ
    800024c4:	dd69                	beqz	a0,8000249e <sys_pgaccess+0x72>
    if (*pte & PTE_A) // Kiểm tra bit PTE_A (trang đã truy cập)
    800024c6:	611c                	ld	a5,0(a0)
    800024c8:	0417f793          	andi	a5,a5,65
    800024cc:	fd3799e3          	bne	a5,s3,8000249e <sys_pgaccess+0x72>
      bitmap |= (1L << i); // Đặt bit tương ứng trong bitmap
    800024d0:	009a1733          	sll	a4,s4,s1
    800024d4:	fb043783          	ld	a5,-80(s0)
    800024d8:	8fd9                	or	a5,a5,a4
    800024da:	faf43823          	sd	a5,-80(s0)
      *pte &= ~PTE_A;      // Xóa bit PTE_A
    800024de:	611c                	ld	a5,0(a0)
    800024e0:	fbf7f793          	andi	a5,a5,-65
    800024e4:	e11c                	sd	a5,0(a0)
    800024e6:	bf65                	j	8000249e <sys_pgaccess+0x72>
    800024e8:	74e2                	ld	s1,56(sp)
    800024ea:	79a2                	ld	s3,40(sp)
    800024ec:	7a02                	ld	s4,32(sp)
    }
  }

  // Sao chép kết quả bitmap từ kernel sang user space
  if (copyout(p->pagetable, bitmap_u, (char *)&bitmap, sizeof(bitmap)) < 0)
    800024ee:	46a1                	li	a3,8
    800024f0:	fb040613          	addi	a2,s0,-80
    800024f4:	fb843583          	ld	a1,-72(s0)
    800024f8:	05093503          	ld	a0,80(s2)
    800024fc:	ffffe097          	auipc	ra,0xffffe
    80002500:	650080e7          	jalr	1616(ra) # 80000b4c <copyout>
    80002504:	41f5551b          	sraiw	a0,a0,0x1f
    80002508:	7942                	ld	s2,48(sp)
    return -1;

  return 0;
}
    8000250a:	60a6                	ld	ra,72(sp)
    8000250c:	6406                	ld	s0,64(sp)
    8000250e:	6161                	addi	sp,sp,80
    80002510:	8082                	ret
    return -1;
    80002512:	557d                	li	a0,-1
    80002514:	bfdd                	j	8000250a <sys_pgaccess+0xde>

0000000080002516 <sys_kill>:
#endif

uint64
sys_kill(void)
{
    80002516:	1101                	addi	sp,sp,-32
    80002518:	ec06                	sd	ra,24(sp)
    8000251a:	e822                	sd	s0,16(sp)
    8000251c:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    8000251e:	fec40593          	addi	a1,s0,-20
    80002522:	4501                	li	a0,0
    80002524:	00000097          	auipc	ra,0x0
    80002528:	cac080e7          	jalr	-852(ra) # 800021d0 <argint>
  return kill(pid);
    8000252c:	fec42503          	lw	a0,-20(s0)
    80002530:	fffff097          	auipc	ra,0xfffff
    80002534:	434080e7          	jalr	1076(ra) # 80001964 <kill>
}
    80002538:	60e2                	ld	ra,24(sp)
    8000253a:	6442                	ld	s0,16(sp)
    8000253c:	6105                	addi	sp,sp,32
    8000253e:	8082                	ret

0000000080002540 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002540:	1101                	addi	sp,sp,-32
    80002542:	ec06                	sd	ra,24(sp)
    80002544:	e822                	sd	s0,16(sp)
    80002546:	e426                	sd	s1,8(sp)
    80002548:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000254a:	0000f517          	auipc	a0,0xf
    8000254e:	e7650513          	addi	a0,a0,-394 # 800113c0 <tickslock>
    80002552:	00004097          	auipc	ra,0x4
    80002556:	04a080e7          	jalr	74(ra) # 8000659c <acquire>
  xticks = ticks;
    8000255a:	00009497          	auipc	s1,0x9
    8000255e:	dfe4a483          	lw	s1,-514(s1) # 8000b358 <ticks>
  release(&tickslock);
    80002562:	0000f517          	auipc	a0,0xf
    80002566:	e5e50513          	addi	a0,a0,-418 # 800113c0 <tickslock>
    8000256a:	00004097          	auipc	ra,0x4
    8000256e:	0e6080e7          	jalr	230(ra) # 80006650 <release>
  return xticks;
}
    80002572:	02049513          	slli	a0,s1,0x20
    80002576:	9101                	srli	a0,a0,0x20
    80002578:	60e2                	ld	ra,24(sp)
    8000257a:	6442                	ld	s0,16(sp)
    8000257c:	64a2                	ld	s1,8(sp)
    8000257e:	6105                	addi	sp,sp,32
    80002580:	8082                	ret

0000000080002582 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002582:	7179                	addi	sp,sp,-48
    80002584:	f406                	sd	ra,40(sp)
    80002586:	f022                	sd	s0,32(sp)
    80002588:	ec26                	sd	s1,24(sp)
    8000258a:	e84a                	sd	s2,16(sp)
    8000258c:	e44e                	sd	s3,8(sp)
    8000258e:	e052                	sd	s4,0(sp)
    80002590:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002592:	00006597          	auipc	a1,0x6
    80002596:	e9658593          	addi	a1,a1,-362 # 80008428 <etext+0x428>
    8000259a:	0000f517          	auipc	a0,0xf
    8000259e:	e3e50513          	addi	a0,a0,-450 # 800113d8 <bcache>
    800025a2:	00004097          	auipc	ra,0x4
    800025a6:	f6a080e7          	jalr	-150(ra) # 8000650c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800025aa:	00017797          	auipc	a5,0x17
    800025ae:	e2e78793          	addi	a5,a5,-466 # 800193d8 <bcache+0x8000>
    800025b2:	00017717          	auipc	a4,0x17
    800025b6:	08e70713          	addi	a4,a4,142 # 80019640 <bcache+0x8268>
    800025ba:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800025be:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800025c2:	0000f497          	auipc	s1,0xf
    800025c6:	e2e48493          	addi	s1,s1,-466 # 800113f0 <bcache+0x18>
    b->next = bcache.head.next;
    800025ca:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800025cc:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800025ce:	00006a17          	auipc	s4,0x6
    800025d2:	e62a0a13          	addi	s4,s4,-414 # 80008430 <etext+0x430>
    b->next = bcache.head.next;
    800025d6:	2b893783          	ld	a5,696(s2)
    800025da:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800025dc:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800025e0:	85d2                	mv	a1,s4
    800025e2:	01048513          	addi	a0,s1,16
    800025e6:	00001097          	auipc	ra,0x1
    800025ea:	4e8080e7          	jalr	1256(ra) # 80003ace <initsleeplock>
    bcache.head.next->prev = b;
    800025ee:	2b893783          	ld	a5,696(s2)
    800025f2:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800025f4:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800025f8:	45848493          	addi	s1,s1,1112
    800025fc:	fd349de3          	bne	s1,s3,800025d6 <binit+0x54>
  }
}
    80002600:	70a2                	ld	ra,40(sp)
    80002602:	7402                	ld	s0,32(sp)
    80002604:	64e2                	ld	s1,24(sp)
    80002606:	6942                	ld	s2,16(sp)
    80002608:	69a2                	ld	s3,8(sp)
    8000260a:	6a02                	ld	s4,0(sp)
    8000260c:	6145                	addi	sp,sp,48
    8000260e:	8082                	ret

0000000080002610 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002610:	7179                	addi	sp,sp,-48
    80002612:	f406                	sd	ra,40(sp)
    80002614:	f022                	sd	s0,32(sp)
    80002616:	ec26                	sd	s1,24(sp)
    80002618:	e84a                	sd	s2,16(sp)
    8000261a:	e44e                	sd	s3,8(sp)
    8000261c:	1800                	addi	s0,sp,48
    8000261e:	892a                	mv	s2,a0
    80002620:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002622:	0000f517          	auipc	a0,0xf
    80002626:	db650513          	addi	a0,a0,-586 # 800113d8 <bcache>
    8000262a:	00004097          	auipc	ra,0x4
    8000262e:	f72080e7          	jalr	-142(ra) # 8000659c <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002632:	00017497          	auipc	s1,0x17
    80002636:	05e4b483          	ld	s1,94(s1) # 80019690 <bcache+0x82b8>
    8000263a:	00017797          	auipc	a5,0x17
    8000263e:	00678793          	addi	a5,a5,6 # 80019640 <bcache+0x8268>
    80002642:	02f48f63          	beq	s1,a5,80002680 <bread+0x70>
    80002646:	873e                	mv	a4,a5
    80002648:	a021                	j	80002650 <bread+0x40>
    8000264a:	68a4                	ld	s1,80(s1)
    8000264c:	02e48a63          	beq	s1,a4,80002680 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002650:	449c                	lw	a5,8(s1)
    80002652:	ff279ce3          	bne	a5,s2,8000264a <bread+0x3a>
    80002656:	44dc                	lw	a5,12(s1)
    80002658:	ff3799e3          	bne	a5,s3,8000264a <bread+0x3a>
      b->refcnt++;
    8000265c:	40bc                	lw	a5,64(s1)
    8000265e:	2785                	addiw	a5,a5,1
    80002660:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002662:	0000f517          	auipc	a0,0xf
    80002666:	d7650513          	addi	a0,a0,-650 # 800113d8 <bcache>
    8000266a:	00004097          	auipc	ra,0x4
    8000266e:	fe6080e7          	jalr	-26(ra) # 80006650 <release>
      acquiresleep(&b->lock);
    80002672:	01048513          	addi	a0,s1,16
    80002676:	00001097          	auipc	ra,0x1
    8000267a:	492080e7          	jalr	1170(ra) # 80003b08 <acquiresleep>
      return b;
    8000267e:	a8b9                	j	800026dc <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002680:	00017497          	auipc	s1,0x17
    80002684:	0084b483          	ld	s1,8(s1) # 80019688 <bcache+0x82b0>
    80002688:	00017797          	auipc	a5,0x17
    8000268c:	fb878793          	addi	a5,a5,-72 # 80019640 <bcache+0x8268>
    80002690:	00f48863          	beq	s1,a5,800026a0 <bread+0x90>
    80002694:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002696:	40bc                	lw	a5,64(s1)
    80002698:	cf81                	beqz	a5,800026b0 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000269a:	64a4                	ld	s1,72(s1)
    8000269c:	fee49de3          	bne	s1,a4,80002696 <bread+0x86>
  panic("bget: no buffers");
    800026a0:	00006517          	auipc	a0,0x6
    800026a4:	d9850513          	addi	a0,a0,-616 # 80008438 <etext+0x438>
    800026a8:	00004097          	auipc	ra,0x4
    800026ac:	97a080e7          	jalr	-1670(ra) # 80006022 <panic>
      b->dev = dev;
    800026b0:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800026b4:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800026b8:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800026bc:	4785                	li	a5,1
    800026be:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800026c0:	0000f517          	auipc	a0,0xf
    800026c4:	d1850513          	addi	a0,a0,-744 # 800113d8 <bcache>
    800026c8:	00004097          	auipc	ra,0x4
    800026cc:	f88080e7          	jalr	-120(ra) # 80006650 <release>
      acquiresleep(&b->lock);
    800026d0:	01048513          	addi	a0,s1,16
    800026d4:	00001097          	auipc	ra,0x1
    800026d8:	434080e7          	jalr	1076(ra) # 80003b08 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800026dc:	409c                	lw	a5,0(s1)
    800026de:	cb89                	beqz	a5,800026f0 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800026e0:	8526                	mv	a0,s1
    800026e2:	70a2                	ld	ra,40(sp)
    800026e4:	7402                	ld	s0,32(sp)
    800026e6:	64e2                	ld	s1,24(sp)
    800026e8:	6942                	ld	s2,16(sp)
    800026ea:	69a2                	ld	s3,8(sp)
    800026ec:	6145                	addi	sp,sp,48
    800026ee:	8082                	ret
    virtio_disk_rw(b, 0);
    800026f0:	4581                	li	a1,0
    800026f2:	8526                	mv	a0,s1
    800026f4:	00003097          	auipc	ra,0x3
    800026f8:	104080e7          	jalr	260(ra) # 800057f8 <virtio_disk_rw>
    b->valid = 1;
    800026fc:	4785                	li	a5,1
    800026fe:	c09c                	sw	a5,0(s1)
  return b;
    80002700:	b7c5                	j	800026e0 <bread+0xd0>

0000000080002702 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002702:	1101                	addi	sp,sp,-32
    80002704:	ec06                	sd	ra,24(sp)
    80002706:	e822                	sd	s0,16(sp)
    80002708:	e426                	sd	s1,8(sp)
    8000270a:	1000                	addi	s0,sp,32
    8000270c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000270e:	0541                	addi	a0,a0,16
    80002710:	00001097          	auipc	ra,0x1
    80002714:	492080e7          	jalr	1170(ra) # 80003ba2 <holdingsleep>
    80002718:	cd01                	beqz	a0,80002730 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000271a:	4585                	li	a1,1
    8000271c:	8526                	mv	a0,s1
    8000271e:	00003097          	auipc	ra,0x3
    80002722:	0da080e7          	jalr	218(ra) # 800057f8 <virtio_disk_rw>
}
    80002726:	60e2                	ld	ra,24(sp)
    80002728:	6442                	ld	s0,16(sp)
    8000272a:	64a2                	ld	s1,8(sp)
    8000272c:	6105                	addi	sp,sp,32
    8000272e:	8082                	ret
    panic("bwrite");
    80002730:	00006517          	auipc	a0,0x6
    80002734:	d2050513          	addi	a0,a0,-736 # 80008450 <etext+0x450>
    80002738:	00004097          	auipc	ra,0x4
    8000273c:	8ea080e7          	jalr	-1814(ra) # 80006022 <panic>

0000000080002740 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002740:	1101                	addi	sp,sp,-32
    80002742:	ec06                	sd	ra,24(sp)
    80002744:	e822                	sd	s0,16(sp)
    80002746:	e426                	sd	s1,8(sp)
    80002748:	e04a                	sd	s2,0(sp)
    8000274a:	1000                	addi	s0,sp,32
    8000274c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000274e:	01050913          	addi	s2,a0,16
    80002752:	854a                	mv	a0,s2
    80002754:	00001097          	auipc	ra,0x1
    80002758:	44e080e7          	jalr	1102(ra) # 80003ba2 <holdingsleep>
    8000275c:	c925                	beqz	a0,800027cc <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    8000275e:	854a                	mv	a0,s2
    80002760:	00001097          	auipc	ra,0x1
    80002764:	3fe080e7          	jalr	1022(ra) # 80003b5e <releasesleep>

  acquire(&bcache.lock);
    80002768:	0000f517          	auipc	a0,0xf
    8000276c:	c7050513          	addi	a0,a0,-912 # 800113d8 <bcache>
    80002770:	00004097          	auipc	ra,0x4
    80002774:	e2c080e7          	jalr	-468(ra) # 8000659c <acquire>
  b->refcnt--;
    80002778:	40bc                	lw	a5,64(s1)
    8000277a:	37fd                	addiw	a5,a5,-1
    8000277c:	0007871b          	sext.w	a4,a5
    80002780:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002782:	e71d                	bnez	a4,800027b0 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002784:	68b8                	ld	a4,80(s1)
    80002786:	64bc                	ld	a5,72(s1)
    80002788:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    8000278a:	68b8                	ld	a4,80(s1)
    8000278c:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000278e:	00017797          	auipc	a5,0x17
    80002792:	c4a78793          	addi	a5,a5,-950 # 800193d8 <bcache+0x8000>
    80002796:	2b87b703          	ld	a4,696(a5)
    8000279a:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000279c:	00017717          	auipc	a4,0x17
    800027a0:	ea470713          	addi	a4,a4,-348 # 80019640 <bcache+0x8268>
    800027a4:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800027a6:	2b87b703          	ld	a4,696(a5)
    800027aa:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800027ac:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800027b0:	0000f517          	auipc	a0,0xf
    800027b4:	c2850513          	addi	a0,a0,-984 # 800113d8 <bcache>
    800027b8:	00004097          	auipc	ra,0x4
    800027bc:	e98080e7          	jalr	-360(ra) # 80006650 <release>
}
    800027c0:	60e2                	ld	ra,24(sp)
    800027c2:	6442                	ld	s0,16(sp)
    800027c4:	64a2                	ld	s1,8(sp)
    800027c6:	6902                	ld	s2,0(sp)
    800027c8:	6105                	addi	sp,sp,32
    800027ca:	8082                	ret
    panic("brelse");
    800027cc:	00006517          	auipc	a0,0x6
    800027d0:	c8c50513          	addi	a0,a0,-884 # 80008458 <etext+0x458>
    800027d4:	00004097          	auipc	ra,0x4
    800027d8:	84e080e7          	jalr	-1970(ra) # 80006022 <panic>

00000000800027dc <bpin>:

void
bpin(struct buf *b) {
    800027dc:	1101                	addi	sp,sp,-32
    800027de:	ec06                	sd	ra,24(sp)
    800027e0:	e822                	sd	s0,16(sp)
    800027e2:	e426                	sd	s1,8(sp)
    800027e4:	1000                	addi	s0,sp,32
    800027e6:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800027e8:	0000f517          	auipc	a0,0xf
    800027ec:	bf050513          	addi	a0,a0,-1040 # 800113d8 <bcache>
    800027f0:	00004097          	auipc	ra,0x4
    800027f4:	dac080e7          	jalr	-596(ra) # 8000659c <acquire>
  b->refcnt++;
    800027f8:	40bc                	lw	a5,64(s1)
    800027fa:	2785                	addiw	a5,a5,1
    800027fc:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800027fe:	0000f517          	auipc	a0,0xf
    80002802:	bda50513          	addi	a0,a0,-1062 # 800113d8 <bcache>
    80002806:	00004097          	auipc	ra,0x4
    8000280a:	e4a080e7          	jalr	-438(ra) # 80006650 <release>
}
    8000280e:	60e2                	ld	ra,24(sp)
    80002810:	6442                	ld	s0,16(sp)
    80002812:	64a2                	ld	s1,8(sp)
    80002814:	6105                	addi	sp,sp,32
    80002816:	8082                	ret

0000000080002818 <bunpin>:

void
bunpin(struct buf *b) {
    80002818:	1101                	addi	sp,sp,-32
    8000281a:	ec06                	sd	ra,24(sp)
    8000281c:	e822                	sd	s0,16(sp)
    8000281e:	e426                	sd	s1,8(sp)
    80002820:	1000                	addi	s0,sp,32
    80002822:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002824:	0000f517          	auipc	a0,0xf
    80002828:	bb450513          	addi	a0,a0,-1100 # 800113d8 <bcache>
    8000282c:	00004097          	auipc	ra,0x4
    80002830:	d70080e7          	jalr	-656(ra) # 8000659c <acquire>
  b->refcnt--;
    80002834:	40bc                	lw	a5,64(s1)
    80002836:	37fd                	addiw	a5,a5,-1
    80002838:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000283a:	0000f517          	auipc	a0,0xf
    8000283e:	b9e50513          	addi	a0,a0,-1122 # 800113d8 <bcache>
    80002842:	00004097          	auipc	ra,0x4
    80002846:	e0e080e7          	jalr	-498(ra) # 80006650 <release>
}
    8000284a:	60e2                	ld	ra,24(sp)
    8000284c:	6442                	ld	s0,16(sp)
    8000284e:	64a2                	ld	s1,8(sp)
    80002850:	6105                	addi	sp,sp,32
    80002852:	8082                	ret

0000000080002854 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002854:	1101                	addi	sp,sp,-32
    80002856:	ec06                	sd	ra,24(sp)
    80002858:	e822                	sd	s0,16(sp)
    8000285a:	e426                	sd	s1,8(sp)
    8000285c:	e04a                	sd	s2,0(sp)
    8000285e:	1000                	addi	s0,sp,32
    80002860:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002862:	00d5d59b          	srliw	a1,a1,0xd
    80002866:	00017797          	auipc	a5,0x17
    8000286a:	24e7a783          	lw	a5,590(a5) # 80019ab4 <sb+0x1c>
    8000286e:	9dbd                	addw	a1,a1,a5
    80002870:	00000097          	auipc	ra,0x0
    80002874:	da0080e7          	jalr	-608(ra) # 80002610 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002878:	0074f713          	andi	a4,s1,7
    8000287c:	4785                	li	a5,1
    8000287e:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002882:	14ce                	slli	s1,s1,0x33
    80002884:	90d9                	srli	s1,s1,0x36
    80002886:	00950733          	add	a4,a0,s1
    8000288a:	05874703          	lbu	a4,88(a4)
    8000288e:	00e7f6b3          	and	a3,a5,a4
    80002892:	c69d                	beqz	a3,800028c0 <bfree+0x6c>
    80002894:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002896:	94aa                	add	s1,s1,a0
    80002898:	fff7c793          	not	a5,a5
    8000289c:	8f7d                	and	a4,a4,a5
    8000289e:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800028a2:	00001097          	auipc	ra,0x1
    800028a6:	148080e7          	jalr	328(ra) # 800039ea <log_write>
  brelse(bp);
    800028aa:	854a                	mv	a0,s2
    800028ac:	00000097          	auipc	ra,0x0
    800028b0:	e94080e7          	jalr	-364(ra) # 80002740 <brelse>
}
    800028b4:	60e2                	ld	ra,24(sp)
    800028b6:	6442                	ld	s0,16(sp)
    800028b8:	64a2                	ld	s1,8(sp)
    800028ba:	6902                	ld	s2,0(sp)
    800028bc:	6105                	addi	sp,sp,32
    800028be:	8082                	ret
    panic("freeing free block");
    800028c0:	00006517          	auipc	a0,0x6
    800028c4:	ba050513          	addi	a0,a0,-1120 # 80008460 <etext+0x460>
    800028c8:	00003097          	auipc	ra,0x3
    800028cc:	75a080e7          	jalr	1882(ra) # 80006022 <panic>

00000000800028d0 <balloc>:
{
    800028d0:	711d                	addi	sp,sp,-96
    800028d2:	ec86                	sd	ra,88(sp)
    800028d4:	e8a2                	sd	s0,80(sp)
    800028d6:	e4a6                	sd	s1,72(sp)
    800028d8:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800028da:	00017797          	auipc	a5,0x17
    800028de:	1c27a783          	lw	a5,450(a5) # 80019a9c <sb+0x4>
    800028e2:	10078f63          	beqz	a5,80002a00 <balloc+0x130>
    800028e6:	e0ca                	sd	s2,64(sp)
    800028e8:	fc4e                	sd	s3,56(sp)
    800028ea:	f852                	sd	s4,48(sp)
    800028ec:	f456                	sd	s5,40(sp)
    800028ee:	f05a                	sd	s6,32(sp)
    800028f0:	ec5e                	sd	s7,24(sp)
    800028f2:	e862                	sd	s8,16(sp)
    800028f4:	e466                	sd	s9,8(sp)
    800028f6:	8baa                	mv	s7,a0
    800028f8:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800028fa:	00017b17          	auipc	s6,0x17
    800028fe:	19eb0b13          	addi	s6,s6,414 # 80019a98 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002902:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002904:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002906:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002908:	6c89                	lui	s9,0x2
    8000290a:	a061                	j	80002992 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000290c:	97ca                	add	a5,a5,s2
    8000290e:	8e55                	or	a2,a2,a3
    80002910:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002914:	854a                	mv	a0,s2
    80002916:	00001097          	auipc	ra,0x1
    8000291a:	0d4080e7          	jalr	212(ra) # 800039ea <log_write>
        brelse(bp);
    8000291e:	854a                	mv	a0,s2
    80002920:	00000097          	auipc	ra,0x0
    80002924:	e20080e7          	jalr	-480(ra) # 80002740 <brelse>
  bp = bread(dev, bno);
    80002928:	85a6                	mv	a1,s1
    8000292a:	855e                	mv	a0,s7
    8000292c:	00000097          	auipc	ra,0x0
    80002930:	ce4080e7          	jalr	-796(ra) # 80002610 <bread>
    80002934:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002936:	40000613          	li	a2,1024
    8000293a:	4581                	li	a1,0
    8000293c:	05850513          	addi	a0,a0,88
    80002940:	ffffe097          	auipc	ra,0xffffe
    80002944:	83a080e7          	jalr	-1990(ra) # 8000017a <memset>
  log_write(bp);
    80002948:	854a                	mv	a0,s2
    8000294a:	00001097          	auipc	ra,0x1
    8000294e:	0a0080e7          	jalr	160(ra) # 800039ea <log_write>
  brelse(bp);
    80002952:	854a                	mv	a0,s2
    80002954:	00000097          	auipc	ra,0x0
    80002958:	dec080e7          	jalr	-532(ra) # 80002740 <brelse>
}
    8000295c:	6906                	ld	s2,64(sp)
    8000295e:	79e2                	ld	s3,56(sp)
    80002960:	7a42                	ld	s4,48(sp)
    80002962:	7aa2                	ld	s5,40(sp)
    80002964:	7b02                	ld	s6,32(sp)
    80002966:	6be2                	ld	s7,24(sp)
    80002968:	6c42                	ld	s8,16(sp)
    8000296a:	6ca2                	ld	s9,8(sp)
}
    8000296c:	8526                	mv	a0,s1
    8000296e:	60e6                	ld	ra,88(sp)
    80002970:	6446                	ld	s0,80(sp)
    80002972:	64a6                	ld	s1,72(sp)
    80002974:	6125                	addi	sp,sp,96
    80002976:	8082                	ret
    brelse(bp);
    80002978:	854a                	mv	a0,s2
    8000297a:	00000097          	auipc	ra,0x0
    8000297e:	dc6080e7          	jalr	-570(ra) # 80002740 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002982:	015c87bb          	addw	a5,s9,s5
    80002986:	00078a9b          	sext.w	s5,a5
    8000298a:	004b2703          	lw	a4,4(s6)
    8000298e:	06eaf163          	bgeu	s5,a4,800029f0 <balloc+0x120>
    bp = bread(dev, BBLOCK(b, sb));
    80002992:	41fad79b          	sraiw	a5,s5,0x1f
    80002996:	0137d79b          	srliw	a5,a5,0x13
    8000299a:	015787bb          	addw	a5,a5,s5
    8000299e:	40d7d79b          	sraiw	a5,a5,0xd
    800029a2:	01cb2583          	lw	a1,28(s6)
    800029a6:	9dbd                	addw	a1,a1,a5
    800029a8:	855e                	mv	a0,s7
    800029aa:	00000097          	auipc	ra,0x0
    800029ae:	c66080e7          	jalr	-922(ra) # 80002610 <bread>
    800029b2:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800029b4:	004b2503          	lw	a0,4(s6)
    800029b8:	000a849b          	sext.w	s1,s5
    800029bc:	8762                	mv	a4,s8
    800029be:	faa4fde3          	bgeu	s1,a0,80002978 <balloc+0xa8>
      m = 1 << (bi % 8);
    800029c2:	00777693          	andi	a3,a4,7
    800029c6:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800029ca:	41f7579b          	sraiw	a5,a4,0x1f
    800029ce:	01d7d79b          	srliw	a5,a5,0x1d
    800029d2:	9fb9                	addw	a5,a5,a4
    800029d4:	4037d79b          	sraiw	a5,a5,0x3
    800029d8:	00f90633          	add	a2,s2,a5
    800029dc:	05864603          	lbu	a2,88(a2)
    800029e0:	00c6f5b3          	and	a1,a3,a2
    800029e4:	d585                	beqz	a1,8000290c <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800029e6:	2705                	addiw	a4,a4,1
    800029e8:	2485                	addiw	s1,s1,1
    800029ea:	fd471ae3          	bne	a4,s4,800029be <balloc+0xee>
    800029ee:	b769                	j	80002978 <balloc+0xa8>
    800029f0:	6906                	ld	s2,64(sp)
    800029f2:	79e2                	ld	s3,56(sp)
    800029f4:	7a42                	ld	s4,48(sp)
    800029f6:	7aa2                	ld	s5,40(sp)
    800029f8:	7b02                	ld	s6,32(sp)
    800029fa:	6be2                	ld	s7,24(sp)
    800029fc:	6c42                	ld	s8,16(sp)
    800029fe:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80002a00:	00006517          	auipc	a0,0x6
    80002a04:	a7850513          	addi	a0,a0,-1416 # 80008478 <etext+0x478>
    80002a08:	00003097          	auipc	ra,0x3
    80002a0c:	664080e7          	jalr	1636(ra) # 8000606c <printf>
  return 0;
    80002a10:	4481                	li	s1,0
    80002a12:	bfa9                	j	8000296c <balloc+0x9c>

0000000080002a14 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002a14:	7179                	addi	sp,sp,-48
    80002a16:	f406                	sd	ra,40(sp)
    80002a18:	f022                	sd	s0,32(sp)
    80002a1a:	ec26                	sd	s1,24(sp)
    80002a1c:	e84a                	sd	s2,16(sp)
    80002a1e:	e44e                	sd	s3,8(sp)
    80002a20:	1800                	addi	s0,sp,48
    80002a22:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002a24:	47ad                	li	a5,11
    80002a26:	02b7e863          	bltu	a5,a1,80002a56 <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    80002a2a:	02059793          	slli	a5,a1,0x20
    80002a2e:	01e7d593          	srli	a1,a5,0x1e
    80002a32:	00b504b3          	add	s1,a0,a1
    80002a36:	0504a903          	lw	s2,80(s1)
    80002a3a:	08091263          	bnez	s2,80002abe <bmap+0xaa>
      addr = balloc(ip->dev);
    80002a3e:	4108                	lw	a0,0(a0)
    80002a40:	00000097          	auipc	ra,0x0
    80002a44:	e90080e7          	jalr	-368(ra) # 800028d0 <balloc>
    80002a48:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002a4c:	06090963          	beqz	s2,80002abe <bmap+0xaa>
        return 0;
      ip->addrs[bn] = addr;
    80002a50:	0524a823          	sw	s2,80(s1)
    80002a54:	a0ad                	j	80002abe <bmap+0xaa>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002a56:	ff45849b          	addiw	s1,a1,-12
    80002a5a:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002a5e:	0ff00793          	li	a5,255
    80002a62:	08e7e863          	bltu	a5,a4,80002af2 <bmap+0xde>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002a66:	08052903          	lw	s2,128(a0)
    80002a6a:	00091f63          	bnez	s2,80002a88 <bmap+0x74>
      addr = balloc(ip->dev);
    80002a6e:	4108                	lw	a0,0(a0)
    80002a70:	00000097          	auipc	ra,0x0
    80002a74:	e60080e7          	jalr	-416(ra) # 800028d0 <balloc>
    80002a78:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002a7c:	04090163          	beqz	s2,80002abe <bmap+0xaa>
    80002a80:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002a82:	0929a023          	sw	s2,128(s3)
    80002a86:	a011                	j	80002a8a <bmap+0x76>
    80002a88:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002a8a:	85ca                	mv	a1,s2
    80002a8c:	0009a503          	lw	a0,0(s3)
    80002a90:	00000097          	auipc	ra,0x0
    80002a94:	b80080e7          	jalr	-1152(ra) # 80002610 <bread>
    80002a98:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002a9a:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002a9e:	02049713          	slli	a4,s1,0x20
    80002aa2:	01e75593          	srli	a1,a4,0x1e
    80002aa6:	00b784b3          	add	s1,a5,a1
    80002aaa:	0004a903          	lw	s2,0(s1)
    80002aae:	02090063          	beqz	s2,80002ace <bmap+0xba>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002ab2:	8552                	mv	a0,s4
    80002ab4:	00000097          	auipc	ra,0x0
    80002ab8:	c8c080e7          	jalr	-884(ra) # 80002740 <brelse>
    return addr;
    80002abc:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002abe:	854a                	mv	a0,s2
    80002ac0:	70a2                	ld	ra,40(sp)
    80002ac2:	7402                	ld	s0,32(sp)
    80002ac4:	64e2                	ld	s1,24(sp)
    80002ac6:	6942                	ld	s2,16(sp)
    80002ac8:	69a2                	ld	s3,8(sp)
    80002aca:	6145                	addi	sp,sp,48
    80002acc:	8082                	ret
      addr = balloc(ip->dev);
    80002ace:	0009a503          	lw	a0,0(s3)
    80002ad2:	00000097          	auipc	ra,0x0
    80002ad6:	dfe080e7          	jalr	-514(ra) # 800028d0 <balloc>
    80002ada:	0005091b          	sext.w	s2,a0
      if(addr){
    80002ade:	fc090ae3          	beqz	s2,80002ab2 <bmap+0x9e>
        a[bn] = addr;
    80002ae2:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002ae6:	8552                	mv	a0,s4
    80002ae8:	00001097          	auipc	ra,0x1
    80002aec:	f02080e7          	jalr	-254(ra) # 800039ea <log_write>
    80002af0:	b7c9                	j	80002ab2 <bmap+0x9e>
    80002af2:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002af4:	00006517          	auipc	a0,0x6
    80002af8:	99c50513          	addi	a0,a0,-1636 # 80008490 <etext+0x490>
    80002afc:	00003097          	auipc	ra,0x3
    80002b00:	526080e7          	jalr	1318(ra) # 80006022 <panic>

0000000080002b04 <iget>:
{
    80002b04:	7179                	addi	sp,sp,-48
    80002b06:	f406                	sd	ra,40(sp)
    80002b08:	f022                	sd	s0,32(sp)
    80002b0a:	ec26                	sd	s1,24(sp)
    80002b0c:	e84a                	sd	s2,16(sp)
    80002b0e:	e44e                	sd	s3,8(sp)
    80002b10:	e052                	sd	s4,0(sp)
    80002b12:	1800                	addi	s0,sp,48
    80002b14:	89aa                	mv	s3,a0
    80002b16:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002b18:	00017517          	auipc	a0,0x17
    80002b1c:	fa050513          	addi	a0,a0,-96 # 80019ab8 <itable>
    80002b20:	00004097          	auipc	ra,0x4
    80002b24:	a7c080e7          	jalr	-1412(ra) # 8000659c <acquire>
  empty = 0;
    80002b28:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002b2a:	00017497          	auipc	s1,0x17
    80002b2e:	fa648493          	addi	s1,s1,-90 # 80019ad0 <itable+0x18>
    80002b32:	00019697          	auipc	a3,0x19
    80002b36:	a2e68693          	addi	a3,a3,-1490 # 8001b560 <log>
    80002b3a:	a039                	j	80002b48 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002b3c:	02090b63          	beqz	s2,80002b72 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002b40:	08848493          	addi	s1,s1,136
    80002b44:	02d48a63          	beq	s1,a3,80002b78 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002b48:	449c                	lw	a5,8(s1)
    80002b4a:	fef059e3          	blez	a5,80002b3c <iget+0x38>
    80002b4e:	4098                	lw	a4,0(s1)
    80002b50:	ff3716e3          	bne	a4,s3,80002b3c <iget+0x38>
    80002b54:	40d8                	lw	a4,4(s1)
    80002b56:	ff4713e3          	bne	a4,s4,80002b3c <iget+0x38>
      ip->ref++;
    80002b5a:	2785                	addiw	a5,a5,1
    80002b5c:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002b5e:	00017517          	auipc	a0,0x17
    80002b62:	f5a50513          	addi	a0,a0,-166 # 80019ab8 <itable>
    80002b66:	00004097          	auipc	ra,0x4
    80002b6a:	aea080e7          	jalr	-1302(ra) # 80006650 <release>
      return ip;
    80002b6e:	8926                	mv	s2,s1
    80002b70:	a03d                	j	80002b9e <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002b72:	f7f9                	bnez	a5,80002b40 <iget+0x3c>
      empty = ip;
    80002b74:	8926                	mv	s2,s1
    80002b76:	b7e9                	j	80002b40 <iget+0x3c>
  if(empty == 0)
    80002b78:	02090c63          	beqz	s2,80002bb0 <iget+0xac>
  ip->dev = dev;
    80002b7c:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002b80:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002b84:	4785                	li	a5,1
    80002b86:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002b8a:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002b8e:	00017517          	auipc	a0,0x17
    80002b92:	f2a50513          	addi	a0,a0,-214 # 80019ab8 <itable>
    80002b96:	00004097          	auipc	ra,0x4
    80002b9a:	aba080e7          	jalr	-1350(ra) # 80006650 <release>
}
    80002b9e:	854a                	mv	a0,s2
    80002ba0:	70a2                	ld	ra,40(sp)
    80002ba2:	7402                	ld	s0,32(sp)
    80002ba4:	64e2                	ld	s1,24(sp)
    80002ba6:	6942                	ld	s2,16(sp)
    80002ba8:	69a2                	ld	s3,8(sp)
    80002baa:	6a02                	ld	s4,0(sp)
    80002bac:	6145                	addi	sp,sp,48
    80002bae:	8082                	ret
    panic("iget: no inodes");
    80002bb0:	00006517          	auipc	a0,0x6
    80002bb4:	8f850513          	addi	a0,a0,-1800 # 800084a8 <etext+0x4a8>
    80002bb8:	00003097          	auipc	ra,0x3
    80002bbc:	46a080e7          	jalr	1130(ra) # 80006022 <panic>

0000000080002bc0 <fsinit>:
fsinit(int dev) {
    80002bc0:	7179                	addi	sp,sp,-48
    80002bc2:	f406                	sd	ra,40(sp)
    80002bc4:	f022                	sd	s0,32(sp)
    80002bc6:	ec26                	sd	s1,24(sp)
    80002bc8:	e84a                	sd	s2,16(sp)
    80002bca:	e44e                	sd	s3,8(sp)
    80002bcc:	1800                	addi	s0,sp,48
    80002bce:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002bd0:	4585                	li	a1,1
    80002bd2:	00000097          	auipc	ra,0x0
    80002bd6:	a3e080e7          	jalr	-1474(ra) # 80002610 <bread>
    80002bda:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002bdc:	00017997          	auipc	s3,0x17
    80002be0:	ebc98993          	addi	s3,s3,-324 # 80019a98 <sb>
    80002be4:	02000613          	li	a2,32
    80002be8:	05850593          	addi	a1,a0,88
    80002bec:	854e                	mv	a0,s3
    80002bee:	ffffd097          	auipc	ra,0xffffd
    80002bf2:	5e8080e7          	jalr	1512(ra) # 800001d6 <memmove>
  brelse(bp);
    80002bf6:	8526                	mv	a0,s1
    80002bf8:	00000097          	auipc	ra,0x0
    80002bfc:	b48080e7          	jalr	-1208(ra) # 80002740 <brelse>
  if(sb.magic != FSMAGIC)
    80002c00:	0009a703          	lw	a4,0(s3)
    80002c04:	102037b7          	lui	a5,0x10203
    80002c08:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002c0c:	02f71263          	bne	a4,a5,80002c30 <fsinit+0x70>
  initlog(dev, &sb);
    80002c10:	00017597          	auipc	a1,0x17
    80002c14:	e8858593          	addi	a1,a1,-376 # 80019a98 <sb>
    80002c18:	854a                	mv	a0,s2
    80002c1a:	00001097          	auipc	ra,0x1
    80002c1e:	b60080e7          	jalr	-1184(ra) # 8000377a <initlog>
}
    80002c22:	70a2                	ld	ra,40(sp)
    80002c24:	7402                	ld	s0,32(sp)
    80002c26:	64e2                	ld	s1,24(sp)
    80002c28:	6942                	ld	s2,16(sp)
    80002c2a:	69a2                	ld	s3,8(sp)
    80002c2c:	6145                	addi	sp,sp,48
    80002c2e:	8082                	ret
    panic("invalid file system");
    80002c30:	00006517          	auipc	a0,0x6
    80002c34:	88850513          	addi	a0,a0,-1912 # 800084b8 <etext+0x4b8>
    80002c38:	00003097          	auipc	ra,0x3
    80002c3c:	3ea080e7          	jalr	1002(ra) # 80006022 <panic>

0000000080002c40 <iinit>:
{
    80002c40:	7179                	addi	sp,sp,-48
    80002c42:	f406                	sd	ra,40(sp)
    80002c44:	f022                	sd	s0,32(sp)
    80002c46:	ec26                	sd	s1,24(sp)
    80002c48:	e84a                	sd	s2,16(sp)
    80002c4a:	e44e                	sd	s3,8(sp)
    80002c4c:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002c4e:	00006597          	auipc	a1,0x6
    80002c52:	88258593          	addi	a1,a1,-1918 # 800084d0 <etext+0x4d0>
    80002c56:	00017517          	auipc	a0,0x17
    80002c5a:	e6250513          	addi	a0,a0,-414 # 80019ab8 <itable>
    80002c5e:	00004097          	auipc	ra,0x4
    80002c62:	8ae080e7          	jalr	-1874(ra) # 8000650c <initlock>
  for(i = 0; i < NINODE; i++) {
    80002c66:	00017497          	auipc	s1,0x17
    80002c6a:	e7a48493          	addi	s1,s1,-390 # 80019ae0 <itable+0x28>
    80002c6e:	00019997          	auipc	s3,0x19
    80002c72:	90298993          	addi	s3,s3,-1790 # 8001b570 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002c76:	00006917          	auipc	s2,0x6
    80002c7a:	86290913          	addi	s2,s2,-1950 # 800084d8 <etext+0x4d8>
    80002c7e:	85ca                	mv	a1,s2
    80002c80:	8526                	mv	a0,s1
    80002c82:	00001097          	auipc	ra,0x1
    80002c86:	e4c080e7          	jalr	-436(ra) # 80003ace <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002c8a:	08848493          	addi	s1,s1,136
    80002c8e:	ff3498e3          	bne	s1,s3,80002c7e <iinit+0x3e>
}
    80002c92:	70a2                	ld	ra,40(sp)
    80002c94:	7402                	ld	s0,32(sp)
    80002c96:	64e2                	ld	s1,24(sp)
    80002c98:	6942                	ld	s2,16(sp)
    80002c9a:	69a2                	ld	s3,8(sp)
    80002c9c:	6145                	addi	sp,sp,48
    80002c9e:	8082                	ret

0000000080002ca0 <ialloc>:
{
    80002ca0:	7139                	addi	sp,sp,-64
    80002ca2:	fc06                	sd	ra,56(sp)
    80002ca4:	f822                	sd	s0,48(sp)
    80002ca6:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ca8:	00017717          	auipc	a4,0x17
    80002cac:	dfc72703          	lw	a4,-516(a4) # 80019aa4 <sb+0xc>
    80002cb0:	4785                	li	a5,1
    80002cb2:	06e7f463          	bgeu	a5,a4,80002d1a <ialloc+0x7a>
    80002cb6:	f426                	sd	s1,40(sp)
    80002cb8:	f04a                	sd	s2,32(sp)
    80002cba:	ec4e                	sd	s3,24(sp)
    80002cbc:	e852                	sd	s4,16(sp)
    80002cbe:	e456                	sd	s5,8(sp)
    80002cc0:	e05a                	sd	s6,0(sp)
    80002cc2:	8aaa                	mv	s5,a0
    80002cc4:	8b2e                	mv	s6,a1
    80002cc6:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002cc8:	00017a17          	auipc	s4,0x17
    80002ccc:	dd0a0a13          	addi	s4,s4,-560 # 80019a98 <sb>
    80002cd0:	00495593          	srli	a1,s2,0x4
    80002cd4:	018a2783          	lw	a5,24(s4)
    80002cd8:	9dbd                	addw	a1,a1,a5
    80002cda:	8556                	mv	a0,s5
    80002cdc:	00000097          	auipc	ra,0x0
    80002ce0:	934080e7          	jalr	-1740(ra) # 80002610 <bread>
    80002ce4:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002ce6:	05850993          	addi	s3,a0,88
    80002cea:	00f97793          	andi	a5,s2,15
    80002cee:	079a                	slli	a5,a5,0x6
    80002cf0:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002cf2:	00099783          	lh	a5,0(s3)
    80002cf6:	cf9d                	beqz	a5,80002d34 <ialloc+0x94>
    brelse(bp);
    80002cf8:	00000097          	auipc	ra,0x0
    80002cfc:	a48080e7          	jalr	-1464(ra) # 80002740 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002d00:	0905                	addi	s2,s2,1
    80002d02:	00ca2703          	lw	a4,12(s4)
    80002d06:	0009079b          	sext.w	a5,s2
    80002d0a:	fce7e3e3          	bltu	a5,a4,80002cd0 <ialloc+0x30>
    80002d0e:	74a2                	ld	s1,40(sp)
    80002d10:	7902                	ld	s2,32(sp)
    80002d12:	69e2                	ld	s3,24(sp)
    80002d14:	6a42                	ld	s4,16(sp)
    80002d16:	6aa2                	ld	s5,8(sp)
    80002d18:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002d1a:	00005517          	auipc	a0,0x5
    80002d1e:	7c650513          	addi	a0,a0,1990 # 800084e0 <etext+0x4e0>
    80002d22:	00003097          	auipc	ra,0x3
    80002d26:	34a080e7          	jalr	842(ra) # 8000606c <printf>
  return 0;
    80002d2a:	4501                	li	a0,0
}
    80002d2c:	70e2                	ld	ra,56(sp)
    80002d2e:	7442                	ld	s0,48(sp)
    80002d30:	6121                	addi	sp,sp,64
    80002d32:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002d34:	04000613          	li	a2,64
    80002d38:	4581                	li	a1,0
    80002d3a:	854e                	mv	a0,s3
    80002d3c:	ffffd097          	auipc	ra,0xffffd
    80002d40:	43e080e7          	jalr	1086(ra) # 8000017a <memset>
      dip->type = type;
    80002d44:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002d48:	8526                	mv	a0,s1
    80002d4a:	00001097          	auipc	ra,0x1
    80002d4e:	ca0080e7          	jalr	-864(ra) # 800039ea <log_write>
      brelse(bp);
    80002d52:	8526                	mv	a0,s1
    80002d54:	00000097          	auipc	ra,0x0
    80002d58:	9ec080e7          	jalr	-1556(ra) # 80002740 <brelse>
      return iget(dev, inum);
    80002d5c:	0009059b          	sext.w	a1,s2
    80002d60:	8556                	mv	a0,s5
    80002d62:	00000097          	auipc	ra,0x0
    80002d66:	da2080e7          	jalr	-606(ra) # 80002b04 <iget>
    80002d6a:	74a2                	ld	s1,40(sp)
    80002d6c:	7902                	ld	s2,32(sp)
    80002d6e:	69e2                	ld	s3,24(sp)
    80002d70:	6a42                	ld	s4,16(sp)
    80002d72:	6aa2                	ld	s5,8(sp)
    80002d74:	6b02                	ld	s6,0(sp)
    80002d76:	bf5d                	j	80002d2c <ialloc+0x8c>

0000000080002d78 <iupdate>:
{
    80002d78:	1101                	addi	sp,sp,-32
    80002d7a:	ec06                	sd	ra,24(sp)
    80002d7c:	e822                	sd	s0,16(sp)
    80002d7e:	e426                	sd	s1,8(sp)
    80002d80:	e04a                	sd	s2,0(sp)
    80002d82:	1000                	addi	s0,sp,32
    80002d84:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d86:	415c                	lw	a5,4(a0)
    80002d88:	0047d79b          	srliw	a5,a5,0x4
    80002d8c:	00017597          	auipc	a1,0x17
    80002d90:	d245a583          	lw	a1,-732(a1) # 80019ab0 <sb+0x18>
    80002d94:	9dbd                	addw	a1,a1,a5
    80002d96:	4108                	lw	a0,0(a0)
    80002d98:	00000097          	auipc	ra,0x0
    80002d9c:	878080e7          	jalr	-1928(ra) # 80002610 <bread>
    80002da0:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002da2:	05850793          	addi	a5,a0,88
    80002da6:	40d8                	lw	a4,4(s1)
    80002da8:	8b3d                	andi	a4,a4,15
    80002daa:	071a                	slli	a4,a4,0x6
    80002dac:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002dae:	04449703          	lh	a4,68(s1)
    80002db2:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002db6:	04649703          	lh	a4,70(s1)
    80002dba:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002dbe:	04849703          	lh	a4,72(s1)
    80002dc2:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002dc6:	04a49703          	lh	a4,74(s1)
    80002dca:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002dce:	44f8                	lw	a4,76(s1)
    80002dd0:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002dd2:	03400613          	li	a2,52
    80002dd6:	05048593          	addi	a1,s1,80
    80002dda:	00c78513          	addi	a0,a5,12
    80002dde:	ffffd097          	auipc	ra,0xffffd
    80002de2:	3f8080e7          	jalr	1016(ra) # 800001d6 <memmove>
  log_write(bp);
    80002de6:	854a                	mv	a0,s2
    80002de8:	00001097          	auipc	ra,0x1
    80002dec:	c02080e7          	jalr	-1022(ra) # 800039ea <log_write>
  brelse(bp);
    80002df0:	854a                	mv	a0,s2
    80002df2:	00000097          	auipc	ra,0x0
    80002df6:	94e080e7          	jalr	-1714(ra) # 80002740 <brelse>
}
    80002dfa:	60e2                	ld	ra,24(sp)
    80002dfc:	6442                	ld	s0,16(sp)
    80002dfe:	64a2                	ld	s1,8(sp)
    80002e00:	6902                	ld	s2,0(sp)
    80002e02:	6105                	addi	sp,sp,32
    80002e04:	8082                	ret

0000000080002e06 <idup>:
{
    80002e06:	1101                	addi	sp,sp,-32
    80002e08:	ec06                	sd	ra,24(sp)
    80002e0a:	e822                	sd	s0,16(sp)
    80002e0c:	e426                	sd	s1,8(sp)
    80002e0e:	1000                	addi	s0,sp,32
    80002e10:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e12:	00017517          	auipc	a0,0x17
    80002e16:	ca650513          	addi	a0,a0,-858 # 80019ab8 <itable>
    80002e1a:	00003097          	auipc	ra,0x3
    80002e1e:	782080e7          	jalr	1922(ra) # 8000659c <acquire>
  ip->ref++;
    80002e22:	449c                	lw	a5,8(s1)
    80002e24:	2785                	addiw	a5,a5,1
    80002e26:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e28:	00017517          	auipc	a0,0x17
    80002e2c:	c9050513          	addi	a0,a0,-880 # 80019ab8 <itable>
    80002e30:	00004097          	auipc	ra,0x4
    80002e34:	820080e7          	jalr	-2016(ra) # 80006650 <release>
}
    80002e38:	8526                	mv	a0,s1
    80002e3a:	60e2                	ld	ra,24(sp)
    80002e3c:	6442                	ld	s0,16(sp)
    80002e3e:	64a2                	ld	s1,8(sp)
    80002e40:	6105                	addi	sp,sp,32
    80002e42:	8082                	ret

0000000080002e44 <ilock>:
{
    80002e44:	1101                	addi	sp,sp,-32
    80002e46:	ec06                	sd	ra,24(sp)
    80002e48:	e822                	sd	s0,16(sp)
    80002e4a:	e426                	sd	s1,8(sp)
    80002e4c:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002e4e:	c10d                	beqz	a0,80002e70 <ilock+0x2c>
    80002e50:	84aa                	mv	s1,a0
    80002e52:	451c                	lw	a5,8(a0)
    80002e54:	00f05e63          	blez	a5,80002e70 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002e58:	0541                	addi	a0,a0,16
    80002e5a:	00001097          	auipc	ra,0x1
    80002e5e:	cae080e7          	jalr	-850(ra) # 80003b08 <acquiresleep>
  if(ip->valid == 0){
    80002e62:	40bc                	lw	a5,64(s1)
    80002e64:	cf99                	beqz	a5,80002e82 <ilock+0x3e>
}
    80002e66:	60e2                	ld	ra,24(sp)
    80002e68:	6442                	ld	s0,16(sp)
    80002e6a:	64a2                	ld	s1,8(sp)
    80002e6c:	6105                	addi	sp,sp,32
    80002e6e:	8082                	ret
    80002e70:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002e72:	00005517          	auipc	a0,0x5
    80002e76:	68650513          	addi	a0,a0,1670 # 800084f8 <etext+0x4f8>
    80002e7a:	00003097          	auipc	ra,0x3
    80002e7e:	1a8080e7          	jalr	424(ra) # 80006022 <panic>
    80002e82:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002e84:	40dc                	lw	a5,4(s1)
    80002e86:	0047d79b          	srliw	a5,a5,0x4
    80002e8a:	00017597          	auipc	a1,0x17
    80002e8e:	c265a583          	lw	a1,-986(a1) # 80019ab0 <sb+0x18>
    80002e92:	9dbd                	addw	a1,a1,a5
    80002e94:	4088                	lw	a0,0(s1)
    80002e96:	fffff097          	auipc	ra,0xfffff
    80002e9a:	77a080e7          	jalr	1914(ra) # 80002610 <bread>
    80002e9e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002ea0:	05850593          	addi	a1,a0,88
    80002ea4:	40dc                	lw	a5,4(s1)
    80002ea6:	8bbd                	andi	a5,a5,15
    80002ea8:	079a                	slli	a5,a5,0x6
    80002eaa:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002eac:	00059783          	lh	a5,0(a1)
    80002eb0:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002eb4:	00259783          	lh	a5,2(a1)
    80002eb8:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002ebc:	00459783          	lh	a5,4(a1)
    80002ec0:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002ec4:	00659783          	lh	a5,6(a1)
    80002ec8:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002ecc:	459c                	lw	a5,8(a1)
    80002ece:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002ed0:	03400613          	li	a2,52
    80002ed4:	05b1                	addi	a1,a1,12
    80002ed6:	05048513          	addi	a0,s1,80
    80002eda:	ffffd097          	auipc	ra,0xffffd
    80002ede:	2fc080e7          	jalr	764(ra) # 800001d6 <memmove>
    brelse(bp);
    80002ee2:	854a                	mv	a0,s2
    80002ee4:	00000097          	auipc	ra,0x0
    80002ee8:	85c080e7          	jalr	-1956(ra) # 80002740 <brelse>
    ip->valid = 1;
    80002eec:	4785                	li	a5,1
    80002eee:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002ef0:	04449783          	lh	a5,68(s1)
    80002ef4:	c399                	beqz	a5,80002efa <ilock+0xb6>
    80002ef6:	6902                	ld	s2,0(sp)
    80002ef8:	b7bd                	j	80002e66 <ilock+0x22>
      panic("ilock: no type");
    80002efa:	00005517          	auipc	a0,0x5
    80002efe:	60650513          	addi	a0,a0,1542 # 80008500 <etext+0x500>
    80002f02:	00003097          	auipc	ra,0x3
    80002f06:	120080e7          	jalr	288(ra) # 80006022 <panic>

0000000080002f0a <iunlock>:
{
    80002f0a:	1101                	addi	sp,sp,-32
    80002f0c:	ec06                	sd	ra,24(sp)
    80002f0e:	e822                	sd	s0,16(sp)
    80002f10:	e426                	sd	s1,8(sp)
    80002f12:	e04a                	sd	s2,0(sp)
    80002f14:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002f16:	c905                	beqz	a0,80002f46 <iunlock+0x3c>
    80002f18:	84aa                	mv	s1,a0
    80002f1a:	01050913          	addi	s2,a0,16
    80002f1e:	854a                	mv	a0,s2
    80002f20:	00001097          	auipc	ra,0x1
    80002f24:	c82080e7          	jalr	-894(ra) # 80003ba2 <holdingsleep>
    80002f28:	cd19                	beqz	a0,80002f46 <iunlock+0x3c>
    80002f2a:	449c                	lw	a5,8(s1)
    80002f2c:	00f05d63          	blez	a5,80002f46 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002f30:	854a                	mv	a0,s2
    80002f32:	00001097          	auipc	ra,0x1
    80002f36:	c2c080e7          	jalr	-980(ra) # 80003b5e <releasesleep>
}
    80002f3a:	60e2                	ld	ra,24(sp)
    80002f3c:	6442                	ld	s0,16(sp)
    80002f3e:	64a2                	ld	s1,8(sp)
    80002f40:	6902                	ld	s2,0(sp)
    80002f42:	6105                	addi	sp,sp,32
    80002f44:	8082                	ret
    panic("iunlock");
    80002f46:	00005517          	auipc	a0,0x5
    80002f4a:	5ca50513          	addi	a0,a0,1482 # 80008510 <etext+0x510>
    80002f4e:	00003097          	auipc	ra,0x3
    80002f52:	0d4080e7          	jalr	212(ra) # 80006022 <panic>

0000000080002f56 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002f56:	7179                	addi	sp,sp,-48
    80002f58:	f406                	sd	ra,40(sp)
    80002f5a:	f022                	sd	s0,32(sp)
    80002f5c:	ec26                	sd	s1,24(sp)
    80002f5e:	e84a                	sd	s2,16(sp)
    80002f60:	e44e                	sd	s3,8(sp)
    80002f62:	1800                	addi	s0,sp,48
    80002f64:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002f66:	05050493          	addi	s1,a0,80
    80002f6a:	08050913          	addi	s2,a0,128
    80002f6e:	a021                	j	80002f76 <itrunc+0x20>
    80002f70:	0491                	addi	s1,s1,4
    80002f72:	01248d63          	beq	s1,s2,80002f8c <itrunc+0x36>
    if(ip->addrs[i]){
    80002f76:	408c                	lw	a1,0(s1)
    80002f78:	dde5                	beqz	a1,80002f70 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002f7a:	0009a503          	lw	a0,0(s3)
    80002f7e:	00000097          	auipc	ra,0x0
    80002f82:	8d6080e7          	jalr	-1834(ra) # 80002854 <bfree>
      ip->addrs[i] = 0;
    80002f86:	0004a023          	sw	zero,0(s1)
    80002f8a:	b7dd                	j	80002f70 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002f8c:	0809a583          	lw	a1,128(s3)
    80002f90:	ed99                	bnez	a1,80002fae <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002f92:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002f96:	854e                	mv	a0,s3
    80002f98:	00000097          	auipc	ra,0x0
    80002f9c:	de0080e7          	jalr	-544(ra) # 80002d78 <iupdate>
}
    80002fa0:	70a2                	ld	ra,40(sp)
    80002fa2:	7402                	ld	s0,32(sp)
    80002fa4:	64e2                	ld	s1,24(sp)
    80002fa6:	6942                	ld	s2,16(sp)
    80002fa8:	69a2                	ld	s3,8(sp)
    80002faa:	6145                	addi	sp,sp,48
    80002fac:	8082                	ret
    80002fae:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002fb0:	0009a503          	lw	a0,0(s3)
    80002fb4:	fffff097          	auipc	ra,0xfffff
    80002fb8:	65c080e7          	jalr	1628(ra) # 80002610 <bread>
    80002fbc:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002fbe:	05850493          	addi	s1,a0,88
    80002fc2:	45850913          	addi	s2,a0,1112
    80002fc6:	a021                	j	80002fce <itrunc+0x78>
    80002fc8:	0491                	addi	s1,s1,4
    80002fca:	01248b63          	beq	s1,s2,80002fe0 <itrunc+0x8a>
      if(a[j])
    80002fce:	408c                	lw	a1,0(s1)
    80002fd0:	dde5                	beqz	a1,80002fc8 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002fd2:	0009a503          	lw	a0,0(s3)
    80002fd6:	00000097          	auipc	ra,0x0
    80002fda:	87e080e7          	jalr	-1922(ra) # 80002854 <bfree>
    80002fde:	b7ed                	j	80002fc8 <itrunc+0x72>
    brelse(bp);
    80002fe0:	8552                	mv	a0,s4
    80002fe2:	fffff097          	auipc	ra,0xfffff
    80002fe6:	75e080e7          	jalr	1886(ra) # 80002740 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002fea:	0809a583          	lw	a1,128(s3)
    80002fee:	0009a503          	lw	a0,0(s3)
    80002ff2:	00000097          	auipc	ra,0x0
    80002ff6:	862080e7          	jalr	-1950(ra) # 80002854 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002ffa:	0809a023          	sw	zero,128(s3)
    80002ffe:	6a02                	ld	s4,0(sp)
    80003000:	bf49                	j	80002f92 <itrunc+0x3c>

0000000080003002 <iput>:
{
    80003002:	1101                	addi	sp,sp,-32
    80003004:	ec06                	sd	ra,24(sp)
    80003006:	e822                	sd	s0,16(sp)
    80003008:	e426                	sd	s1,8(sp)
    8000300a:	1000                	addi	s0,sp,32
    8000300c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000300e:	00017517          	auipc	a0,0x17
    80003012:	aaa50513          	addi	a0,a0,-1366 # 80019ab8 <itable>
    80003016:	00003097          	auipc	ra,0x3
    8000301a:	586080e7          	jalr	1414(ra) # 8000659c <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000301e:	4498                	lw	a4,8(s1)
    80003020:	4785                	li	a5,1
    80003022:	02f70263          	beq	a4,a5,80003046 <iput+0x44>
  ip->ref--;
    80003026:	449c                	lw	a5,8(s1)
    80003028:	37fd                	addiw	a5,a5,-1
    8000302a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000302c:	00017517          	auipc	a0,0x17
    80003030:	a8c50513          	addi	a0,a0,-1396 # 80019ab8 <itable>
    80003034:	00003097          	auipc	ra,0x3
    80003038:	61c080e7          	jalr	1564(ra) # 80006650 <release>
}
    8000303c:	60e2                	ld	ra,24(sp)
    8000303e:	6442                	ld	s0,16(sp)
    80003040:	64a2                	ld	s1,8(sp)
    80003042:	6105                	addi	sp,sp,32
    80003044:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003046:	40bc                	lw	a5,64(s1)
    80003048:	dff9                	beqz	a5,80003026 <iput+0x24>
    8000304a:	04a49783          	lh	a5,74(s1)
    8000304e:	ffe1                	bnez	a5,80003026 <iput+0x24>
    80003050:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003052:	01048913          	addi	s2,s1,16
    80003056:	854a                	mv	a0,s2
    80003058:	00001097          	auipc	ra,0x1
    8000305c:	ab0080e7          	jalr	-1360(ra) # 80003b08 <acquiresleep>
    release(&itable.lock);
    80003060:	00017517          	auipc	a0,0x17
    80003064:	a5850513          	addi	a0,a0,-1448 # 80019ab8 <itable>
    80003068:	00003097          	auipc	ra,0x3
    8000306c:	5e8080e7          	jalr	1512(ra) # 80006650 <release>
    itrunc(ip);
    80003070:	8526                	mv	a0,s1
    80003072:	00000097          	auipc	ra,0x0
    80003076:	ee4080e7          	jalr	-284(ra) # 80002f56 <itrunc>
    ip->type = 0;
    8000307a:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    8000307e:	8526                	mv	a0,s1
    80003080:	00000097          	auipc	ra,0x0
    80003084:	cf8080e7          	jalr	-776(ra) # 80002d78 <iupdate>
    ip->valid = 0;
    80003088:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    8000308c:	854a                	mv	a0,s2
    8000308e:	00001097          	auipc	ra,0x1
    80003092:	ad0080e7          	jalr	-1328(ra) # 80003b5e <releasesleep>
    acquire(&itable.lock);
    80003096:	00017517          	auipc	a0,0x17
    8000309a:	a2250513          	addi	a0,a0,-1502 # 80019ab8 <itable>
    8000309e:	00003097          	auipc	ra,0x3
    800030a2:	4fe080e7          	jalr	1278(ra) # 8000659c <acquire>
    800030a6:	6902                	ld	s2,0(sp)
    800030a8:	bfbd                	j	80003026 <iput+0x24>

00000000800030aa <iunlockput>:
{
    800030aa:	1101                	addi	sp,sp,-32
    800030ac:	ec06                	sd	ra,24(sp)
    800030ae:	e822                	sd	s0,16(sp)
    800030b0:	e426                	sd	s1,8(sp)
    800030b2:	1000                	addi	s0,sp,32
    800030b4:	84aa                	mv	s1,a0
  iunlock(ip);
    800030b6:	00000097          	auipc	ra,0x0
    800030ba:	e54080e7          	jalr	-428(ra) # 80002f0a <iunlock>
  iput(ip);
    800030be:	8526                	mv	a0,s1
    800030c0:	00000097          	auipc	ra,0x0
    800030c4:	f42080e7          	jalr	-190(ra) # 80003002 <iput>
}
    800030c8:	60e2                	ld	ra,24(sp)
    800030ca:	6442                	ld	s0,16(sp)
    800030cc:	64a2                	ld	s1,8(sp)
    800030ce:	6105                	addi	sp,sp,32
    800030d0:	8082                	ret

00000000800030d2 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800030d2:	1141                	addi	sp,sp,-16
    800030d4:	e422                	sd	s0,8(sp)
    800030d6:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800030d8:	411c                	lw	a5,0(a0)
    800030da:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800030dc:	415c                	lw	a5,4(a0)
    800030de:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800030e0:	04451783          	lh	a5,68(a0)
    800030e4:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800030e8:	04a51783          	lh	a5,74(a0)
    800030ec:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800030f0:	04c56783          	lwu	a5,76(a0)
    800030f4:	e99c                	sd	a5,16(a1)
}
    800030f6:	6422                	ld	s0,8(sp)
    800030f8:	0141                	addi	sp,sp,16
    800030fa:	8082                	ret

00000000800030fc <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800030fc:	457c                	lw	a5,76(a0)
    800030fe:	10d7e563          	bltu	a5,a3,80003208 <readi+0x10c>
{
    80003102:	7159                	addi	sp,sp,-112
    80003104:	f486                	sd	ra,104(sp)
    80003106:	f0a2                	sd	s0,96(sp)
    80003108:	eca6                	sd	s1,88(sp)
    8000310a:	e0d2                	sd	s4,64(sp)
    8000310c:	fc56                	sd	s5,56(sp)
    8000310e:	f85a                	sd	s6,48(sp)
    80003110:	f45e                	sd	s7,40(sp)
    80003112:	1880                	addi	s0,sp,112
    80003114:	8b2a                	mv	s6,a0
    80003116:	8bae                	mv	s7,a1
    80003118:	8a32                	mv	s4,a2
    8000311a:	84b6                	mv	s1,a3
    8000311c:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    8000311e:	9f35                	addw	a4,a4,a3
    return 0;
    80003120:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003122:	0cd76a63          	bltu	a4,a3,800031f6 <readi+0xfa>
    80003126:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003128:	00e7f463          	bgeu	a5,a4,80003130 <readi+0x34>
    n = ip->size - off;
    8000312c:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003130:	0a0a8963          	beqz	s5,800031e2 <readi+0xe6>
    80003134:	e8ca                	sd	s2,80(sp)
    80003136:	f062                	sd	s8,32(sp)
    80003138:	ec66                	sd	s9,24(sp)
    8000313a:	e86a                	sd	s10,16(sp)
    8000313c:	e46e                	sd	s11,8(sp)
    8000313e:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003140:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003144:	5c7d                	li	s8,-1
    80003146:	a82d                	j	80003180 <readi+0x84>
    80003148:	020d1d93          	slli	s11,s10,0x20
    8000314c:	020ddd93          	srli	s11,s11,0x20
    80003150:	05890613          	addi	a2,s2,88
    80003154:	86ee                	mv	a3,s11
    80003156:	963a                	add	a2,a2,a4
    80003158:	85d2                	mv	a1,s4
    8000315a:	855e                	mv	a0,s7
    8000315c:	fffff097          	auipc	ra,0xfffff
    80003160:	a06080e7          	jalr	-1530(ra) # 80001b62 <either_copyout>
    80003164:	05850d63          	beq	a0,s8,800031be <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003168:	854a                	mv	a0,s2
    8000316a:	fffff097          	auipc	ra,0xfffff
    8000316e:	5d6080e7          	jalr	1494(ra) # 80002740 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003172:	013d09bb          	addw	s3,s10,s3
    80003176:	009d04bb          	addw	s1,s10,s1
    8000317a:	9a6e                	add	s4,s4,s11
    8000317c:	0559fd63          	bgeu	s3,s5,800031d6 <readi+0xda>
    uint addr = bmap(ip, off/BSIZE);
    80003180:	00a4d59b          	srliw	a1,s1,0xa
    80003184:	855a                	mv	a0,s6
    80003186:	00000097          	auipc	ra,0x0
    8000318a:	88e080e7          	jalr	-1906(ra) # 80002a14 <bmap>
    8000318e:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003192:	c9b1                	beqz	a1,800031e6 <readi+0xea>
    bp = bread(ip->dev, addr);
    80003194:	000b2503          	lw	a0,0(s6)
    80003198:	fffff097          	auipc	ra,0xfffff
    8000319c:	478080e7          	jalr	1144(ra) # 80002610 <bread>
    800031a0:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800031a2:	3ff4f713          	andi	a4,s1,1023
    800031a6:	40ec87bb          	subw	a5,s9,a4
    800031aa:	413a86bb          	subw	a3,s5,s3
    800031ae:	8d3e                	mv	s10,a5
    800031b0:	2781                	sext.w	a5,a5
    800031b2:	0006861b          	sext.w	a2,a3
    800031b6:	f8f679e3          	bgeu	a2,a5,80003148 <readi+0x4c>
    800031ba:	8d36                	mv	s10,a3
    800031bc:	b771                	j	80003148 <readi+0x4c>
      brelse(bp);
    800031be:	854a                	mv	a0,s2
    800031c0:	fffff097          	auipc	ra,0xfffff
    800031c4:	580080e7          	jalr	1408(ra) # 80002740 <brelse>
      tot = -1;
    800031c8:	59fd                	li	s3,-1
      break;
    800031ca:	6946                	ld	s2,80(sp)
    800031cc:	7c02                	ld	s8,32(sp)
    800031ce:	6ce2                	ld	s9,24(sp)
    800031d0:	6d42                	ld	s10,16(sp)
    800031d2:	6da2                	ld	s11,8(sp)
    800031d4:	a831                	j	800031f0 <readi+0xf4>
    800031d6:	6946                	ld	s2,80(sp)
    800031d8:	7c02                	ld	s8,32(sp)
    800031da:	6ce2                	ld	s9,24(sp)
    800031dc:	6d42                	ld	s10,16(sp)
    800031de:	6da2                	ld	s11,8(sp)
    800031e0:	a801                	j	800031f0 <readi+0xf4>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800031e2:	89d6                	mv	s3,s5
    800031e4:	a031                	j	800031f0 <readi+0xf4>
    800031e6:	6946                	ld	s2,80(sp)
    800031e8:	7c02                	ld	s8,32(sp)
    800031ea:	6ce2                	ld	s9,24(sp)
    800031ec:	6d42                	ld	s10,16(sp)
    800031ee:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800031f0:	0009851b          	sext.w	a0,s3
    800031f4:	69a6                	ld	s3,72(sp)
}
    800031f6:	70a6                	ld	ra,104(sp)
    800031f8:	7406                	ld	s0,96(sp)
    800031fa:	64e6                	ld	s1,88(sp)
    800031fc:	6a06                	ld	s4,64(sp)
    800031fe:	7ae2                	ld	s5,56(sp)
    80003200:	7b42                	ld	s6,48(sp)
    80003202:	7ba2                	ld	s7,40(sp)
    80003204:	6165                	addi	sp,sp,112
    80003206:	8082                	ret
    return 0;
    80003208:	4501                	li	a0,0
}
    8000320a:	8082                	ret

000000008000320c <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000320c:	457c                	lw	a5,76(a0)
    8000320e:	10d7ee63          	bltu	a5,a3,8000332a <writei+0x11e>
{
    80003212:	7159                	addi	sp,sp,-112
    80003214:	f486                	sd	ra,104(sp)
    80003216:	f0a2                	sd	s0,96(sp)
    80003218:	e8ca                	sd	s2,80(sp)
    8000321a:	e0d2                	sd	s4,64(sp)
    8000321c:	fc56                	sd	s5,56(sp)
    8000321e:	f85a                	sd	s6,48(sp)
    80003220:	f45e                	sd	s7,40(sp)
    80003222:	1880                	addi	s0,sp,112
    80003224:	8aaa                	mv	s5,a0
    80003226:	8bae                	mv	s7,a1
    80003228:	8a32                	mv	s4,a2
    8000322a:	8936                	mv	s2,a3
    8000322c:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000322e:	00e687bb          	addw	a5,a3,a4
    80003232:	0ed7ee63          	bltu	a5,a3,8000332e <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003236:	00043737          	lui	a4,0x43
    8000323a:	0ef76c63          	bltu	a4,a5,80003332 <writei+0x126>
    8000323e:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003240:	0c0b0d63          	beqz	s6,8000331a <writei+0x10e>
    80003244:	eca6                	sd	s1,88(sp)
    80003246:	f062                	sd	s8,32(sp)
    80003248:	ec66                	sd	s9,24(sp)
    8000324a:	e86a                	sd	s10,16(sp)
    8000324c:	e46e                	sd	s11,8(sp)
    8000324e:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003250:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003254:	5c7d                	li	s8,-1
    80003256:	a091                	j	8000329a <writei+0x8e>
    80003258:	020d1d93          	slli	s11,s10,0x20
    8000325c:	020ddd93          	srli	s11,s11,0x20
    80003260:	05848513          	addi	a0,s1,88
    80003264:	86ee                	mv	a3,s11
    80003266:	8652                	mv	a2,s4
    80003268:	85de                	mv	a1,s7
    8000326a:	953a                	add	a0,a0,a4
    8000326c:	fffff097          	auipc	ra,0xfffff
    80003270:	94c080e7          	jalr	-1716(ra) # 80001bb8 <either_copyin>
    80003274:	07850263          	beq	a0,s8,800032d8 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003278:	8526                	mv	a0,s1
    8000327a:	00000097          	auipc	ra,0x0
    8000327e:	770080e7          	jalr	1904(ra) # 800039ea <log_write>
    brelse(bp);
    80003282:	8526                	mv	a0,s1
    80003284:	fffff097          	auipc	ra,0xfffff
    80003288:	4bc080e7          	jalr	1212(ra) # 80002740 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000328c:	013d09bb          	addw	s3,s10,s3
    80003290:	012d093b          	addw	s2,s10,s2
    80003294:	9a6e                	add	s4,s4,s11
    80003296:	0569f663          	bgeu	s3,s6,800032e2 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    8000329a:	00a9559b          	srliw	a1,s2,0xa
    8000329e:	8556                	mv	a0,s5
    800032a0:	fffff097          	auipc	ra,0xfffff
    800032a4:	774080e7          	jalr	1908(ra) # 80002a14 <bmap>
    800032a8:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800032ac:	c99d                	beqz	a1,800032e2 <writei+0xd6>
    bp = bread(ip->dev, addr);
    800032ae:	000aa503          	lw	a0,0(s5)
    800032b2:	fffff097          	auipc	ra,0xfffff
    800032b6:	35e080e7          	jalr	862(ra) # 80002610 <bread>
    800032ba:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800032bc:	3ff97713          	andi	a4,s2,1023
    800032c0:	40ec87bb          	subw	a5,s9,a4
    800032c4:	413b06bb          	subw	a3,s6,s3
    800032c8:	8d3e                	mv	s10,a5
    800032ca:	2781                	sext.w	a5,a5
    800032cc:	0006861b          	sext.w	a2,a3
    800032d0:	f8f674e3          	bgeu	a2,a5,80003258 <writei+0x4c>
    800032d4:	8d36                	mv	s10,a3
    800032d6:	b749                	j	80003258 <writei+0x4c>
      brelse(bp);
    800032d8:	8526                	mv	a0,s1
    800032da:	fffff097          	auipc	ra,0xfffff
    800032de:	466080e7          	jalr	1126(ra) # 80002740 <brelse>
  }

  if(off > ip->size)
    800032e2:	04caa783          	lw	a5,76(s5)
    800032e6:	0327fc63          	bgeu	a5,s2,8000331e <writei+0x112>
    ip->size = off;
    800032ea:	052aa623          	sw	s2,76(s5)
    800032ee:	64e6                	ld	s1,88(sp)
    800032f0:	7c02                	ld	s8,32(sp)
    800032f2:	6ce2                	ld	s9,24(sp)
    800032f4:	6d42                	ld	s10,16(sp)
    800032f6:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800032f8:	8556                	mv	a0,s5
    800032fa:	00000097          	auipc	ra,0x0
    800032fe:	a7e080e7          	jalr	-1410(ra) # 80002d78 <iupdate>

  return tot;
    80003302:	0009851b          	sext.w	a0,s3
    80003306:	69a6                	ld	s3,72(sp)
}
    80003308:	70a6                	ld	ra,104(sp)
    8000330a:	7406                	ld	s0,96(sp)
    8000330c:	6946                	ld	s2,80(sp)
    8000330e:	6a06                	ld	s4,64(sp)
    80003310:	7ae2                	ld	s5,56(sp)
    80003312:	7b42                	ld	s6,48(sp)
    80003314:	7ba2                	ld	s7,40(sp)
    80003316:	6165                	addi	sp,sp,112
    80003318:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000331a:	89da                	mv	s3,s6
    8000331c:	bff1                	j	800032f8 <writei+0xec>
    8000331e:	64e6                	ld	s1,88(sp)
    80003320:	7c02                	ld	s8,32(sp)
    80003322:	6ce2                	ld	s9,24(sp)
    80003324:	6d42                	ld	s10,16(sp)
    80003326:	6da2                	ld	s11,8(sp)
    80003328:	bfc1                	j	800032f8 <writei+0xec>
    return -1;
    8000332a:	557d                	li	a0,-1
}
    8000332c:	8082                	ret
    return -1;
    8000332e:	557d                	li	a0,-1
    80003330:	bfe1                	j	80003308 <writei+0xfc>
    return -1;
    80003332:	557d                	li	a0,-1
    80003334:	bfd1                	j	80003308 <writei+0xfc>

0000000080003336 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003336:	1141                	addi	sp,sp,-16
    80003338:	e406                	sd	ra,8(sp)
    8000333a:	e022                	sd	s0,0(sp)
    8000333c:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000333e:	4639                	li	a2,14
    80003340:	ffffd097          	auipc	ra,0xffffd
    80003344:	f0a080e7          	jalr	-246(ra) # 8000024a <strncmp>
}
    80003348:	60a2                	ld	ra,8(sp)
    8000334a:	6402                	ld	s0,0(sp)
    8000334c:	0141                	addi	sp,sp,16
    8000334e:	8082                	ret

0000000080003350 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003350:	7139                	addi	sp,sp,-64
    80003352:	fc06                	sd	ra,56(sp)
    80003354:	f822                	sd	s0,48(sp)
    80003356:	f426                	sd	s1,40(sp)
    80003358:	f04a                	sd	s2,32(sp)
    8000335a:	ec4e                	sd	s3,24(sp)
    8000335c:	e852                	sd	s4,16(sp)
    8000335e:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003360:	04451703          	lh	a4,68(a0)
    80003364:	4785                	li	a5,1
    80003366:	00f71a63          	bne	a4,a5,8000337a <dirlookup+0x2a>
    8000336a:	892a                	mv	s2,a0
    8000336c:	89ae                	mv	s3,a1
    8000336e:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003370:	457c                	lw	a5,76(a0)
    80003372:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003374:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003376:	e79d                	bnez	a5,800033a4 <dirlookup+0x54>
    80003378:	a8a5                	j	800033f0 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000337a:	00005517          	auipc	a0,0x5
    8000337e:	19e50513          	addi	a0,a0,414 # 80008518 <etext+0x518>
    80003382:	00003097          	auipc	ra,0x3
    80003386:	ca0080e7          	jalr	-864(ra) # 80006022 <panic>
      panic("dirlookup read");
    8000338a:	00005517          	auipc	a0,0x5
    8000338e:	1a650513          	addi	a0,a0,422 # 80008530 <etext+0x530>
    80003392:	00003097          	auipc	ra,0x3
    80003396:	c90080e7          	jalr	-880(ra) # 80006022 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000339a:	24c1                	addiw	s1,s1,16
    8000339c:	04c92783          	lw	a5,76(s2)
    800033a0:	04f4f763          	bgeu	s1,a5,800033ee <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033a4:	4741                	li	a4,16
    800033a6:	86a6                	mv	a3,s1
    800033a8:	fc040613          	addi	a2,s0,-64
    800033ac:	4581                	li	a1,0
    800033ae:	854a                	mv	a0,s2
    800033b0:	00000097          	auipc	ra,0x0
    800033b4:	d4c080e7          	jalr	-692(ra) # 800030fc <readi>
    800033b8:	47c1                	li	a5,16
    800033ba:	fcf518e3          	bne	a0,a5,8000338a <dirlookup+0x3a>
    if(de.inum == 0)
    800033be:	fc045783          	lhu	a5,-64(s0)
    800033c2:	dfe1                	beqz	a5,8000339a <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800033c4:	fc240593          	addi	a1,s0,-62
    800033c8:	854e                	mv	a0,s3
    800033ca:	00000097          	auipc	ra,0x0
    800033ce:	f6c080e7          	jalr	-148(ra) # 80003336 <namecmp>
    800033d2:	f561                	bnez	a0,8000339a <dirlookup+0x4a>
      if(poff)
    800033d4:	000a0463          	beqz	s4,800033dc <dirlookup+0x8c>
        *poff = off;
    800033d8:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800033dc:	fc045583          	lhu	a1,-64(s0)
    800033e0:	00092503          	lw	a0,0(s2)
    800033e4:	fffff097          	auipc	ra,0xfffff
    800033e8:	720080e7          	jalr	1824(ra) # 80002b04 <iget>
    800033ec:	a011                	j	800033f0 <dirlookup+0xa0>
  return 0;
    800033ee:	4501                	li	a0,0
}
    800033f0:	70e2                	ld	ra,56(sp)
    800033f2:	7442                	ld	s0,48(sp)
    800033f4:	74a2                	ld	s1,40(sp)
    800033f6:	7902                	ld	s2,32(sp)
    800033f8:	69e2                	ld	s3,24(sp)
    800033fa:	6a42                	ld	s4,16(sp)
    800033fc:	6121                	addi	sp,sp,64
    800033fe:	8082                	ret

0000000080003400 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003400:	711d                	addi	sp,sp,-96
    80003402:	ec86                	sd	ra,88(sp)
    80003404:	e8a2                	sd	s0,80(sp)
    80003406:	e4a6                	sd	s1,72(sp)
    80003408:	e0ca                	sd	s2,64(sp)
    8000340a:	fc4e                	sd	s3,56(sp)
    8000340c:	f852                	sd	s4,48(sp)
    8000340e:	f456                	sd	s5,40(sp)
    80003410:	f05a                	sd	s6,32(sp)
    80003412:	ec5e                	sd	s7,24(sp)
    80003414:	e862                	sd	s8,16(sp)
    80003416:	e466                	sd	s9,8(sp)
    80003418:	1080                	addi	s0,sp,96
    8000341a:	84aa                	mv	s1,a0
    8000341c:	8b2e                	mv	s6,a1
    8000341e:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003420:	00054703          	lbu	a4,0(a0)
    80003424:	02f00793          	li	a5,47
    80003428:	02f70263          	beq	a4,a5,8000344c <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000342c:	ffffe097          	auipc	ra,0xffffe
    80003430:	bd4080e7          	jalr	-1068(ra) # 80001000 <myproc>
    80003434:	15853503          	ld	a0,344(a0)
    80003438:	00000097          	auipc	ra,0x0
    8000343c:	9ce080e7          	jalr	-1586(ra) # 80002e06 <idup>
    80003440:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003442:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003446:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003448:	4b85                	li	s7,1
    8000344a:	a875                	j	80003506 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    8000344c:	4585                	li	a1,1
    8000344e:	4505                	li	a0,1
    80003450:	fffff097          	auipc	ra,0xfffff
    80003454:	6b4080e7          	jalr	1716(ra) # 80002b04 <iget>
    80003458:	8a2a                	mv	s4,a0
    8000345a:	b7e5                	j	80003442 <namex+0x42>
      iunlockput(ip);
    8000345c:	8552                	mv	a0,s4
    8000345e:	00000097          	auipc	ra,0x0
    80003462:	c4c080e7          	jalr	-948(ra) # 800030aa <iunlockput>
      return 0;
    80003466:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003468:	8552                	mv	a0,s4
    8000346a:	60e6                	ld	ra,88(sp)
    8000346c:	6446                	ld	s0,80(sp)
    8000346e:	64a6                	ld	s1,72(sp)
    80003470:	6906                	ld	s2,64(sp)
    80003472:	79e2                	ld	s3,56(sp)
    80003474:	7a42                	ld	s4,48(sp)
    80003476:	7aa2                	ld	s5,40(sp)
    80003478:	7b02                	ld	s6,32(sp)
    8000347a:	6be2                	ld	s7,24(sp)
    8000347c:	6c42                	ld	s8,16(sp)
    8000347e:	6ca2                	ld	s9,8(sp)
    80003480:	6125                	addi	sp,sp,96
    80003482:	8082                	ret
      iunlock(ip);
    80003484:	8552                	mv	a0,s4
    80003486:	00000097          	auipc	ra,0x0
    8000348a:	a84080e7          	jalr	-1404(ra) # 80002f0a <iunlock>
      return ip;
    8000348e:	bfe9                	j	80003468 <namex+0x68>
      iunlockput(ip);
    80003490:	8552                	mv	a0,s4
    80003492:	00000097          	auipc	ra,0x0
    80003496:	c18080e7          	jalr	-1000(ra) # 800030aa <iunlockput>
      return 0;
    8000349a:	8a4e                	mv	s4,s3
    8000349c:	b7f1                	j	80003468 <namex+0x68>
  len = path - s;
    8000349e:	40998633          	sub	a2,s3,s1
    800034a2:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800034a6:	099c5863          	bge	s8,s9,80003536 <namex+0x136>
    memmove(name, s, DIRSIZ);
    800034aa:	4639                	li	a2,14
    800034ac:	85a6                	mv	a1,s1
    800034ae:	8556                	mv	a0,s5
    800034b0:	ffffd097          	auipc	ra,0xffffd
    800034b4:	d26080e7          	jalr	-730(ra) # 800001d6 <memmove>
    800034b8:	84ce                	mv	s1,s3
  while(*path == '/')
    800034ba:	0004c783          	lbu	a5,0(s1)
    800034be:	01279763          	bne	a5,s2,800034cc <namex+0xcc>
    path++;
    800034c2:	0485                	addi	s1,s1,1
  while(*path == '/')
    800034c4:	0004c783          	lbu	a5,0(s1)
    800034c8:	ff278de3          	beq	a5,s2,800034c2 <namex+0xc2>
    ilock(ip);
    800034cc:	8552                	mv	a0,s4
    800034ce:	00000097          	auipc	ra,0x0
    800034d2:	976080e7          	jalr	-1674(ra) # 80002e44 <ilock>
    if(ip->type != T_DIR){
    800034d6:	044a1783          	lh	a5,68(s4)
    800034da:	f97791e3          	bne	a5,s7,8000345c <namex+0x5c>
    if(nameiparent && *path == '\0'){
    800034de:	000b0563          	beqz	s6,800034e8 <namex+0xe8>
    800034e2:	0004c783          	lbu	a5,0(s1)
    800034e6:	dfd9                	beqz	a5,80003484 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    800034e8:	4601                	li	a2,0
    800034ea:	85d6                	mv	a1,s5
    800034ec:	8552                	mv	a0,s4
    800034ee:	00000097          	auipc	ra,0x0
    800034f2:	e62080e7          	jalr	-414(ra) # 80003350 <dirlookup>
    800034f6:	89aa                	mv	s3,a0
    800034f8:	dd41                	beqz	a0,80003490 <namex+0x90>
    iunlockput(ip);
    800034fa:	8552                	mv	a0,s4
    800034fc:	00000097          	auipc	ra,0x0
    80003500:	bae080e7          	jalr	-1106(ra) # 800030aa <iunlockput>
    ip = next;
    80003504:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003506:	0004c783          	lbu	a5,0(s1)
    8000350a:	01279763          	bne	a5,s2,80003518 <namex+0x118>
    path++;
    8000350e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003510:	0004c783          	lbu	a5,0(s1)
    80003514:	ff278de3          	beq	a5,s2,8000350e <namex+0x10e>
  if(*path == 0)
    80003518:	cb9d                	beqz	a5,8000354e <namex+0x14e>
  while(*path != '/' && *path != 0)
    8000351a:	0004c783          	lbu	a5,0(s1)
    8000351e:	89a6                	mv	s3,s1
  len = path - s;
    80003520:	4c81                	li	s9,0
    80003522:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003524:	01278963          	beq	a5,s2,80003536 <namex+0x136>
    80003528:	dbbd                	beqz	a5,8000349e <namex+0x9e>
    path++;
    8000352a:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    8000352c:	0009c783          	lbu	a5,0(s3)
    80003530:	ff279ce3          	bne	a5,s2,80003528 <namex+0x128>
    80003534:	b7ad                	j	8000349e <namex+0x9e>
    memmove(name, s, len);
    80003536:	2601                	sext.w	a2,a2
    80003538:	85a6                	mv	a1,s1
    8000353a:	8556                	mv	a0,s5
    8000353c:	ffffd097          	auipc	ra,0xffffd
    80003540:	c9a080e7          	jalr	-870(ra) # 800001d6 <memmove>
    name[len] = 0;
    80003544:	9cd6                	add	s9,s9,s5
    80003546:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000354a:	84ce                	mv	s1,s3
    8000354c:	b7bd                	j	800034ba <namex+0xba>
  if(nameiparent){
    8000354e:	f00b0de3          	beqz	s6,80003468 <namex+0x68>
    iput(ip);
    80003552:	8552                	mv	a0,s4
    80003554:	00000097          	auipc	ra,0x0
    80003558:	aae080e7          	jalr	-1362(ra) # 80003002 <iput>
    return 0;
    8000355c:	4a01                	li	s4,0
    8000355e:	b729                	j	80003468 <namex+0x68>

0000000080003560 <dirlink>:
{
    80003560:	7139                	addi	sp,sp,-64
    80003562:	fc06                	sd	ra,56(sp)
    80003564:	f822                	sd	s0,48(sp)
    80003566:	f04a                	sd	s2,32(sp)
    80003568:	ec4e                	sd	s3,24(sp)
    8000356a:	e852                	sd	s4,16(sp)
    8000356c:	0080                	addi	s0,sp,64
    8000356e:	892a                	mv	s2,a0
    80003570:	8a2e                	mv	s4,a1
    80003572:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003574:	4601                	li	a2,0
    80003576:	00000097          	auipc	ra,0x0
    8000357a:	dda080e7          	jalr	-550(ra) # 80003350 <dirlookup>
    8000357e:	ed25                	bnez	a0,800035f6 <dirlink+0x96>
    80003580:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003582:	04c92483          	lw	s1,76(s2)
    80003586:	c49d                	beqz	s1,800035b4 <dirlink+0x54>
    80003588:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000358a:	4741                	li	a4,16
    8000358c:	86a6                	mv	a3,s1
    8000358e:	fc040613          	addi	a2,s0,-64
    80003592:	4581                	li	a1,0
    80003594:	854a                	mv	a0,s2
    80003596:	00000097          	auipc	ra,0x0
    8000359a:	b66080e7          	jalr	-1178(ra) # 800030fc <readi>
    8000359e:	47c1                	li	a5,16
    800035a0:	06f51163          	bne	a0,a5,80003602 <dirlink+0xa2>
    if(de.inum == 0)
    800035a4:	fc045783          	lhu	a5,-64(s0)
    800035a8:	c791                	beqz	a5,800035b4 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800035aa:	24c1                	addiw	s1,s1,16
    800035ac:	04c92783          	lw	a5,76(s2)
    800035b0:	fcf4ede3          	bltu	s1,a5,8000358a <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800035b4:	4639                	li	a2,14
    800035b6:	85d2                	mv	a1,s4
    800035b8:	fc240513          	addi	a0,s0,-62
    800035bc:	ffffd097          	auipc	ra,0xffffd
    800035c0:	cc4080e7          	jalr	-828(ra) # 80000280 <strncpy>
  de.inum = inum;
    800035c4:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800035c8:	4741                	li	a4,16
    800035ca:	86a6                	mv	a3,s1
    800035cc:	fc040613          	addi	a2,s0,-64
    800035d0:	4581                	li	a1,0
    800035d2:	854a                	mv	a0,s2
    800035d4:	00000097          	auipc	ra,0x0
    800035d8:	c38080e7          	jalr	-968(ra) # 8000320c <writei>
    800035dc:	1541                	addi	a0,a0,-16
    800035de:	00a03533          	snez	a0,a0
    800035e2:	40a00533          	neg	a0,a0
    800035e6:	74a2                	ld	s1,40(sp)
}
    800035e8:	70e2                	ld	ra,56(sp)
    800035ea:	7442                	ld	s0,48(sp)
    800035ec:	7902                	ld	s2,32(sp)
    800035ee:	69e2                	ld	s3,24(sp)
    800035f0:	6a42                	ld	s4,16(sp)
    800035f2:	6121                	addi	sp,sp,64
    800035f4:	8082                	ret
    iput(ip);
    800035f6:	00000097          	auipc	ra,0x0
    800035fa:	a0c080e7          	jalr	-1524(ra) # 80003002 <iput>
    return -1;
    800035fe:	557d                	li	a0,-1
    80003600:	b7e5                	j	800035e8 <dirlink+0x88>
      panic("dirlink read");
    80003602:	00005517          	auipc	a0,0x5
    80003606:	f3e50513          	addi	a0,a0,-194 # 80008540 <etext+0x540>
    8000360a:	00003097          	auipc	ra,0x3
    8000360e:	a18080e7          	jalr	-1512(ra) # 80006022 <panic>

0000000080003612 <namei>:

struct inode*
namei(char *path)
{
    80003612:	1101                	addi	sp,sp,-32
    80003614:	ec06                	sd	ra,24(sp)
    80003616:	e822                	sd	s0,16(sp)
    80003618:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000361a:	fe040613          	addi	a2,s0,-32
    8000361e:	4581                	li	a1,0
    80003620:	00000097          	auipc	ra,0x0
    80003624:	de0080e7          	jalr	-544(ra) # 80003400 <namex>
}
    80003628:	60e2                	ld	ra,24(sp)
    8000362a:	6442                	ld	s0,16(sp)
    8000362c:	6105                	addi	sp,sp,32
    8000362e:	8082                	ret

0000000080003630 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003630:	1141                	addi	sp,sp,-16
    80003632:	e406                	sd	ra,8(sp)
    80003634:	e022                	sd	s0,0(sp)
    80003636:	0800                	addi	s0,sp,16
    80003638:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000363a:	4585                	li	a1,1
    8000363c:	00000097          	auipc	ra,0x0
    80003640:	dc4080e7          	jalr	-572(ra) # 80003400 <namex>
}
    80003644:	60a2                	ld	ra,8(sp)
    80003646:	6402                	ld	s0,0(sp)
    80003648:	0141                	addi	sp,sp,16
    8000364a:	8082                	ret

000000008000364c <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000364c:	1101                	addi	sp,sp,-32
    8000364e:	ec06                	sd	ra,24(sp)
    80003650:	e822                	sd	s0,16(sp)
    80003652:	e426                	sd	s1,8(sp)
    80003654:	e04a                	sd	s2,0(sp)
    80003656:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003658:	00018917          	auipc	s2,0x18
    8000365c:	f0890913          	addi	s2,s2,-248 # 8001b560 <log>
    80003660:	01892583          	lw	a1,24(s2)
    80003664:	02892503          	lw	a0,40(s2)
    80003668:	fffff097          	auipc	ra,0xfffff
    8000366c:	fa8080e7          	jalr	-88(ra) # 80002610 <bread>
    80003670:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003672:	02c92603          	lw	a2,44(s2)
    80003676:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003678:	00c05f63          	blez	a2,80003696 <write_head+0x4a>
    8000367c:	00018717          	auipc	a4,0x18
    80003680:	f1470713          	addi	a4,a4,-236 # 8001b590 <log+0x30>
    80003684:	87aa                	mv	a5,a0
    80003686:	060a                	slli	a2,a2,0x2
    80003688:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000368a:	4314                	lw	a3,0(a4)
    8000368c:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000368e:	0711                	addi	a4,a4,4
    80003690:	0791                	addi	a5,a5,4
    80003692:	fec79ce3          	bne	a5,a2,8000368a <write_head+0x3e>
  }
  bwrite(buf);
    80003696:	8526                	mv	a0,s1
    80003698:	fffff097          	auipc	ra,0xfffff
    8000369c:	06a080e7          	jalr	106(ra) # 80002702 <bwrite>
  brelse(buf);
    800036a0:	8526                	mv	a0,s1
    800036a2:	fffff097          	auipc	ra,0xfffff
    800036a6:	09e080e7          	jalr	158(ra) # 80002740 <brelse>
}
    800036aa:	60e2                	ld	ra,24(sp)
    800036ac:	6442                	ld	s0,16(sp)
    800036ae:	64a2                	ld	s1,8(sp)
    800036b0:	6902                	ld	s2,0(sp)
    800036b2:	6105                	addi	sp,sp,32
    800036b4:	8082                	ret

00000000800036b6 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800036b6:	00018797          	auipc	a5,0x18
    800036ba:	ed67a783          	lw	a5,-298(a5) # 8001b58c <log+0x2c>
    800036be:	0af05d63          	blez	a5,80003778 <install_trans+0xc2>
{
    800036c2:	7139                	addi	sp,sp,-64
    800036c4:	fc06                	sd	ra,56(sp)
    800036c6:	f822                	sd	s0,48(sp)
    800036c8:	f426                	sd	s1,40(sp)
    800036ca:	f04a                	sd	s2,32(sp)
    800036cc:	ec4e                	sd	s3,24(sp)
    800036ce:	e852                	sd	s4,16(sp)
    800036d0:	e456                	sd	s5,8(sp)
    800036d2:	e05a                	sd	s6,0(sp)
    800036d4:	0080                	addi	s0,sp,64
    800036d6:	8b2a                	mv	s6,a0
    800036d8:	00018a97          	auipc	s5,0x18
    800036dc:	eb8a8a93          	addi	s5,s5,-328 # 8001b590 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036e0:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800036e2:	00018997          	auipc	s3,0x18
    800036e6:	e7e98993          	addi	s3,s3,-386 # 8001b560 <log>
    800036ea:	a00d                	j	8000370c <install_trans+0x56>
    brelse(lbuf);
    800036ec:	854a                	mv	a0,s2
    800036ee:	fffff097          	auipc	ra,0xfffff
    800036f2:	052080e7          	jalr	82(ra) # 80002740 <brelse>
    brelse(dbuf);
    800036f6:	8526                	mv	a0,s1
    800036f8:	fffff097          	auipc	ra,0xfffff
    800036fc:	048080e7          	jalr	72(ra) # 80002740 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003700:	2a05                	addiw	s4,s4,1
    80003702:	0a91                	addi	s5,s5,4
    80003704:	02c9a783          	lw	a5,44(s3)
    80003708:	04fa5e63          	bge	s4,a5,80003764 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000370c:	0189a583          	lw	a1,24(s3)
    80003710:	014585bb          	addw	a1,a1,s4
    80003714:	2585                	addiw	a1,a1,1
    80003716:	0289a503          	lw	a0,40(s3)
    8000371a:	fffff097          	auipc	ra,0xfffff
    8000371e:	ef6080e7          	jalr	-266(ra) # 80002610 <bread>
    80003722:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003724:	000aa583          	lw	a1,0(s5)
    80003728:	0289a503          	lw	a0,40(s3)
    8000372c:	fffff097          	auipc	ra,0xfffff
    80003730:	ee4080e7          	jalr	-284(ra) # 80002610 <bread>
    80003734:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003736:	40000613          	li	a2,1024
    8000373a:	05890593          	addi	a1,s2,88
    8000373e:	05850513          	addi	a0,a0,88
    80003742:	ffffd097          	auipc	ra,0xffffd
    80003746:	a94080e7          	jalr	-1388(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000374a:	8526                	mv	a0,s1
    8000374c:	fffff097          	auipc	ra,0xfffff
    80003750:	fb6080e7          	jalr	-74(ra) # 80002702 <bwrite>
    if(recovering == 0)
    80003754:	f80b1ce3          	bnez	s6,800036ec <install_trans+0x36>
      bunpin(dbuf);
    80003758:	8526                	mv	a0,s1
    8000375a:	fffff097          	auipc	ra,0xfffff
    8000375e:	0be080e7          	jalr	190(ra) # 80002818 <bunpin>
    80003762:	b769                	j	800036ec <install_trans+0x36>
}
    80003764:	70e2                	ld	ra,56(sp)
    80003766:	7442                	ld	s0,48(sp)
    80003768:	74a2                	ld	s1,40(sp)
    8000376a:	7902                	ld	s2,32(sp)
    8000376c:	69e2                	ld	s3,24(sp)
    8000376e:	6a42                	ld	s4,16(sp)
    80003770:	6aa2                	ld	s5,8(sp)
    80003772:	6b02                	ld	s6,0(sp)
    80003774:	6121                	addi	sp,sp,64
    80003776:	8082                	ret
    80003778:	8082                	ret

000000008000377a <initlog>:
{
    8000377a:	7179                	addi	sp,sp,-48
    8000377c:	f406                	sd	ra,40(sp)
    8000377e:	f022                	sd	s0,32(sp)
    80003780:	ec26                	sd	s1,24(sp)
    80003782:	e84a                	sd	s2,16(sp)
    80003784:	e44e                	sd	s3,8(sp)
    80003786:	1800                	addi	s0,sp,48
    80003788:	892a                	mv	s2,a0
    8000378a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000378c:	00018497          	auipc	s1,0x18
    80003790:	dd448493          	addi	s1,s1,-556 # 8001b560 <log>
    80003794:	00005597          	auipc	a1,0x5
    80003798:	dbc58593          	addi	a1,a1,-580 # 80008550 <etext+0x550>
    8000379c:	8526                	mv	a0,s1
    8000379e:	00003097          	auipc	ra,0x3
    800037a2:	d6e080e7          	jalr	-658(ra) # 8000650c <initlock>
  log.start = sb->logstart;
    800037a6:	0149a583          	lw	a1,20(s3)
    800037aa:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800037ac:	0109a783          	lw	a5,16(s3)
    800037b0:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800037b2:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800037b6:	854a                	mv	a0,s2
    800037b8:	fffff097          	auipc	ra,0xfffff
    800037bc:	e58080e7          	jalr	-424(ra) # 80002610 <bread>
  log.lh.n = lh->n;
    800037c0:	4d30                	lw	a2,88(a0)
    800037c2:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800037c4:	00c05f63          	blez	a2,800037e2 <initlog+0x68>
    800037c8:	87aa                	mv	a5,a0
    800037ca:	00018717          	auipc	a4,0x18
    800037ce:	dc670713          	addi	a4,a4,-570 # 8001b590 <log+0x30>
    800037d2:	060a                	slli	a2,a2,0x2
    800037d4:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800037d6:	4ff4                	lw	a3,92(a5)
    800037d8:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800037da:	0791                	addi	a5,a5,4
    800037dc:	0711                	addi	a4,a4,4
    800037de:	fec79ce3          	bne	a5,a2,800037d6 <initlog+0x5c>
  brelse(buf);
    800037e2:	fffff097          	auipc	ra,0xfffff
    800037e6:	f5e080e7          	jalr	-162(ra) # 80002740 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800037ea:	4505                	li	a0,1
    800037ec:	00000097          	auipc	ra,0x0
    800037f0:	eca080e7          	jalr	-310(ra) # 800036b6 <install_trans>
  log.lh.n = 0;
    800037f4:	00018797          	auipc	a5,0x18
    800037f8:	d807ac23          	sw	zero,-616(a5) # 8001b58c <log+0x2c>
  write_head(); // clear the log
    800037fc:	00000097          	auipc	ra,0x0
    80003800:	e50080e7          	jalr	-432(ra) # 8000364c <write_head>
}
    80003804:	70a2                	ld	ra,40(sp)
    80003806:	7402                	ld	s0,32(sp)
    80003808:	64e2                	ld	s1,24(sp)
    8000380a:	6942                	ld	s2,16(sp)
    8000380c:	69a2                	ld	s3,8(sp)
    8000380e:	6145                	addi	sp,sp,48
    80003810:	8082                	ret

0000000080003812 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003812:	1101                	addi	sp,sp,-32
    80003814:	ec06                	sd	ra,24(sp)
    80003816:	e822                	sd	s0,16(sp)
    80003818:	e426                	sd	s1,8(sp)
    8000381a:	e04a                	sd	s2,0(sp)
    8000381c:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000381e:	00018517          	auipc	a0,0x18
    80003822:	d4250513          	addi	a0,a0,-702 # 8001b560 <log>
    80003826:	00003097          	auipc	ra,0x3
    8000382a:	d76080e7          	jalr	-650(ra) # 8000659c <acquire>
  while(1){
    if(log.committing){
    8000382e:	00018497          	auipc	s1,0x18
    80003832:	d3248493          	addi	s1,s1,-718 # 8001b560 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003836:	4979                	li	s2,30
    80003838:	a039                	j	80003846 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000383a:	85a6                	mv	a1,s1
    8000383c:	8526                	mv	a0,s1
    8000383e:	ffffe097          	auipc	ra,0xffffe
    80003842:	f1c080e7          	jalr	-228(ra) # 8000175a <sleep>
    if(log.committing){
    80003846:	50dc                	lw	a5,36(s1)
    80003848:	fbed                	bnez	a5,8000383a <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000384a:	5098                	lw	a4,32(s1)
    8000384c:	2705                	addiw	a4,a4,1
    8000384e:	0027179b          	slliw	a5,a4,0x2
    80003852:	9fb9                	addw	a5,a5,a4
    80003854:	0017979b          	slliw	a5,a5,0x1
    80003858:	54d4                	lw	a3,44(s1)
    8000385a:	9fb5                	addw	a5,a5,a3
    8000385c:	00f95963          	bge	s2,a5,8000386e <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003860:	85a6                	mv	a1,s1
    80003862:	8526                	mv	a0,s1
    80003864:	ffffe097          	auipc	ra,0xffffe
    80003868:	ef6080e7          	jalr	-266(ra) # 8000175a <sleep>
    8000386c:	bfe9                	j	80003846 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000386e:	00018517          	auipc	a0,0x18
    80003872:	cf250513          	addi	a0,a0,-782 # 8001b560 <log>
    80003876:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003878:	00003097          	auipc	ra,0x3
    8000387c:	dd8080e7          	jalr	-552(ra) # 80006650 <release>
      break;
    }
  }
}
    80003880:	60e2                	ld	ra,24(sp)
    80003882:	6442                	ld	s0,16(sp)
    80003884:	64a2                	ld	s1,8(sp)
    80003886:	6902                	ld	s2,0(sp)
    80003888:	6105                	addi	sp,sp,32
    8000388a:	8082                	ret

000000008000388c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000388c:	7139                	addi	sp,sp,-64
    8000388e:	fc06                	sd	ra,56(sp)
    80003890:	f822                	sd	s0,48(sp)
    80003892:	f426                	sd	s1,40(sp)
    80003894:	f04a                	sd	s2,32(sp)
    80003896:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003898:	00018497          	auipc	s1,0x18
    8000389c:	cc848493          	addi	s1,s1,-824 # 8001b560 <log>
    800038a0:	8526                	mv	a0,s1
    800038a2:	00003097          	auipc	ra,0x3
    800038a6:	cfa080e7          	jalr	-774(ra) # 8000659c <acquire>
  log.outstanding -= 1;
    800038aa:	509c                	lw	a5,32(s1)
    800038ac:	37fd                	addiw	a5,a5,-1
    800038ae:	0007891b          	sext.w	s2,a5
    800038b2:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800038b4:	50dc                	lw	a5,36(s1)
    800038b6:	e7b9                	bnez	a5,80003904 <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    800038b8:	06091163          	bnez	s2,8000391a <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800038bc:	00018497          	auipc	s1,0x18
    800038c0:	ca448493          	addi	s1,s1,-860 # 8001b560 <log>
    800038c4:	4785                	li	a5,1
    800038c6:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800038c8:	8526                	mv	a0,s1
    800038ca:	00003097          	auipc	ra,0x3
    800038ce:	d86080e7          	jalr	-634(ra) # 80006650 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800038d2:	54dc                	lw	a5,44(s1)
    800038d4:	06f04763          	bgtz	a5,80003942 <end_op+0xb6>
    acquire(&log.lock);
    800038d8:	00018497          	auipc	s1,0x18
    800038dc:	c8848493          	addi	s1,s1,-888 # 8001b560 <log>
    800038e0:	8526                	mv	a0,s1
    800038e2:	00003097          	auipc	ra,0x3
    800038e6:	cba080e7          	jalr	-838(ra) # 8000659c <acquire>
    log.committing = 0;
    800038ea:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800038ee:	8526                	mv	a0,s1
    800038f0:	ffffe097          	auipc	ra,0xffffe
    800038f4:	ece080e7          	jalr	-306(ra) # 800017be <wakeup>
    release(&log.lock);
    800038f8:	8526                	mv	a0,s1
    800038fa:	00003097          	auipc	ra,0x3
    800038fe:	d56080e7          	jalr	-682(ra) # 80006650 <release>
}
    80003902:	a815                	j	80003936 <end_op+0xaa>
    80003904:	ec4e                	sd	s3,24(sp)
    80003906:	e852                	sd	s4,16(sp)
    80003908:	e456                	sd	s5,8(sp)
    panic("log.committing");
    8000390a:	00005517          	auipc	a0,0x5
    8000390e:	c4e50513          	addi	a0,a0,-946 # 80008558 <etext+0x558>
    80003912:	00002097          	auipc	ra,0x2
    80003916:	710080e7          	jalr	1808(ra) # 80006022 <panic>
    wakeup(&log);
    8000391a:	00018497          	auipc	s1,0x18
    8000391e:	c4648493          	addi	s1,s1,-954 # 8001b560 <log>
    80003922:	8526                	mv	a0,s1
    80003924:	ffffe097          	auipc	ra,0xffffe
    80003928:	e9a080e7          	jalr	-358(ra) # 800017be <wakeup>
  release(&log.lock);
    8000392c:	8526                	mv	a0,s1
    8000392e:	00003097          	auipc	ra,0x3
    80003932:	d22080e7          	jalr	-734(ra) # 80006650 <release>
}
    80003936:	70e2                	ld	ra,56(sp)
    80003938:	7442                	ld	s0,48(sp)
    8000393a:	74a2                	ld	s1,40(sp)
    8000393c:	7902                	ld	s2,32(sp)
    8000393e:	6121                	addi	sp,sp,64
    80003940:	8082                	ret
    80003942:	ec4e                	sd	s3,24(sp)
    80003944:	e852                	sd	s4,16(sp)
    80003946:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003948:	00018a97          	auipc	s5,0x18
    8000394c:	c48a8a93          	addi	s5,s5,-952 # 8001b590 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003950:	00018a17          	auipc	s4,0x18
    80003954:	c10a0a13          	addi	s4,s4,-1008 # 8001b560 <log>
    80003958:	018a2583          	lw	a1,24(s4)
    8000395c:	012585bb          	addw	a1,a1,s2
    80003960:	2585                	addiw	a1,a1,1
    80003962:	028a2503          	lw	a0,40(s4)
    80003966:	fffff097          	auipc	ra,0xfffff
    8000396a:	caa080e7          	jalr	-854(ra) # 80002610 <bread>
    8000396e:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003970:	000aa583          	lw	a1,0(s5)
    80003974:	028a2503          	lw	a0,40(s4)
    80003978:	fffff097          	auipc	ra,0xfffff
    8000397c:	c98080e7          	jalr	-872(ra) # 80002610 <bread>
    80003980:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003982:	40000613          	li	a2,1024
    80003986:	05850593          	addi	a1,a0,88
    8000398a:	05848513          	addi	a0,s1,88
    8000398e:	ffffd097          	auipc	ra,0xffffd
    80003992:	848080e7          	jalr	-1976(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    80003996:	8526                	mv	a0,s1
    80003998:	fffff097          	auipc	ra,0xfffff
    8000399c:	d6a080e7          	jalr	-662(ra) # 80002702 <bwrite>
    brelse(from);
    800039a0:	854e                	mv	a0,s3
    800039a2:	fffff097          	auipc	ra,0xfffff
    800039a6:	d9e080e7          	jalr	-610(ra) # 80002740 <brelse>
    brelse(to);
    800039aa:	8526                	mv	a0,s1
    800039ac:	fffff097          	auipc	ra,0xfffff
    800039b0:	d94080e7          	jalr	-620(ra) # 80002740 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800039b4:	2905                	addiw	s2,s2,1
    800039b6:	0a91                	addi	s5,s5,4
    800039b8:	02ca2783          	lw	a5,44(s4)
    800039bc:	f8f94ee3          	blt	s2,a5,80003958 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800039c0:	00000097          	auipc	ra,0x0
    800039c4:	c8c080e7          	jalr	-884(ra) # 8000364c <write_head>
    install_trans(0); // Now install writes to home locations
    800039c8:	4501                	li	a0,0
    800039ca:	00000097          	auipc	ra,0x0
    800039ce:	cec080e7          	jalr	-788(ra) # 800036b6 <install_trans>
    log.lh.n = 0;
    800039d2:	00018797          	auipc	a5,0x18
    800039d6:	ba07ad23          	sw	zero,-1094(a5) # 8001b58c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800039da:	00000097          	auipc	ra,0x0
    800039de:	c72080e7          	jalr	-910(ra) # 8000364c <write_head>
    800039e2:	69e2                	ld	s3,24(sp)
    800039e4:	6a42                	ld	s4,16(sp)
    800039e6:	6aa2                	ld	s5,8(sp)
    800039e8:	bdc5                	j	800038d8 <end_op+0x4c>

00000000800039ea <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800039ea:	1101                	addi	sp,sp,-32
    800039ec:	ec06                	sd	ra,24(sp)
    800039ee:	e822                	sd	s0,16(sp)
    800039f0:	e426                	sd	s1,8(sp)
    800039f2:	e04a                	sd	s2,0(sp)
    800039f4:	1000                	addi	s0,sp,32
    800039f6:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800039f8:	00018917          	auipc	s2,0x18
    800039fc:	b6890913          	addi	s2,s2,-1176 # 8001b560 <log>
    80003a00:	854a                	mv	a0,s2
    80003a02:	00003097          	auipc	ra,0x3
    80003a06:	b9a080e7          	jalr	-1126(ra) # 8000659c <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003a0a:	02c92603          	lw	a2,44(s2)
    80003a0e:	47f5                	li	a5,29
    80003a10:	06c7c563          	blt	a5,a2,80003a7a <log_write+0x90>
    80003a14:	00018797          	auipc	a5,0x18
    80003a18:	b687a783          	lw	a5,-1176(a5) # 8001b57c <log+0x1c>
    80003a1c:	37fd                	addiw	a5,a5,-1
    80003a1e:	04f65e63          	bge	a2,a5,80003a7a <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003a22:	00018797          	auipc	a5,0x18
    80003a26:	b5e7a783          	lw	a5,-1186(a5) # 8001b580 <log+0x20>
    80003a2a:	06f05063          	blez	a5,80003a8a <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003a2e:	4781                	li	a5,0
    80003a30:	06c05563          	blez	a2,80003a9a <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003a34:	44cc                	lw	a1,12(s1)
    80003a36:	00018717          	auipc	a4,0x18
    80003a3a:	b5a70713          	addi	a4,a4,-1190 # 8001b590 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003a3e:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003a40:	4314                	lw	a3,0(a4)
    80003a42:	04b68c63          	beq	a3,a1,80003a9a <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003a46:	2785                	addiw	a5,a5,1
    80003a48:	0711                	addi	a4,a4,4
    80003a4a:	fef61be3          	bne	a2,a5,80003a40 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003a4e:	0621                	addi	a2,a2,8
    80003a50:	060a                	slli	a2,a2,0x2
    80003a52:	00018797          	auipc	a5,0x18
    80003a56:	b0e78793          	addi	a5,a5,-1266 # 8001b560 <log>
    80003a5a:	97b2                	add	a5,a5,a2
    80003a5c:	44d8                	lw	a4,12(s1)
    80003a5e:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003a60:	8526                	mv	a0,s1
    80003a62:	fffff097          	auipc	ra,0xfffff
    80003a66:	d7a080e7          	jalr	-646(ra) # 800027dc <bpin>
    log.lh.n++;
    80003a6a:	00018717          	auipc	a4,0x18
    80003a6e:	af670713          	addi	a4,a4,-1290 # 8001b560 <log>
    80003a72:	575c                	lw	a5,44(a4)
    80003a74:	2785                	addiw	a5,a5,1
    80003a76:	d75c                	sw	a5,44(a4)
    80003a78:	a82d                	j	80003ab2 <log_write+0xc8>
    panic("too big a transaction");
    80003a7a:	00005517          	auipc	a0,0x5
    80003a7e:	aee50513          	addi	a0,a0,-1298 # 80008568 <etext+0x568>
    80003a82:	00002097          	auipc	ra,0x2
    80003a86:	5a0080e7          	jalr	1440(ra) # 80006022 <panic>
    panic("log_write outside of trans");
    80003a8a:	00005517          	auipc	a0,0x5
    80003a8e:	af650513          	addi	a0,a0,-1290 # 80008580 <etext+0x580>
    80003a92:	00002097          	auipc	ra,0x2
    80003a96:	590080e7          	jalr	1424(ra) # 80006022 <panic>
  log.lh.block[i] = b->blockno;
    80003a9a:	00878693          	addi	a3,a5,8
    80003a9e:	068a                	slli	a3,a3,0x2
    80003aa0:	00018717          	auipc	a4,0x18
    80003aa4:	ac070713          	addi	a4,a4,-1344 # 8001b560 <log>
    80003aa8:	9736                	add	a4,a4,a3
    80003aaa:	44d4                	lw	a3,12(s1)
    80003aac:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003aae:	faf609e3          	beq	a2,a5,80003a60 <log_write+0x76>
  }
  release(&log.lock);
    80003ab2:	00018517          	auipc	a0,0x18
    80003ab6:	aae50513          	addi	a0,a0,-1362 # 8001b560 <log>
    80003aba:	00003097          	auipc	ra,0x3
    80003abe:	b96080e7          	jalr	-1130(ra) # 80006650 <release>
}
    80003ac2:	60e2                	ld	ra,24(sp)
    80003ac4:	6442                	ld	s0,16(sp)
    80003ac6:	64a2                	ld	s1,8(sp)
    80003ac8:	6902                	ld	s2,0(sp)
    80003aca:	6105                	addi	sp,sp,32
    80003acc:	8082                	ret

0000000080003ace <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003ace:	1101                	addi	sp,sp,-32
    80003ad0:	ec06                	sd	ra,24(sp)
    80003ad2:	e822                	sd	s0,16(sp)
    80003ad4:	e426                	sd	s1,8(sp)
    80003ad6:	e04a                	sd	s2,0(sp)
    80003ad8:	1000                	addi	s0,sp,32
    80003ada:	84aa                	mv	s1,a0
    80003adc:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003ade:	00005597          	auipc	a1,0x5
    80003ae2:	ac258593          	addi	a1,a1,-1342 # 800085a0 <etext+0x5a0>
    80003ae6:	0521                	addi	a0,a0,8
    80003ae8:	00003097          	auipc	ra,0x3
    80003aec:	a24080e7          	jalr	-1500(ra) # 8000650c <initlock>
  lk->name = name;
    80003af0:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003af4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003af8:	0204a423          	sw	zero,40(s1)
}
    80003afc:	60e2                	ld	ra,24(sp)
    80003afe:	6442                	ld	s0,16(sp)
    80003b00:	64a2                	ld	s1,8(sp)
    80003b02:	6902                	ld	s2,0(sp)
    80003b04:	6105                	addi	sp,sp,32
    80003b06:	8082                	ret

0000000080003b08 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003b08:	1101                	addi	sp,sp,-32
    80003b0a:	ec06                	sd	ra,24(sp)
    80003b0c:	e822                	sd	s0,16(sp)
    80003b0e:	e426                	sd	s1,8(sp)
    80003b10:	e04a                	sd	s2,0(sp)
    80003b12:	1000                	addi	s0,sp,32
    80003b14:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003b16:	00850913          	addi	s2,a0,8
    80003b1a:	854a                	mv	a0,s2
    80003b1c:	00003097          	auipc	ra,0x3
    80003b20:	a80080e7          	jalr	-1408(ra) # 8000659c <acquire>
  while (lk->locked) {
    80003b24:	409c                	lw	a5,0(s1)
    80003b26:	cb89                	beqz	a5,80003b38 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003b28:	85ca                	mv	a1,s2
    80003b2a:	8526                	mv	a0,s1
    80003b2c:	ffffe097          	auipc	ra,0xffffe
    80003b30:	c2e080e7          	jalr	-978(ra) # 8000175a <sleep>
  while (lk->locked) {
    80003b34:	409c                	lw	a5,0(s1)
    80003b36:	fbed                	bnez	a5,80003b28 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003b38:	4785                	li	a5,1
    80003b3a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003b3c:	ffffd097          	auipc	ra,0xffffd
    80003b40:	4c4080e7          	jalr	1220(ra) # 80001000 <myproc>
    80003b44:	591c                	lw	a5,48(a0)
    80003b46:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003b48:	854a                	mv	a0,s2
    80003b4a:	00003097          	auipc	ra,0x3
    80003b4e:	b06080e7          	jalr	-1274(ra) # 80006650 <release>
}
    80003b52:	60e2                	ld	ra,24(sp)
    80003b54:	6442                	ld	s0,16(sp)
    80003b56:	64a2                	ld	s1,8(sp)
    80003b58:	6902                	ld	s2,0(sp)
    80003b5a:	6105                	addi	sp,sp,32
    80003b5c:	8082                	ret

0000000080003b5e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003b5e:	1101                	addi	sp,sp,-32
    80003b60:	ec06                	sd	ra,24(sp)
    80003b62:	e822                	sd	s0,16(sp)
    80003b64:	e426                	sd	s1,8(sp)
    80003b66:	e04a                	sd	s2,0(sp)
    80003b68:	1000                	addi	s0,sp,32
    80003b6a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003b6c:	00850913          	addi	s2,a0,8
    80003b70:	854a                	mv	a0,s2
    80003b72:	00003097          	auipc	ra,0x3
    80003b76:	a2a080e7          	jalr	-1494(ra) # 8000659c <acquire>
  lk->locked = 0;
    80003b7a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003b7e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003b82:	8526                	mv	a0,s1
    80003b84:	ffffe097          	auipc	ra,0xffffe
    80003b88:	c3a080e7          	jalr	-966(ra) # 800017be <wakeup>
  release(&lk->lk);
    80003b8c:	854a                	mv	a0,s2
    80003b8e:	00003097          	auipc	ra,0x3
    80003b92:	ac2080e7          	jalr	-1342(ra) # 80006650 <release>
}
    80003b96:	60e2                	ld	ra,24(sp)
    80003b98:	6442                	ld	s0,16(sp)
    80003b9a:	64a2                	ld	s1,8(sp)
    80003b9c:	6902                	ld	s2,0(sp)
    80003b9e:	6105                	addi	sp,sp,32
    80003ba0:	8082                	ret

0000000080003ba2 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003ba2:	7179                	addi	sp,sp,-48
    80003ba4:	f406                	sd	ra,40(sp)
    80003ba6:	f022                	sd	s0,32(sp)
    80003ba8:	ec26                	sd	s1,24(sp)
    80003baa:	e84a                	sd	s2,16(sp)
    80003bac:	1800                	addi	s0,sp,48
    80003bae:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003bb0:	00850913          	addi	s2,a0,8
    80003bb4:	854a                	mv	a0,s2
    80003bb6:	00003097          	auipc	ra,0x3
    80003bba:	9e6080e7          	jalr	-1562(ra) # 8000659c <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003bbe:	409c                	lw	a5,0(s1)
    80003bc0:	ef91                	bnez	a5,80003bdc <holdingsleep+0x3a>
    80003bc2:	4481                	li	s1,0
  release(&lk->lk);
    80003bc4:	854a                	mv	a0,s2
    80003bc6:	00003097          	auipc	ra,0x3
    80003bca:	a8a080e7          	jalr	-1398(ra) # 80006650 <release>
  return r;
}
    80003bce:	8526                	mv	a0,s1
    80003bd0:	70a2                	ld	ra,40(sp)
    80003bd2:	7402                	ld	s0,32(sp)
    80003bd4:	64e2                	ld	s1,24(sp)
    80003bd6:	6942                	ld	s2,16(sp)
    80003bd8:	6145                	addi	sp,sp,48
    80003bda:	8082                	ret
    80003bdc:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003bde:	0284a983          	lw	s3,40(s1)
    80003be2:	ffffd097          	auipc	ra,0xffffd
    80003be6:	41e080e7          	jalr	1054(ra) # 80001000 <myproc>
    80003bea:	5904                	lw	s1,48(a0)
    80003bec:	413484b3          	sub	s1,s1,s3
    80003bf0:	0014b493          	seqz	s1,s1
    80003bf4:	69a2                	ld	s3,8(sp)
    80003bf6:	b7f9                	j	80003bc4 <holdingsleep+0x22>

0000000080003bf8 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003bf8:	1141                	addi	sp,sp,-16
    80003bfa:	e406                	sd	ra,8(sp)
    80003bfc:	e022                	sd	s0,0(sp)
    80003bfe:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003c00:	00005597          	auipc	a1,0x5
    80003c04:	9b058593          	addi	a1,a1,-1616 # 800085b0 <etext+0x5b0>
    80003c08:	00018517          	auipc	a0,0x18
    80003c0c:	aa050513          	addi	a0,a0,-1376 # 8001b6a8 <ftable>
    80003c10:	00003097          	auipc	ra,0x3
    80003c14:	8fc080e7          	jalr	-1796(ra) # 8000650c <initlock>
}
    80003c18:	60a2                	ld	ra,8(sp)
    80003c1a:	6402                	ld	s0,0(sp)
    80003c1c:	0141                	addi	sp,sp,16
    80003c1e:	8082                	ret

0000000080003c20 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003c20:	1101                	addi	sp,sp,-32
    80003c22:	ec06                	sd	ra,24(sp)
    80003c24:	e822                	sd	s0,16(sp)
    80003c26:	e426                	sd	s1,8(sp)
    80003c28:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003c2a:	00018517          	auipc	a0,0x18
    80003c2e:	a7e50513          	addi	a0,a0,-1410 # 8001b6a8 <ftable>
    80003c32:	00003097          	auipc	ra,0x3
    80003c36:	96a080e7          	jalr	-1686(ra) # 8000659c <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003c3a:	00018497          	auipc	s1,0x18
    80003c3e:	a8648493          	addi	s1,s1,-1402 # 8001b6c0 <ftable+0x18>
    80003c42:	00019717          	auipc	a4,0x19
    80003c46:	a1e70713          	addi	a4,a4,-1506 # 8001c660 <disk>
    if(f->ref == 0){
    80003c4a:	40dc                	lw	a5,4(s1)
    80003c4c:	cf99                	beqz	a5,80003c6a <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003c4e:	02848493          	addi	s1,s1,40
    80003c52:	fee49ce3          	bne	s1,a4,80003c4a <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003c56:	00018517          	auipc	a0,0x18
    80003c5a:	a5250513          	addi	a0,a0,-1454 # 8001b6a8 <ftable>
    80003c5e:	00003097          	auipc	ra,0x3
    80003c62:	9f2080e7          	jalr	-1550(ra) # 80006650 <release>
  return 0;
    80003c66:	4481                	li	s1,0
    80003c68:	a819                	j	80003c7e <filealloc+0x5e>
      f->ref = 1;
    80003c6a:	4785                	li	a5,1
    80003c6c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003c6e:	00018517          	auipc	a0,0x18
    80003c72:	a3a50513          	addi	a0,a0,-1478 # 8001b6a8 <ftable>
    80003c76:	00003097          	auipc	ra,0x3
    80003c7a:	9da080e7          	jalr	-1574(ra) # 80006650 <release>
}
    80003c7e:	8526                	mv	a0,s1
    80003c80:	60e2                	ld	ra,24(sp)
    80003c82:	6442                	ld	s0,16(sp)
    80003c84:	64a2                	ld	s1,8(sp)
    80003c86:	6105                	addi	sp,sp,32
    80003c88:	8082                	ret

0000000080003c8a <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003c8a:	1101                	addi	sp,sp,-32
    80003c8c:	ec06                	sd	ra,24(sp)
    80003c8e:	e822                	sd	s0,16(sp)
    80003c90:	e426                	sd	s1,8(sp)
    80003c92:	1000                	addi	s0,sp,32
    80003c94:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003c96:	00018517          	auipc	a0,0x18
    80003c9a:	a1250513          	addi	a0,a0,-1518 # 8001b6a8 <ftable>
    80003c9e:	00003097          	auipc	ra,0x3
    80003ca2:	8fe080e7          	jalr	-1794(ra) # 8000659c <acquire>
  if(f->ref < 1)
    80003ca6:	40dc                	lw	a5,4(s1)
    80003ca8:	02f05263          	blez	a5,80003ccc <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003cac:	2785                	addiw	a5,a5,1
    80003cae:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003cb0:	00018517          	auipc	a0,0x18
    80003cb4:	9f850513          	addi	a0,a0,-1544 # 8001b6a8 <ftable>
    80003cb8:	00003097          	auipc	ra,0x3
    80003cbc:	998080e7          	jalr	-1640(ra) # 80006650 <release>
  return f;
}
    80003cc0:	8526                	mv	a0,s1
    80003cc2:	60e2                	ld	ra,24(sp)
    80003cc4:	6442                	ld	s0,16(sp)
    80003cc6:	64a2                	ld	s1,8(sp)
    80003cc8:	6105                	addi	sp,sp,32
    80003cca:	8082                	ret
    panic("filedup");
    80003ccc:	00005517          	auipc	a0,0x5
    80003cd0:	8ec50513          	addi	a0,a0,-1812 # 800085b8 <etext+0x5b8>
    80003cd4:	00002097          	auipc	ra,0x2
    80003cd8:	34e080e7          	jalr	846(ra) # 80006022 <panic>

0000000080003cdc <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003cdc:	7139                	addi	sp,sp,-64
    80003cde:	fc06                	sd	ra,56(sp)
    80003ce0:	f822                	sd	s0,48(sp)
    80003ce2:	f426                	sd	s1,40(sp)
    80003ce4:	0080                	addi	s0,sp,64
    80003ce6:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003ce8:	00018517          	auipc	a0,0x18
    80003cec:	9c050513          	addi	a0,a0,-1600 # 8001b6a8 <ftable>
    80003cf0:	00003097          	auipc	ra,0x3
    80003cf4:	8ac080e7          	jalr	-1876(ra) # 8000659c <acquire>
  if(f->ref < 1)
    80003cf8:	40dc                	lw	a5,4(s1)
    80003cfa:	04f05c63          	blez	a5,80003d52 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80003cfe:	37fd                	addiw	a5,a5,-1
    80003d00:	0007871b          	sext.w	a4,a5
    80003d04:	c0dc                	sw	a5,4(s1)
    80003d06:	06e04263          	bgtz	a4,80003d6a <fileclose+0x8e>
    80003d0a:	f04a                	sd	s2,32(sp)
    80003d0c:	ec4e                	sd	s3,24(sp)
    80003d0e:	e852                	sd	s4,16(sp)
    80003d10:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003d12:	0004a903          	lw	s2,0(s1)
    80003d16:	0094ca83          	lbu	s5,9(s1)
    80003d1a:	0104ba03          	ld	s4,16(s1)
    80003d1e:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003d22:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003d26:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003d2a:	00018517          	auipc	a0,0x18
    80003d2e:	97e50513          	addi	a0,a0,-1666 # 8001b6a8 <ftable>
    80003d32:	00003097          	auipc	ra,0x3
    80003d36:	91e080e7          	jalr	-1762(ra) # 80006650 <release>

  if(ff.type == FD_PIPE){
    80003d3a:	4785                	li	a5,1
    80003d3c:	04f90463          	beq	s2,a5,80003d84 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003d40:	3979                	addiw	s2,s2,-2
    80003d42:	4785                	li	a5,1
    80003d44:	0527fb63          	bgeu	a5,s2,80003d9a <fileclose+0xbe>
    80003d48:	7902                	ld	s2,32(sp)
    80003d4a:	69e2                	ld	s3,24(sp)
    80003d4c:	6a42                	ld	s4,16(sp)
    80003d4e:	6aa2                	ld	s5,8(sp)
    80003d50:	a02d                	j	80003d7a <fileclose+0x9e>
    80003d52:	f04a                	sd	s2,32(sp)
    80003d54:	ec4e                	sd	s3,24(sp)
    80003d56:	e852                	sd	s4,16(sp)
    80003d58:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003d5a:	00005517          	auipc	a0,0x5
    80003d5e:	86650513          	addi	a0,a0,-1946 # 800085c0 <etext+0x5c0>
    80003d62:	00002097          	auipc	ra,0x2
    80003d66:	2c0080e7          	jalr	704(ra) # 80006022 <panic>
    release(&ftable.lock);
    80003d6a:	00018517          	auipc	a0,0x18
    80003d6e:	93e50513          	addi	a0,a0,-1730 # 8001b6a8 <ftable>
    80003d72:	00003097          	auipc	ra,0x3
    80003d76:	8de080e7          	jalr	-1826(ra) # 80006650 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003d7a:	70e2                	ld	ra,56(sp)
    80003d7c:	7442                	ld	s0,48(sp)
    80003d7e:	74a2                	ld	s1,40(sp)
    80003d80:	6121                	addi	sp,sp,64
    80003d82:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003d84:	85d6                	mv	a1,s5
    80003d86:	8552                	mv	a0,s4
    80003d88:	00000097          	auipc	ra,0x0
    80003d8c:	3a2080e7          	jalr	930(ra) # 8000412a <pipeclose>
    80003d90:	7902                	ld	s2,32(sp)
    80003d92:	69e2                	ld	s3,24(sp)
    80003d94:	6a42                	ld	s4,16(sp)
    80003d96:	6aa2                	ld	s5,8(sp)
    80003d98:	b7cd                	j	80003d7a <fileclose+0x9e>
    begin_op();
    80003d9a:	00000097          	auipc	ra,0x0
    80003d9e:	a78080e7          	jalr	-1416(ra) # 80003812 <begin_op>
    iput(ff.ip);
    80003da2:	854e                	mv	a0,s3
    80003da4:	fffff097          	auipc	ra,0xfffff
    80003da8:	25e080e7          	jalr	606(ra) # 80003002 <iput>
    end_op();
    80003dac:	00000097          	auipc	ra,0x0
    80003db0:	ae0080e7          	jalr	-1312(ra) # 8000388c <end_op>
    80003db4:	7902                	ld	s2,32(sp)
    80003db6:	69e2                	ld	s3,24(sp)
    80003db8:	6a42                	ld	s4,16(sp)
    80003dba:	6aa2                	ld	s5,8(sp)
    80003dbc:	bf7d                	j	80003d7a <fileclose+0x9e>

0000000080003dbe <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003dbe:	715d                	addi	sp,sp,-80
    80003dc0:	e486                	sd	ra,72(sp)
    80003dc2:	e0a2                	sd	s0,64(sp)
    80003dc4:	fc26                	sd	s1,56(sp)
    80003dc6:	f44e                	sd	s3,40(sp)
    80003dc8:	0880                	addi	s0,sp,80
    80003dca:	84aa                	mv	s1,a0
    80003dcc:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003dce:	ffffd097          	auipc	ra,0xffffd
    80003dd2:	232080e7          	jalr	562(ra) # 80001000 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003dd6:	409c                	lw	a5,0(s1)
    80003dd8:	37f9                	addiw	a5,a5,-2
    80003dda:	4705                	li	a4,1
    80003ddc:	04f76863          	bltu	a4,a5,80003e2c <filestat+0x6e>
    80003de0:	f84a                	sd	s2,48(sp)
    80003de2:	892a                	mv	s2,a0
    ilock(f->ip);
    80003de4:	6c88                	ld	a0,24(s1)
    80003de6:	fffff097          	auipc	ra,0xfffff
    80003dea:	05e080e7          	jalr	94(ra) # 80002e44 <ilock>
    stati(f->ip, &st);
    80003dee:	fb840593          	addi	a1,s0,-72
    80003df2:	6c88                	ld	a0,24(s1)
    80003df4:	fffff097          	auipc	ra,0xfffff
    80003df8:	2de080e7          	jalr	734(ra) # 800030d2 <stati>
    iunlock(f->ip);
    80003dfc:	6c88                	ld	a0,24(s1)
    80003dfe:	fffff097          	auipc	ra,0xfffff
    80003e02:	10c080e7          	jalr	268(ra) # 80002f0a <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003e06:	46e1                	li	a3,24
    80003e08:	fb840613          	addi	a2,s0,-72
    80003e0c:	85ce                	mv	a1,s3
    80003e0e:	05093503          	ld	a0,80(s2)
    80003e12:	ffffd097          	auipc	ra,0xffffd
    80003e16:	d3a080e7          	jalr	-710(ra) # 80000b4c <copyout>
    80003e1a:	41f5551b          	sraiw	a0,a0,0x1f
    80003e1e:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003e20:	60a6                	ld	ra,72(sp)
    80003e22:	6406                	ld	s0,64(sp)
    80003e24:	74e2                	ld	s1,56(sp)
    80003e26:	79a2                	ld	s3,40(sp)
    80003e28:	6161                	addi	sp,sp,80
    80003e2a:	8082                	ret
  return -1;
    80003e2c:	557d                	li	a0,-1
    80003e2e:	bfcd                	j	80003e20 <filestat+0x62>

0000000080003e30 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003e30:	7179                	addi	sp,sp,-48
    80003e32:	f406                	sd	ra,40(sp)
    80003e34:	f022                	sd	s0,32(sp)
    80003e36:	e84a                	sd	s2,16(sp)
    80003e38:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003e3a:	00854783          	lbu	a5,8(a0)
    80003e3e:	cbc5                	beqz	a5,80003eee <fileread+0xbe>
    80003e40:	ec26                	sd	s1,24(sp)
    80003e42:	e44e                	sd	s3,8(sp)
    80003e44:	84aa                	mv	s1,a0
    80003e46:	89ae                	mv	s3,a1
    80003e48:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e4a:	411c                	lw	a5,0(a0)
    80003e4c:	4705                	li	a4,1
    80003e4e:	04e78963          	beq	a5,a4,80003ea0 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e52:	470d                	li	a4,3
    80003e54:	04e78f63          	beq	a5,a4,80003eb2 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e58:	4709                	li	a4,2
    80003e5a:	08e79263          	bne	a5,a4,80003ede <fileread+0xae>
    ilock(f->ip);
    80003e5e:	6d08                	ld	a0,24(a0)
    80003e60:	fffff097          	auipc	ra,0xfffff
    80003e64:	fe4080e7          	jalr	-28(ra) # 80002e44 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003e68:	874a                	mv	a4,s2
    80003e6a:	5094                	lw	a3,32(s1)
    80003e6c:	864e                	mv	a2,s3
    80003e6e:	4585                	li	a1,1
    80003e70:	6c88                	ld	a0,24(s1)
    80003e72:	fffff097          	auipc	ra,0xfffff
    80003e76:	28a080e7          	jalr	650(ra) # 800030fc <readi>
    80003e7a:	892a                	mv	s2,a0
    80003e7c:	00a05563          	blez	a0,80003e86 <fileread+0x56>
      f->off += r;
    80003e80:	509c                	lw	a5,32(s1)
    80003e82:	9fa9                	addw	a5,a5,a0
    80003e84:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003e86:	6c88                	ld	a0,24(s1)
    80003e88:	fffff097          	auipc	ra,0xfffff
    80003e8c:	082080e7          	jalr	130(ra) # 80002f0a <iunlock>
    80003e90:	64e2                	ld	s1,24(sp)
    80003e92:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003e94:	854a                	mv	a0,s2
    80003e96:	70a2                	ld	ra,40(sp)
    80003e98:	7402                	ld	s0,32(sp)
    80003e9a:	6942                	ld	s2,16(sp)
    80003e9c:	6145                	addi	sp,sp,48
    80003e9e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003ea0:	6908                	ld	a0,16(a0)
    80003ea2:	00000097          	auipc	ra,0x0
    80003ea6:	400080e7          	jalr	1024(ra) # 800042a2 <piperead>
    80003eaa:	892a                	mv	s2,a0
    80003eac:	64e2                	ld	s1,24(sp)
    80003eae:	69a2                	ld	s3,8(sp)
    80003eb0:	b7d5                	j	80003e94 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003eb2:	02451783          	lh	a5,36(a0)
    80003eb6:	03079693          	slli	a3,a5,0x30
    80003eba:	92c1                	srli	a3,a3,0x30
    80003ebc:	4725                	li	a4,9
    80003ebe:	02d76a63          	bltu	a4,a3,80003ef2 <fileread+0xc2>
    80003ec2:	0792                	slli	a5,a5,0x4
    80003ec4:	00017717          	auipc	a4,0x17
    80003ec8:	74470713          	addi	a4,a4,1860 # 8001b608 <devsw>
    80003ecc:	97ba                	add	a5,a5,a4
    80003ece:	639c                	ld	a5,0(a5)
    80003ed0:	c78d                	beqz	a5,80003efa <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003ed2:	4505                	li	a0,1
    80003ed4:	9782                	jalr	a5
    80003ed6:	892a                	mv	s2,a0
    80003ed8:	64e2                	ld	s1,24(sp)
    80003eda:	69a2                	ld	s3,8(sp)
    80003edc:	bf65                	j	80003e94 <fileread+0x64>
    panic("fileread");
    80003ede:	00004517          	auipc	a0,0x4
    80003ee2:	6f250513          	addi	a0,a0,1778 # 800085d0 <etext+0x5d0>
    80003ee6:	00002097          	auipc	ra,0x2
    80003eea:	13c080e7          	jalr	316(ra) # 80006022 <panic>
    return -1;
    80003eee:	597d                	li	s2,-1
    80003ef0:	b755                	j	80003e94 <fileread+0x64>
      return -1;
    80003ef2:	597d                	li	s2,-1
    80003ef4:	64e2                	ld	s1,24(sp)
    80003ef6:	69a2                	ld	s3,8(sp)
    80003ef8:	bf71                	j	80003e94 <fileread+0x64>
    80003efa:	597d                	li	s2,-1
    80003efc:	64e2                	ld	s1,24(sp)
    80003efe:	69a2                	ld	s3,8(sp)
    80003f00:	bf51                	j	80003e94 <fileread+0x64>

0000000080003f02 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003f02:	00954783          	lbu	a5,9(a0)
    80003f06:	12078963          	beqz	a5,80004038 <filewrite+0x136>
{
    80003f0a:	715d                	addi	sp,sp,-80
    80003f0c:	e486                	sd	ra,72(sp)
    80003f0e:	e0a2                	sd	s0,64(sp)
    80003f10:	f84a                	sd	s2,48(sp)
    80003f12:	f052                	sd	s4,32(sp)
    80003f14:	e85a                	sd	s6,16(sp)
    80003f16:	0880                	addi	s0,sp,80
    80003f18:	892a                	mv	s2,a0
    80003f1a:	8b2e                	mv	s6,a1
    80003f1c:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003f1e:	411c                	lw	a5,0(a0)
    80003f20:	4705                	li	a4,1
    80003f22:	02e78763          	beq	a5,a4,80003f50 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003f26:	470d                	li	a4,3
    80003f28:	02e78a63          	beq	a5,a4,80003f5c <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003f2c:	4709                	li	a4,2
    80003f2e:	0ee79863          	bne	a5,a4,8000401e <filewrite+0x11c>
    80003f32:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003f34:	0cc05463          	blez	a2,80003ffc <filewrite+0xfa>
    80003f38:	fc26                	sd	s1,56(sp)
    80003f3a:	ec56                	sd	s5,24(sp)
    80003f3c:	e45e                	sd	s7,8(sp)
    80003f3e:	e062                	sd	s8,0(sp)
    int i = 0;
    80003f40:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003f42:	6b85                	lui	s7,0x1
    80003f44:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003f48:	6c05                	lui	s8,0x1
    80003f4a:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003f4e:	a851                	j	80003fe2 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003f50:	6908                	ld	a0,16(a0)
    80003f52:	00000097          	auipc	ra,0x0
    80003f56:	248080e7          	jalr	584(ra) # 8000419a <pipewrite>
    80003f5a:	a85d                	j	80004010 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003f5c:	02451783          	lh	a5,36(a0)
    80003f60:	03079693          	slli	a3,a5,0x30
    80003f64:	92c1                	srli	a3,a3,0x30
    80003f66:	4725                	li	a4,9
    80003f68:	0cd76a63          	bltu	a4,a3,8000403c <filewrite+0x13a>
    80003f6c:	0792                	slli	a5,a5,0x4
    80003f6e:	00017717          	auipc	a4,0x17
    80003f72:	69a70713          	addi	a4,a4,1690 # 8001b608 <devsw>
    80003f76:	97ba                	add	a5,a5,a4
    80003f78:	679c                	ld	a5,8(a5)
    80003f7a:	c3f9                	beqz	a5,80004040 <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80003f7c:	4505                	li	a0,1
    80003f7e:	9782                	jalr	a5
    80003f80:	a841                	j	80004010 <filewrite+0x10e>
      if(n1 > max)
    80003f82:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003f86:	00000097          	auipc	ra,0x0
    80003f8a:	88c080e7          	jalr	-1908(ra) # 80003812 <begin_op>
      ilock(f->ip);
    80003f8e:	01893503          	ld	a0,24(s2)
    80003f92:	fffff097          	auipc	ra,0xfffff
    80003f96:	eb2080e7          	jalr	-334(ra) # 80002e44 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003f9a:	8756                	mv	a4,s5
    80003f9c:	02092683          	lw	a3,32(s2)
    80003fa0:	01698633          	add	a2,s3,s6
    80003fa4:	4585                	li	a1,1
    80003fa6:	01893503          	ld	a0,24(s2)
    80003faa:	fffff097          	auipc	ra,0xfffff
    80003fae:	262080e7          	jalr	610(ra) # 8000320c <writei>
    80003fb2:	84aa                	mv	s1,a0
    80003fb4:	00a05763          	blez	a0,80003fc2 <filewrite+0xc0>
        f->off += r;
    80003fb8:	02092783          	lw	a5,32(s2)
    80003fbc:	9fa9                	addw	a5,a5,a0
    80003fbe:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003fc2:	01893503          	ld	a0,24(s2)
    80003fc6:	fffff097          	auipc	ra,0xfffff
    80003fca:	f44080e7          	jalr	-188(ra) # 80002f0a <iunlock>
      end_op();
    80003fce:	00000097          	auipc	ra,0x0
    80003fd2:	8be080e7          	jalr	-1858(ra) # 8000388c <end_op>

      if(r != n1){
    80003fd6:	029a9563          	bne	s5,s1,80004000 <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80003fda:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003fde:	0149da63          	bge	s3,s4,80003ff2 <filewrite+0xf0>
      int n1 = n - i;
    80003fe2:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003fe6:	0004879b          	sext.w	a5,s1
    80003fea:	f8fbdce3          	bge	s7,a5,80003f82 <filewrite+0x80>
    80003fee:	84e2                	mv	s1,s8
    80003ff0:	bf49                	j	80003f82 <filewrite+0x80>
    80003ff2:	74e2                	ld	s1,56(sp)
    80003ff4:	6ae2                	ld	s5,24(sp)
    80003ff6:	6ba2                	ld	s7,8(sp)
    80003ff8:	6c02                	ld	s8,0(sp)
    80003ffa:	a039                	j	80004008 <filewrite+0x106>
    int i = 0;
    80003ffc:	4981                	li	s3,0
    80003ffe:	a029                	j	80004008 <filewrite+0x106>
    80004000:	74e2                	ld	s1,56(sp)
    80004002:	6ae2                	ld	s5,24(sp)
    80004004:	6ba2                	ld	s7,8(sp)
    80004006:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80004008:	033a1e63          	bne	s4,s3,80004044 <filewrite+0x142>
    8000400c:	8552                	mv	a0,s4
    8000400e:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004010:	60a6                	ld	ra,72(sp)
    80004012:	6406                	ld	s0,64(sp)
    80004014:	7942                	ld	s2,48(sp)
    80004016:	7a02                	ld	s4,32(sp)
    80004018:	6b42                	ld	s6,16(sp)
    8000401a:	6161                	addi	sp,sp,80
    8000401c:	8082                	ret
    8000401e:	fc26                	sd	s1,56(sp)
    80004020:	f44e                	sd	s3,40(sp)
    80004022:	ec56                	sd	s5,24(sp)
    80004024:	e45e                	sd	s7,8(sp)
    80004026:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80004028:	00004517          	auipc	a0,0x4
    8000402c:	5b850513          	addi	a0,a0,1464 # 800085e0 <etext+0x5e0>
    80004030:	00002097          	auipc	ra,0x2
    80004034:	ff2080e7          	jalr	-14(ra) # 80006022 <panic>
    return -1;
    80004038:	557d                	li	a0,-1
}
    8000403a:	8082                	ret
      return -1;
    8000403c:	557d                	li	a0,-1
    8000403e:	bfc9                	j	80004010 <filewrite+0x10e>
    80004040:	557d                	li	a0,-1
    80004042:	b7f9                	j	80004010 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80004044:	557d                	li	a0,-1
    80004046:	79a2                	ld	s3,40(sp)
    80004048:	b7e1                	j	80004010 <filewrite+0x10e>

000000008000404a <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000404a:	7179                	addi	sp,sp,-48
    8000404c:	f406                	sd	ra,40(sp)
    8000404e:	f022                	sd	s0,32(sp)
    80004050:	ec26                	sd	s1,24(sp)
    80004052:	e052                	sd	s4,0(sp)
    80004054:	1800                	addi	s0,sp,48
    80004056:	84aa                	mv	s1,a0
    80004058:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000405a:	0005b023          	sd	zero,0(a1)
    8000405e:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004062:	00000097          	auipc	ra,0x0
    80004066:	bbe080e7          	jalr	-1090(ra) # 80003c20 <filealloc>
    8000406a:	e088                	sd	a0,0(s1)
    8000406c:	cd49                	beqz	a0,80004106 <pipealloc+0xbc>
    8000406e:	00000097          	auipc	ra,0x0
    80004072:	bb2080e7          	jalr	-1102(ra) # 80003c20 <filealloc>
    80004076:	00aa3023          	sd	a0,0(s4)
    8000407a:	c141                	beqz	a0,800040fa <pipealloc+0xb0>
    8000407c:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000407e:	ffffc097          	auipc	ra,0xffffc
    80004082:	09c080e7          	jalr	156(ra) # 8000011a <kalloc>
    80004086:	892a                	mv	s2,a0
    80004088:	c13d                	beqz	a0,800040ee <pipealloc+0xa4>
    8000408a:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    8000408c:	4985                	li	s3,1
    8000408e:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004092:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004096:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000409a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000409e:	00004597          	auipc	a1,0x4
    800040a2:	55258593          	addi	a1,a1,1362 # 800085f0 <etext+0x5f0>
    800040a6:	00002097          	auipc	ra,0x2
    800040aa:	466080e7          	jalr	1126(ra) # 8000650c <initlock>
  (*f0)->type = FD_PIPE;
    800040ae:	609c                	ld	a5,0(s1)
    800040b0:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800040b4:	609c                	ld	a5,0(s1)
    800040b6:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800040ba:	609c                	ld	a5,0(s1)
    800040bc:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800040c0:	609c                	ld	a5,0(s1)
    800040c2:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800040c6:	000a3783          	ld	a5,0(s4)
    800040ca:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800040ce:	000a3783          	ld	a5,0(s4)
    800040d2:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800040d6:	000a3783          	ld	a5,0(s4)
    800040da:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800040de:	000a3783          	ld	a5,0(s4)
    800040e2:	0127b823          	sd	s2,16(a5)
  return 0;
    800040e6:	4501                	li	a0,0
    800040e8:	6942                	ld	s2,16(sp)
    800040ea:	69a2                	ld	s3,8(sp)
    800040ec:	a03d                	j	8000411a <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800040ee:	6088                	ld	a0,0(s1)
    800040f0:	c119                	beqz	a0,800040f6 <pipealloc+0xac>
    800040f2:	6942                	ld	s2,16(sp)
    800040f4:	a029                	j	800040fe <pipealloc+0xb4>
    800040f6:	6942                	ld	s2,16(sp)
    800040f8:	a039                	j	80004106 <pipealloc+0xbc>
    800040fa:	6088                	ld	a0,0(s1)
    800040fc:	c50d                	beqz	a0,80004126 <pipealloc+0xdc>
    fileclose(*f0);
    800040fe:	00000097          	auipc	ra,0x0
    80004102:	bde080e7          	jalr	-1058(ra) # 80003cdc <fileclose>
  if(*f1)
    80004106:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000410a:	557d                	li	a0,-1
  if(*f1)
    8000410c:	c799                	beqz	a5,8000411a <pipealloc+0xd0>
    fileclose(*f1);
    8000410e:	853e                	mv	a0,a5
    80004110:	00000097          	auipc	ra,0x0
    80004114:	bcc080e7          	jalr	-1076(ra) # 80003cdc <fileclose>
  return -1;
    80004118:	557d                	li	a0,-1
}
    8000411a:	70a2                	ld	ra,40(sp)
    8000411c:	7402                	ld	s0,32(sp)
    8000411e:	64e2                	ld	s1,24(sp)
    80004120:	6a02                	ld	s4,0(sp)
    80004122:	6145                	addi	sp,sp,48
    80004124:	8082                	ret
  return -1;
    80004126:	557d                	li	a0,-1
    80004128:	bfcd                	j	8000411a <pipealloc+0xd0>

000000008000412a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000412a:	1101                	addi	sp,sp,-32
    8000412c:	ec06                	sd	ra,24(sp)
    8000412e:	e822                	sd	s0,16(sp)
    80004130:	e426                	sd	s1,8(sp)
    80004132:	e04a                	sd	s2,0(sp)
    80004134:	1000                	addi	s0,sp,32
    80004136:	84aa                	mv	s1,a0
    80004138:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000413a:	00002097          	auipc	ra,0x2
    8000413e:	462080e7          	jalr	1122(ra) # 8000659c <acquire>
  if(writable){
    80004142:	02090d63          	beqz	s2,8000417c <pipeclose+0x52>
    pi->writeopen = 0;
    80004146:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    8000414a:	21848513          	addi	a0,s1,536
    8000414e:	ffffd097          	auipc	ra,0xffffd
    80004152:	670080e7          	jalr	1648(ra) # 800017be <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004156:	2204b783          	ld	a5,544(s1)
    8000415a:	eb95                	bnez	a5,8000418e <pipeclose+0x64>
    release(&pi->lock);
    8000415c:	8526                	mv	a0,s1
    8000415e:	00002097          	auipc	ra,0x2
    80004162:	4f2080e7          	jalr	1266(ra) # 80006650 <release>
    kfree((char*)pi);
    80004166:	8526                	mv	a0,s1
    80004168:	ffffc097          	auipc	ra,0xffffc
    8000416c:	eb4080e7          	jalr	-332(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80004170:	60e2                	ld	ra,24(sp)
    80004172:	6442                	ld	s0,16(sp)
    80004174:	64a2                	ld	s1,8(sp)
    80004176:	6902                	ld	s2,0(sp)
    80004178:	6105                	addi	sp,sp,32
    8000417a:	8082                	ret
    pi->readopen = 0;
    8000417c:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004180:	21c48513          	addi	a0,s1,540
    80004184:	ffffd097          	auipc	ra,0xffffd
    80004188:	63a080e7          	jalr	1594(ra) # 800017be <wakeup>
    8000418c:	b7e9                	j	80004156 <pipeclose+0x2c>
    release(&pi->lock);
    8000418e:	8526                	mv	a0,s1
    80004190:	00002097          	auipc	ra,0x2
    80004194:	4c0080e7          	jalr	1216(ra) # 80006650 <release>
}
    80004198:	bfe1                	j	80004170 <pipeclose+0x46>

000000008000419a <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000419a:	711d                	addi	sp,sp,-96
    8000419c:	ec86                	sd	ra,88(sp)
    8000419e:	e8a2                	sd	s0,80(sp)
    800041a0:	e4a6                	sd	s1,72(sp)
    800041a2:	e0ca                	sd	s2,64(sp)
    800041a4:	fc4e                	sd	s3,56(sp)
    800041a6:	f852                	sd	s4,48(sp)
    800041a8:	f456                	sd	s5,40(sp)
    800041aa:	1080                	addi	s0,sp,96
    800041ac:	84aa                	mv	s1,a0
    800041ae:	8aae                	mv	s5,a1
    800041b0:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800041b2:	ffffd097          	auipc	ra,0xffffd
    800041b6:	e4e080e7          	jalr	-434(ra) # 80001000 <myproc>
    800041ba:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800041bc:	8526                	mv	a0,s1
    800041be:	00002097          	auipc	ra,0x2
    800041c2:	3de080e7          	jalr	990(ra) # 8000659c <acquire>
  while(i < n){
    800041c6:	0d405863          	blez	s4,80004296 <pipewrite+0xfc>
    800041ca:	f05a                	sd	s6,32(sp)
    800041cc:	ec5e                	sd	s7,24(sp)
    800041ce:	e862                	sd	s8,16(sp)
  int i = 0;
    800041d0:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800041d2:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800041d4:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800041d8:	21c48b93          	addi	s7,s1,540
    800041dc:	a089                	j	8000421e <pipewrite+0x84>
      release(&pi->lock);
    800041de:	8526                	mv	a0,s1
    800041e0:	00002097          	auipc	ra,0x2
    800041e4:	470080e7          	jalr	1136(ra) # 80006650 <release>
      return -1;
    800041e8:	597d                	li	s2,-1
    800041ea:	7b02                	ld	s6,32(sp)
    800041ec:	6be2                	ld	s7,24(sp)
    800041ee:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800041f0:	854a                	mv	a0,s2
    800041f2:	60e6                	ld	ra,88(sp)
    800041f4:	6446                	ld	s0,80(sp)
    800041f6:	64a6                	ld	s1,72(sp)
    800041f8:	6906                	ld	s2,64(sp)
    800041fa:	79e2                	ld	s3,56(sp)
    800041fc:	7a42                	ld	s4,48(sp)
    800041fe:	7aa2                	ld	s5,40(sp)
    80004200:	6125                	addi	sp,sp,96
    80004202:	8082                	ret
      wakeup(&pi->nread);
    80004204:	8562                	mv	a0,s8
    80004206:	ffffd097          	auipc	ra,0xffffd
    8000420a:	5b8080e7          	jalr	1464(ra) # 800017be <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000420e:	85a6                	mv	a1,s1
    80004210:	855e                	mv	a0,s7
    80004212:	ffffd097          	auipc	ra,0xffffd
    80004216:	548080e7          	jalr	1352(ra) # 8000175a <sleep>
  while(i < n){
    8000421a:	05495f63          	bge	s2,s4,80004278 <pipewrite+0xde>
    if(pi->readopen == 0 || killed(pr)){
    8000421e:	2204a783          	lw	a5,544(s1)
    80004222:	dfd5                	beqz	a5,800041de <pipewrite+0x44>
    80004224:	854e                	mv	a0,s3
    80004226:	ffffd097          	auipc	ra,0xffffd
    8000422a:	7dc080e7          	jalr	2012(ra) # 80001a02 <killed>
    8000422e:	f945                	bnez	a0,800041de <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004230:	2184a783          	lw	a5,536(s1)
    80004234:	21c4a703          	lw	a4,540(s1)
    80004238:	2007879b          	addiw	a5,a5,512
    8000423c:	fcf704e3          	beq	a4,a5,80004204 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004240:	4685                	li	a3,1
    80004242:	01590633          	add	a2,s2,s5
    80004246:	faf40593          	addi	a1,s0,-81
    8000424a:	0509b503          	ld	a0,80(s3)
    8000424e:	ffffd097          	auipc	ra,0xffffd
    80004252:	9dc080e7          	jalr	-1572(ra) # 80000c2a <copyin>
    80004256:	05650263          	beq	a0,s6,8000429a <pipewrite+0x100>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000425a:	21c4a783          	lw	a5,540(s1)
    8000425e:	0017871b          	addiw	a4,a5,1
    80004262:	20e4ae23          	sw	a4,540(s1)
    80004266:	1ff7f793          	andi	a5,a5,511
    8000426a:	97a6                	add	a5,a5,s1
    8000426c:	faf44703          	lbu	a4,-81(s0)
    80004270:	00e78c23          	sb	a4,24(a5)
      i++;
    80004274:	2905                	addiw	s2,s2,1
    80004276:	b755                	j	8000421a <pipewrite+0x80>
    80004278:	7b02                	ld	s6,32(sp)
    8000427a:	6be2                	ld	s7,24(sp)
    8000427c:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    8000427e:	21848513          	addi	a0,s1,536
    80004282:	ffffd097          	auipc	ra,0xffffd
    80004286:	53c080e7          	jalr	1340(ra) # 800017be <wakeup>
  release(&pi->lock);
    8000428a:	8526                	mv	a0,s1
    8000428c:	00002097          	auipc	ra,0x2
    80004290:	3c4080e7          	jalr	964(ra) # 80006650 <release>
  return i;
    80004294:	bfb1                	j	800041f0 <pipewrite+0x56>
  int i = 0;
    80004296:	4901                	li	s2,0
    80004298:	b7dd                	j	8000427e <pipewrite+0xe4>
    8000429a:	7b02                	ld	s6,32(sp)
    8000429c:	6be2                	ld	s7,24(sp)
    8000429e:	6c42                	ld	s8,16(sp)
    800042a0:	bff9                	j	8000427e <pipewrite+0xe4>

00000000800042a2 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800042a2:	715d                	addi	sp,sp,-80
    800042a4:	e486                	sd	ra,72(sp)
    800042a6:	e0a2                	sd	s0,64(sp)
    800042a8:	fc26                	sd	s1,56(sp)
    800042aa:	f84a                	sd	s2,48(sp)
    800042ac:	f44e                	sd	s3,40(sp)
    800042ae:	f052                	sd	s4,32(sp)
    800042b0:	ec56                	sd	s5,24(sp)
    800042b2:	0880                	addi	s0,sp,80
    800042b4:	84aa                	mv	s1,a0
    800042b6:	892e                	mv	s2,a1
    800042b8:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800042ba:	ffffd097          	auipc	ra,0xffffd
    800042be:	d46080e7          	jalr	-698(ra) # 80001000 <myproc>
    800042c2:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800042c4:	8526                	mv	a0,s1
    800042c6:	00002097          	auipc	ra,0x2
    800042ca:	2d6080e7          	jalr	726(ra) # 8000659c <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800042ce:	2184a703          	lw	a4,536(s1)
    800042d2:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800042d6:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800042da:	02f71963          	bne	a4,a5,8000430c <piperead+0x6a>
    800042de:	2244a783          	lw	a5,548(s1)
    800042e2:	cf95                	beqz	a5,8000431e <piperead+0x7c>
    if(killed(pr)){
    800042e4:	8552                	mv	a0,s4
    800042e6:	ffffd097          	auipc	ra,0xffffd
    800042ea:	71c080e7          	jalr	1820(ra) # 80001a02 <killed>
    800042ee:	e10d                	bnez	a0,80004310 <piperead+0x6e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800042f0:	85a6                	mv	a1,s1
    800042f2:	854e                	mv	a0,s3
    800042f4:	ffffd097          	auipc	ra,0xffffd
    800042f8:	466080e7          	jalr	1126(ra) # 8000175a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800042fc:	2184a703          	lw	a4,536(s1)
    80004300:	21c4a783          	lw	a5,540(s1)
    80004304:	fcf70de3          	beq	a4,a5,800042de <piperead+0x3c>
    80004308:	e85a                	sd	s6,16(sp)
    8000430a:	a819                	j	80004320 <piperead+0x7e>
    8000430c:	e85a                	sd	s6,16(sp)
    8000430e:	a809                	j	80004320 <piperead+0x7e>
      release(&pi->lock);
    80004310:	8526                	mv	a0,s1
    80004312:	00002097          	auipc	ra,0x2
    80004316:	33e080e7          	jalr	830(ra) # 80006650 <release>
      return -1;
    8000431a:	59fd                	li	s3,-1
    8000431c:	a0a5                	j	80004384 <piperead+0xe2>
    8000431e:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004320:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004322:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004324:	05505463          	blez	s5,8000436c <piperead+0xca>
    if(pi->nread == pi->nwrite)
    80004328:	2184a783          	lw	a5,536(s1)
    8000432c:	21c4a703          	lw	a4,540(s1)
    80004330:	02f70e63          	beq	a4,a5,8000436c <piperead+0xca>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004334:	0017871b          	addiw	a4,a5,1
    80004338:	20e4ac23          	sw	a4,536(s1)
    8000433c:	1ff7f793          	andi	a5,a5,511
    80004340:	97a6                	add	a5,a5,s1
    80004342:	0187c783          	lbu	a5,24(a5)
    80004346:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000434a:	4685                	li	a3,1
    8000434c:	fbf40613          	addi	a2,s0,-65
    80004350:	85ca                	mv	a1,s2
    80004352:	050a3503          	ld	a0,80(s4)
    80004356:	ffffc097          	auipc	ra,0xffffc
    8000435a:	7f6080e7          	jalr	2038(ra) # 80000b4c <copyout>
    8000435e:	01650763          	beq	a0,s6,8000436c <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004362:	2985                	addiw	s3,s3,1
    80004364:	0905                	addi	s2,s2,1
    80004366:	fd3a91e3          	bne	s5,s3,80004328 <piperead+0x86>
    8000436a:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000436c:	21c48513          	addi	a0,s1,540
    80004370:	ffffd097          	auipc	ra,0xffffd
    80004374:	44e080e7          	jalr	1102(ra) # 800017be <wakeup>
  release(&pi->lock);
    80004378:	8526                	mv	a0,s1
    8000437a:	00002097          	auipc	ra,0x2
    8000437e:	2d6080e7          	jalr	726(ra) # 80006650 <release>
    80004382:	6b42                	ld	s6,16(sp)
  return i;
}
    80004384:	854e                	mv	a0,s3
    80004386:	60a6                	ld	ra,72(sp)
    80004388:	6406                	ld	s0,64(sp)
    8000438a:	74e2                	ld	s1,56(sp)
    8000438c:	7942                	ld	s2,48(sp)
    8000438e:	79a2                	ld	s3,40(sp)
    80004390:	7a02                	ld	s4,32(sp)
    80004392:	6ae2                	ld	s5,24(sp)
    80004394:	6161                	addi	sp,sp,80
    80004396:	8082                	ret

0000000080004398 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004398:	1141                	addi	sp,sp,-16
    8000439a:	e422                	sd	s0,8(sp)
    8000439c:	0800                	addi	s0,sp,16
    8000439e:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800043a0:	8905                	andi	a0,a0,1
    800043a2:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800043a4:	8b89                	andi	a5,a5,2
    800043a6:	c399                	beqz	a5,800043ac <flags2perm+0x14>
      perm |= PTE_W;
    800043a8:	00456513          	ori	a0,a0,4
    return perm;
}
    800043ac:	6422                	ld	s0,8(sp)
    800043ae:	0141                	addi	sp,sp,16
    800043b0:	8082                	ret

00000000800043b2 <exec>:

int
exec(char *path, char **argv)
{
    800043b2:	df010113          	addi	sp,sp,-528
    800043b6:	20113423          	sd	ra,520(sp)
    800043ba:	20813023          	sd	s0,512(sp)
    800043be:	ffa6                	sd	s1,504(sp)
    800043c0:	fbca                	sd	s2,496(sp)
    800043c2:	0c00                	addi	s0,sp,528
    800043c4:	892a                	mv	s2,a0
    800043c6:	dea43c23          	sd	a0,-520(s0)
    800043ca:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800043ce:	ffffd097          	auipc	ra,0xffffd
    800043d2:	c32080e7          	jalr	-974(ra) # 80001000 <myproc>
    800043d6:	84aa                	mv	s1,a0

  begin_op();
    800043d8:	fffff097          	auipc	ra,0xfffff
    800043dc:	43a080e7          	jalr	1082(ra) # 80003812 <begin_op>

  if((ip = namei(path)) == 0){
    800043e0:	854a                	mv	a0,s2
    800043e2:	fffff097          	auipc	ra,0xfffff
    800043e6:	230080e7          	jalr	560(ra) # 80003612 <namei>
    800043ea:	c135                	beqz	a0,8000444e <exec+0x9c>
    800043ec:	f3d2                	sd	s4,480(sp)
    800043ee:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800043f0:	fffff097          	auipc	ra,0xfffff
    800043f4:	a54080e7          	jalr	-1452(ra) # 80002e44 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800043f8:	04000713          	li	a4,64
    800043fc:	4681                	li	a3,0
    800043fe:	e5040613          	addi	a2,s0,-432
    80004402:	4581                	li	a1,0
    80004404:	8552                	mv	a0,s4
    80004406:	fffff097          	auipc	ra,0xfffff
    8000440a:	cf6080e7          	jalr	-778(ra) # 800030fc <readi>
    8000440e:	04000793          	li	a5,64
    80004412:	00f51a63          	bne	a0,a5,80004426 <exec+0x74>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004416:	e5042703          	lw	a4,-432(s0)
    8000441a:	464c47b7          	lui	a5,0x464c4
    8000441e:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004422:	02f70c63          	beq	a4,a5,8000445a <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004426:	8552                	mv	a0,s4
    80004428:	fffff097          	auipc	ra,0xfffff
    8000442c:	c82080e7          	jalr	-894(ra) # 800030aa <iunlockput>
    end_op();
    80004430:	fffff097          	auipc	ra,0xfffff
    80004434:	45c080e7          	jalr	1116(ra) # 8000388c <end_op>
  }
  return -1;
    80004438:	557d                	li	a0,-1
    8000443a:	7a1e                	ld	s4,480(sp)
}
    8000443c:	20813083          	ld	ra,520(sp)
    80004440:	20013403          	ld	s0,512(sp)
    80004444:	74fe                	ld	s1,504(sp)
    80004446:	795e                	ld	s2,496(sp)
    80004448:	21010113          	addi	sp,sp,528
    8000444c:	8082                	ret
    end_op();
    8000444e:	fffff097          	auipc	ra,0xfffff
    80004452:	43e080e7          	jalr	1086(ra) # 8000388c <end_op>
    return -1;
    80004456:	557d                	li	a0,-1
    80004458:	b7d5                	j	8000443c <exec+0x8a>
    8000445a:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    8000445c:	8526                	mv	a0,s1
    8000445e:	ffffd097          	auipc	ra,0xffffd
    80004462:	c6a080e7          	jalr	-918(ra) # 800010c8 <proc_pagetable>
    80004466:	8b2a                	mv	s6,a0
    80004468:	32050b63          	beqz	a0,8000479e <exec+0x3ec>
    8000446c:	f7ce                	sd	s3,488(sp)
    8000446e:	efd6                	sd	s5,472(sp)
    80004470:	e7de                	sd	s7,456(sp)
    80004472:	e3e2                	sd	s8,448(sp)
    80004474:	ff66                	sd	s9,440(sp)
    80004476:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004478:	e7042d03          	lw	s10,-400(s0)
    8000447c:	e8845783          	lhu	a5,-376(s0)
    80004480:	14078d63          	beqz	a5,800045da <exec+0x228>
    80004484:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004486:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004488:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    8000448a:	6c85                	lui	s9,0x1
    8000448c:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004490:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004494:	6a85                	lui	s5,0x1
    80004496:	a0b5                	j	80004502 <exec+0x150>
      panic("loadseg: address should exist");
    80004498:	00004517          	auipc	a0,0x4
    8000449c:	16050513          	addi	a0,a0,352 # 800085f8 <etext+0x5f8>
    800044a0:	00002097          	auipc	ra,0x2
    800044a4:	b82080e7          	jalr	-1150(ra) # 80006022 <panic>
    if(sz - i < PGSIZE)
    800044a8:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800044aa:	8726                	mv	a4,s1
    800044ac:	012c06bb          	addw	a3,s8,s2
    800044b0:	4581                	li	a1,0
    800044b2:	8552                	mv	a0,s4
    800044b4:	fffff097          	auipc	ra,0xfffff
    800044b8:	c48080e7          	jalr	-952(ra) # 800030fc <readi>
    800044bc:	2501                	sext.w	a0,a0
    800044be:	2aa49463          	bne	s1,a0,80004766 <exec+0x3b4>
  for(i = 0; i < sz; i += PGSIZE){
    800044c2:	012a893b          	addw	s2,s5,s2
    800044c6:	03397563          	bgeu	s2,s3,800044f0 <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    800044ca:	02091593          	slli	a1,s2,0x20
    800044ce:	9181                	srli	a1,a1,0x20
    800044d0:	95de                	add	a1,a1,s7
    800044d2:	855a                	mv	a0,s6
    800044d4:	ffffc097          	auipc	ra,0xffffc
    800044d8:	028080e7          	jalr	40(ra) # 800004fc <walkaddr>
    800044dc:	862a                	mv	a2,a0
    if(pa == 0)
    800044de:	dd4d                	beqz	a0,80004498 <exec+0xe6>
    if(sz - i < PGSIZE)
    800044e0:	412984bb          	subw	s1,s3,s2
    800044e4:	0004879b          	sext.w	a5,s1
    800044e8:	fcfcf0e3          	bgeu	s9,a5,800044a8 <exec+0xf6>
    800044ec:	84d6                	mv	s1,s5
    800044ee:	bf6d                	j	800044a8 <exec+0xf6>
    sz = sz1;
    800044f0:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800044f4:	2d85                	addiw	s11,s11,1
    800044f6:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    800044fa:	e8845783          	lhu	a5,-376(s0)
    800044fe:	08fdd663          	bge	s11,a5,8000458a <exec+0x1d8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004502:	2d01                	sext.w	s10,s10
    80004504:	03800713          	li	a4,56
    80004508:	86ea                	mv	a3,s10
    8000450a:	e1840613          	addi	a2,s0,-488
    8000450e:	4581                	li	a1,0
    80004510:	8552                	mv	a0,s4
    80004512:	fffff097          	auipc	ra,0xfffff
    80004516:	bea080e7          	jalr	-1046(ra) # 800030fc <readi>
    8000451a:	03800793          	li	a5,56
    8000451e:	20f51c63          	bne	a0,a5,80004736 <exec+0x384>
    if(ph.type != ELF_PROG_LOAD)
    80004522:	e1842783          	lw	a5,-488(s0)
    80004526:	4705                	li	a4,1
    80004528:	fce796e3          	bne	a5,a4,800044f4 <exec+0x142>
    if(ph.memsz < ph.filesz)
    8000452c:	e4043483          	ld	s1,-448(s0)
    80004530:	e3843783          	ld	a5,-456(s0)
    80004534:	20f4e563          	bltu	s1,a5,8000473e <exec+0x38c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004538:	e2843783          	ld	a5,-472(s0)
    8000453c:	94be                	add	s1,s1,a5
    8000453e:	20f4e463          	bltu	s1,a5,80004746 <exec+0x394>
    if(ph.vaddr % PGSIZE != 0)
    80004542:	df043703          	ld	a4,-528(s0)
    80004546:	8ff9                	and	a5,a5,a4
    80004548:	20079363          	bnez	a5,8000474e <exec+0x39c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000454c:	e1c42503          	lw	a0,-484(s0)
    80004550:	00000097          	auipc	ra,0x0
    80004554:	e48080e7          	jalr	-440(ra) # 80004398 <flags2perm>
    80004558:	86aa                	mv	a3,a0
    8000455a:	8626                	mv	a2,s1
    8000455c:	85ca                	mv	a1,s2
    8000455e:	855a                	mv	a0,s6
    80004560:	ffffc097          	auipc	ra,0xffffc
    80004564:	384080e7          	jalr	900(ra) # 800008e4 <uvmalloc>
    80004568:	e0a43423          	sd	a0,-504(s0)
    8000456c:	1e050563          	beqz	a0,80004756 <exec+0x3a4>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004570:	e2843b83          	ld	s7,-472(s0)
    80004574:	e2042c03          	lw	s8,-480(s0)
    80004578:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000457c:	00098463          	beqz	s3,80004584 <exec+0x1d2>
    80004580:	4901                	li	s2,0
    80004582:	b7a1                	j	800044ca <exec+0x118>
    sz = sz1;
    80004584:	e0843903          	ld	s2,-504(s0)
    80004588:	b7b5                	j	800044f4 <exec+0x142>
    8000458a:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    8000458c:	8552                	mv	a0,s4
    8000458e:	fffff097          	auipc	ra,0xfffff
    80004592:	b1c080e7          	jalr	-1252(ra) # 800030aa <iunlockput>
  end_op();
    80004596:	fffff097          	auipc	ra,0xfffff
    8000459a:	2f6080e7          	jalr	758(ra) # 8000388c <end_op>
  p = myproc();
    8000459e:	ffffd097          	auipc	ra,0xffffd
    800045a2:	a62080e7          	jalr	-1438(ra) # 80001000 <myproc>
    800045a6:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800045a8:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    800045ac:	6985                	lui	s3,0x1
    800045ae:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800045b0:	99ca                	add	s3,s3,s2
    800045b2:	77fd                	lui	a5,0xfffff
    800045b4:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800045b8:	4691                	li	a3,4
    800045ba:	6609                	lui	a2,0x2
    800045bc:	964e                	add	a2,a2,s3
    800045be:	85ce                	mv	a1,s3
    800045c0:	855a                	mv	a0,s6
    800045c2:	ffffc097          	auipc	ra,0xffffc
    800045c6:	322080e7          	jalr	802(ra) # 800008e4 <uvmalloc>
    800045ca:	892a                	mv	s2,a0
    800045cc:	e0a43423          	sd	a0,-504(s0)
    800045d0:	e519                	bnez	a0,800045de <exec+0x22c>
  if(pagetable)
    800045d2:	e1343423          	sd	s3,-504(s0)
    800045d6:	4a01                	li	s4,0
    800045d8:	aa41                	j	80004768 <exec+0x3b6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800045da:	4901                	li	s2,0
    800045dc:	bf45                	j	8000458c <exec+0x1da>
  uvmclear(pagetable, sz-2*PGSIZE);
    800045de:	75f9                	lui	a1,0xffffe
    800045e0:	95aa                	add	a1,a1,a0
    800045e2:	855a                	mv	a0,s6
    800045e4:	ffffc097          	auipc	ra,0xffffc
    800045e8:	536080e7          	jalr	1334(ra) # 80000b1a <uvmclear>
  stackbase = sp - PGSIZE;
    800045ec:	7bfd                	lui	s7,0xfffff
    800045ee:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800045f0:	e0043783          	ld	a5,-512(s0)
    800045f4:	6388                	ld	a0,0(a5)
    800045f6:	c52d                	beqz	a0,80004660 <exec+0x2ae>
    800045f8:	e9040993          	addi	s3,s0,-368
    800045fc:	f9040c13          	addi	s8,s0,-112
    80004600:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004602:	ffffc097          	auipc	ra,0xffffc
    80004606:	cec080e7          	jalr	-788(ra) # 800002ee <strlen>
    8000460a:	0015079b          	addiw	a5,a0,1
    8000460e:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004612:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004616:	15796463          	bltu	s2,s7,8000475e <exec+0x3ac>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000461a:	e0043d03          	ld	s10,-512(s0)
    8000461e:	000d3a03          	ld	s4,0(s10)
    80004622:	8552                	mv	a0,s4
    80004624:	ffffc097          	auipc	ra,0xffffc
    80004628:	cca080e7          	jalr	-822(ra) # 800002ee <strlen>
    8000462c:	0015069b          	addiw	a3,a0,1
    80004630:	8652                	mv	a2,s4
    80004632:	85ca                	mv	a1,s2
    80004634:	855a                	mv	a0,s6
    80004636:	ffffc097          	auipc	ra,0xffffc
    8000463a:	516080e7          	jalr	1302(ra) # 80000b4c <copyout>
    8000463e:	12054263          	bltz	a0,80004762 <exec+0x3b0>
    ustack[argc] = sp;
    80004642:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004646:	0485                	addi	s1,s1,1
    80004648:	008d0793          	addi	a5,s10,8
    8000464c:	e0f43023          	sd	a5,-512(s0)
    80004650:	008d3503          	ld	a0,8(s10)
    80004654:	c909                	beqz	a0,80004666 <exec+0x2b4>
    if(argc >= MAXARG)
    80004656:	09a1                	addi	s3,s3,8
    80004658:	fb8995e3          	bne	s3,s8,80004602 <exec+0x250>
  ip = 0;
    8000465c:	4a01                	li	s4,0
    8000465e:	a229                	j	80004768 <exec+0x3b6>
  sp = sz;
    80004660:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004664:	4481                	li	s1,0
  ustack[argc] = 0;
    80004666:	00349793          	slli	a5,s1,0x3
    8000466a:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffda5b0>
    8000466e:	97a2                	add	a5,a5,s0
    80004670:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004674:	00148693          	addi	a3,s1,1
    80004678:	068e                	slli	a3,a3,0x3
    8000467a:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000467e:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004682:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004686:	f57966e3          	bltu	s2,s7,800045d2 <exec+0x220>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000468a:	e9040613          	addi	a2,s0,-368
    8000468e:	85ca                	mv	a1,s2
    80004690:	855a                	mv	a0,s6
    80004692:	ffffc097          	auipc	ra,0xffffc
    80004696:	4ba080e7          	jalr	1210(ra) # 80000b4c <copyout>
    8000469a:	10054463          	bltz	a0,800047a2 <exec+0x3f0>
  p->trapframe->a1 = sp;
    8000469e:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    800046a2:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800046a6:	df843783          	ld	a5,-520(s0)
    800046aa:	0007c703          	lbu	a4,0(a5)
    800046ae:	cf11                	beqz	a4,800046ca <exec+0x318>
    800046b0:	0785                	addi	a5,a5,1
    if(*s == '/')
    800046b2:	02f00693          	li	a3,47
    800046b6:	a039                	j	800046c4 <exec+0x312>
      last = s+1;
    800046b8:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800046bc:	0785                	addi	a5,a5,1
    800046be:	fff7c703          	lbu	a4,-1(a5)
    800046c2:	c701                	beqz	a4,800046ca <exec+0x318>
    if(*s == '/')
    800046c4:	fed71ce3          	bne	a4,a3,800046bc <exec+0x30a>
    800046c8:	bfc5                	j	800046b8 <exec+0x306>
  safestrcpy(p->name, last, sizeof(p->name));
    800046ca:	4641                	li	a2,16
    800046cc:	df843583          	ld	a1,-520(s0)
    800046d0:	160a8513          	addi	a0,s5,352
    800046d4:	ffffc097          	auipc	ra,0xffffc
    800046d8:	be8080e7          	jalr	-1048(ra) # 800002bc <safestrcpy>
  oldpagetable = p->pagetable;
    800046dc:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800046e0:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800046e4:	e0843783          	ld	a5,-504(s0)
    800046e8:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800046ec:	058ab783          	ld	a5,88(s5)
    800046f0:	e6843703          	ld	a4,-408(s0)
    800046f4:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800046f6:	058ab783          	ld	a5,88(s5)
    800046fa:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800046fe:	85e6                	mv	a1,s9
    80004700:	ffffd097          	auipc	ra,0xffffd
    80004704:	abe080e7          	jalr	-1346(ra) # 800011be <proc_freepagetable>
  if(p->pid == 1){
    80004708:	030aa703          	lw	a4,48(s5)
    8000470c:	4785                	li	a5,1
    8000470e:	00f70d63          	beq	a4,a5,80004728 <exec+0x376>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004712:	0004851b          	sext.w	a0,s1
    80004716:	79be                	ld	s3,488(sp)
    80004718:	7a1e                	ld	s4,480(sp)
    8000471a:	6afe                	ld	s5,472(sp)
    8000471c:	6b5e                	ld	s6,464(sp)
    8000471e:	6bbe                	ld	s7,456(sp)
    80004720:	6c1e                	ld	s8,448(sp)
    80004722:	7cfa                	ld	s9,440(sp)
    80004724:	7d5a                	ld	s10,432(sp)
    80004726:	bb19                	j	8000443c <exec+0x8a>
    vmprint(p->pagetable);
    80004728:	050ab503          	ld	a0,80(s5)
    8000472c:	ffffc097          	auipc	ra,0xffffc
    80004730:	712080e7          	jalr	1810(ra) # 80000e3e <vmprint>
    80004734:	bff9                	j	80004712 <exec+0x360>
    80004736:	e1243423          	sd	s2,-504(s0)
    8000473a:	7dba                	ld	s11,424(sp)
    8000473c:	a035                	j	80004768 <exec+0x3b6>
    8000473e:	e1243423          	sd	s2,-504(s0)
    80004742:	7dba                	ld	s11,424(sp)
    80004744:	a015                	j	80004768 <exec+0x3b6>
    80004746:	e1243423          	sd	s2,-504(s0)
    8000474a:	7dba                	ld	s11,424(sp)
    8000474c:	a831                	j	80004768 <exec+0x3b6>
    8000474e:	e1243423          	sd	s2,-504(s0)
    80004752:	7dba                	ld	s11,424(sp)
    80004754:	a811                	j	80004768 <exec+0x3b6>
    80004756:	e1243423          	sd	s2,-504(s0)
    8000475a:	7dba                	ld	s11,424(sp)
    8000475c:	a031                	j	80004768 <exec+0x3b6>
  ip = 0;
    8000475e:	4a01                	li	s4,0
    80004760:	a021                	j	80004768 <exec+0x3b6>
    80004762:	4a01                	li	s4,0
  if(pagetable)
    80004764:	a011                	j	80004768 <exec+0x3b6>
    80004766:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004768:	e0843583          	ld	a1,-504(s0)
    8000476c:	855a                	mv	a0,s6
    8000476e:	ffffd097          	auipc	ra,0xffffd
    80004772:	a50080e7          	jalr	-1456(ra) # 800011be <proc_freepagetable>
  return -1;
    80004776:	557d                	li	a0,-1
  if(ip){
    80004778:	000a1b63          	bnez	s4,8000478e <exec+0x3dc>
    8000477c:	79be                	ld	s3,488(sp)
    8000477e:	7a1e                	ld	s4,480(sp)
    80004780:	6afe                	ld	s5,472(sp)
    80004782:	6b5e                	ld	s6,464(sp)
    80004784:	6bbe                	ld	s7,456(sp)
    80004786:	6c1e                	ld	s8,448(sp)
    80004788:	7cfa                	ld	s9,440(sp)
    8000478a:	7d5a                	ld	s10,432(sp)
    8000478c:	b945                	j	8000443c <exec+0x8a>
    8000478e:	79be                	ld	s3,488(sp)
    80004790:	6afe                	ld	s5,472(sp)
    80004792:	6b5e                	ld	s6,464(sp)
    80004794:	6bbe                	ld	s7,456(sp)
    80004796:	6c1e                	ld	s8,448(sp)
    80004798:	7cfa                	ld	s9,440(sp)
    8000479a:	7d5a                	ld	s10,432(sp)
    8000479c:	b169                	j	80004426 <exec+0x74>
    8000479e:	6b5e                	ld	s6,464(sp)
    800047a0:	b159                	j	80004426 <exec+0x74>
  sz = sz1;
    800047a2:	e0843983          	ld	s3,-504(s0)
    800047a6:	b535                	j	800045d2 <exec+0x220>

00000000800047a8 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800047a8:	7179                	addi	sp,sp,-48
    800047aa:	f406                	sd	ra,40(sp)
    800047ac:	f022                	sd	s0,32(sp)
    800047ae:	ec26                	sd	s1,24(sp)
    800047b0:	e84a                	sd	s2,16(sp)
    800047b2:	1800                	addi	s0,sp,48
    800047b4:	892e                	mv	s2,a1
    800047b6:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800047b8:	fdc40593          	addi	a1,s0,-36
    800047bc:	ffffe097          	auipc	ra,0xffffe
    800047c0:	a14080e7          	jalr	-1516(ra) # 800021d0 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800047c4:	fdc42703          	lw	a4,-36(s0)
    800047c8:	47bd                	li	a5,15
    800047ca:	02e7eb63          	bltu	a5,a4,80004800 <argfd+0x58>
    800047ce:	ffffd097          	auipc	ra,0xffffd
    800047d2:	832080e7          	jalr	-1998(ra) # 80001000 <myproc>
    800047d6:	fdc42703          	lw	a4,-36(s0)
    800047da:	01a70793          	addi	a5,a4,26
    800047de:	078e                	slli	a5,a5,0x3
    800047e0:	953e                	add	a0,a0,a5
    800047e2:	651c                	ld	a5,8(a0)
    800047e4:	c385                	beqz	a5,80004804 <argfd+0x5c>
    return -1;
  if(pfd)
    800047e6:	00090463          	beqz	s2,800047ee <argfd+0x46>
    *pfd = fd;
    800047ea:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800047ee:	4501                	li	a0,0
  if(pf)
    800047f0:	c091                	beqz	s1,800047f4 <argfd+0x4c>
    *pf = f;
    800047f2:	e09c                	sd	a5,0(s1)
}
    800047f4:	70a2                	ld	ra,40(sp)
    800047f6:	7402                	ld	s0,32(sp)
    800047f8:	64e2                	ld	s1,24(sp)
    800047fa:	6942                	ld	s2,16(sp)
    800047fc:	6145                	addi	sp,sp,48
    800047fe:	8082                	ret
    return -1;
    80004800:	557d                	li	a0,-1
    80004802:	bfcd                	j	800047f4 <argfd+0x4c>
    80004804:	557d                	li	a0,-1
    80004806:	b7fd                	j	800047f4 <argfd+0x4c>

0000000080004808 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004808:	1101                	addi	sp,sp,-32
    8000480a:	ec06                	sd	ra,24(sp)
    8000480c:	e822                	sd	s0,16(sp)
    8000480e:	e426                	sd	s1,8(sp)
    80004810:	1000                	addi	s0,sp,32
    80004812:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004814:	ffffc097          	auipc	ra,0xffffc
    80004818:	7ec080e7          	jalr	2028(ra) # 80001000 <myproc>
    8000481c:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000481e:	0d850793          	addi	a5,a0,216
    80004822:	4501                	li	a0,0
    80004824:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004826:	6398                	ld	a4,0(a5)
    80004828:	cb19                	beqz	a4,8000483e <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000482a:	2505                	addiw	a0,a0,1
    8000482c:	07a1                	addi	a5,a5,8
    8000482e:	fed51ce3          	bne	a0,a3,80004826 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004832:	557d                	li	a0,-1
}
    80004834:	60e2                	ld	ra,24(sp)
    80004836:	6442                	ld	s0,16(sp)
    80004838:	64a2                	ld	s1,8(sp)
    8000483a:	6105                	addi	sp,sp,32
    8000483c:	8082                	ret
      p->ofile[fd] = f;
    8000483e:	01a50793          	addi	a5,a0,26
    80004842:	078e                	slli	a5,a5,0x3
    80004844:	963e                	add	a2,a2,a5
    80004846:	e604                	sd	s1,8(a2)
      return fd;
    80004848:	b7f5                	j	80004834 <fdalloc+0x2c>

000000008000484a <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000484a:	715d                	addi	sp,sp,-80
    8000484c:	e486                	sd	ra,72(sp)
    8000484e:	e0a2                	sd	s0,64(sp)
    80004850:	fc26                	sd	s1,56(sp)
    80004852:	f84a                	sd	s2,48(sp)
    80004854:	f44e                	sd	s3,40(sp)
    80004856:	ec56                	sd	s5,24(sp)
    80004858:	e85a                	sd	s6,16(sp)
    8000485a:	0880                	addi	s0,sp,80
    8000485c:	8b2e                	mv	s6,a1
    8000485e:	89b2                	mv	s3,a2
    80004860:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004862:	fb040593          	addi	a1,s0,-80
    80004866:	fffff097          	auipc	ra,0xfffff
    8000486a:	dca080e7          	jalr	-566(ra) # 80003630 <nameiparent>
    8000486e:	84aa                	mv	s1,a0
    80004870:	14050e63          	beqz	a0,800049cc <create+0x182>
    return 0;

  ilock(dp);
    80004874:	ffffe097          	auipc	ra,0xffffe
    80004878:	5d0080e7          	jalr	1488(ra) # 80002e44 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000487c:	4601                	li	a2,0
    8000487e:	fb040593          	addi	a1,s0,-80
    80004882:	8526                	mv	a0,s1
    80004884:	fffff097          	auipc	ra,0xfffff
    80004888:	acc080e7          	jalr	-1332(ra) # 80003350 <dirlookup>
    8000488c:	8aaa                	mv	s5,a0
    8000488e:	c539                	beqz	a0,800048dc <create+0x92>
    iunlockput(dp);
    80004890:	8526                	mv	a0,s1
    80004892:	fffff097          	auipc	ra,0xfffff
    80004896:	818080e7          	jalr	-2024(ra) # 800030aa <iunlockput>
    ilock(ip);
    8000489a:	8556                	mv	a0,s5
    8000489c:	ffffe097          	auipc	ra,0xffffe
    800048a0:	5a8080e7          	jalr	1448(ra) # 80002e44 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800048a4:	4789                	li	a5,2
    800048a6:	02fb1463          	bne	s6,a5,800048ce <create+0x84>
    800048aa:	044ad783          	lhu	a5,68(s5)
    800048ae:	37f9                	addiw	a5,a5,-2
    800048b0:	17c2                	slli	a5,a5,0x30
    800048b2:	93c1                	srli	a5,a5,0x30
    800048b4:	4705                	li	a4,1
    800048b6:	00f76c63          	bltu	a4,a5,800048ce <create+0x84>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800048ba:	8556                	mv	a0,s5
    800048bc:	60a6                	ld	ra,72(sp)
    800048be:	6406                	ld	s0,64(sp)
    800048c0:	74e2                	ld	s1,56(sp)
    800048c2:	7942                	ld	s2,48(sp)
    800048c4:	79a2                	ld	s3,40(sp)
    800048c6:	6ae2                	ld	s5,24(sp)
    800048c8:	6b42                	ld	s6,16(sp)
    800048ca:	6161                	addi	sp,sp,80
    800048cc:	8082                	ret
    iunlockput(ip);
    800048ce:	8556                	mv	a0,s5
    800048d0:	ffffe097          	auipc	ra,0xffffe
    800048d4:	7da080e7          	jalr	2010(ra) # 800030aa <iunlockput>
    return 0;
    800048d8:	4a81                	li	s5,0
    800048da:	b7c5                	j	800048ba <create+0x70>
    800048dc:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    800048de:	85da                	mv	a1,s6
    800048e0:	4088                	lw	a0,0(s1)
    800048e2:	ffffe097          	auipc	ra,0xffffe
    800048e6:	3be080e7          	jalr	958(ra) # 80002ca0 <ialloc>
    800048ea:	8a2a                	mv	s4,a0
    800048ec:	c531                	beqz	a0,80004938 <create+0xee>
  ilock(ip);
    800048ee:	ffffe097          	auipc	ra,0xffffe
    800048f2:	556080e7          	jalr	1366(ra) # 80002e44 <ilock>
  ip->major = major;
    800048f6:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800048fa:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800048fe:	4905                	li	s2,1
    80004900:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004904:	8552                	mv	a0,s4
    80004906:	ffffe097          	auipc	ra,0xffffe
    8000490a:	472080e7          	jalr	1138(ra) # 80002d78 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000490e:	032b0d63          	beq	s6,s2,80004948 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80004912:	004a2603          	lw	a2,4(s4)
    80004916:	fb040593          	addi	a1,s0,-80
    8000491a:	8526                	mv	a0,s1
    8000491c:	fffff097          	auipc	ra,0xfffff
    80004920:	c44080e7          	jalr	-956(ra) # 80003560 <dirlink>
    80004924:	08054163          	bltz	a0,800049a6 <create+0x15c>
  iunlockput(dp);
    80004928:	8526                	mv	a0,s1
    8000492a:	ffffe097          	auipc	ra,0xffffe
    8000492e:	780080e7          	jalr	1920(ra) # 800030aa <iunlockput>
  return ip;
    80004932:	8ad2                	mv	s5,s4
    80004934:	7a02                	ld	s4,32(sp)
    80004936:	b751                	j	800048ba <create+0x70>
    iunlockput(dp);
    80004938:	8526                	mv	a0,s1
    8000493a:	ffffe097          	auipc	ra,0xffffe
    8000493e:	770080e7          	jalr	1904(ra) # 800030aa <iunlockput>
    return 0;
    80004942:	8ad2                	mv	s5,s4
    80004944:	7a02                	ld	s4,32(sp)
    80004946:	bf95                	j	800048ba <create+0x70>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004948:	004a2603          	lw	a2,4(s4)
    8000494c:	00004597          	auipc	a1,0x4
    80004950:	ccc58593          	addi	a1,a1,-820 # 80008618 <etext+0x618>
    80004954:	8552                	mv	a0,s4
    80004956:	fffff097          	auipc	ra,0xfffff
    8000495a:	c0a080e7          	jalr	-1014(ra) # 80003560 <dirlink>
    8000495e:	04054463          	bltz	a0,800049a6 <create+0x15c>
    80004962:	40d0                	lw	a2,4(s1)
    80004964:	00004597          	auipc	a1,0x4
    80004968:	cbc58593          	addi	a1,a1,-836 # 80008620 <etext+0x620>
    8000496c:	8552                	mv	a0,s4
    8000496e:	fffff097          	auipc	ra,0xfffff
    80004972:	bf2080e7          	jalr	-1038(ra) # 80003560 <dirlink>
    80004976:	02054863          	bltz	a0,800049a6 <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    8000497a:	004a2603          	lw	a2,4(s4)
    8000497e:	fb040593          	addi	a1,s0,-80
    80004982:	8526                	mv	a0,s1
    80004984:	fffff097          	auipc	ra,0xfffff
    80004988:	bdc080e7          	jalr	-1060(ra) # 80003560 <dirlink>
    8000498c:	00054d63          	bltz	a0,800049a6 <create+0x15c>
    dp->nlink++;  // for ".."
    80004990:	04a4d783          	lhu	a5,74(s1)
    80004994:	2785                	addiw	a5,a5,1
    80004996:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000499a:	8526                	mv	a0,s1
    8000499c:	ffffe097          	auipc	ra,0xffffe
    800049a0:	3dc080e7          	jalr	988(ra) # 80002d78 <iupdate>
    800049a4:	b751                	j	80004928 <create+0xde>
  ip->nlink = 0;
    800049a6:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800049aa:	8552                	mv	a0,s4
    800049ac:	ffffe097          	auipc	ra,0xffffe
    800049b0:	3cc080e7          	jalr	972(ra) # 80002d78 <iupdate>
  iunlockput(ip);
    800049b4:	8552                	mv	a0,s4
    800049b6:	ffffe097          	auipc	ra,0xffffe
    800049ba:	6f4080e7          	jalr	1780(ra) # 800030aa <iunlockput>
  iunlockput(dp);
    800049be:	8526                	mv	a0,s1
    800049c0:	ffffe097          	auipc	ra,0xffffe
    800049c4:	6ea080e7          	jalr	1770(ra) # 800030aa <iunlockput>
  return 0;
    800049c8:	7a02                	ld	s4,32(sp)
    800049ca:	bdc5                	j	800048ba <create+0x70>
    return 0;
    800049cc:	8aaa                	mv	s5,a0
    800049ce:	b5f5                	j	800048ba <create+0x70>

00000000800049d0 <sys_dup>:
{
    800049d0:	7179                	addi	sp,sp,-48
    800049d2:	f406                	sd	ra,40(sp)
    800049d4:	f022                	sd	s0,32(sp)
    800049d6:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800049d8:	fd840613          	addi	a2,s0,-40
    800049dc:	4581                	li	a1,0
    800049de:	4501                	li	a0,0
    800049e0:	00000097          	auipc	ra,0x0
    800049e4:	dc8080e7          	jalr	-568(ra) # 800047a8 <argfd>
    return -1;
    800049e8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800049ea:	02054763          	bltz	a0,80004a18 <sys_dup+0x48>
    800049ee:	ec26                	sd	s1,24(sp)
    800049f0:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    800049f2:	fd843903          	ld	s2,-40(s0)
    800049f6:	854a                	mv	a0,s2
    800049f8:	00000097          	auipc	ra,0x0
    800049fc:	e10080e7          	jalr	-496(ra) # 80004808 <fdalloc>
    80004a00:	84aa                	mv	s1,a0
    return -1;
    80004a02:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004a04:	00054f63          	bltz	a0,80004a22 <sys_dup+0x52>
  filedup(f);
    80004a08:	854a                	mv	a0,s2
    80004a0a:	fffff097          	auipc	ra,0xfffff
    80004a0e:	280080e7          	jalr	640(ra) # 80003c8a <filedup>
  return fd;
    80004a12:	87a6                	mv	a5,s1
    80004a14:	64e2                	ld	s1,24(sp)
    80004a16:	6942                	ld	s2,16(sp)
}
    80004a18:	853e                	mv	a0,a5
    80004a1a:	70a2                	ld	ra,40(sp)
    80004a1c:	7402                	ld	s0,32(sp)
    80004a1e:	6145                	addi	sp,sp,48
    80004a20:	8082                	ret
    80004a22:	64e2                	ld	s1,24(sp)
    80004a24:	6942                	ld	s2,16(sp)
    80004a26:	bfcd                	j	80004a18 <sys_dup+0x48>

0000000080004a28 <sys_read>:
{
    80004a28:	7179                	addi	sp,sp,-48
    80004a2a:	f406                	sd	ra,40(sp)
    80004a2c:	f022                	sd	s0,32(sp)
    80004a2e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004a30:	fd840593          	addi	a1,s0,-40
    80004a34:	4505                	li	a0,1
    80004a36:	ffffd097          	auipc	ra,0xffffd
    80004a3a:	7ba080e7          	jalr	1978(ra) # 800021f0 <argaddr>
  argint(2, &n);
    80004a3e:	fe440593          	addi	a1,s0,-28
    80004a42:	4509                	li	a0,2
    80004a44:	ffffd097          	auipc	ra,0xffffd
    80004a48:	78c080e7          	jalr	1932(ra) # 800021d0 <argint>
  if(argfd(0, 0, &f) < 0)
    80004a4c:	fe840613          	addi	a2,s0,-24
    80004a50:	4581                	li	a1,0
    80004a52:	4501                	li	a0,0
    80004a54:	00000097          	auipc	ra,0x0
    80004a58:	d54080e7          	jalr	-684(ra) # 800047a8 <argfd>
    80004a5c:	87aa                	mv	a5,a0
    return -1;
    80004a5e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004a60:	0007cc63          	bltz	a5,80004a78 <sys_read+0x50>
  return fileread(f, p, n);
    80004a64:	fe442603          	lw	a2,-28(s0)
    80004a68:	fd843583          	ld	a1,-40(s0)
    80004a6c:	fe843503          	ld	a0,-24(s0)
    80004a70:	fffff097          	auipc	ra,0xfffff
    80004a74:	3c0080e7          	jalr	960(ra) # 80003e30 <fileread>
}
    80004a78:	70a2                	ld	ra,40(sp)
    80004a7a:	7402                	ld	s0,32(sp)
    80004a7c:	6145                	addi	sp,sp,48
    80004a7e:	8082                	ret

0000000080004a80 <sys_write>:
{
    80004a80:	7179                	addi	sp,sp,-48
    80004a82:	f406                	sd	ra,40(sp)
    80004a84:	f022                	sd	s0,32(sp)
    80004a86:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004a88:	fd840593          	addi	a1,s0,-40
    80004a8c:	4505                	li	a0,1
    80004a8e:	ffffd097          	auipc	ra,0xffffd
    80004a92:	762080e7          	jalr	1890(ra) # 800021f0 <argaddr>
  argint(2, &n);
    80004a96:	fe440593          	addi	a1,s0,-28
    80004a9a:	4509                	li	a0,2
    80004a9c:	ffffd097          	auipc	ra,0xffffd
    80004aa0:	734080e7          	jalr	1844(ra) # 800021d0 <argint>
  if(argfd(0, 0, &f) < 0)
    80004aa4:	fe840613          	addi	a2,s0,-24
    80004aa8:	4581                	li	a1,0
    80004aaa:	4501                	li	a0,0
    80004aac:	00000097          	auipc	ra,0x0
    80004ab0:	cfc080e7          	jalr	-772(ra) # 800047a8 <argfd>
    80004ab4:	87aa                	mv	a5,a0
    return -1;
    80004ab6:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004ab8:	0007cc63          	bltz	a5,80004ad0 <sys_write+0x50>
  return filewrite(f, p, n);
    80004abc:	fe442603          	lw	a2,-28(s0)
    80004ac0:	fd843583          	ld	a1,-40(s0)
    80004ac4:	fe843503          	ld	a0,-24(s0)
    80004ac8:	fffff097          	auipc	ra,0xfffff
    80004acc:	43a080e7          	jalr	1082(ra) # 80003f02 <filewrite>
}
    80004ad0:	70a2                	ld	ra,40(sp)
    80004ad2:	7402                	ld	s0,32(sp)
    80004ad4:	6145                	addi	sp,sp,48
    80004ad6:	8082                	ret

0000000080004ad8 <sys_close>:
{
    80004ad8:	1101                	addi	sp,sp,-32
    80004ada:	ec06                	sd	ra,24(sp)
    80004adc:	e822                	sd	s0,16(sp)
    80004ade:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004ae0:	fe040613          	addi	a2,s0,-32
    80004ae4:	fec40593          	addi	a1,s0,-20
    80004ae8:	4501                	li	a0,0
    80004aea:	00000097          	auipc	ra,0x0
    80004aee:	cbe080e7          	jalr	-834(ra) # 800047a8 <argfd>
    return -1;
    80004af2:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004af4:	02054463          	bltz	a0,80004b1c <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004af8:	ffffc097          	auipc	ra,0xffffc
    80004afc:	508080e7          	jalr	1288(ra) # 80001000 <myproc>
    80004b00:	fec42783          	lw	a5,-20(s0)
    80004b04:	07e9                	addi	a5,a5,26
    80004b06:	078e                	slli	a5,a5,0x3
    80004b08:	953e                	add	a0,a0,a5
    80004b0a:	00053423          	sd	zero,8(a0)
  fileclose(f);
    80004b0e:	fe043503          	ld	a0,-32(s0)
    80004b12:	fffff097          	auipc	ra,0xfffff
    80004b16:	1ca080e7          	jalr	458(ra) # 80003cdc <fileclose>
  return 0;
    80004b1a:	4781                	li	a5,0
}
    80004b1c:	853e                	mv	a0,a5
    80004b1e:	60e2                	ld	ra,24(sp)
    80004b20:	6442                	ld	s0,16(sp)
    80004b22:	6105                	addi	sp,sp,32
    80004b24:	8082                	ret

0000000080004b26 <sys_fstat>:
{
    80004b26:	1101                	addi	sp,sp,-32
    80004b28:	ec06                	sd	ra,24(sp)
    80004b2a:	e822                	sd	s0,16(sp)
    80004b2c:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004b2e:	fe040593          	addi	a1,s0,-32
    80004b32:	4505                	li	a0,1
    80004b34:	ffffd097          	auipc	ra,0xffffd
    80004b38:	6bc080e7          	jalr	1724(ra) # 800021f0 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004b3c:	fe840613          	addi	a2,s0,-24
    80004b40:	4581                	li	a1,0
    80004b42:	4501                	li	a0,0
    80004b44:	00000097          	auipc	ra,0x0
    80004b48:	c64080e7          	jalr	-924(ra) # 800047a8 <argfd>
    80004b4c:	87aa                	mv	a5,a0
    return -1;
    80004b4e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004b50:	0007ca63          	bltz	a5,80004b64 <sys_fstat+0x3e>
  return filestat(f, st);
    80004b54:	fe043583          	ld	a1,-32(s0)
    80004b58:	fe843503          	ld	a0,-24(s0)
    80004b5c:	fffff097          	auipc	ra,0xfffff
    80004b60:	262080e7          	jalr	610(ra) # 80003dbe <filestat>
}
    80004b64:	60e2                	ld	ra,24(sp)
    80004b66:	6442                	ld	s0,16(sp)
    80004b68:	6105                	addi	sp,sp,32
    80004b6a:	8082                	ret

0000000080004b6c <sys_link>:
{
    80004b6c:	7169                	addi	sp,sp,-304
    80004b6e:	f606                	sd	ra,296(sp)
    80004b70:	f222                	sd	s0,288(sp)
    80004b72:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b74:	08000613          	li	a2,128
    80004b78:	ed040593          	addi	a1,s0,-304
    80004b7c:	4501                	li	a0,0
    80004b7e:	ffffd097          	auipc	ra,0xffffd
    80004b82:	692080e7          	jalr	1682(ra) # 80002210 <argstr>
    return -1;
    80004b86:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b88:	12054663          	bltz	a0,80004cb4 <sys_link+0x148>
    80004b8c:	08000613          	li	a2,128
    80004b90:	f5040593          	addi	a1,s0,-176
    80004b94:	4505                	li	a0,1
    80004b96:	ffffd097          	auipc	ra,0xffffd
    80004b9a:	67a080e7          	jalr	1658(ra) # 80002210 <argstr>
    return -1;
    80004b9e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004ba0:	10054a63          	bltz	a0,80004cb4 <sys_link+0x148>
    80004ba4:	ee26                	sd	s1,280(sp)
  begin_op();
    80004ba6:	fffff097          	auipc	ra,0xfffff
    80004baa:	c6c080e7          	jalr	-916(ra) # 80003812 <begin_op>
  if((ip = namei(old)) == 0){
    80004bae:	ed040513          	addi	a0,s0,-304
    80004bb2:	fffff097          	auipc	ra,0xfffff
    80004bb6:	a60080e7          	jalr	-1440(ra) # 80003612 <namei>
    80004bba:	84aa                	mv	s1,a0
    80004bbc:	c949                	beqz	a0,80004c4e <sys_link+0xe2>
  ilock(ip);
    80004bbe:	ffffe097          	auipc	ra,0xffffe
    80004bc2:	286080e7          	jalr	646(ra) # 80002e44 <ilock>
  if(ip->type == T_DIR){
    80004bc6:	04449703          	lh	a4,68(s1)
    80004bca:	4785                	li	a5,1
    80004bcc:	08f70863          	beq	a4,a5,80004c5c <sys_link+0xf0>
    80004bd0:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004bd2:	04a4d783          	lhu	a5,74(s1)
    80004bd6:	2785                	addiw	a5,a5,1
    80004bd8:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004bdc:	8526                	mv	a0,s1
    80004bde:	ffffe097          	auipc	ra,0xffffe
    80004be2:	19a080e7          	jalr	410(ra) # 80002d78 <iupdate>
  iunlock(ip);
    80004be6:	8526                	mv	a0,s1
    80004be8:	ffffe097          	auipc	ra,0xffffe
    80004bec:	322080e7          	jalr	802(ra) # 80002f0a <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004bf0:	fd040593          	addi	a1,s0,-48
    80004bf4:	f5040513          	addi	a0,s0,-176
    80004bf8:	fffff097          	auipc	ra,0xfffff
    80004bfc:	a38080e7          	jalr	-1480(ra) # 80003630 <nameiparent>
    80004c00:	892a                	mv	s2,a0
    80004c02:	cd35                	beqz	a0,80004c7e <sys_link+0x112>
  ilock(dp);
    80004c04:	ffffe097          	auipc	ra,0xffffe
    80004c08:	240080e7          	jalr	576(ra) # 80002e44 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004c0c:	00092703          	lw	a4,0(s2)
    80004c10:	409c                	lw	a5,0(s1)
    80004c12:	06f71163          	bne	a4,a5,80004c74 <sys_link+0x108>
    80004c16:	40d0                	lw	a2,4(s1)
    80004c18:	fd040593          	addi	a1,s0,-48
    80004c1c:	854a                	mv	a0,s2
    80004c1e:	fffff097          	auipc	ra,0xfffff
    80004c22:	942080e7          	jalr	-1726(ra) # 80003560 <dirlink>
    80004c26:	04054763          	bltz	a0,80004c74 <sys_link+0x108>
  iunlockput(dp);
    80004c2a:	854a                	mv	a0,s2
    80004c2c:	ffffe097          	auipc	ra,0xffffe
    80004c30:	47e080e7          	jalr	1150(ra) # 800030aa <iunlockput>
  iput(ip);
    80004c34:	8526                	mv	a0,s1
    80004c36:	ffffe097          	auipc	ra,0xffffe
    80004c3a:	3cc080e7          	jalr	972(ra) # 80003002 <iput>
  end_op();
    80004c3e:	fffff097          	auipc	ra,0xfffff
    80004c42:	c4e080e7          	jalr	-946(ra) # 8000388c <end_op>
  return 0;
    80004c46:	4781                	li	a5,0
    80004c48:	64f2                	ld	s1,280(sp)
    80004c4a:	6952                	ld	s2,272(sp)
    80004c4c:	a0a5                	j	80004cb4 <sys_link+0x148>
    end_op();
    80004c4e:	fffff097          	auipc	ra,0xfffff
    80004c52:	c3e080e7          	jalr	-962(ra) # 8000388c <end_op>
    return -1;
    80004c56:	57fd                	li	a5,-1
    80004c58:	64f2                	ld	s1,280(sp)
    80004c5a:	a8a9                	j	80004cb4 <sys_link+0x148>
    iunlockput(ip);
    80004c5c:	8526                	mv	a0,s1
    80004c5e:	ffffe097          	auipc	ra,0xffffe
    80004c62:	44c080e7          	jalr	1100(ra) # 800030aa <iunlockput>
    end_op();
    80004c66:	fffff097          	auipc	ra,0xfffff
    80004c6a:	c26080e7          	jalr	-986(ra) # 8000388c <end_op>
    return -1;
    80004c6e:	57fd                	li	a5,-1
    80004c70:	64f2                	ld	s1,280(sp)
    80004c72:	a089                	j	80004cb4 <sys_link+0x148>
    iunlockput(dp);
    80004c74:	854a                	mv	a0,s2
    80004c76:	ffffe097          	auipc	ra,0xffffe
    80004c7a:	434080e7          	jalr	1076(ra) # 800030aa <iunlockput>
  ilock(ip);
    80004c7e:	8526                	mv	a0,s1
    80004c80:	ffffe097          	auipc	ra,0xffffe
    80004c84:	1c4080e7          	jalr	452(ra) # 80002e44 <ilock>
  ip->nlink--;
    80004c88:	04a4d783          	lhu	a5,74(s1)
    80004c8c:	37fd                	addiw	a5,a5,-1
    80004c8e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004c92:	8526                	mv	a0,s1
    80004c94:	ffffe097          	auipc	ra,0xffffe
    80004c98:	0e4080e7          	jalr	228(ra) # 80002d78 <iupdate>
  iunlockput(ip);
    80004c9c:	8526                	mv	a0,s1
    80004c9e:	ffffe097          	auipc	ra,0xffffe
    80004ca2:	40c080e7          	jalr	1036(ra) # 800030aa <iunlockput>
  end_op();
    80004ca6:	fffff097          	auipc	ra,0xfffff
    80004caa:	be6080e7          	jalr	-1050(ra) # 8000388c <end_op>
  return -1;
    80004cae:	57fd                	li	a5,-1
    80004cb0:	64f2                	ld	s1,280(sp)
    80004cb2:	6952                	ld	s2,272(sp)
}
    80004cb4:	853e                	mv	a0,a5
    80004cb6:	70b2                	ld	ra,296(sp)
    80004cb8:	7412                	ld	s0,288(sp)
    80004cba:	6155                	addi	sp,sp,304
    80004cbc:	8082                	ret

0000000080004cbe <sys_unlink>:
{
    80004cbe:	7151                	addi	sp,sp,-240
    80004cc0:	f586                	sd	ra,232(sp)
    80004cc2:	f1a2                	sd	s0,224(sp)
    80004cc4:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004cc6:	08000613          	li	a2,128
    80004cca:	f3040593          	addi	a1,s0,-208
    80004cce:	4501                	li	a0,0
    80004cd0:	ffffd097          	auipc	ra,0xffffd
    80004cd4:	540080e7          	jalr	1344(ra) # 80002210 <argstr>
    80004cd8:	1a054a63          	bltz	a0,80004e8c <sys_unlink+0x1ce>
    80004cdc:	eda6                	sd	s1,216(sp)
  begin_op();
    80004cde:	fffff097          	auipc	ra,0xfffff
    80004ce2:	b34080e7          	jalr	-1228(ra) # 80003812 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004ce6:	fb040593          	addi	a1,s0,-80
    80004cea:	f3040513          	addi	a0,s0,-208
    80004cee:	fffff097          	auipc	ra,0xfffff
    80004cf2:	942080e7          	jalr	-1726(ra) # 80003630 <nameiparent>
    80004cf6:	84aa                	mv	s1,a0
    80004cf8:	cd71                	beqz	a0,80004dd4 <sys_unlink+0x116>
  ilock(dp);
    80004cfa:	ffffe097          	auipc	ra,0xffffe
    80004cfe:	14a080e7          	jalr	330(ra) # 80002e44 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004d02:	00004597          	auipc	a1,0x4
    80004d06:	91658593          	addi	a1,a1,-1770 # 80008618 <etext+0x618>
    80004d0a:	fb040513          	addi	a0,s0,-80
    80004d0e:	ffffe097          	auipc	ra,0xffffe
    80004d12:	628080e7          	jalr	1576(ra) # 80003336 <namecmp>
    80004d16:	14050c63          	beqz	a0,80004e6e <sys_unlink+0x1b0>
    80004d1a:	00004597          	auipc	a1,0x4
    80004d1e:	90658593          	addi	a1,a1,-1786 # 80008620 <etext+0x620>
    80004d22:	fb040513          	addi	a0,s0,-80
    80004d26:	ffffe097          	auipc	ra,0xffffe
    80004d2a:	610080e7          	jalr	1552(ra) # 80003336 <namecmp>
    80004d2e:	14050063          	beqz	a0,80004e6e <sys_unlink+0x1b0>
    80004d32:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004d34:	f2c40613          	addi	a2,s0,-212
    80004d38:	fb040593          	addi	a1,s0,-80
    80004d3c:	8526                	mv	a0,s1
    80004d3e:	ffffe097          	auipc	ra,0xffffe
    80004d42:	612080e7          	jalr	1554(ra) # 80003350 <dirlookup>
    80004d46:	892a                	mv	s2,a0
    80004d48:	12050263          	beqz	a0,80004e6c <sys_unlink+0x1ae>
  ilock(ip);
    80004d4c:	ffffe097          	auipc	ra,0xffffe
    80004d50:	0f8080e7          	jalr	248(ra) # 80002e44 <ilock>
  if(ip->nlink < 1)
    80004d54:	04a91783          	lh	a5,74(s2)
    80004d58:	08f05563          	blez	a5,80004de2 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004d5c:	04491703          	lh	a4,68(s2)
    80004d60:	4785                	li	a5,1
    80004d62:	08f70963          	beq	a4,a5,80004df4 <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004d66:	4641                	li	a2,16
    80004d68:	4581                	li	a1,0
    80004d6a:	fc040513          	addi	a0,s0,-64
    80004d6e:	ffffb097          	auipc	ra,0xffffb
    80004d72:	40c080e7          	jalr	1036(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004d76:	4741                	li	a4,16
    80004d78:	f2c42683          	lw	a3,-212(s0)
    80004d7c:	fc040613          	addi	a2,s0,-64
    80004d80:	4581                	li	a1,0
    80004d82:	8526                	mv	a0,s1
    80004d84:	ffffe097          	auipc	ra,0xffffe
    80004d88:	488080e7          	jalr	1160(ra) # 8000320c <writei>
    80004d8c:	47c1                	li	a5,16
    80004d8e:	0af51b63          	bne	a0,a5,80004e44 <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80004d92:	04491703          	lh	a4,68(s2)
    80004d96:	4785                	li	a5,1
    80004d98:	0af70f63          	beq	a4,a5,80004e56 <sys_unlink+0x198>
  iunlockput(dp);
    80004d9c:	8526                	mv	a0,s1
    80004d9e:	ffffe097          	auipc	ra,0xffffe
    80004da2:	30c080e7          	jalr	780(ra) # 800030aa <iunlockput>
  ip->nlink--;
    80004da6:	04a95783          	lhu	a5,74(s2)
    80004daa:	37fd                	addiw	a5,a5,-1
    80004dac:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004db0:	854a                	mv	a0,s2
    80004db2:	ffffe097          	auipc	ra,0xffffe
    80004db6:	fc6080e7          	jalr	-58(ra) # 80002d78 <iupdate>
  iunlockput(ip);
    80004dba:	854a                	mv	a0,s2
    80004dbc:	ffffe097          	auipc	ra,0xffffe
    80004dc0:	2ee080e7          	jalr	750(ra) # 800030aa <iunlockput>
  end_op();
    80004dc4:	fffff097          	auipc	ra,0xfffff
    80004dc8:	ac8080e7          	jalr	-1336(ra) # 8000388c <end_op>
  return 0;
    80004dcc:	4501                	li	a0,0
    80004dce:	64ee                	ld	s1,216(sp)
    80004dd0:	694e                	ld	s2,208(sp)
    80004dd2:	a84d                	j	80004e84 <sys_unlink+0x1c6>
    end_op();
    80004dd4:	fffff097          	auipc	ra,0xfffff
    80004dd8:	ab8080e7          	jalr	-1352(ra) # 8000388c <end_op>
    return -1;
    80004ddc:	557d                	li	a0,-1
    80004dde:	64ee                	ld	s1,216(sp)
    80004de0:	a055                	j	80004e84 <sys_unlink+0x1c6>
    80004de2:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004de4:	00004517          	auipc	a0,0x4
    80004de8:	84450513          	addi	a0,a0,-1980 # 80008628 <etext+0x628>
    80004dec:	00001097          	auipc	ra,0x1
    80004df0:	236080e7          	jalr	566(ra) # 80006022 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004df4:	04c92703          	lw	a4,76(s2)
    80004df8:	02000793          	li	a5,32
    80004dfc:	f6e7f5e3          	bgeu	a5,a4,80004d66 <sys_unlink+0xa8>
    80004e00:	e5ce                	sd	s3,200(sp)
    80004e02:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004e06:	4741                	li	a4,16
    80004e08:	86ce                	mv	a3,s3
    80004e0a:	f1840613          	addi	a2,s0,-232
    80004e0e:	4581                	li	a1,0
    80004e10:	854a                	mv	a0,s2
    80004e12:	ffffe097          	auipc	ra,0xffffe
    80004e16:	2ea080e7          	jalr	746(ra) # 800030fc <readi>
    80004e1a:	47c1                	li	a5,16
    80004e1c:	00f51c63          	bne	a0,a5,80004e34 <sys_unlink+0x176>
    if(de.inum != 0)
    80004e20:	f1845783          	lhu	a5,-232(s0)
    80004e24:	e7b5                	bnez	a5,80004e90 <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004e26:	29c1                	addiw	s3,s3,16
    80004e28:	04c92783          	lw	a5,76(s2)
    80004e2c:	fcf9ede3          	bltu	s3,a5,80004e06 <sys_unlink+0x148>
    80004e30:	69ae                	ld	s3,200(sp)
    80004e32:	bf15                	j	80004d66 <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004e34:	00004517          	auipc	a0,0x4
    80004e38:	80c50513          	addi	a0,a0,-2036 # 80008640 <etext+0x640>
    80004e3c:	00001097          	auipc	ra,0x1
    80004e40:	1e6080e7          	jalr	486(ra) # 80006022 <panic>
    80004e44:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004e46:	00004517          	auipc	a0,0x4
    80004e4a:	81250513          	addi	a0,a0,-2030 # 80008658 <etext+0x658>
    80004e4e:	00001097          	auipc	ra,0x1
    80004e52:	1d4080e7          	jalr	468(ra) # 80006022 <panic>
    dp->nlink--;
    80004e56:	04a4d783          	lhu	a5,74(s1)
    80004e5a:	37fd                	addiw	a5,a5,-1
    80004e5c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004e60:	8526                	mv	a0,s1
    80004e62:	ffffe097          	auipc	ra,0xffffe
    80004e66:	f16080e7          	jalr	-234(ra) # 80002d78 <iupdate>
    80004e6a:	bf0d                	j	80004d9c <sys_unlink+0xde>
    80004e6c:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004e6e:	8526                	mv	a0,s1
    80004e70:	ffffe097          	auipc	ra,0xffffe
    80004e74:	23a080e7          	jalr	570(ra) # 800030aa <iunlockput>
  end_op();
    80004e78:	fffff097          	auipc	ra,0xfffff
    80004e7c:	a14080e7          	jalr	-1516(ra) # 8000388c <end_op>
  return -1;
    80004e80:	557d                	li	a0,-1
    80004e82:	64ee                	ld	s1,216(sp)
}
    80004e84:	70ae                	ld	ra,232(sp)
    80004e86:	740e                	ld	s0,224(sp)
    80004e88:	616d                	addi	sp,sp,240
    80004e8a:	8082                	ret
    return -1;
    80004e8c:	557d                	li	a0,-1
    80004e8e:	bfdd                	j	80004e84 <sys_unlink+0x1c6>
    iunlockput(ip);
    80004e90:	854a                	mv	a0,s2
    80004e92:	ffffe097          	auipc	ra,0xffffe
    80004e96:	218080e7          	jalr	536(ra) # 800030aa <iunlockput>
    goto bad;
    80004e9a:	694e                	ld	s2,208(sp)
    80004e9c:	69ae                	ld	s3,200(sp)
    80004e9e:	bfc1                	j	80004e6e <sys_unlink+0x1b0>

0000000080004ea0 <sys_open>:

uint64
sys_open(void)
{
    80004ea0:	7131                	addi	sp,sp,-192
    80004ea2:	fd06                	sd	ra,184(sp)
    80004ea4:	f922                	sd	s0,176(sp)
    80004ea6:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004ea8:	f4c40593          	addi	a1,s0,-180
    80004eac:	4505                	li	a0,1
    80004eae:	ffffd097          	auipc	ra,0xffffd
    80004eb2:	322080e7          	jalr	802(ra) # 800021d0 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004eb6:	08000613          	li	a2,128
    80004eba:	f5040593          	addi	a1,s0,-176
    80004ebe:	4501                	li	a0,0
    80004ec0:	ffffd097          	auipc	ra,0xffffd
    80004ec4:	350080e7          	jalr	848(ra) # 80002210 <argstr>
    80004ec8:	87aa                	mv	a5,a0
    return -1;
    80004eca:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004ecc:	0a07ce63          	bltz	a5,80004f88 <sys_open+0xe8>
    80004ed0:	f526                	sd	s1,168(sp)

  begin_op();
    80004ed2:	fffff097          	auipc	ra,0xfffff
    80004ed6:	940080e7          	jalr	-1728(ra) # 80003812 <begin_op>

  if(omode & O_CREATE){
    80004eda:	f4c42783          	lw	a5,-180(s0)
    80004ede:	2007f793          	andi	a5,a5,512
    80004ee2:	cfd5                	beqz	a5,80004f9e <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004ee4:	4681                	li	a3,0
    80004ee6:	4601                	li	a2,0
    80004ee8:	4589                	li	a1,2
    80004eea:	f5040513          	addi	a0,s0,-176
    80004eee:	00000097          	auipc	ra,0x0
    80004ef2:	95c080e7          	jalr	-1700(ra) # 8000484a <create>
    80004ef6:	84aa                	mv	s1,a0
    if(ip == 0){
    80004ef8:	cd41                	beqz	a0,80004f90 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004efa:	04449703          	lh	a4,68(s1)
    80004efe:	478d                	li	a5,3
    80004f00:	00f71763          	bne	a4,a5,80004f0e <sys_open+0x6e>
    80004f04:	0464d703          	lhu	a4,70(s1)
    80004f08:	47a5                	li	a5,9
    80004f0a:	0ee7e163          	bltu	a5,a4,80004fec <sys_open+0x14c>
    80004f0e:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004f10:	fffff097          	auipc	ra,0xfffff
    80004f14:	d10080e7          	jalr	-752(ra) # 80003c20 <filealloc>
    80004f18:	892a                	mv	s2,a0
    80004f1a:	c97d                	beqz	a0,80005010 <sys_open+0x170>
    80004f1c:	ed4e                	sd	s3,152(sp)
    80004f1e:	00000097          	auipc	ra,0x0
    80004f22:	8ea080e7          	jalr	-1814(ra) # 80004808 <fdalloc>
    80004f26:	89aa                	mv	s3,a0
    80004f28:	0c054e63          	bltz	a0,80005004 <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004f2c:	04449703          	lh	a4,68(s1)
    80004f30:	478d                	li	a5,3
    80004f32:	0ef70c63          	beq	a4,a5,8000502a <sys_open+0x18a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004f36:	4789                	li	a5,2
    80004f38:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004f3c:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004f40:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004f44:	f4c42783          	lw	a5,-180(s0)
    80004f48:	0017c713          	xori	a4,a5,1
    80004f4c:	8b05                	andi	a4,a4,1
    80004f4e:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004f52:	0037f713          	andi	a4,a5,3
    80004f56:	00e03733          	snez	a4,a4
    80004f5a:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004f5e:	4007f793          	andi	a5,a5,1024
    80004f62:	c791                	beqz	a5,80004f6e <sys_open+0xce>
    80004f64:	04449703          	lh	a4,68(s1)
    80004f68:	4789                	li	a5,2
    80004f6a:	0cf70763          	beq	a4,a5,80005038 <sys_open+0x198>
    itrunc(ip);
  }

  iunlock(ip);
    80004f6e:	8526                	mv	a0,s1
    80004f70:	ffffe097          	auipc	ra,0xffffe
    80004f74:	f9a080e7          	jalr	-102(ra) # 80002f0a <iunlock>
  end_op();
    80004f78:	fffff097          	auipc	ra,0xfffff
    80004f7c:	914080e7          	jalr	-1772(ra) # 8000388c <end_op>

  return fd;
    80004f80:	854e                	mv	a0,s3
    80004f82:	74aa                	ld	s1,168(sp)
    80004f84:	790a                	ld	s2,160(sp)
    80004f86:	69ea                	ld	s3,152(sp)
}
    80004f88:	70ea                	ld	ra,184(sp)
    80004f8a:	744a                	ld	s0,176(sp)
    80004f8c:	6129                	addi	sp,sp,192
    80004f8e:	8082                	ret
      end_op();
    80004f90:	fffff097          	auipc	ra,0xfffff
    80004f94:	8fc080e7          	jalr	-1796(ra) # 8000388c <end_op>
      return -1;
    80004f98:	557d                	li	a0,-1
    80004f9a:	74aa                	ld	s1,168(sp)
    80004f9c:	b7f5                	j	80004f88 <sys_open+0xe8>
    if((ip = namei(path)) == 0){
    80004f9e:	f5040513          	addi	a0,s0,-176
    80004fa2:	ffffe097          	auipc	ra,0xffffe
    80004fa6:	670080e7          	jalr	1648(ra) # 80003612 <namei>
    80004faa:	84aa                	mv	s1,a0
    80004fac:	c90d                	beqz	a0,80004fde <sys_open+0x13e>
    ilock(ip);
    80004fae:	ffffe097          	auipc	ra,0xffffe
    80004fb2:	e96080e7          	jalr	-362(ra) # 80002e44 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004fb6:	04449703          	lh	a4,68(s1)
    80004fba:	4785                	li	a5,1
    80004fbc:	f2f71fe3          	bne	a4,a5,80004efa <sys_open+0x5a>
    80004fc0:	f4c42783          	lw	a5,-180(s0)
    80004fc4:	d7a9                	beqz	a5,80004f0e <sys_open+0x6e>
      iunlockput(ip);
    80004fc6:	8526                	mv	a0,s1
    80004fc8:	ffffe097          	auipc	ra,0xffffe
    80004fcc:	0e2080e7          	jalr	226(ra) # 800030aa <iunlockput>
      end_op();
    80004fd0:	fffff097          	auipc	ra,0xfffff
    80004fd4:	8bc080e7          	jalr	-1860(ra) # 8000388c <end_op>
      return -1;
    80004fd8:	557d                	li	a0,-1
    80004fda:	74aa                	ld	s1,168(sp)
    80004fdc:	b775                	j	80004f88 <sys_open+0xe8>
      end_op();
    80004fde:	fffff097          	auipc	ra,0xfffff
    80004fe2:	8ae080e7          	jalr	-1874(ra) # 8000388c <end_op>
      return -1;
    80004fe6:	557d                	li	a0,-1
    80004fe8:	74aa                	ld	s1,168(sp)
    80004fea:	bf79                	j	80004f88 <sys_open+0xe8>
    iunlockput(ip);
    80004fec:	8526                	mv	a0,s1
    80004fee:	ffffe097          	auipc	ra,0xffffe
    80004ff2:	0bc080e7          	jalr	188(ra) # 800030aa <iunlockput>
    end_op();
    80004ff6:	fffff097          	auipc	ra,0xfffff
    80004ffa:	896080e7          	jalr	-1898(ra) # 8000388c <end_op>
    return -1;
    80004ffe:	557d                	li	a0,-1
    80005000:	74aa                	ld	s1,168(sp)
    80005002:	b759                	j	80004f88 <sys_open+0xe8>
      fileclose(f);
    80005004:	854a                	mv	a0,s2
    80005006:	fffff097          	auipc	ra,0xfffff
    8000500a:	cd6080e7          	jalr	-810(ra) # 80003cdc <fileclose>
    8000500e:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005010:	8526                	mv	a0,s1
    80005012:	ffffe097          	auipc	ra,0xffffe
    80005016:	098080e7          	jalr	152(ra) # 800030aa <iunlockput>
    end_op();
    8000501a:	fffff097          	auipc	ra,0xfffff
    8000501e:	872080e7          	jalr	-1934(ra) # 8000388c <end_op>
    return -1;
    80005022:	557d                	li	a0,-1
    80005024:	74aa                	ld	s1,168(sp)
    80005026:	790a                	ld	s2,160(sp)
    80005028:	b785                	j	80004f88 <sys_open+0xe8>
    f->type = FD_DEVICE;
    8000502a:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    8000502e:	04649783          	lh	a5,70(s1)
    80005032:	02f91223          	sh	a5,36(s2)
    80005036:	b729                	j	80004f40 <sys_open+0xa0>
    itrunc(ip);
    80005038:	8526                	mv	a0,s1
    8000503a:	ffffe097          	auipc	ra,0xffffe
    8000503e:	f1c080e7          	jalr	-228(ra) # 80002f56 <itrunc>
    80005042:	b735                	j	80004f6e <sys_open+0xce>

0000000080005044 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005044:	7175                	addi	sp,sp,-144
    80005046:	e506                	sd	ra,136(sp)
    80005048:	e122                	sd	s0,128(sp)
    8000504a:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000504c:	ffffe097          	auipc	ra,0xffffe
    80005050:	7c6080e7          	jalr	1990(ra) # 80003812 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005054:	08000613          	li	a2,128
    80005058:	f7040593          	addi	a1,s0,-144
    8000505c:	4501                	li	a0,0
    8000505e:	ffffd097          	auipc	ra,0xffffd
    80005062:	1b2080e7          	jalr	434(ra) # 80002210 <argstr>
    80005066:	02054963          	bltz	a0,80005098 <sys_mkdir+0x54>
    8000506a:	4681                	li	a3,0
    8000506c:	4601                	li	a2,0
    8000506e:	4585                	li	a1,1
    80005070:	f7040513          	addi	a0,s0,-144
    80005074:	fffff097          	auipc	ra,0xfffff
    80005078:	7d6080e7          	jalr	2006(ra) # 8000484a <create>
    8000507c:	cd11                	beqz	a0,80005098 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000507e:	ffffe097          	auipc	ra,0xffffe
    80005082:	02c080e7          	jalr	44(ra) # 800030aa <iunlockput>
  end_op();
    80005086:	fffff097          	auipc	ra,0xfffff
    8000508a:	806080e7          	jalr	-2042(ra) # 8000388c <end_op>
  return 0;
    8000508e:	4501                	li	a0,0
}
    80005090:	60aa                	ld	ra,136(sp)
    80005092:	640a                	ld	s0,128(sp)
    80005094:	6149                	addi	sp,sp,144
    80005096:	8082                	ret
    end_op();
    80005098:	ffffe097          	auipc	ra,0xffffe
    8000509c:	7f4080e7          	jalr	2036(ra) # 8000388c <end_op>
    return -1;
    800050a0:	557d                	li	a0,-1
    800050a2:	b7fd                	j	80005090 <sys_mkdir+0x4c>

00000000800050a4 <sys_mknod>:

uint64
sys_mknod(void)
{
    800050a4:	7135                	addi	sp,sp,-160
    800050a6:	ed06                	sd	ra,152(sp)
    800050a8:	e922                	sd	s0,144(sp)
    800050aa:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800050ac:	ffffe097          	auipc	ra,0xffffe
    800050b0:	766080e7          	jalr	1894(ra) # 80003812 <begin_op>
  argint(1, &major);
    800050b4:	f6c40593          	addi	a1,s0,-148
    800050b8:	4505                	li	a0,1
    800050ba:	ffffd097          	auipc	ra,0xffffd
    800050be:	116080e7          	jalr	278(ra) # 800021d0 <argint>
  argint(2, &minor);
    800050c2:	f6840593          	addi	a1,s0,-152
    800050c6:	4509                	li	a0,2
    800050c8:	ffffd097          	auipc	ra,0xffffd
    800050cc:	108080e7          	jalr	264(ra) # 800021d0 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800050d0:	08000613          	li	a2,128
    800050d4:	f7040593          	addi	a1,s0,-144
    800050d8:	4501                	li	a0,0
    800050da:	ffffd097          	auipc	ra,0xffffd
    800050de:	136080e7          	jalr	310(ra) # 80002210 <argstr>
    800050e2:	02054b63          	bltz	a0,80005118 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800050e6:	f6841683          	lh	a3,-152(s0)
    800050ea:	f6c41603          	lh	a2,-148(s0)
    800050ee:	458d                	li	a1,3
    800050f0:	f7040513          	addi	a0,s0,-144
    800050f4:	fffff097          	auipc	ra,0xfffff
    800050f8:	756080e7          	jalr	1878(ra) # 8000484a <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800050fc:	cd11                	beqz	a0,80005118 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800050fe:	ffffe097          	auipc	ra,0xffffe
    80005102:	fac080e7          	jalr	-84(ra) # 800030aa <iunlockput>
  end_op();
    80005106:	ffffe097          	auipc	ra,0xffffe
    8000510a:	786080e7          	jalr	1926(ra) # 8000388c <end_op>
  return 0;
    8000510e:	4501                	li	a0,0
}
    80005110:	60ea                	ld	ra,152(sp)
    80005112:	644a                	ld	s0,144(sp)
    80005114:	610d                	addi	sp,sp,160
    80005116:	8082                	ret
    end_op();
    80005118:	ffffe097          	auipc	ra,0xffffe
    8000511c:	774080e7          	jalr	1908(ra) # 8000388c <end_op>
    return -1;
    80005120:	557d                	li	a0,-1
    80005122:	b7fd                	j	80005110 <sys_mknod+0x6c>

0000000080005124 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005124:	7135                	addi	sp,sp,-160
    80005126:	ed06                	sd	ra,152(sp)
    80005128:	e922                	sd	s0,144(sp)
    8000512a:	e14a                	sd	s2,128(sp)
    8000512c:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000512e:	ffffc097          	auipc	ra,0xffffc
    80005132:	ed2080e7          	jalr	-302(ra) # 80001000 <myproc>
    80005136:	892a                	mv	s2,a0
  
  begin_op();
    80005138:	ffffe097          	auipc	ra,0xffffe
    8000513c:	6da080e7          	jalr	1754(ra) # 80003812 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005140:	08000613          	li	a2,128
    80005144:	f6040593          	addi	a1,s0,-160
    80005148:	4501                	li	a0,0
    8000514a:	ffffd097          	auipc	ra,0xffffd
    8000514e:	0c6080e7          	jalr	198(ra) # 80002210 <argstr>
    80005152:	04054d63          	bltz	a0,800051ac <sys_chdir+0x88>
    80005156:	e526                	sd	s1,136(sp)
    80005158:	f6040513          	addi	a0,s0,-160
    8000515c:	ffffe097          	auipc	ra,0xffffe
    80005160:	4b6080e7          	jalr	1206(ra) # 80003612 <namei>
    80005164:	84aa                	mv	s1,a0
    80005166:	c131                	beqz	a0,800051aa <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005168:	ffffe097          	auipc	ra,0xffffe
    8000516c:	cdc080e7          	jalr	-804(ra) # 80002e44 <ilock>
  if(ip->type != T_DIR){
    80005170:	04449703          	lh	a4,68(s1)
    80005174:	4785                	li	a5,1
    80005176:	04f71163          	bne	a4,a5,800051b8 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000517a:	8526                	mv	a0,s1
    8000517c:	ffffe097          	auipc	ra,0xffffe
    80005180:	d8e080e7          	jalr	-626(ra) # 80002f0a <iunlock>
  iput(p->cwd);
    80005184:	15893503          	ld	a0,344(s2)
    80005188:	ffffe097          	auipc	ra,0xffffe
    8000518c:	e7a080e7          	jalr	-390(ra) # 80003002 <iput>
  end_op();
    80005190:	ffffe097          	auipc	ra,0xffffe
    80005194:	6fc080e7          	jalr	1788(ra) # 8000388c <end_op>
  p->cwd = ip;
    80005198:	14993c23          	sd	s1,344(s2)
  return 0;
    8000519c:	4501                	li	a0,0
    8000519e:	64aa                	ld	s1,136(sp)
}
    800051a0:	60ea                	ld	ra,152(sp)
    800051a2:	644a                	ld	s0,144(sp)
    800051a4:	690a                	ld	s2,128(sp)
    800051a6:	610d                	addi	sp,sp,160
    800051a8:	8082                	ret
    800051aa:	64aa                	ld	s1,136(sp)
    end_op();
    800051ac:	ffffe097          	auipc	ra,0xffffe
    800051b0:	6e0080e7          	jalr	1760(ra) # 8000388c <end_op>
    return -1;
    800051b4:	557d                	li	a0,-1
    800051b6:	b7ed                	j	800051a0 <sys_chdir+0x7c>
    iunlockput(ip);
    800051b8:	8526                	mv	a0,s1
    800051ba:	ffffe097          	auipc	ra,0xffffe
    800051be:	ef0080e7          	jalr	-272(ra) # 800030aa <iunlockput>
    end_op();
    800051c2:	ffffe097          	auipc	ra,0xffffe
    800051c6:	6ca080e7          	jalr	1738(ra) # 8000388c <end_op>
    return -1;
    800051ca:	557d                	li	a0,-1
    800051cc:	64aa                	ld	s1,136(sp)
    800051ce:	bfc9                	j	800051a0 <sys_chdir+0x7c>

00000000800051d0 <sys_exec>:

uint64
sys_exec(void)
{
    800051d0:	7121                	addi	sp,sp,-448
    800051d2:	ff06                	sd	ra,440(sp)
    800051d4:	fb22                	sd	s0,432(sp)
    800051d6:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800051d8:	e4840593          	addi	a1,s0,-440
    800051dc:	4505                	li	a0,1
    800051de:	ffffd097          	auipc	ra,0xffffd
    800051e2:	012080e7          	jalr	18(ra) # 800021f0 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800051e6:	08000613          	li	a2,128
    800051ea:	f5040593          	addi	a1,s0,-176
    800051ee:	4501                	li	a0,0
    800051f0:	ffffd097          	auipc	ra,0xffffd
    800051f4:	020080e7          	jalr	32(ra) # 80002210 <argstr>
    800051f8:	87aa                	mv	a5,a0
    return -1;
    800051fa:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800051fc:	0e07c263          	bltz	a5,800052e0 <sys_exec+0x110>
    80005200:	f726                	sd	s1,424(sp)
    80005202:	f34a                	sd	s2,416(sp)
    80005204:	ef4e                	sd	s3,408(sp)
    80005206:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005208:	10000613          	li	a2,256
    8000520c:	4581                	li	a1,0
    8000520e:	e5040513          	addi	a0,s0,-432
    80005212:	ffffb097          	auipc	ra,0xffffb
    80005216:	f68080e7          	jalr	-152(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000521a:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    8000521e:	89a6                	mv	s3,s1
    80005220:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005222:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005226:	00391513          	slli	a0,s2,0x3
    8000522a:	e4040593          	addi	a1,s0,-448
    8000522e:	e4843783          	ld	a5,-440(s0)
    80005232:	953e                	add	a0,a0,a5
    80005234:	ffffd097          	auipc	ra,0xffffd
    80005238:	efe080e7          	jalr	-258(ra) # 80002132 <fetchaddr>
    8000523c:	02054a63          	bltz	a0,80005270 <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80005240:	e4043783          	ld	a5,-448(s0)
    80005244:	c7b9                	beqz	a5,80005292 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005246:	ffffb097          	auipc	ra,0xffffb
    8000524a:	ed4080e7          	jalr	-300(ra) # 8000011a <kalloc>
    8000524e:	85aa                	mv	a1,a0
    80005250:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005254:	cd11                	beqz	a0,80005270 <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005256:	6605                	lui	a2,0x1
    80005258:	e4043503          	ld	a0,-448(s0)
    8000525c:	ffffd097          	auipc	ra,0xffffd
    80005260:	f28080e7          	jalr	-216(ra) # 80002184 <fetchstr>
    80005264:	00054663          	bltz	a0,80005270 <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    80005268:	0905                	addi	s2,s2,1
    8000526a:	09a1                	addi	s3,s3,8
    8000526c:	fb491de3          	bne	s2,s4,80005226 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005270:	f5040913          	addi	s2,s0,-176
    80005274:	6088                	ld	a0,0(s1)
    80005276:	c125                	beqz	a0,800052d6 <sys_exec+0x106>
    kfree(argv[i]);
    80005278:	ffffb097          	auipc	ra,0xffffb
    8000527c:	da4080e7          	jalr	-604(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005280:	04a1                	addi	s1,s1,8
    80005282:	ff2499e3          	bne	s1,s2,80005274 <sys_exec+0xa4>
  return -1;
    80005286:	557d                	li	a0,-1
    80005288:	74ba                	ld	s1,424(sp)
    8000528a:	791a                	ld	s2,416(sp)
    8000528c:	69fa                	ld	s3,408(sp)
    8000528e:	6a5a                	ld	s4,400(sp)
    80005290:	a881                	j	800052e0 <sys_exec+0x110>
      argv[i] = 0;
    80005292:	0009079b          	sext.w	a5,s2
    80005296:	078e                	slli	a5,a5,0x3
    80005298:	fd078793          	addi	a5,a5,-48
    8000529c:	97a2                	add	a5,a5,s0
    8000529e:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    800052a2:	e5040593          	addi	a1,s0,-432
    800052a6:	f5040513          	addi	a0,s0,-176
    800052aa:	fffff097          	auipc	ra,0xfffff
    800052ae:	108080e7          	jalr	264(ra) # 800043b2 <exec>
    800052b2:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800052b4:	f5040993          	addi	s3,s0,-176
    800052b8:	6088                	ld	a0,0(s1)
    800052ba:	c901                	beqz	a0,800052ca <sys_exec+0xfa>
    kfree(argv[i]);
    800052bc:	ffffb097          	auipc	ra,0xffffb
    800052c0:	d60080e7          	jalr	-672(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800052c4:	04a1                	addi	s1,s1,8
    800052c6:	ff3499e3          	bne	s1,s3,800052b8 <sys_exec+0xe8>
  return ret;
    800052ca:	854a                	mv	a0,s2
    800052cc:	74ba                	ld	s1,424(sp)
    800052ce:	791a                	ld	s2,416(sp)
    800052d0:	69fa                	ld	s3,408(sp)
    800052d2:	6a5a                	ld	s4,400(sp)
    800052d4:	a031                	j	800052e0 <sys_exec+0x110>
  return -1;
    800052d6:	557d                	li	a0,-1
    800052d8:	74ba                	ld	s1,424(sp)
    800052da:	791a                	ld	s2,416(sp)
    800052dc:	69fa                	ld	s3,408(sp)
    800052de:	6a5a                	ld	s4,400(sp)
}
    800052e0:	70fa                	ld	ra,440(sp)
    800052e2:	745a                	ld	s0,432(sp)
    800052e4:	6139                	addi	sp,sp,448
    800052e6:	8082                	ret

00000000800052e8 <sys_pipe>:

uint64
sys_pipe(void)
{
    800052e8:	7139                	addi	sp,sp,-64
    800052ea:	fc06                	sd	ra,56(sp)
    800052ec:	f822                	sd	s0,48(sp)
    800052ee:	f426                	sd	s1,40(sp)
    800052f0:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800052f2:	ffffc097          	auipc	ra,0xffffc
    800052f6:	d0e080e7          	jalr	-754(ra) # 80001000 <myproc>
    800052fa:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800052fc:	fd840593          	addi	a1,s0,-40
    80005300:	4501                	li	a0,0
    80005302:	ffffd097          	auipc	ra,0xffffd
    80005306:	eee080e7          	jalr	-274(ra) # 800021f0 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000530a:	fc840593          	addi	a1,s0,-56
    8000530e:	fd040513          	addi	a0,s0,-48
    80005312:	fffff097          	auipc	ra,0xfffff
    80005316:	d38080e7          	jalr	-712(ra) # 8000404a <pipealloc>
    return -1;
    8000531a:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000531c:	0c054463          	bltz	a0,800053e4 <sys_pipe+0xfc>
  fd0 = -1;
    80005320:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005324:	fd043503          	ld	a0,-48(s0)
    80005328:	fffff097          	auipc	ra,0xfffff
    8000532c:	4e0080e7          	jalr	1248(ra) # 80004808 <fdalloc>
    80005330:	fca42223          	sw	a0,-60(s0)
    80005334:	08054b63          	bltz	a0,800053ca <sys_pipe+0xe2>
    80005338:	fc843503          	ld	a0,-56(s0)
    8000533c:	fffff097          	auipc	ra,0xfffff
    80005340:	4cc080e7          	jalr	1228(ra) # 80004808 <fdalloc>
    80005344:	fca42023          	sw	a0,-64(s0)
    80005348:	06054863          	bltz	a0,800053b8 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000534c:	4691                	li	a3,4
    8000534e:	fc440613          	addi	a2,s0,-60
    80005352:	fd843583          	ld	a1,-40(s0)
    80005356:	68a8                	ld	a0,80(s1)
    80005358:	ffffb097          	auipc	ra,0xffffb
    8000535c:	7f4080e7          	jalr	2036(ra) # 80000b4c <copyout>
    80005360:	02054063          	bltz	a0,80005380 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005364:	4691                	li	a3,4
    80005366:	fc040613          	addi	a2,s0,-64
    8000536a:	fd843583          	ld	a1,-40(s0)
    8000536e:	0591                	addi	a1,a1,4
    80005370:	68a8                	ld	a0,80(s1)
    80005372:	ffffb097          	auipc	ra,0xffffb
    80005376:	7da080e7          	jalr	2010(ra) # 80000b4c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000537a:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000537c:	06055463          	bgez	a0,800053e4 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005380:	fc442783          	lw	a5,-60(s0)
    80005384:	07e9                	addi	a5,a5,26
    80005386:	078e                	slli	a5,a5,0x3
    80005388:	97a6                	add	a5,a5,s1
    8000538a:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    8000538e:	fc042783          	lw	a5,-64(s0)
    80005392:	07e9                	addi	a5,a5,26
    80005394:	078e                	slli	a5,a5,0x3
    80005396:	94be                	add	s1,s1,a5
    80005398:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    8000539c:	fd043503          	ld	a0,-48(s0)
    800053a0:	fffff097          	auipc	ra,0xfffff
    800053a4:	93c080e7          	jalr	-1732(ra) # 80003cdc <fileclose>
    fileclose(wf);
    800053a8:	fc843503          	ld	a0,-56(s0)
    800053ac:	fffff097          	auipc	ra,0xfffff
    800053b0:	930080e7          	jalr	-1744(ra) # 80003cdc <fileclose>
    return -1;
    800053b4:	57fd                	li	a5,-1
    800053b6:	a03d                	j	800053e4 <sys_pipe+0xfc>
    if(fd0 >= 0)
    800053b8:	fc442783          	lw	a5,-60(s0)
    800053bc:	0007c763          	bltz	a5,800053ca <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    800053c0:	07e9                	addi	a5,a5,26
    800053c2:	078e                	slli	a5,a5,0x3
    800053c4:	97a6                	add	a5,a5,s1
    800053c6:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    800053ca:	fd043503          	ld	a0,-48(s0)
    800053ce:	fffff097          	auipc	ra,0xfffff
    800053d2:	90e080e7          	jalr	-1778(ra) # 80003cdc <fileclose>
    fileclose(wf);
    800053d6:	fc843503          	ld	a0,-56(s0)
    800053da:	fffff097          	auipc	ra,0xfffff
    800053de:	902080e7          	jalr	-1790(ra) # 80003cdc <fileclose>
    return -1;
    800053e2:	57fd                	li	a5,-1
}
    800053e4:	853e                	mv	a0,a5
    800053e6:	70e2                	ld	ra,56(sp)
    800053e8:	7442                	ld	s0,48(sp)
    800053ea:	74a2                	ld	s1,40(sp)
    800053ec:	6121                	addi	sp,sp,64
    800053ee:	8082                	ret

00000000800053f0 <kernelvec>:
    800053f0:	7111                	addi	sp,sp,-256
    800053f2:	e006                	sd	ra,0(sp)
    800053f4:	e40a                	sd	sp,8(sp)
    800053f6:	e80e                	sd	gp,16(sp)
    800053f8:	ec12                	sd	tp,24(sp)
    800053fa:	f016                	sd	t0,32(sp)
    800053fc:	f41a                	sd	t1,40(sp)
    800053fe:	f81e                	sd	t2,48(sp)
    80005400:	fc22                	sd	s0,56(sp)
    80005402:	e0a6                	sd	s1,64(sp)
    80005404:	e4aa                	sd	a0,72(sp)
    80005406:	e8ae                	sd	a1,80(sp)
    80005408:	ecb2                	sd	a2,88(sp)
    8000540a:	f0b6                	sd	a3,96(sp)
    8000540c:	f4ba                	sd	a4,104(sp)
    8000540e:	f8be                	sd	a5,112(sp)
    80005410:	fcc2                	sd	a6,120(sp)
    80005412:	e146                	sd	a7,128(sp)
    80005414:	e54a                	sd	s2,136(sp)
    80005416:	e94e                	sd	s3,144(sp)
    80005418:	ed52                	sd	s4,152(sp)
    8000541a:	f156                	sd	s5,160(sp)
    8000541c:	f55a                	sd	s6,168(sp)
    8000541e:	f95e                	sd	s7,176(sp)
    80005420:	fd62                	sd	s8,184(sp)
    80005422:	e1e6                	sd	s9,192(sp)
    80005424:	e5ea                	sd	s10,200(sp)
    80005426:	e9ee                	sd	s11,208(sp)
    80005428:	edf2                	sd	t3,216(sp)
    8000542a:	f1f6                	sd	t4,224(sp)
    8000542c:	f5fa                	sd	t5,232(sp)
    8000542e:	f9fe                	sd	t6,240(sp)
    80005430:	bcffc0ef          	jal	80001ffe <kerneltrap>
    80005434:	6082                	ld	ra,0(sp)
    80005436:	6122                	ld	sp,8(sp)
    80005438:	61c2                	ld	gp,16(sp)
    8000543a:	7282                	ld	t0,32(sp)
    8000543c:	7322                	ld	t1,40(sp)
    8000543e:	73c2                	ld	t2,48(sp)
    80005440:	7462                	ld	s0,56(sp)
    80005442:	6486                	ld	s1,64(sp)
    80005444:	6526                	ld	a0,72(sp)
    80005446:	65c6                	ld	a1,80(sp)
    80005448:	6666                	ld	a2,88(sp)
    8000544a:	7686                	ld	a3,96(sp)
    8000544c:	7726                	ld	a4,104(sp)
    8000544e:	77c6                	ld	a5,112(sp)
    80005450:	7866                	ld	a6,120(sp)
    80005452:	688a                	ld	a7,128(sp)
    80005454:	692a                	ld	s2,136(sp)
    80005456:	69ca                	ld	s3,144(sp)
    80005458:	6a6a                	ld	s4,152(sp)
    8000545a:	7a8a                	ld	s5,160(sp)
    8000545c:	7b2a                	ld	s6,168(sp)
    8000545e:	7bca                	ld	s7,176(sp)
    80005460:	7c6a                	ld	s8,184(sp)
    80005462:	6c8e                	ld	s9,192(sp)
    80005464:	6d2e                	ld	s10,200(sp)
    80005466:	6dce                	ld	s11,208(sp)
    80005468:	6e6e                	ld	t3,216(sp)
    8000546a:	7e8e                	ld	t4,224(sp)
    8000546c:	7f2e                	ld	t5,232(sp)
    8000546e:	7fce                	ld	t6,240(sp)
    80005470:	6111                	addi	sp,sp,256
    80005472:	10200073          	sret
    80005476:	00000013          	nop
    8000547a:	00000013          	nop
    8000547e:	0001                	nop

0000000080005480 <timervec>:
    80005480:	34051573          	csrrw	a0,mscratch,a0
    80005484:	e10c                	sd	a1,0(a0)
    80005486:	e510                	sd	a2,8(a0)
    80005488:	e914                	sd	a3,16(a0)
    8000548a:	6d0c                	ld	a1,24(a0)
    8000548c:	7110                	ld	a2,32(a0)
    8000548e:	6194                	ld	a3,0(a1)
    80005490:	96b2                	add	a3,a3,a2
    80005492:	e194                	sd	a3,0(a1)
    80005494:	4589                	li	a1,2
    80005496:	14459073          	csrw	sip,a1
    8000549a:	6914                	ld	a3,16(a0)
    8000549c:	6510                	ld	a2,8(a0)
    8000549e:	610c                	ld	a1,0(a0)
    800054a0:	34051573          	csrrw	a0,mscratch,a0
    800054a4:	30200073          	mret
	...

00000000800054aa <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800054aa:	1141                	addi	sp,sp,-16
    800054ac:	e422                	sd	s0,8(sp)
    800054ae:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800054b0:	0c0007b7          	lui	a5,0xc000
    800054b4:	4705                	li	a4,1
    800054b6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800054b8:	0c0007b7          	lui	a5,0xc000
    800054bc:	c3d8                	sw	a4,4(a5)
}
    800054be:	6422                	ld	s0,8(sp)
    800054c0:	0141                	addi	sp,sp,16
    800054c2:	8082                	ret

00000000800054c4 <plicinithart>:

void
plicinithart(void)
{
    800054c4:	1141                	addi	sp,sp,-16
    800054c6:	e406                	sd	ra,8(sp)
    800054c8:	e022                	sd	s0,0(sp)
    800054ca:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800054cc:	ffffc097          	auipc	ra,0xffffc
    800054d0:	b08080e7          	jalr	-1272(ra) # 80000fd4 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800054d4:	0085171b          	slliw	a4,a0,0x8
    800054d8:	0c0027b7          	lui	a5,0xc002
    800054dc:	97ba                	add	a5,a5,a4
    800054de:	40200713          	li	a4,1026
    800054e2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800054e6:	00d5151b          	slliw	a0,a0,0xd
    800054ea:	0c2017b7          	lui	a5,0xc201
    800054ee:	97aa                	add	a5,a5,a0
    800054f0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800054f4:	60a2                	ld	ra,8(sp)
    800054f6:	6402                	ld	s0,0(sp)
    800054f8:	0141                	addi	sp,sp,16
    800054fa:	8082                	ret

00000000800054fc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800054fc:	1141                	addi	sp,sp,-16
    800054fe:	e406                	sd	ra,8(sp)
    80005500:	e022                	sd	s0,0(sp)
    80005502:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005504:	ffffc097          	auipc	ra,0xffffc
    80005508:	ad0080e7          	jalr	-1328(ra) # 80000fd4 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000550c:	00d5151b          	slliw	a0,a0,0xd
    80005510:	0c2017b7          	lui	a5,0xc201
    80005514:	97aa                	add	a5,a5,a0
  return irq;
}
    80005516:	43c8                	lw	a0,4(a5)
    80005518:	60a2                	ld	ra,8(sp)
    8000551a:	6402                	ld	s0,0(sp)
    8000551c:	0141                	addi	sp,sp,16
    8000551e:	8082                	ret

0000000080005520 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005520:	1101                	addi	sp,sp,-32
    80005522:	ec06                	sd	ra,24(sp)
    80005524:	e822                	sd	s0,16(sp)
    80005526:	e426                	sd	s1,8(sp)
    80005528:	1000                	addi	s0,sp,32
    8000552a:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000552c:	ffffc097          	auipc	ra,0xffffc
    80005530:	aa8080e7          	jalr	-1368(ra) # 80000fd4 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005534:	00d5151b          	slliw	a0,a0,0xd
    80005538:	0c2017b7          	lui	a5,0xc201
    8000553c:	97aa                	add	a5,a5,a0
    8000553e:	c3c4                	sw	s1,4(a5)
}
    80005540:	60e2                	ld	ra,24(sp)
    80005542:	6442                	ld	s0,16(sp)
    80005544:	64a2                	ld	s1,8(sp)
    80005546:	6105                	addi	sp,sp,32
    80005548:	8082                	ret

000000008000554a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000554a:	1141                	addi	sp,sp,-16
    8000554c:	e406                	sd	ra,8(sp)
    8000554e:	e022                	sd	s0,0(sp)
    80005550:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005552:	479d                	li	a5,7
    80005554:	04a7cc63          	blt	a5,a0,800055ac <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005558:	00017797          	auipc	a5,0x17
    8000555c:	10878793          	addi	a5,a5,264 # 8001c660 <disk>
    80005560:	97aa                	add	a5,a5,a0
    80005562:	0187c783          	lbu	a5,24(a5)
    80005566:	ebb9                	bnez	a5,800055bc <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005568:	00451693          	slli	a3,a0,0x4
    8000556c:	00017797          	auipc	a5,0x17
    80005570:	0f478793          	addi	a5,a5,244 # 8001c660 <disk>
    80005574:	6398                	ld	a4,0(a5)
    80005576:	9736                	add	a4,a4,a3
    80005578:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    8000557c:	6398                	ld	a4,0(a5)
    8000557e:	9736                	add	a4,a4,a3
    80005580:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005584:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005588:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    8000558c:	97aa                	add	a5,a5,a0
    8000558e:	4705                	li	a4,1
    80005590:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005594:	00017517          	auipc	a0,0x17
    80005598:	0e450513          	addi	a0,a0,228 # 8001c678 <disk+0x18>
    8000559c:	ffffc097          	auipc	ra,0xffffc
    800055a0:	222080e7          	jalr	546(ra) # 800017be <wakeup>
}
    800055a4:	60a2                	ld	ra,8(sp)
    800055a6:	6402                	ld	s0,0(sp)
    800055a8:	0141                	addi	sp,sp,16
    800055aa:	8082                	ret
    panic("free_desc 1");
    800055ac:	00003517          	auipc	a0,0x3
    800055b0:	0bc50513          	addi	a0,a0,188 # 80008668 <etext+0x668>
    800055b4:	00001097          	auipc	ra,0x1
    800055b8:	a6e080e7          	jalr	-1426(ra) # 80006022 <panic>
    panic("free_desc 2");
    800055bc:	00003517          	auipc	a0,0x3
    800055c0:	0bc50513          	addi	a0,a0,188 # 80008678 <etext+0x678>
    800055c4:	00001097          	auipc	ra,0x1
    800055c8:	a5e080e7          	jalr	-1442(ra) # 80006022 <panic>

00000000800055cc <virtio_disk_init>:
{
    800055cc:	1101                	addi	sp,sp,-32
    800055ce:	ec06                	sd	ra,24(sp)
    800055d0:	e822                	sd	s0,16(sp)
    800055d2:	e426                	sd	s1,8(sp)
    800055d4:	e04a                	sd	s2,0(sp)
    800055d6:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800055d8:	00003597          	auipc	a1,0x3
    800055dc:	0b058593          	addi	a1,a1,176 # 80008688 <etext+0x688>
    800055e0:	00017517          	auipc	a0,0x17
    800055e4:	1a850513          	addi	a0,a0,424 # 8001c788 <disk+0x128>
    800055e8:	00001097          	auipc	ra,0x1
    800055ec:	f24080e7          	jalr	-220(ra) # 8000650c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800055f0:	100017b7          	lui	a5,0x10001
    800055f4:	4398                	lw	a4,0(a5)
    800055f6:	2701                	sext.w	a4,a4
    800055f8:	747277b7          	lui	a5,0x74727
    800055fc:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005600:	18f71c63          	bne	a4,a5,80005798 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005604:	100017b7          	lui	a5,0x10001
    80005608:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    8000560a:	439c                	lw	a5,0(a5)
    8000560c:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000560e:	4709                	li	a4,2
    80005610:	18e79463          	bne	a5,a4,80005798 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005614:	100017b7          	lui	a5,0x10001
    80005618:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    8000561a:	439c                	lw	a5,0(a5)
    8000561c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000561e:	16e79d63          	bne	a5,a4,80005798 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005622:	100017b7          	lui	a5,0x10001
    80005626:	47d8                	lw	a4,12(a5)
    80005628:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000562a:	554d47b7          	lui	a5,0x554d4
    8000562e:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005632:	16f71363          	bne	a4,a5,80005798 <virtio_disk_init+0x1cc>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005636:	100017b7          	lui	a5,0x10001
    8000563a:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000563e:	4705                	li	a4,1
    80005640:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005642:	470d                	li	a4,3
    80005644:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005646:	10001737          	lui	a4,0x10001
    8000564a:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000564c:	c7ffe737          	lui	a4,0xc7ffe
    80005650:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd9d7f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005654:	8ef9                	and	a3,a3,a4
    80005656:	10001737          	lui	a4,0x10001
    8000565a:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000565c:	472d                	li	a4,11
    8000565e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005660:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80005664:	439c                	lw	a5,0(a5)
    80005666:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000566a:	8ba1                	andi	a5,a5,8
    8000566c:	12078e63          	beqz	a5,800057a8 <virtio_disk_init+0x1dc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005670:	100017b7          	lui	a5,0x10001
    80005674:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005678:	100017b7          	lui	a5,0x10001
    8000567c:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80005680:	439c                	lw	a5,0(a5)
    80005682:	2781                	sext.w	a5,a5
    80005684:	12079a63          	bnez	a5,800057b8 <virtio_disk_init+0x1ec>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005688:	100017b7          	lui	a5,0x10001
    8000568c:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80005690:	439c                	lw	a5,0(a5)
    80005692:	2781                	sext.w	a5,a5
  if(max == 0)
    80005694:	12078a63          	beqz	a5,800057c8 <virtio_disk_init+0x1fc>
  if(max < NUM)
    80005698:	471d                	li	a4,7
    8000569a:	12f77f63          	bgeu	a4,a5,800057d8 <virtio_disk_init+0x20c>
  disk.desc = kalloc();
    8000569e:	ffffb097          	auipc	ra,0xffffb
    800056a2:	a7c080e7          	jalr	-1412(ra) # 8000011a <kalloc>
    800056a6:	00017497          	auipc	s1,0x17
    800056aa:	fba48493          	addi	s1,s1,-70 # 8001c660 <disk>
    800056ae:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800056b0:	ffffb097          	auipc	ra,0xffffb
    800056b4:	a6a080e7          	jalr	-1430(ra) # 8000011a <kalloc>
    800056b8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800056ba:	ffffb097          	auipc	ra,0xffffb
    800056be:	a60080e7          	jalr	-1440(ra) # 8000011a <kalloc>
    800056c2:	87aa                	mv	a5,a0
    800056c4:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800056c6:	6088                	ld	a0,0(s1)
    800056c8:	12050063          	beqz	a0,800057e8 <virtio_disk_init+0x21c>
    800056cc:	00017717          	auipc	a4,0x17
    800056d0:	f9c73703          	ld	a4,-100(a4) # 8001c668 <disk+0x8>
    800056d4:	10070a63          	beqz	a4,800057e8 <virtio_disk_init+0x21c>
    800056d8:	10078863          	beqz	a5,800057e8 <virtio_disk_init+0x21c>
  memset(disk.desc, 0, PGSIZE);
    800056dc:	6605                	lui	a2,0x1
    800056de:	4581                	li	a1,0
    800056e0:	ffffb097          	auipc	ra,0xffffb
    800056e4:	a9a080e7          	jalr	-1382(ra) # 8000017a <memset>
  memset(disk.avail, 0, PGSIZE);
    800056e8:	00017497          	auipc	s1,0x17
    800056ec:	f7848493          	addi	s1,s1,-136 # 8001c660 <disk>
    800056f0:	6605                	lui	a2,0x1
    800056f2:	4581                	li	a1,0
    800056f4:	6488                	ld	a0,8(s1)
    800056f6:	ffffb097          	auipc	ra,0xffffb
    800056fa:	a84080e7          	jalr	-1404(ra) # 8000017a <memset>
  memset(disk.used, 0, PGSIZE);
    800056fe:	6605                	lui	a2,0x1
    80005700:	4581                	li	a1,0
    80005702:	6888                	ld	a0,16(s1)
    80005704:	ffffb097          	auipc	ra,0xffffb
    80005708:	a76080e7          	jalr	-1418(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000570c:	100017b7          	lui	a5,0x10001
    80005710:	4721                	li	a4,8
    80005712:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005714:	4098                	lw	a4,0(s1)
    80005716:	100017b7          	lui	a5,0x10001
    8000571a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    8000571e:	40d8                	lw	a4,4(s1)
    80005720:	100017b7          	lui	a5,0x10001
    80005724:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005728:	649c                	ld	a5,8(s1)
    8000572a:	0007869b          	sext.w	a3,a5
    8000572e:	10001737          	lui	a4,0x10001
    80005732:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005736:	9781                	srai	a5,a5,0x20
    80005738:	10001737          	lui	a4,0x10001
    8000573c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005740:	689c                	ld	a5,16(s1)
    80005742:	0007869b          	sext.w	a3,a5
    80005746:	10001737          	lui	a4,0x10001
    8000574a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000574e:	9781                	srai	a5,a5,0x20
    80005750:	10001737          	lui	a4,0x10001
    80005754:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005758:	10001737          	lui	a4,0x10001
    8000575c:	4785                	li	a5,1
    8000575e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005760:	00f48c23          	sb	a5,24(s1)
    80005764:	00f48ca3          	sb	a5,25(s1)
    80005768:	00f48d23          	sb	a5,26(s1)
    8000576c:	00f48da3          	sb	a5,27(s1)
    80005770:	00f48e23          	sb	a5,28(s1)
    80005774:	00f48ea3          	sb	a5,29(s1)
    80005778:	00f48f23          	sb	a5,30(s1)
    8000577c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005780:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005784:	100017b7          	lui	a5,0x10001
    80005788:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    8000578c:	60e2                	ld	ra,24(sp)
    8000578e:	6442                	ld	s0,16(sp)
    80005790:	64a2                	ld	s1,8(sp)
    80005792:	6902                	ld	s2,0(sp)
    80005794:	6105                	addi	sp,sp,32
    80005796:	8082                	ret
    panic("could not find virtio disk");
    80005798:	00003517          	auipc	a0,0x3
    8000579c:	f0050513          	addi	a0,a0,-256 # 80008698 <etext+0x698>
    800057a0:	00001097          	auipc	ra,0x1
    800057a4:	882080e7          	jalr	-1918(ra) # 80006022 <panic>
    panic("virtio disk FEATURES_OK unset");
    800057a8:	00003517          	auipc	a0,0x3
    800057ac:	f1050513          	addi	a0,a0,-240 # 800086b8 <etext+0x6b8>
    800057b0:	00001097          	auipc	ra,0x1
    800057b4:	872080e7          	jalr	-1934(ra) # 80006022 <panic>
    panic("virtio disk should not be ready");
    800057b8:	00003517          	auipc	a0,0x3
    800057bc:	f2050513          	addi	a0,a0,-224 # 800086d8 <etext+0x6d8>
    800057c0:	00001097          	auipc	ra,0x1
    800057c4:	862080e7          	jalr	-1950(ra) # 80006022 <panic>
    panic("virtio disk has no queue 0");
    800057c8:	00003517          	auipc	a0,0x3
    800057cc:	f3050513          	addi	a0,a0,-208 # 800086f8 <etext+0x6f8>
    800057d0:	00001097          	auipc	ra,0x1
    800057d4:	852080e7          	jalr	-1966(ra) # 80006022 <panic>
    panic("virtio disk max queue too short");
    800057d8:	00003517          	auipc	a0,0x3
    800057dc:	f4050513          	addi	a0,a0,-192 # 80008718 <etext+0x718>
    800057e0:	00001097          	auipc	ra,0x1
    800057e4:	842080e7          	jalr	-1982(ra) # 80006022 <panic>
    panic("virtio disk kalloc");
    800057e8:	00003517          	auipc	a0,0x3
    800057ec:	f5050513          	addi	a0,a0,-176 # 80008738 <etext+0x738>
    800057f0:	00001097          	auipc	ra,0x1
    800057f4:	832080e7          	jalr	-1998(ra) # 80006022 <panic>

00000000800057f8 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800057f8:	7159                	addi	sp,sp,-112
    800057fa:	f486                	sd	ra,104(sp)
    800057fc:	f0a2                	sd	s0,96(sp)
    800057fe:	eca6                	sd	s1,88(sp)
    80005800:	e8ca                	sd	s2,80(sp)
    80005802:	e4ce                	sd	s3,72(sp)
    80005804:	e0d2                	sd	s4,64(sp)
    80005806:	fc56                	sd	s5,56(sp)
    80005808:	f85a                	sd	s6,48(sp)
    8000580a:	f45e                	sd	s7,40(sp)
    8000580c:	f062                	sd	s8,32(sp)
    8000580e:	ec66                	sd	s9,24(sp)
    80005810:	1880                	addi	s0,sp,112
    80005812:	8a2a                	mv	s4,a0
    80005814:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005816:	00c52c83          	lw	s9,12(a0)
    8000581a:	001c9c9b          	slliw	s9,s9,0x1
    8000581e:	1c82                	slli	s9,s9,0x20
    80005820:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005824:	00017517          	auipc	a0,0x17
    80005828:	f6450513          	addi	a0,a0,-156 # 8001c788 <disk+0x128>
    8000582c:	00001097          	auipc	ra,0x1
    80005830:	d70080e7          	jalr	-656(ra) # 8000659c <acquire>
  for(int i = 0; i < 3; i++){
    80005834:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005836:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005838:	00017b17          	auipc	s6,0x17
    8000583c:	e28b0b13          	addi	s6,s6,-472 # 8001c660 <disk>
  for(int i = 0; i < 3; i++){
    80005840:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005842:	00017c17          	auipc	s8,0x17
    80005846:	f46c0c13          	addi	s8,s8,-186 # 8001c788 <disk+0x128>
    8000584a:	a0ad                	j	800058b4 <virtio_disk_rw+0xbc>
      disk.free[i] = 0;
    8000584c:	00fb0733          	add	a4,s6,a5
    80005850:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80005854:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005856:	0207c563          	bltz	a5,80005880 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    8000585a:	2905                	addiw	s2,s2,1
    8000585c:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    8000585e:	05590f63          	beq	s2,s5,800058bc <virtio_disk_rw+0xc4>
    idx[i] = alloc_desc();
    80005862:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005864:	00017717          	auipc	a4,0x17
    80005868:	dfc70713          	addi	a4,a4,-516 # 8001c660 <disk>
    8000586c:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000586e:	01874683          	lbu	a3,24(a4)
    80005872:	fee9                	bnez	a3,8000584c <virtio_disk_rw+0x54>
  for(int i = 0; i < NUM; i++){
    80005874:	2785                	addiw	a5,a5,1
    80005876:	0705                	addi	a4,a4,1
    80005878:	fe979be3          	bne	a5,s1,8000586e <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000587c:	57fd                	li	a5,-1
    8000587e:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005880:	03205163          	blez	s2,800058a2 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    80005884:	f9042503          	lw	a0,-112(s0)
    80005888:	00000097          	auipc	ra,0x0
    8000588c:	cc2080e7          	jalr	-830(ra) # 8000554a <free_desc>
      for(int j = 0; j < i; j++)
    80005890:	4785                	li	a5,1
    80005892:	0127d863          	bge	a5,s2,800058a2 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    80005896:	f9442503          	lw	a0,-108(s0)
    8000589a:	00000097          	auipc	ra,0x0
    8000589e:	cb0080e7          	jalr	-848(ra) # 8000554a <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800058a2:	85e2                	mv	a1,s8
    800058a4:	00017517          	auipc	a0,0x17
    800058a8:	dd450513          	addi	a0,a0,-556 # 8001c678 <disk+0x18>
    800058ac:	ffffc097          	auipc	ra,0xffffc
    800058b0:	eae080e7          	jalr	-338(ra) # 8000175a <sleep>
  for(int i = 0; i < 3; i++){
    800058b4:	f9040613          	addi	a2,s0,-112
    800058b8:	894e                	mv	s2,s3
    800058ba:	b765                	j	80005862 <virtio_disk_rw+0x6a>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800058bc:	f9042503          	lw	a0,-112(s0)
    800058c0:	00451693          	slli	a3,a0,0x4

  if(write)
    800058c4:	00017797          	auipc	a5,0x17
    800058c8:	d9c78793          	addi	a5,a5,-612 # 8001c660 <disk>
    800058cc:	00a50713          	addi	a4,a0,10
    800058d0:	0712                	slli	a4,a4,0x4
    800058d2:	973e                	add	a4,a4,a5
    800058d4:	01703633          	snez	a2,s7
    800058d8:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800058da:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800058de:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800058e2:	6398                	ld	a4,0(a5)
    800058e4:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800058e6:	0a868613          	addi	a2,a3,168
    800058ea:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800058ec:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800058ee:	6390                	ld	a2,0(a5)
    800058f0:	00d605b3          	add	a1,a2,a3
    800058f4:	4741                	li	a4,16
    800058f6:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800058f8:	4805                	li	a6,1
    800058fa:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    800058fe:	f9442703          	lw	a4,-108(s0)
    80005902:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005906:	0712                	slli	a4,a4,0x4
    80005908:	963a                	add	a2,a2,a4
    8000590a:	058a0593          	addi	a1,s4,88
    8000590e:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005910:	0007b883          	ld	a7,0(a5)
    80005914:	9746                	add	a4,a4,a7
    80005916:	40000613          	li	a2,1024
    8000591a:	c710                	sw	a2,8(a4)
  if(write)
    8000591c:	001bb613          	seqz	a2,s7
    80005920:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005924:	00166613          	ori	a2,a2,1
    80005928:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    8000592c:	f9842583          	lw	a1,-104(s0)
    80005930:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005934:	00250613          	addi	a2,a0,2
    80005938:	0612                	slli	a2,a2,0x4
    8000593a:	963e                	add	a2,a2,a5
    8000593c:	577d                	li	a4,-1
    8000593e:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005942:	0592                	slli	a1,a1,0x4
    80005944:	98ae                	add	a7,a7,a1
    80005946:	03068713          	addi	a4,a3,48
    8000594a:	973e                	add	a4,a4,a5
    8000594c:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005950:	6398                	ld	a4,0(a5)
    80005952:	972e                	add	a4,a4,a1
    80005954:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005958:	4689                	li	a3,2
    8000595a:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    8000595e:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005962:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80005966:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000596a:	6794                	ld	a3,8(a5)
    8000596c:	0026d703          	lhu	a4,2(a3)
    80005970:	8b1d                	andi	a4,a4,7
    80005972:	0706                	slli	a4,a4,0x1
    80005974:	96ba                	add	a3,a3,a4
    80005976:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000597a:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000597e:	6798                	ld	a4,8(a5)
    80005980:	00275783          	lhu	a5,2(a4)
    80005984:	2785                	addiw	a5,a5,1
    80005986:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000598a:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000598e:	100017b7          	lui	a5,0x10001
    80005992:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005996:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    8000599a:	00017917          	auipc	s2,0x17
    8000599e:	dee90913          	addi	s2,s2,-530 # 8001c788 <disk+0x128>
  while(b->disk == 1) {
    800059a2:	4485                	li	s1,1
    800059a4:	01079c63          	bne	a5,a6,800059bc <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    800059a8:	85ca                	mv	a1,s2
    800059aa:	8552                	mv	a0,s4
    800059ac:	ffffc097          	auipc	ra,0xffffc
    800059b0:	dae080e7          	jalr	-594(ra) # 8000175a <sleep>
  while(b->disk == 1) {
    800059b4:	004a2783          	lw	a5,4(s4)
    800059b8:	fe9788e3          	beq	a5,s1,800059a8 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800059bc:	f9042903          	lw	s2,-112(s0)
    800059c0:	00290713          	addi	a4,s2,2
    800059c4:	0712                	slli	a4,a4,0x4
    800059c6:	00017797          	auipc	a5,0x17
    800059ca:	c9a78793          	addi	a5,a5,-870 # 8001c660 <disk>
    800059ce:	97ba                	add	a5,a5,a4
    800059d0:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800059d4:	00017997          	auipc	s3,0x17
    800059d8:	c8c98993          	addi	s3,s3,-884 # 8001c660 <disk>
    800059dc:	00491713          	slli	a4,s2,0x4
    800059e0:	0009b783          	ld	a5,0(s3)
    800059e4:	97ba                	add	a5,a5,a4
    800059e6:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800059ea:	854a                	mv	a0,s2
    800059ec:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800059f0:	00000097          	auipc	ra,0x0
    800059f4:	b5a080e7          	jalr	-1190(ra) # 8000554a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800059f8:	8885                	andi	s1,s1,1
    800059fa:	f0ed                	bnez	s1,800059dc <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800059fc:	00017517          	auipc	a0,0x17
    80005a00:	d8c50513          	addi	a0,a0,-628 # 8001c788 <disk+0x128>
    80005a04:	00001097          	auipc	ra,0x1
    80005a08:	c4c080e7          	jalr	-948(ra) # 80006650 <release>
}
    80005a0c:	70a6                	ld	ra,104(sp)
    80005a0e:	7406                	ld	s0,96(sp)
    80005a10:	64e6                	ld	s1,88(sp)
    80005a12:	6946                	ld	s2,80(sp)
    80005a14:	69a6                	ld	s3,72(sp)
    80005a16:	6a06                	ld	s4,64(sp)
    80005a18:	7ae2                	ld	s5,56(sp)
    80005a1a:	7b42                	ld	s6,48(sp)
    80005a1c:	7ba2                	ld	s7,40(sp)
    80005a1e:	7c02                	ld	s8,32(sp)
    80005a20:	6ce2                	ld	s9,24(sp)
    80005a22:	6165                	addi	sp,sp,112
    80005a24:	8082                	ret

0000000080005a26 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005a26:	1101                	addi	sp,sp,-32
    80005a28:	ec06                	sd	ra,24(sp)
    80005a2a:	e822                	sd	s0,16(sp)
    80005a2c:	e426                	sd	s1,8(sp)
    80005a2e:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005a30:	00017497          	auipc	s1,0x17
    80005a34:	c3048493          	addi	s1,s1,-976 # 8001c660 <disk>
    80005a38:	00017517          	auipc	a0,0x17
    80005a3c:	d5050513          	addi	a0,a0,-688 # 8001c788 <disk+0x128>
    80005a40:	00001097          	auipc	ra,0x1
    80005a44:	b5c080e7          	jalr	-1188(ra) # 8000659c <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005a48:	100017b7          	lui	a5,0x10001
    80005a4c:	53b8                	lw	a4,96(a5)
    80005a4e:	8b0d                	andi	a4,a4,3
    80005a50:	100017b7          	lui	a5,0x10001
    80005a54:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005a56:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005a5a:	689c                	ld	a5,16(s1)
    80005a5c:	0204d703          	lhu	a4,32(s1)
    80005a60:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005a64:	04f70863          	beq	a4,a5,80005ab4 <virtio_disk_intr+0x8e>
    __sync_synchronize();
    80005a68:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005a6c:	6898                	ld	a4,16(s1)
    80005a6e:	0204d783          	lhu	a5,32(s1)
    80005a72:	8b9d                	andi	a5,a5,7
    80005a74:	078e                	slli	a5,a5,0x3
    80005a76:	97ba                	add	a5,a5,a4
    80005a78:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005a7a:	00278713          	addi	a4,a5,2
    80005a7e:	0712                	slli	a4,a4,0x4
    80005a80:	9726                	add	a4,a4,s1
    80005a82:	01074703          	lbu	a4,16(a4)
    80005a86:	e721                	bnez	a4,80005ace <virtio_disk_intr+0xa8>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005a88:	0789                	addi	a5,a5,2
    80005a8a:	0792                	slli	a5,a5,0x4
    80005a8c:	97a6                	add	a5,a5,s1
    80005a8e:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005a90:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005a94:	ffffc097          	auipc	ra,0xffffc
    80005a98:	d2a080e7          	jalr	-726(ra) # 800017be <wakeup>

    disk.used_idx += 1;
    80005a9c:	0204d783          	lhu	a5,32(s1)
    80005aa0:	2785                	addiw	a5,a5,1
    80005aa2:	17c2                	slli	a5,a5,0x30
    80005aa4:	93c1                	srli	a5,a5,0x30
    80005aa6:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005aaa:	6898                	ld	a4,16(s1)
    80005aac:	00275703          	lhu	a4,2(a4)
    80005ab0:	faf71ce3          	bne	a4,a5,80005a68 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    80005ab4:	00017517          	auipc	a0,0x17
    80005ab8:	cd450513          	addi	a0,a0,-812 # 8001c788 <disk+0x128>
    80005abc:	00001097          	auipc	ra,0x1
    80005ac0:	b94080e7          	jalr	-1132(ra) # 80006650 <release>
}
    80005ac4:	60e2                	ld	ra,24(sp)
    80005ac6:	6442                	ld	s0,16(sp)
    80005ac8:	64a2                	ld	s1,8(sp)
    80005aca:	6105                	addi	sp,sp,32
    80005acc:	8082                	ret
      panic("virtio_disk_intr status");
    80005ace:	00003517          	auipc	a0,0x3
    80005ad2:	c8250513          	addi	a0,a0,-894 # 80008750 <etext+0x750>
    80005ad6:	00000097          	auipc	ra,0x0
    80005ada:	54c080e7          	jalr	1356(ra) # 80006022 <panic>

0000000080005ade <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005ade:	1141                	addi	sp,sp,-16
    80005ae0:	e422                	sd	s0,8(sp)
    80005ae2:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005ae4:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005ae8:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005aec:	0037979b          	slliw	a5,a5,0x3
    80005af0:	02004737          	lui	a4,0x2004
    80005af4:	97ba                	add	a5,a5,a4
    80005af6:	0200c737          	lui	a4,0x200c
    80005afa:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    80005afc:	6318                	ld	a4,0(a4)
    80005afe:	000f4637          	lui	a2,0xf4
    80005b02:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005b06:	9732                	add	a4,a4,a2
    80005b08:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005b0a:	00259693          	slli	a3,a1,0x2
    80005b0e:	96ae                	add	a3,a3,a1
    80005b10:	068e                	slli	a3,a3,0x3
    80005b12:	00017717          	auipc	a4,0x17
    80005b16:	c8e70713          	addi	a4,a4,-882 # 8001c7a0 <timer_scratch>
    80005b1a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005b1c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005b1e:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005b20:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005b24:	00000797          	auipc	a5,0x0
    80005b28:	95c78793          	addi	a5,a5,-1700 # 80005480 <timervec>
    80005b2c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005b30:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005b34:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005b38:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005b3c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005b40:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005b44:	30479073          	csrw	mie,a5
}
    80005b48:	6422                	ld	s0,8(sp)
    80005b4a:	0141                	addi	sp,sp,16
    80005b4c:	8082                	ret

0000000080005b4e <start>:
{
    80005b4e:	1141                	addi	sp,sp,-16
    80005b50:	e406                	sd	ra,8(sp)
    80005b52:	e022                	sd	s0,0(sp)
    80005b54:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005b56:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005b5a:	7779                	lui	a4,0xffffe
    80005b5c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd9e1f>
    80005b60:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005b62:	6705                	lui	a4,0x1
    80005b64:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005b68:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005b6a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005b6e:	ffffa797          	auipc	a5,0xffffa
    80005b72:	7aa78793          	addi	a5,a5,1962 # 80000318 <main>
    80005b76:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005b7a:	4781                	li	a5,0
    80005b7c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005b80:	67c1                	lui	a5,0x10
    80005b82:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005b84:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005b88:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005b8c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005b90:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005b94:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005b98:	57fd                	li	a5,-1
    80005b9a:	83a9                	srli	a5,a5,0xa
    80005b9c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005ba0:	47bd                	li	a5,15
    80005ba2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005ba6:	00000097          	auipc	ra,0x0
    80005baa:	f38080e7          	jalr	-200(ra) # 80005ade <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005bae:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005bb2:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005bb4:	823e                	mv	tp,a5
  asm volatile("mret");
    80005bb6:	30200073          	mret
}
    80005bba:	60a2                	ld	ra,8(sp)
    80005bbc:	6402                	ld	s0,0(sp)
    80005bbe:	0141                	addi	sp,sp,16
    80005bc0:	8082                	ret

0000000080005bc2 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005bc2:	715d                	addi	sp,sp,-80
    80005bc4:	e486                	sd	ra,72(sp)
    80005bc6:	e0a2                	sd	s0,64(sp)
    80005bc8:	f84a                	sd	s2,48(sp)
    80005bca:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005bcc:	04c05663          	blez	a2,80005c18 <consolewrite+0x56>
    80005bd0:	fc26                	sd	s1,56(sp)
    80005bd2:	f44e                	sd	s3,40(sp)
    80005bd4:	f052                	sd	s4,32(sp)
    80005bd6:	ec56                	sd	s5,24(sp)
    80005bd8:	8a2a                	mv	s4,a0
    80005bda:	84ae                	mv	s1,a1
    80005bdc:	89b2                	mv	s3,a2
    80005bde:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005be0:	5afd                	li	s5,-1
    80005be2:	4685                	li	a3,1
    80005be4:	8626                	mv	a2,s1
    80005be6:	85d2                	mv	a1,s4
    80005be8:	fbf40513          	addi	a0,s0,-65
    80005bec:	ffffc097          	auipc	ra,0xffffc
    80005bf0:	fcc080e7          	jalr	-52(ra) # 80001bb8 <either_copyin>
    80005bf4:	03550463          	beq	a0,s5,80005c1c <consolewrite+0x5a>
      break;
    uartputc(c);
    80005bf8:	fbf44503          	lbu	a0,-65(s0)
    80005bfc:	00000097          	auipc	ra,0x0
    80005c00:	7e4080e7          	jalr	2020(ra) # 800063e0 <uartputc>
  for(i = 0; i < n; i++){
    80005c04:	2905                	addiw	s2,s2,1
    80005c06:	0485                	addi	s1,s1,1
    80005c08:	fd299de3          	bne	s3,s2,80005be2 <consolewrite+0x20>
    80005c0c:	894e                	mv	s2,s3
    80005c0e:	74e2                	ld	s1,56(sp)
    80005c10:	79a2                	ld	s3,40(sp)
    80005c12:	7a02                	ld	s4,32(sp)
    80005c14:	6ae2                	ld	s5,24(sp)
    80005c16:	a039                	j	80005c24 <consolewrite+0x62>
    80005c18:	4901                	li	s2,0
    80005c1a:	a029                	j	80005c24 <consolewrite+0x62>
    80005c1c:	74e2                	ld	s1,56(sp)
    80005c1e:	79a2                	ld	s3,40(sp)
    80005c20:	7a02                	ld	s4,32(sp)
    80005c22:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005c24:	854a                	mv	a0,s2
    80005c26:	60a6                	ld	ra,72(sp)
    80005c28:	6406                	ld	s0,64(sp)
    80005c2a:	7942                	ld	s2,48(sp)
    80005c2c:	6161                	addi	sp,sp,80
    80005c2e:	8082                	ret

0000000080005c30 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005c30:	711d                	addi	sp,sp,-96
    80005c32:	ec86                	sd	ra,88(sp)
    80005c34:	e8a2                	sd	s0,80(sp)
    80005c36:	e4a6                	sd	s1,72(sp)
    80005c38:	e0ca                	sd	s2,64(sp)
    80005c3a:	fc4e                	sd	s3,56(sp)
    80005c3c:	f852                	sd	s4,48(sp)
    80005c3e:	f456                	sd	s5,40(sp)
    80005c40:	f05a                	sd	s6,32(sp)
    80005c42:	1080                	addi	s0,sp,96
    80005c44:	8aaa                	mv	s5,a0
    80005c46:	8a2e                	mv	s4,a1
    80005c48:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005c4a:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005c4e:	0001f517          	auipc	a0,0x1f
    80005c52:	c9250513          	addi	a0,a0,-878 # 800248e0 <cons>
    80005c56:	00001097          	auipc	ra,0x1
    80005c5a:	946080e7          	jalr	-1722(ra) # 8000659c <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005c5e:	0001f497          	auipc	s1,0x1f
    80005c62:	c8248493          	addi	s1,s1,-894 # 800248e0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005c66:	0001f917          	auipc	s2,0x1f
    80005c6a:	d1290913          	addi	s2,s2,-750 # 80024978 <cons+0x98>
  while(n > 0){
    80005c6e:	0d305763          	blez	s3,80005d3c <consoleread+0x10c>
    while(cons.r == cons.w){
    80005c72:	0984a783          	lw	a5,152(s1)
    80005c76:	09c4a703          	lw	a4,156(s1)
    80005c7a:	0af71c63          	bne	a4,a5,80005d32 <consoleread+0x102>
      if(killed(myproc())){
    80005c7e:	ffffb097          	auipc	ra,0xffffb
    80005c82:	382080e7          	jalr	898(ra) # 80001000 <myproc>
    80005c86:	ffffc097          	auipc	ra,0xffffc
    80005c8a:	d7c080e7          	jalr	-644(ra) # 80001a02 <killed>
    80005c8e:	e52d                	bnez	a0,80005cf8 <consoleread+0xc8>
      sleep(&cons.r, &cons.lock);
    80005c90:	85a6                	mv	a1,s1
    80005c92:	854a                	mv	a0,s2
    80005c94:	ffffc097          	auipc	ra,0xffffc
    80005c98:	ac6080e7          	jalr	-1338(ra) # 8000175a <sleep>
    while(cons.r == cons.w){
    80005c9c:	0984a783          	lw	a5,152(s1)
    80005ca0:	09c4a703          	lw	a4,156(s1)
    80005ca4:	fcf70de3          	beq	a4,a5,80005c7e <consoleread+0x4e>
    80005ca8:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005caa:	0001f717          	auipc	a4,0x1f
    80005cae:	c3670713          	addi	a4,a4,-970 # 800248e0 <cons>
    80005cb2:	0017869b          	addiw	a3,a5,1
    80005cb6:	08d72c23          	sw	a3,152(a4)
    80005cba:	07f7f693          	andi	a3,a5,127
    80005cbe:	9736                	add	a4,a4,a3
    80005cc0:	01874703          	lbu	a4,24(a4)
    80005cc4:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005cc8:	4691                	li	a3,4
    80005cca:	04db8a63          	beq	s7,a3,80005d1e <consoleread+0xee>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005cce:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005cd2:	4685                	li	a3,1
    80005cd4:	faf40613          	addi	a2,s0,-81
    80005cd8:	85d2                	mv	a1,s4
    80005cda:	8556                	mv	a0,s5
    80005cdc:	ffffc097          	auipc	ra,0xffffc
    80005ce0:	e86080e7          	jalr	-378(ra) # 80001b62 <either_copyout>
    80005ce4:	57fd                	li	a5,-1
    80005ce6:	04f50a63          	beq	a0,a5,80005d3a <consoleread+0x10a>
      break;

    dst++;
    80005cea:	0a05                	addi	s4,s4,1
    --n;
    80005cec:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005cee:	47a9                	li	a5,10
    80005cf0:	06fb8163          	beq	s7,a5,80005d52 <consoleread+0x122>
    80005cf4:	6be2                	ld	s7,24(sp)
    80005cf6:	bfa5                	j	80005c6e <consoleread+0x3e>
        release(&cons.lock);
    80005cf8:	0001f517          	auipc	a0,0x1f
    80005cfc:	be850513          	addi	a0,a0,-1048 # 800248e0 <cons>
    80005d00:	00001097          	auipc	ra,0x1
    80005d04:	950080e7          	jalr	-1712(ra) # 80006650 <release>
        return -1;
    80005d08:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005d0a:	60e6                	ld	ra,88(sp)
    80005d0c:	6446                	ld	s0,80(sp)
    80005d0e:	64a6                	ld	s1,72(sp)
    80005d10:	6906                	ld	s2,64(sp)
    80005d12:	79e2                	ld	s3,56(sp)
    80005d14:	7a42                	ld	s4,48(sp)
    80005d16:	7aa2                	ld	s5,40(sp)
    80005d18:	7b02                	ld	s6,32(sp)
    80005d1a:	6125                	addi	sp,sp,96
    80005d1c:	8082                	ret
      if(n < target){
    80005d1e:	0009871b          	sext.w	a4,s3
    80005d22:	01677a63          	bgeu	a4,s6,80005d36 <consoleread+0x106>
        cons.r--;
    80005d26:	0001f717          	auipc	a4,0x1f
    80005d2a:	c4f72923          	sw	a5,-942(a4) # 80024978 <cons+0x98>
    80005d2e:	6be2                	ld	s7,24(sp)
    80005d30:	a031                	j	80005d3c <consoleread+0x10c>
    80005d32:	ec5e                	sd	s7,24(sp)
    80005d34:	bf9d                	j	80005caa <consoleread+0x7a>
    80005d36:	6be2                	ld	s7,24(sp)
    80005d38:	a011                	j	80005d3c <consoleread+0x10c>
    80005d3a:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005d3c:	0001f517          	auipc	a0,0x1f
    80005d40:	ba450513          	addi	a0,a0,-1116 # 800248e0 <cons>
    80005d44:	00001097          	auipc	ra,0x1
    80005d48:	90c080e7          	jalr	-1780(ra) # 80006650 <release>
  return target - n;
    80005d4c:	413b053b          	subw	a0,s6,s3
    80005d50:	bf6d                	j	80005d0a <consoleread+0xda>
    80005d52:	6be2                	ld	s7,24(sp)
    80005d54:	b7e5                	j	80005d3c <consoleread+0x10c>

0000000080005d56 <consputc>:
{
    80005d56:	1141                	addi	sp,sp,-16
    80005d58:	e406                	sd	ra,8(sp)
    80005d5a:	e022                	sd	s0,0(sp)
    80005d5c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005d5e:	10000793          	li	a5,256
    80005d62:	00f50a63          	beq	a0,a5,80005d76 <consputc+0x20>
    uartputc_sync(c);
    80005d66:	00000097          	auipc	ra,0x0
    80005d6a:	59c080e7          	jalr	1436(ra) # 80006302 <uartputc_sync>
}
    80005d6e:	60a2                	ld	ra,8(sp)
    80005d70:	6402                	ld	s0,0(sp)
    80005d72:	0141                	addi	sp,sp,16
    80005d74:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005d76:	4521                	li	a0,8
    80005d78:	00000097          	auipc	ra,0x0
    80005d7c:	58a080e7          	jalr	1418(ra) # 80006302 <uartputc_sync>
    80005d80:	02000513          	li	a0,32
    80005d84:	00000097          	auipc	ra,0x0
    80005d88:	57e080e7          	jalr	1406(ra) # 80006302 <uartputc_sync>
    80005d8c:	4521                	li	a0,8
    80005d8e:	00000097          	auipc	ra,0x0
    80005d92:	574080e7          	jalr	1396(ra) # 80006302 <uartputc_sync>
    80005d96:	bfe1                	j	80005d6e <consputc+0x18>

0000000080005d98 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005d98:	1101                	addi	sp,sp,-32
    80005d9a:	ec06                	sd	ra,24(sp)
    80005d9c:	e822                	sd	s0,16(sp)
    80005d9e:	e426                	sd	s1,8(sp)
    80005da0:	1000                	addi	s0,sp,32
    80005da2:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005da4:	0001f517          	auipc	a0,0x1f
    80005da8:	b3c50513          	addi	a0,a0,-1220 # 800248e0 <cons>
    80005dac:	00000097          	auipc	ra,0x0
    80005db0:	7f0080e7          	jalr	2032(ra) # 8000659c <acquire>

  switch(c){
    80005db4:	47d5                	li	a5,21
    80005db6:	0af48563          	beq	s1,a5,80005e60 <consoleintr+0xc8>
    80005dba:	0297c963          	blt	a5,s1,80005dec <consoleintr+0x54>
    80005dbe:	47a1                	li	a5,8
    80005dc0:	0ef48c63          	beq	s1,a5,80005eb8 <consoleintr+0x120>
    80005dc4:	47c1                	li	a5,16
    80005dc6:	10f49f63          	bne	s1,a5,80005ee4 <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    80005dca:	ffffc097          	auipc	ra,0xffffc
    80005dce:	e44080e7          	jalr	-444(ra) # 80001c0e <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005dd2:	0001f517          	auipc	a0,0x1f
    80005dd6:	b0e50513          	addi	a0,a0,-1266 # 800248e0 <cons>
    80005dda:	00001097          	auipc	ra,0x1
    80005dde:	876080e7          	jalr	-1930(ra) # 80006650 <release>
}
    80005de2:	60e2                	ld	ra,24(sp)
    80005de4:	6442                	ld	s0,16(sp)
    80005de6:	64a2                	ld	s1,8(sp)
    80005de8:	6105                	addi	sp,sp,32
    80005dea:	8082                	ret
  switch(c){
    80005dec:	07f00793          	li	a5,127
    80005df0:	0cf48463          	beq	s1,a5,80005eb8 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005df4:	0001f717          	auipc	a4,0x1f
    80005df8:	aec70713          	addi	a4,a4,-1300 # 800248e0 <cons>
    80005dfc:	0a072783          	lw	a5,160(a4)
    80005e00:	09872703          	lw	a4,152(a4)
    80005e04:	9f99                	subw	a5,a5,a4
    80005e06:	07f00713          	li	a4,127
    80005e0a:	fcf764e3          	bltu	a4,a5,80005dd2 <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005e0e:	47b5                	li	a5,13
    80005e10:	0cf48d63          	beq	s1,a5,80005eea <consoleintr+0x152>
      consputc(c);
    80005e14:	8526                	mv	a0,s1
    80005e16:	00000097          	auipc	ra,0x0
    80005e1a:	f40080e7          	jalr	-192(ra) # 80005d56 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005e1e:	0001f797          	auipc	a5,0x1f
    80005e22:	ac278793          	addi	a5,a5,-1342 # 800248e0 <cons>
    80005e26:	0a07a683          	lw	a3,160(a5)
    80005e2a:	0016871b          	addiw	a4,a3,1
    80005e2e:	0007061b          	sext.w	a2,a4
    80005e32:	0ae7a023          	sw	a4,160(a5)
    80005e36:	07f6f693          	andi	a3,a3,127
    80005e3a:	97b6                	add	a5,a5,a3
    80005e3c:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005e40:	47a9                	li	a5,10
    80005e42:	0cf48b63          	beq	s1,a5,80005f18 <consoleintr+0x180>
    80005e46:	4791                	li	a5,4
    80005e48:	0cf48863          	beq	s1,a5,80005f18 <consoleintr+0x180>
    80005e4c:	0001f797          	auipc	a5,0x1f
    80005e50:	b2c7a783          	lw	a5,-1236(a5) # 80024978 <cons+0x98>
    80005e54:	9f1d                	subw	a4,a4,a5
    80005e56:	08000793          	li	a5,128
    80005e5a:	f6f71ce3          	bne	a4,a5,80005dd2 <consoleintr+0x3a>
    80005e5e:	a86d                	j	80005f18 <consoleintr+0x180>
    80005e60:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005e62:	0001f717          	auipc	a4,0x1f
    80005e66:	a7e70713          	addi	a4,a4,-1410 # 800248e0 <cons>
    80005e6a:	0a072783          	lw	a5,160(a4)
    80005e6e:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005e72:	0001f497          	auipc	s1,0x1f
    80005e76:	a6e48493          	addi	s1,s1,-1426 # 800248e0 <cons>
    while(cons.e != cons.w &&
    80005e7a:	4929                	li	s2,10
    80005e7c:	02f70a63          	beq	a4,a5,80005eb0 <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005e80:	37fd                	addiw	a5,a5,-1
    80005e82:	07f7f713          	andi	a4,a5,127
    80005e86:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005e88:	01874703          	lbu	a4,24(a4)
    80005e8c:	03270463          	beq	a4,s2,80005eb4 <consoleintr+0x11c>
      cons.e--;
    80005e90:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005e94:	10000513          	li	a0,256
    80005e98:	00000097          	auipc	ra,0x0
    80005e9c:	ebe080e7          	jalr	-322(ra) # 80005d56 <consputc>
    while(cons.e != cons.w &&
    80005ea0:	0a04a783          	lw	a5,160(s1)
    80005ea4:	09c4a703          	lw	a4,156(s1)
    80005ea8:	fcf71ce3          	bne	a4,a5,80005e80 <consoleintr+0xe8>
    80005eac:	6902                	ld	s2,0(sp)
    80005eae:	b715                	j	80005dd2 <consoleintr+0x3a>
    80005eb0:	6902                	ld	s2,0(sp)
    80005eb2:	b705                	j	80005dd2 <consoleintr+0x3a>
    80005eb4:	6902                	ld	s2,0(sp)
    80005eb6:	bf31                	j	80005dd2 <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005eb8:	0001f717          	auipc	a4,0x1f
    80005ebc:	a2870713          	addi	a4,a4,-1496 # 800248e0 <cons>
    80005ec0:	0a072783          	lw	a5,160(a4)
    80005ec4:	09c72703          	lw	a4,156(a4)
    80005ec8:	f0f705e3          	beq	a4,a5,80005dd2 <consoleintr+0x3a>
      cons.e--;
    80005ecc:	37fd                	addiw	a5,a5,-1
    80005ece:	0001f717          	auipc	a4,0x1f
    80005ed2:	aaf72923          	sw	a5,-1358(a4) # 80024980 <cons+0xa0>
      consputc(BACKSPACE);
    80005ed6:	10000513          	li	a0,256
    80005eda:	00000097          	auipc	ra,0x0
    80005ede:	e7c080e7          	jalr	-388(ra) # 80005d56 <consputc>
    80005ee2:	bdc5                	j	80005dd2 <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005ee4:	ee0487e3          	beqz	s1,80005dd2 <consoleintr+0x3a>
    80005ee8:	b731                	j	80005df4 <consoleintr+0x5c>
      consputc(c);
    80005eea:	4529                	li	a0,10
    80005eec:	00000097          	auipc	ra,0x0
    80005ef0:	e6a080e7          	jalr	-406(ra) # 80005d56 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005ef4:	0001f797          	auipc	a5,0x1f
    80005ef8:	9ec78793          	addi	a5,a5,-1556 # 800248e0 <cons>
    80005efc:	0a07a703          	lw	a4,160(a5)
    80005f00:	0017069b          	addiw	a3,a4,1
    80005f04:	0006861b          	sext.w	a2,a3
    80005f08:	0ad7a023          	sw	a3,160(a5)
    80005f0c:	07f77713          	andi	a4,a4,127
    80005f10:	97ba                	add	a5,a5,a4
    80005f12:	4729                	li	a4,10
    80005f14:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005f18:	0001f797          	auipc	a5,0x1f
    80005f1c:	a6c7a223          	sw	a2,-1436(a5) # 8002497c <cons+0x9c>
        wakeup(&cons.r);
    80005f20:	0001f517          	auipc	a0,0x1f
    80005f24:	a5850513          	addi	a0,a0,-1448 # 80024978 <cons+0x98>
    80005f28:	ffffc097          	auipc	ra,0xffffc
    80005f2c:	896080e7          	jalr	-1898(ra) # 800017be <wakeup>
    80005f30:	b54d                	j	80005dd2 <consoleintr+0x3a>

0000000080005f32 <consoleinit>:

void
consoleinit(void)
{
    80005f32:	1141                	addi	sp,sp,-16
    80005f34:	e406                	sd	ra,8(sp)
    80005f36:	e022                	sd	s0,0(sp)
    80005f38:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005f3a:	00003597          	auipc	a1,0x3
    80005f3e:	82e58593          	addi	a1,a1,-2002 # 80008768 <etext+0x768>
    80005f42:	0001f517          	auipc	a0,0x1f
    80005f46:	99e50513          	addi	a0,a0,-1634 # 800248e0 <cons>
    80005f4a:	00000097          	auipc	ra,0x0
    80005f4e:	5c2080e7          	jalr	1474(ra) # 8000650c <initlock>

  uartinit();
    80005f52:	00000097          	auipc	ra,0x0
    80005f56:	354080e7          	jalr	852(ra) # 800062a6 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005f5a:	00015797          	auipc	a5,0x15
    80005f5e:	6ae78793          	addi	a5,a5,1710 # 8001b608 <devsw>
    80005f62:	00000717          	auipc	a4,0x0
    80005f66:	cce70713          	addi	a4,a4,-818 # 80005c30 <consoleread>
    80005f6a:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005f6c:	00000717          	auipc	a4,0x0
    80005f70:	c5670713          	addi	a4,a4,-938 # 80005bc2 <consolewrite>
    80005f74:	ef98                	sd	a4,24(a5)
}
    80005f76:	60a2                	ld	ra,8(sp)
    80005f78:	6402                	ld	s0,0(sp)
    80005f7a:	0141                	addi	sp,sp,16
    80005f7c:	8082                	ret

0000000080005f7e <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005f7e:	7179                	addi	sp,sp,-48
    80005f80:	f406                	sd	ra,40(sp)
    80005f82:	f022                	sd	s0,32(sp)
    80005f84:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005f86:	c219                	beqz	a2,80005f8c <printint+0xe>
    80005f88:	08054963          	bltz	a0,8000601a <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005f8c:	2501                	sext.w	a0,a0
    80005f8e:	4881                	li	a7,0
    80005f90:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005f94:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005f96:	2581                	sext.w	a1,a1
    80005f98:	00003617          	auipc	a2,0x3
    80005f9c:	97860613          	addi	a2,a2,-1672 # 80008910 <digits>
    80005fa0:	883a                	mv	a6,a4
    80005fa2:	2705                	addiw	a4,a4,1
    80005fa4:	02b577bb          	remuw	a5,a0,a1
    80005fa8:	1782                	slli	a5,a5,0x20
    80005faa:	9381                	srli	a5,a5,0x20
    80005fac:	97b2                	add	a5,a5,a2
    80005fae:	0007c783          	lbu	a5,0(a5)
    80005fb2:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005fb6:	0005079b          	sext.w	a5,a0
    80005fba:	02b5553b          	divuw	a0,a0,a1
    80005fbe:	0685                	addi	a3,a3,1
    80005fc0:	feb7f0e3          	bgeu	a5,a1,80005fa0 <printint+0x22>

  if(sign)
    80005fc4:	00088c63          	beqz	a7,80005fdc <printint+0x5e>
    buf[i++] = '-';
    80005fc8:	fe070793          	addi	a5,a4,-32
    80005fcc:	00878733          	add	a4,a5,s0
    80005fd0:	02d00793          	li	a5,45
    80005fd4:	fef70823          	sb	a5,-16(a4)
    80005fd8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005fdc:	02e05b63          	blez	a4,80006012 <printint+0x94>
    80005fe0:	ec26                	sd	s1,24(sp)
    80005fe2:	e84a                	sd	s2,16(sp)
    80005fe4:	fd040793          	addi	a5,s0,-48
    80005fe8:	00e784b3          	add	s1,a5,a4
    80005fec:	fff78913          	addi	s2,a5,-1
    80005ff0:	993a                	add	s2,s2,a4
    80005ff2:	377d                	addiw	a4,a4,-1
    80005ff4:	1702                	slli	a4,a4,0x20
    80005ff6:	9301                	srli	a4,a4,0x20
    80005ff8:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005ffc:	fff4c503          	lbu	a0,-1(s1)
    80006000:	00000097          	auipc	ra,0x0
    80006004:	d56080e7          	jalr	-682(ra) # 80005d56 <consputc>
  while(--i >= 0)
    80006008:	14fd                	addi	s1,s1,-1
    8000600a:	ff2499e3          	bne	s1,s2,80005ffc <printint+0x7e>
    8000600e:	64e2                	ld	s1,24(sp)
    80006010:	6942                	ld	s2,16(sp)
}
    80006012:	70a2                	ld	ra,40(sp)
    80006014:	7402                	ld	s0,32(sp)
    80006016:	6145                	addi	sp,sp,48
    80006018:	8082                	ret
    x = -xx;
    8000601a:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000601e:	4885                	li	a7,1
    x = -xx;
    80006020:	bf85                	j	80005f90 <printint+0x12>

0000000080006022 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80006022:	1101                	addi	sp,sp,-32
    80006024:	ec06                	sd	ra,24(sp)
    80006026:	e822                	sd	s0,16(sp)
    80006028:	e426                	sd	s1,8(sp)
    8000602a:	1000                	addi	s0,sp,32
    8000602c:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000602e:	0001f797          	auipc	a5,0x1f
    80006032:	9607a923          	sw	zero,-1678(a5) # 800249a0 <pr+0x18>
  printf("panic: ");
    80006036:	00002517          	auipc	a0,0x2
    8000603a:	73a50513          	addi	a0,a0,1850 # 80008770 <etext+0x770>
    8000603e:	00000097          	auipc	ra,0x0
    80006042:	02e080e7          	jalr	46(ra) # 8000606c <printf>
  printf(s);
    80006046:	8526                	mv	a0,s1
    80006048:	00000097          	auipc	ra,0x0
    8000604c:	024080e7          	jalr	36(ra) # 8000606c <printf>
  printf("\n");
    80006050:	00002517          	auipc	a0,0x2
    80006054:	fc850513          	addi	a0,a0,-56 # 80008018 <etext+0x18>
    80006058:	00000097          	auipc	ra,0x0
    8000605c:	014080e7          	jalr	20(ra) # 8000606c <printf>
  panicked = 1; // freeze uart output from other CPUs
    80006060:	4785                	li	a5,1
    80006062:	00005717          	auipc	a4,0x5
    80006066:	2ef72d23          	sw	a5,762(a4) # 8000b35c <panicked>
  for(;;)
    8000606a:	a001                	j	8000606a <panic+0x48>

000000008000606c <printf>:
{
    8000606c:	7131                	addi	sp,sp,-192
    8000606e:	fc86                	sd	ra,120(sp)
    80006070:	f8a2                	sd	s0,112(sp)
    80006072:	e8d2                	sd	s4,80(sp)
    80006074:	f06a                	sd	s10,32(sp)
    80006076:	0100                	addi	s0,sp,128
    80006078:	8a2a                	mv	s4,a0
    8000607a:	e40c                	sd	a1,8(s0)
    8000607c:	e810                	sd	a2,16(s0)
    8000607e:	ec14                	sd	a3,24(s0)
    80006080:	f018                	sd	a4,32(s0)
    80006082:	f41c                	sd	a5,40(s0)
    80006084:	03043823          	sd	a6,48(s0)
    80006088:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    8000608c:	0001fd17          	auipc	s10,0x1f
    80006090:	914d2d03          	lw	s10,-1772(s10) # 800249a0 <pr+0x18>
  if(locking)
    80006094:	040d1463          	bnez	s10,800060dc <printf+0x70>
  if (fmt == 0)
    80006098:	040a0b63          	beqz	s4,800060ee <printf+0x82>
  va_start(ap, fmt);
    8000609c:	00840793          	addi	a5,s0,8
    800060a0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800060a4:	000a4503          	lbu	a0,0(s4)
    800060a8:	18050b63          	beqz	a0,8000623e <printf+0x1d2>
    800060ac:	f4a6                	sd	s1,104(sp)
    800060ae:	f0ca                	sd	s2,96(sp)
    800060b0:	ecce                	sd	s3,88(sp)
    800060b2:	e4d6                	sd	s5,72(sp)
    800060b4:	e0da                	sd	s6,64(sp)
    800060b6:	fc5e                	sd	s7,56(sp)
    800060b8:	f862                	sd	s8,48(sp)
    800060ba:	f466                	sd	s9,40(sp)
    800060bc:	ec6e                	sd	s11,24(sp)
    800060be:	4981                	li	s3,0
    if(c != '%'){
    800060c0:	02500b13          	li	s6,37
    switch(c){
    800060c4:	07000b93          	li	s7,112
  consputc('x');
    800060c8:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800060ca:	00003a97          	auipc	s5,0x3
    800060ce:	846a8a93          	addi	s5,s5,-1978 # 80008910 <digits>
    switch(c){
    800060d2:	07300c13          	li	s8,115
    800060d6:	06400d93          	li	s11,100
    800060da:	a0b1                	j	80006126 <printf+0xba>
    acquire(&pr.lock);
    800060dc:	0001f517          	auipc	a0,0x1f
    800060e0:	8ac50513          	addi	a0,a0,-1876 # 80024988 <pr>
    800060e4:	00000097          	auipc	ra,0x0
    800060e8:	4b8080e7          	jalr	1208(ra) # 8000659c <acquire>
    800060ec:	b775                	j	80006098 <printf+0x2c>
    800060ee:	f4a6                	sd	s1,104(sp)
    800060f0:	f0ca                	sd	s2,96(sp)
    800060f2:	ecce                	sd	s3,88(sp)
    800060f4:	e4d6                	sd	s5,72(sp)
    800060f6:	e0da                	sd	s6,64(sp)
    800060f8:	fc5e                	sd	s7,56(sp)
    800060fa:	f862                	sd	s8,48(sp)
    800060fc:	f466                	sd	s9,40(sp)
    800060fe:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    80006100:	00002517          	auipc	a0,0x2
    80006104:	68050513          	addi	a0,a0,1664 # 80008780 <etext+0x780>
    80006108:	00000097          	auipc	ra,0x0
    8000610c:	f1a080e7          	jalr	-230(ra) # 80006022 <panic>
      consputc(c);
    80006110:	00000097          	auipc	ra,0x0
    80006114:	c46080e7          	jalr	-954(ra) # 80005d56 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006118:	2985                	addiw	s3,s3,1
    8000611a:	013a07b3          	add	a5,s4,s3
    8000611e:	0007c503          	lbu	a0,0(a5)
    80006122:	10050563          	beqz	a0,8000622c <printf+0x1c0>
    if(c != '%'){
    80006126:	ff6515e3          	bne	a0,s6,80006110 <printf+0xa4>
    c = fmt[++i] & 0xff;
    8000612a:	2985                	addiw	s3,s3,1
    8000612c:	013a07b3          	add	a5,s4,s3
    80006130:	0007c783          	lbu	a5,0(a5)
    80006134:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80006138:	10078b63          	beqz	a5,8000624e <printf+0x1e2>
    switch(c){
    8000613c:	05778a63          	beq	a5,s7,80006190 <printf+0x124>
    80006140:	02fbf663          	bgeu	s7,a5,8000616c <printf+0x100>
    80006144:	09878863          	beq	a5,s8,800061d4 <printf+0x168>
    80006148:	07800713          	li	a4,120
    8000614c:	0ce79563          	bne	a5,a4,80006216 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    80006150:	f8843783          	ld	a5,-120(s0)
    80006154:	00878713          	addi	a4,a5,8
    80006158:	f8e43423          	sd	a4,-120(s0)
    8000615c:	4605                	li	a2,1
    8000615e:	85e6                	mv	a1,s9
    80006160:	4388                	lw	a0,0(a5)
    80006162:	00000097          	auipc	ra,0x0
    80006166:	e1c080e7          	jalr	-484(ra) # 80005f7e <printint>
      break;
    8000616a:	b77d                	j	80006118 <printf+0xac>
    switch(c){
    8000616c:	09678f63          	beq	a5,s6,8000620a <printf+0x19e>
    80006170:	0bb79363          	bne	a5,s11,80006216 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    80006174:	f8843783          	ld	a5,-120(s0)
    80006178:	00878713          	addi	a4,a5,8
    8000617c:	f8e43423          	sd	a4,-120(s0)
    80006180:	4605                	li	a2,1
    80006182:	45a9                	li	a1,10
    80006184:	4388                	lw	a0,0(a5)
    80006186:	00000097          	auipc	ra,0x0
    8000618a:	df8080e7          	jalr	-520(ra) # 80005f7e <printint>
      break;
    8000618e:	b769                	j	80006118 <printf+0xac>
      printptr(va_arg(ap, uint64));
    80006190:	f8843783          	ld	a5,-120(s0)
    80006194:	00878713          	addi	a4,a5,8
    80006198:	f8e43423          	sd	a4,-120(s0)
    8000619c:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800061a0:	03000513          	li	a0,48
    800061a4:	00000097          	auipc	ra,0x0
    800061a8:	bb2080e7          	jalr	-1102(ra) # 80005d56 <consputc>
  consputc('x');
    800061ac:	07800513          	li	a0,120
    800061b0:	00000097          	auipc	ra,0x0
    800061b4:	ba6080e7          	jalr	-1114(ra) # 80005d56 <consputc>
    800061b8:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800061ba:	03c95793          	srli	a5,s2,0x3c
    800061be:	97d6                	add	a5,a5,s5
    800061c0:	0007c503          	lbu	a0,0(a5)
    800061c4:	00000097          	auipc	ra,0x0
    800061c8:	b92080e7          	jalr	-1134(ra) # 80005d56 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800061cc:	0912                	slli	s2,s2,0x4
    800061ce:	34fd                	addiw	s1,s1,-1
    800061d0:	f4ed                	bnez	s1,800061ba <printf+0x14e>
    800061d2:	b799                	j	80006118 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    800061d4:	f8843783          	ld	a5,-120(s0)
    800061d8:	00878713          	addi	a4,a5,8
    800061dc:	f8e43423          	sd	a4,-120(s0)
    800061e0:	6384                	ld	s1,0(a5)
    800061e2:	cc89                	beqz	s1,800061fc <printf+0x190>
      for(; *s; s++)
    800061e4:	0004c503          	lbu	a0,0(s1)
    800061e8:	d905                	beqz	a0,80006118 <printf+0xac>
        consputc(*s);
    800061ea:	00000097          	auipc	ra,0x0
    800061ee:	b6c080e7          	jalr	-1172(ra) # 80005d56 <consputc>
      for(; *s; s++)
    800061f2:	0485                	addi	s1,s1,1
    800061f4:	0004c503          	lbu	a0,0(s1)
    800061f8:	f96d                	bnez	a0,800061ea <printf+0x17e>
    800061fa:	bf39                	j	80006118 <printf+0xac>
        s = "(null)";
    800061fc:	00002497          	auipc	s1,0x2
    80006200:	57c48493          	addi	s1,s1,1404 # 80008778 <etext+0x778>
      for(; *s; s++)
    80006204:	02800513          	li	a0,40
    80006208:	b7cd                	j	800061ea <printf+0x17e>
      consputc('%');
    8000620a:	855a                	mv	a0,s6
    8000620c:	00000097          	auipc	ra,0x0
    80006210:	b4a080e7          	jalr	-1206(ra) # 80005d56 <consputc>
      break;
    80006214:	b711                	j	80006118 <printf+0xac>
      consputc('%');
    80006216:	855a                	mv	a0,s6
    80006218:	00000097          	auipc	ra,0x0
    8000621c:	b3e080e7          	jalr	-1218(ra) # 80005d56 <consputc>
      consputc(c);
    80006220:	8526                	mv	a0,s1
    80006222:	00000097          	auipc	ra,0x0
    80006226:	b34080e7          	jalr	-1228(ra) # 80005d56 <consputc>
      break;
    8000622a:	b5fd                	j	80006118 <printf+0xac>
    8000622c:	74a6                	ld	s1,104(sp)
    8000622e:	7906                	ld	s2,96(sp)
    80006230:	69e6                	ld	s3,88(sp)
    80006232:	6aa6                	ld	s5,72(sp)
    80006234:	6b06                	ld	s6,64(sp)
    80006236:	7be2                	ld	s7,56(sp)
    80006238:	7c42                	ld	s8,48(sp)
    8000623a:	7ca2                	ld	s9,40(sp)
    8000623c:	6de2                	ld	s11,24(sp)
  if(locking)
    8000623e:	020d1263          	bnez	s10,80006262 <printf+0x1f6>
}
    80006242:	70e6                	ld	ra,120(sp)
    80006244:	7446                	ld	s0,112(sp)
    80006246:	6a46                	ld	s4,80(sp)
    80006248:	7d02                	ld	s10,32(sp)
    8000624a:	6129                	addi	sp,sp,192
    8000624c:	8082                	ret
    8000624e:	74a6                	ld	s1,104(sp)
    80006250:	7906                	ld	s2,96(sp)
    80006252:	69e6                	ld	s3,88(sp)
    80006254:	6aa6                	ld	s5,72(sp)
    80006256:	6b06                	ld	s6,64(sp)
    80006258:	7be2                	ld	s7,56(sp)
    8000625a:	7c42                	ld	s8,48(sp)
    8000625c:	7ca2                	ld	s9,40(sp)
    8000625e:	6de2                	ld	s11,24(sp)
    80006260:	bff9                	j	8000623e <printf+0x1d2>
    release(&pr.lock);
    80006262:	0001e517          	auipc	a0,0x1e
    80006266:	72650513          	addi	a0,a0,1830 # 80024988 <pr>
    8000626a:	00000097          	auipc	ra,0x0
    8000626e:	3e6080e7          	jalr	998(ra) # 80006650 <release>
}
    80006272:	bfc1                	j	80006242 <printf+0x1d6>

0000000080006274 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006274:	1101                	addi	sp,sp,-32
    80006276:	ec06                	sd	ra,24(sp)
    80006278:	e822                	sd	s0,16(sp)
    8000627a:	e426                	sd	s1,8(sp)
    8000627c:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000627e:	0001e497          	auipc	s1,0x1e
    80006282:	70a48493          	addi	s1,s1,1802 # 80024988 <pr>
    80006286:	00002597          	auipc	a1,0x2
    8000628a:	50a58593          	addi	a1,a1,1290 # 80008790 <etext+0x790>
    8000628e:	8526                	mv	a0,s1
    80006290:	00000097          	auipc	ra,0x0
    80006294:	27c080e7          	jalr	636(ra) # 8000650c <initlock>
  pr.locking = 1;
    80006298:	4785                	li	a5,1
    8000629a:	cc9c                	sw	a5,24(s1)
}
    8000629c:	60e2                	ld	ra,24(sp)
    8000629e:	6442                	ld	s0,16(sp)
    800062a0:	64a2                	ld	s1,8(sp)
    800062a2:	6105                	addi	sp,sp,32
    800062a4:	8082                	ret

00000000800062a6 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800062a6:	1141                	addi	sp,sp,-16
    800062a8:	e406                	sd	ra,8(sp)
    800062aa:	e022                	sd	s0,0(sp)
    800062ac:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800062ae:	100007b7          	lui	a5,0x10000
    800062b2:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800062b6:	10000737          	lui	a4,0x10000
    800062ba:	f8000693          	li	a3,-128
    800062be:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800062c2:	468d                	li	a3,3
    800062c4:	10000637          	lui	a2,0x10000
    800062c8:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800062cc:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800062d0:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800062d4:	10000737          	lui	a4,0x10000
    800062d8:	461d                	li	a2,7
    800062da:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800062de:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    800062e2:	00002597          	auipc	a1,0x2
    800062e6:	4b658593          	addi	a1,a1,1206 # 80008798 <etext+0x798>
    800062ea:	0001e517          	auipc	a0,0x1e
    800062ee:	6be50513          	addi	a0,a0,1726 # 800249a8 <uart_tx_lock>
    800062f2:	00000097          	auipc	ra,0x0
    800062f6:	21a080e7          	jalr	538(ra) # 8000650c <initlock>
}
    800062fa:	60a2                	ld	ra,8(sp)
    800062fc:	6402                	ld	s0,0(sp)
    800062fe:	0141                	addi	sp,sp,16
    80006300:	8082                	ret

0000000080006302 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006302:	1101                	addi	sp,sp,-32
    80006304:	ec06                	sd	ra,24(sp)
    80006306:	e822                	sd	s0,16(sp)
    80006308:	e426                	sd	s1,8(sp)
    8000630a:	1000                	addi	s0,sp,32
    8000630c:	84aa                	mv	s1,a0
  push_off();
    8000630e:	00000097          	auipc	ra,0x0
    80006312:	242080e7          	jalr	578(ra) # 80006550 <push_off>

  if(panicked){
    80006316:	00005797          	auipc	a5,0x5
    8000631a:	0467a783          	lw	a5,70(a5) # 8000b35c <panicked>
    8000631e:	eb85                	bnez	a5,8000634e <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006320:	10000737          	lui	a4,0x10000
    80006324:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80006326:	00074783          	lbu	a5,0(a4)
    8000632a:	0207f793          	andi	a5,a5,32
    8000632e:	dfe5                	beqz	a5,80006326 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006330:	0ff4f513          	zext.b	a0,s1
    80006334:	100007b7          	lui	a5,0x10000
    80006338:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000633c:	00000097          	auipc	ra,0x0
    80006340:	2b4080e7          	jalr	692(ra) # 800065f0 <pop_off>
}
    80006344:	60e2                	ld	ra,24(sp)
    80006346:	6442                	ld	s0,16(sp)
    80006348:	64a2                	ld	s1,8(sp)
    8000634a:	6105                	addi	sp,sp,32
    8000634c:	8082                	ret
    for(;;)
    8000634e:	a001                	j	8000634e <uartputc_sync+0x4c>

0000000080006350 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006350:	00005797          	auipc	a5,0x5
    80006354:	0107b783          	ld	a5,16(a5) # 8000b360 <uart_tx_r>
    80006358:	00005717          	auipc	a4,0x5
    8000635c:	01073703          	ld	a4,16(a4) # 8000b368 <uart_tx_w>
    80006360:	06f70f63          	beq	a4,a5,800063de <uartstart+0x8e>
{
    80006364:	7139                	addi	sp,sp,-64
    80006366:	fc06                	sd	ra,56(sp)
    80006368:	f822                	sd	s0,48(sp)
    8000636a:	f426                	sd	s1,40(sp)
    8000636c:	f04a                	sd	s2,32(sp)
    8000636e:	ec4e                	sd	s3,24(sp)
    80006370:	e852                	sd	s4,16(sp)
    80006372:	e456                	sd	s5,8(sp)
    80006374:	e05a                	sd	s6,0(sp)
    80006376:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006378:	10000937          	lui	s2,0x10000
    8000637c:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000637e:	0001ea97          	auipc	s5,0x1e
    80006382:	62aa8a93          	addi	s5,s5,1578 # 800249a8 <uart_tx_lock>
    uart_tx_r += 1;
    80006386:	00005497          	auipc	s1,0x5
    8000638a:	fda48493          	addi	s1,s1,-38 # 8000b360 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    8000638e:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    80006392:	00005997          	auipc	s3,0x5
    80006396:	fd698993          	addi	s3,s3,-42 # 8000b368 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000639a:	00094703          	lbu	a4,0(s2)
    8000639e:	02077713          	andi	a4,a4,32
    800063a2:	c705                	beqz	a4,800063ca <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800063a4:	01f7f713          	andi	a4,a5,31
    800063a8:	9756                	add	a4,a4,s5
    800063aa:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800063ae:	0785                	addi	a5,a5,1
    800063b0:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800063b2:	8526                	mv	a0,s1
    800063b4:	ffffb097          	auipc	ra,0xffffb
    800063b8:	40a080e7          	jalr	1034(ra) # 800017be <wakeup>
    WriteReg(THR, c);
    800063bc:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    800063c0:	609c                	ld	a5,0(s1)
    800063c2:	0009b703          	ld	a4,0(s3)
    800063c6:	fcf71ae3          	bne	a4,a5,8000639a <uartstart+0x4a>
  }
}
    800063ca:	70e2                	ld	ra,56(sp)
    800063cc:	7442                	ld	s0,48(sp)
    800063ce:	74a2                	ld	s1,40(sp)
    800063d0:	7902                	ld	s2,32(sp)
    800063d2:	69e2                	ld	s3,24(sp)
    800063d4:	6a42                	ld	s4,16(sp)
    800063d6:	6aa2                	ld	s5,8(sp)
    800063d8:	6b02                	ld	s6,0(sp)
    800063da:	6121                	addi	sp,sp,64
    800063dc:	8082                	ret
    800063de:	8082                	ret

00000000800063e0 <uartputc>:
{
    800063e0:	7179                	addi	sp,sp,-48
    800063e2:	f406                	sd	ra,40(sp)
    800063e4:	f022                	sd	s0,32(sp)
    800063e6:	ec26                	sd	s1,24(sp)
    800063e8:	e84a                	sd	s2,16(sp)
    800063ea:	e44e                	sd	s3,8(sp)
    800063ec:	e052                	sd	s4,0(sp)
    800063ee:	1800                	addi	s0,sp,48
    800063f0:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800063f2:	0001e517          	auipc	a0,0x1e
    800063f6:	5b650513          	addi	a0,a0,1462 # 800249a8 <uart_tx_lock>
    800063fa:	00000097          	auipc	ra,0x0
    800063fe:	1a2080e7          	jalr	418(ra) # 8000659c <acquire>
  if(panicked){
    80006402:	00005797          	auipc	a5,0x5
    80006406:	f5a7a783          	lw	a5,-166(a5) # 8000b35c <panicked>
    8000640a:	e7c9                	bnez	a5,80006494 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000640c:	00005717          	auipc	a4,0x5
    80006410:	f5c73703          	ld	a4,-164(a4) # 8000b368 <uart_tx_w>
    80006414:	00005797          	auipc	a5,0x5
    80006418:	f4c7b783          	ld	a5,-180(a5) # 8000b360 <uart_tx_r>
    8000641c:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80006420:	0001e997          	auipc	s3,0x1e
    80006424:	58898993          	addi	s3,s3,1416 # 800249a8 <uart_tx_lock>
    80006428:	00005497          	auipc	s1,0x5
    8000642c:	f3848493          	addi	s1,s1,-200 # 8000b360 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006430:	00005917          	auipc	s2,0x5
    80006434:	f3890913          	addi	s2,s2,-200 # 8000b368 <uart_tx_w>
    80006438:	00e79f63          	bne	a5,a4,80006456 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000643c:	85ce                	mv	a1,s3
    8000643e:	8526                	mv	a0,s1
    80006440:	ffffb097          	auipc	ra,0xffffb
    80006444:	31a080e7          	jalr	794(ra) # 8000175a <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006448:	00093703          	ld	a4,0(s2)
    8000644c:	609c                	ld	a5,0(s1)
    8000644e:	02078793          	addi	a5,a5,32
    80006452:	fee785e3          	beq	a5,a4,8000643c <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006456:	0001e497          	auipc	s1,0x1e
    8000645a:	55248493          	addi	s1,s1,1362 # 800249a8 <uart_tx_lock>
    8000645e:	01f77793          	andi	a5,a4,31
    80006462:	97a6                	add	a5,a5,s1
    80006464:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80006468:	0705                	addi	a4,a4,1
    8000646a:	00005797          	auipc	a5,0x5
    8000646e:	eee7bf23          	sd	a4,-258(a5) # 8000b368 <uart_tx_w>
  uartstart();
    80006472:	00000097          	auipc	ra,0x0
    80006476:	ede080e7          	jalr	-290(ra) # 80006350 <uartstart>
  release(&uart_tx_lock);
    8000647a:	8526                	mv	a0,s1
    8000647c:	00000097          	auipc	ra,0x0
    80006480:	1d4080e7          	jalr	468(ra) # 80006650 <release>
}
    80006484:	70a2                	ld	ra,40(sp)
    80006486:	7402                	ld	s0,32(sp)
    80006488:	64e2                	ld	s1,24(sp)
    8000648a:	6942                	ld	s2,16(sp)
    8000648c:	69a2                	ld	s3,8(sp)
    8000648e:	6a02                	ld	s4,0(sp)
    80006490:	6145                	addi	sp,sp,48
    80006492:	8082                	ret
    for(;;)
    80006494:	a001                	j	80006494 <uartputc+0xb4>

0000000080006496 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006496:	1141                	addi	sp,sp,-16
    80006498:	e422                	sd	s0,8(sp)
    8000649a:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000649c:	100007b7          	lui	a5,0x10000
    800064a0:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800064a2:	0007c783          	lbu	a5,0(a5)
    800064a6:	8b85                	andi	a5,a5,1
    800064a8:	cb81                	beqz	a5,800064b8 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    800064aa:	100007b7          	lui	a5,0x10000
    800064ae:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800064b2:	6422                	ld	s0,8(sp)
    800064b4:	0141                	addi	sp,sp,16
    800064b6:	8082                	ret
    return -1;
    800064b8:	557d                	li	a0,-1
    800064ba:	bfe5                	j	800064b2 <uartgetc+0x1c>

00000000800064bc <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800064bc:	1101                	addi	sp,sp,-32
    800064be:	ec06                	sd	ra,24(sp)
    800064c0:	e822                	sd	s0,16(sp)
    800064c2:	e426                	sd	s1,8(sp)
    800064c4:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800064c6:	54fd                	li	s1,-1
    800064c8:	a029                	j	800064d2 <uartintr+0x16>
      break;
    consoleintr(c);
    800064ca:	00000097          	auipc	ra,0x0
    800064ce:	8ce080e7          	jalr	-1842(ra) # 80005d98 <consoleintr>
    int c = uartgetc();
    800064d2:	00000097          	auipc	ra,0x0
    800064d6:	fc4080e7          	jalr	-60(ra) # 80006496 <uartgetc>
    if(c == -1)
    800064da:	fe9518e3          	bne	a0,s1,800064ca <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800064de:	0001e497          	auipc	s1,0x1e
    800064e2:	4ca48493          	addi	s1,s1,1226 # 800249a8 <uart_tx_lock>
    800064e6:	8526                	mv	a0,s1
    800064e8:	00000097          	auipc	ra,0x0
    800064ec:	0b4080e7          	jalr	180(ra) # 8000659c <acquire>
  uartstart();
    800064f0:	00000097          	auipc	ra,0x0
    800064f4:	e60080e7          	jalr	-416(ra) # 80006350 <uartstart>
  release(&uart_tx_lock);
    800064f8:	8526                	mv	a0,s1
    800064fa:	00000097          	auipc	ra,0x0
    800064fe:	156080e7          	jalr	342(ra) # 80006650 <release>
}
    80006502:	60e2                	ld	ra,24(sp)
    80006504:	6442                	ld	s0,16(sp)
    80006506:	64a2                	ld	s1,8(sp)
    80006508:	6105                	addi	sp,sp,32
    8000650a:	8082                	ret

000000008000650c <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000650c:	1141                	addi	sp,sp,-16
    8000650e:	e422                	sd	s0,8(sp)
    80006510:	0800                	addi	s0,sp,16
  lk->name = name;
    80006512:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006514:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006518:	00053823          	sd	zero,16(a0)
}
    8000651c:	6422                	ld	s0,8(sp)
    8000651e:	0141                	addi	sp,sp,16
    80006520:	8082                	ret

0000000080006522 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006522:	411c                	lw	a5,0(a0)
    80006524:	e399                	bnez	a5,8000652a <holding+0x8>
    80006526:	4501                	li	a0,0
  return r;
}
    80006528:	8082                	ret
{
    8000652a:	1101                	addi	sp,sp,-32
    8000652c:	ec06                	sd	ra,24(sp)
    8000652e:	e822                	sd	s0,16(sp)
    80006530:	e426                	sd	s1,8(sp)
    80006532:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006534:	6904                	ld	s1,16(a0)
    80006536:	ffffb097          	auipc	ra,0xffffb
    8000653a:	aae080e7          	jalr	-1362(ra) # 80000fe4 <mycpu>
    8000653e:	40a48533          	sub	a0,s1,a0
    80006542:	00153513          	seqz	a0,a0
}
    80006546:	60e2                	ld	ra,24(sp)
    80006548:	6442                	ld	s0,16(sp)
    8000654a:	64a2                	ld	s1,8(sp)
    8000654c:	6105                	addi	sp,sp,32
    8000654e:	8082                	ret

0000000080006550 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006550:	1101                	addi	sp,sp,-32
    80006552:	ec06                	sd	ra,24(sp)
    80006554:	e822                	sd	s0,16(sp)
    80006556:	e426                	sd	s1,8(sp)
    80006558:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000655a:	100024f3          	csrr	s1,sstatus
    8000655e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006562:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006564:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006568:	ffffb097          	auipc	ra,0xffffb
    8000656c:	a7c080e7          	jalr	-1412(ra) # 80000fe4 <mycpu>
    80006570:	5d3c                	lw	a5,120(a0)
    80006572:	cf89                	beqz	a5,8000658c <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006574:	ffffb097          	auipc	ra,0xffffb
    80006578:	a70080e7          	jalr	-1424(ra) # 80000fe4 <mycpu>
    8000657c:	5d3c                	lw	a5,120(a0)
    8000657e:	2785                	addiw	a5,a5,1
    80006580:	dd3c                	sw	a5,120(a0)
}
    80006582:	60e2                	ld	ra,24(sp)
    80006584:	6442                	ld	s0,16(sp)
    80006586:	64a2                	ld	s1,8(sp)
    80006588:	6105                	addi	sp,sp,32
    8000658a:	8082                	ret
    mycpu()->intena = old;
    8000658c:	ffffb097          	auipc	ra,0xffffb
    80006590:	a58080e7          	jalr	-1448(ra) # 80000fe4 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006594:	8085                	srli	s1,s1,0x1
    80006596:	8885                	andi	s1,s1,1
    80006598:	dd64                	sw	s1,124(a0)
    8000659a:	bfe9                	j	80006574 <push_off+0x24>

000000008000659c <acquire>:
{
    8000659c:	1101                	addi	sp,sp,-32
    8000659e:	ec06                	sd	ra,24(sp)
    800065a0:	e822                	sd	s0,16(sp)
    800065a2:	e426                	sd	s1,8(sp)
    800065a4:	1000                	addi	s0,sp,32
    800065a6:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800065a8:	00000097          	auipc	ra,0x0
    800065ac:	fa8080e7          	jalr	-88(ra) # 80006550 <push_off>
  if(holding(lk))
    800065b0:	8526                	mv	a0,s1
    800065b2:	00000097          	auipc	ra,0x0
    800065b6:	f70080e7          	jalr	-144(ra) # 80006522 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800065ba:	4705                	li	a4,1
  if(holding(lk))
    800065bc:	e115                	bnez	a0,800065e0 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800065be:	87ba                	mv	a5,a4
    800065c0:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800065c4:	2781                	sext.w	a5,a5
    800065c6:	ffe5                	bnez	a5,800065be <acquire+0x22>
  __sync_synchronize();
    800065c8:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    800065cc:	ffffb097          	auipc	ra,0xffffb
    800065d0:	a18080e7          	jalr	-1512(ra) # 80000fe4 <mycpu>
    800065d4:	e888                	sd	a0,16(s1)
}
    800065d6:	60e2                	ld	ra,24(sp)
    800065d8:	6442                	ld	s0,16(sp)
    800065da:	64a2                	ld	s1,8(sp)
    800065dc:	6105                	addi	sp,sp,32
    800065de:	8082                	ret
    panic("acquire");
    800065e0:	00002517          	auipc	a0,0x2
    800065e4:	1c050513          	addi	a0,a0,448 # 800087a0 <etext+0x7a0>
    800065e8:	00000097          	auipc	ra,0x0
    800065ec:	a3a080e7          	jalr	-1478(ra) # 80006022 <panic>

00000000800065f0 <pop_off>:

void
pop_off(void)
{
    800065f0:	1141                	addi	sp,sp,-16
    800065f2:	e406                	sd	ra,8(sp)
    800065f4:	e022                	sd	s0,0(sp)
    800065f6:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800065f8:	ffffb097          	auipc	ra,0xffffb
    800065fc:	9ec080e7          	jalr	-1556(ra) # 80000fe4 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006600:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006604:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006606:	e78d                	bnez	a5,80006630 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006608:	5d3c                	lw	a5,120(a0)
    8000660a:	02f05b63          	blez	a5,80006640 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000660e:	37fd                	addiw	a5,a5,-1
    80006610:	0007871b          	sext.w	a4,a5
    80006614:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006616:	eb09                	bnez	a4,80006628 <pop_off+0x38>
    80006618:	5d7c                	lw	a5,124(a0)
    8000661a:	c799                	beqz	a5,80006628 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000661c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006620:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006624:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006628:	60a2                	ld	ra,8(sp)
    8000662a:	6402                	ld	s0,0(sp)
    8000662c:	0141                	addi	sp,sp,16
    8000662e:	8082                	ret
    panic("pop_off - interruptible");
    80006630:	00002517          	auipc	a0,0x2
    80006634:	17850513          	addi	a0,a0,376 # 800087a8 <etext+0x7a8>
    80006638:	00000097          	auipc	ra,0x0
    8000663c:	9ea080e7          	jalr	-1558(ra) # 80006022 <panic>
    panic("pop_off");
    80006640:	00002517          	auipc	a0,0x2
    80006644:	18050513          	addi	a0,a0,384 # 800087c0 <etext+0x7c0>
    80006648:	00000097          	auipc	ra,0x0
    8000664c:	9da080e7          	jalr	-1574(ra) # 80006022 <panic>

0000000080006650 <release>:
{
    80006650:	1101                	addi	sp,sp,-32
    80006652:	ec06                	sd	ra,24(sp)
    80006654:	e822                	sd	s0,16(sp)
    80006656:	e426                	sd	s1,8(sp)
    80006658:	1000                	addi	s0,sp,32
    8000665a:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000665c:	00000097          	auipc	ra,0x0
    80006660:	ec6080e7          	jalr	-314(ra) # 80006522 <holding>
    80006664:	c115                	beqz	a0,80006688 <release+0x38>
  lk->cpu = 0;
    80006666:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000666a:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    8000666e:	0310000f          	fence	rw,w
    80006672:	0004a023          	sw	zero,0(s1)
  pop_off();
    80006676:	00000097          	auipc	ra,0x0
    8000667a:	f7a080e7          	jalr	-134(ra) # 800065f0 <pop_off>
}
    8000667e:	60e2                	ld	ra,24(sp)
    80006680:	6442                	ld	s0,16(sp)
    80006682:	64a2                	ld	s1,8(sp)
    80006684:	6105                	addi	sp,sp,32
    80006686:	8082                	ret
    panic("release");
    80006688:	00002517          	auipc	a0,0x2
    8000668c:	14050513          	addi	a0,a0,320 # 800087c8 <etext+0x7c8>
    80006690:	00000097          	auipc	ra,0x0
    80006694:	992080e7          	jalr	-1646(ra) # 80006022 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
