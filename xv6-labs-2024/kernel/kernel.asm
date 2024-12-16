
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	2d013103          	ld	sp,720(sp) # 8000a2d0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	5c9040ef          	jal	80004dde <start>

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
    8000002c:	e7a9                	bnez	a5,80000076 <kfree+0x5a>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00024797          	auipc	a5,0x24
    80000034:	82078793          	addi	a5,a5,-2016 # 80023850 <end>
    80000038:	02f56f63          	bltu	a0,a5,80000076 <kfree+0x5a>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57b63          	bgeu	a0,a5,80000076 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	106000ef          	jal	8000014e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    8000004c:	0000a917          	auipc	s2,0xa
    80000050:	2d490913          	addi	s2,s2,724 # 8000a320 <kmem>
    80000054:	854a                	mv	a0,s2
    80000056:	7ea050ef          	jal	80005840 <acquire>
  r->next = kmem.freelist;
    8000005a:	01893783          	ld	a5,24(s2)
    8000005e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000060:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000064:	854a                	mv	a0,s2
    80000066:	073050ef          	jal	800058d8 <release>
}
    8000006a:	60e2                	ld	ra,24(sp)
    8000006c:	6442                	ld	s0,16(sp)
    8000006e:	64a2                	ld	s1,8(sp)
    80000070:	6902                	ld	s2,0(sp)
    80000072:	6105                	addi	sp,sp,32
    80000074:	8082                	ret
    panic("kfree");
    80000076:	00007517          	auipc	a0,0x7
    8000007a:	f8a50513          	addi	a0,a0,-118 # 80007000 <etext>
    8000007e:	494050ef          	jal	80005512 <panic>

0000000080000082 <freerange>:
{
    80000082:	7179                	addi	sp,sp,-48
    80000084:	f406                	sd	ra,40(sp)
    80000086:	f022                	sd	s0,32(sp)
    80000088:	ec26                	sd	s1,24(sp)
    8000008a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000008c:	6785                	lui	a5,0x1
    8000008e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000092:	00e504b3          	add	s1,a0,a4
    80000096:	777d                	lui	a4,0xfffff
    80000098:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000009a:	94be                	add	s1,s1,a5
    8000009c:	0295e263          	bltu	a1,s1,800000c0 <freerange+0x3e>
    800000a0:	e84a                	sd	s2,16(sp)
    800000a2:	e44e                	sd	s3,8(sp)
    800000a4:	e052                	sd	s4,0(sp)
    800000a6:	892e                	mv	s2,a1
    kfree(p);
    800000a8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000aa:	6985                	lui	s3,0x1
    kfree(p);
    800000ac:	01448533          	add	a0,s1,s4
    800000b0:	f6dff0ef          	jal	8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b4:	94ce                	add	s1,s1,s3
    800000b6:	fe997be3          	bgeu	s2,s1,800000ac <freerange+0x2a>
    800000ba:	6942                	ld	s2,16(sp)
    800000bc:	69a2                	ld	s3,8(sp)
    800000be:	6a02                	ld	s4,0(sp)
}
    800000c0:	70a2                	ld	ra,40(sp)
    800000c2:	7402                	ld	s0,32(sp)
    800000c4:	64e2                	ld	s1,24(sp)
    800000c6:	6145                	addi	sp,sp,48
    800000c8:	8082                	ret

00000000800000ca <kinit>:
{
    800000ca:	1141                	addi	sp,sp,-16
    800000cc:	e406                	sd	ra,8(sp)
    800000ce:	e022                	sd	s0,0(sp)
    800000d0:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000d2:	00007597          	auipc	a1,0x7
    800000d6:	f3e58593          	addi	a1,a1,-194 # 80007010 <etext+0x10>
    800000da:	0000a517          	auipc	a0,0xa
    800000de:	24650513          	addi	a0,a0,582 # 8000a320 <kmem>
    800000e2:	6de050ef          	jal	800057c0 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000e6:	45c5                	li	a1,17
    800000e8:	05ee                	slli	a1,a1,0x1b
    800000ea:	00023517          	auipc	a0,0x23
    800000ee:	76650513          	addi	a0,a0,1894 # 80023850 <end>
    800000f2:	f91ff0ef          	jal	80000082 <freerange>
}
    800000f6:	60a2                	ld	ra,8(sp)
    800000f8:	6402                	ld	s0,0(sp)
    800000fa:	0141                	addi	sp,sp,16
    800000fc:	8082                	ret

00000000800000fe <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800000fe:	1101                	addi	sp,sp,-32
    80000100:	ec06                	sd	ra,24(sp)
    80000102:	e822                	sd	s0,16(sp)
    80000104:	e426                	sd	s1,8(sp)
    80000106:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000108:	0000a497          	auipc	s1,0xa
    8000010c:	21848493          	addi	s1,s1,536 # 8000a320 <kmem>
    80000110:	8526                	mv	a0,s1
    80000112:	72e050ef          	jal	80005840 <acquire>
  r = kmem.freelist;
    80000116:	6c84                	ld	s1,24(s1)
  if(r)
    80000118:	c485                	beqz	s1,80000140 <kalloc+0x42>
    kmem.freelist = r->next;
    8000011a:	609c                	ld	a5,0(s1)
    8000011c:	0000a517          	auipc	a0,0xa
    80000120:	20450513          	addi	a0,a0,516 # 8000a320 <kmem>
    80000124:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000126:	7b2050ef          	jal	800058d8 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000012a:	6605                	lui	a2,0x1
    8000012c:	4595                	li	a1,5
    8000012e:	8526                	mv	a0,s1
    80000130:	01e000ef          	jal	8000014e <memset>
  return (void*)r;
}
    80000134:	8526                	mv	a0,s1
    80000136:	60e2                	ld	ra,24(sp)
    80000138:	6442                	ld	s0,16(sp)
    8000013a:	64a2                	ld	s1,8(sp)
    8000013c:	6105                	addi	sp,sp,32
    8000013e:	8082                	ret
  release(&kmem.lock);
    80000140:	0000a517          	auipc	a0,0xa
    80000144:	1e050513          	addi	a0,a0,480 # 8000a320 <kmem>
    80000148:	790050ef          	jal	800058d8 <release>
  if(r)
    8000014c:	b7e5                	j	80000134 <kalloc+0x36>

000000008000014e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000014e:	1141                	addi	sp,sp,-16
    80000150:	e422                	sd	s0,8(sp)
    80000152:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000154:	ca19                	beqz	a2,8000016a <memset+0x1c>
    80000156:	87aa                	mv	a5,a0
    80000158:	1602                	slli	a2,a2,0x20
    8000015a:	9201                	srli	a2,a2,0x20
    8000015c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000160:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000164:	0785                	addi	a5,a5,1
    80000166:	fee79de3          	bne	a5,a4,80000160 <memset+0x12>
  }
  return dst;
}
    8000016a:	6422                	ld	s0,8(sp)
    8000016c:	0141                	addi	sp,sp,16
    8000016e:	8082                	ret

0000000080000170 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000170:	1141                	addi	sp,sp,-16
    80000172:	e422                	sd	s0,8(sp)
    80000174:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000176:	ca05                	beqz	a2,800001a6 <memcmp+0x36>
    80000178:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    8000017c:	1682                	slli	a3,a3,0x20
    8000017e:	9281                	srli	a3,a3,0x20
    80000180:	0685                	addi	a3,a3,1
    80000182:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000184:	00054783          	lbu	a5,0(a0)
    80000188:	0005c703          	lbu	a4,0(a1)
    8000018c:	00e79863          	bne	a5,a4,8000019c <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000190:	0505                	addi	a0,a0,1
    80000192:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000194:	fed518e3          	bne	a0,a3,80000184 <memcmp+0x14>
  }

  return 0;
    80000198:	4501                	li	a0,0
    8000019a:	a019                	j	800001a0 <memcmp+0x30>
      return *s1 - *s2;
    8000019c:	40e7853b          	subw	a0,a5,a4
}
    800001a0:	6422                	ld	s0,8(sp)
    800001a2:	0141                	addi	sp,sp,16
    800001a4:	8082                	ret
  return 0;
    800001a6:	4501                	li	a0,0
    800001a8:	bfe5                	j	800001a0 <memcmp+0x30>

00000000800001aa <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001aa:	1141                	addi	sp,sp,-16
    800001ac:	e422                	sd	s0,8(sp)
    800001ae:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001b0:	c205                	beqz	a2,800001d0 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001b2:	02a5e263          	bltu	a1,a0,800001d6 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001b6:	1602                	slli	a2,a2,0x20
    800001b8:	9201                	srli	a2,a2,0x20
    800001ba:	00c587b3          	add	a5,a1,a2
{
    800001be:	872a                	mv	a4,a0
      *d++ = *s++;
    800001c0:	0585                	addi	a1,a1,1
    800001c2:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdb7b1>
    800001c4:	fff5c683          	lbu	a3,-1(a1)
    800001c8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001cc:	feb79ae3          	bne	a5,a1,800001c0 <memmove+0x16>

  return dst;
}
    800001d0:	6422                	ld	s0,8(sp)
    800001d2:	0141                	addi	sp,sp,16
    800001d4:	8082                	ret
  if(s < d && s + n > d){
    800001d6:	02061693          	slli	a3,a2,0x20
    800001da:	9281                	srli	a3,a3,0x20
    800001dc:	00d58733          	add	a4,a1,a3
    800001e0:	fce57be3          	bgeu	a0,a4,800001b6 <memmove+0xc>
    d += n;
    800001e4:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800001e6:	fff6079b          	addiw	a5,a2,-1
    800001ea:	1782                	slli	a5,a5,0x20
    800001ec:	9381                	srli	a5,a5,0x20
    800001ee:	fff7c793          	not	a5,a5
    800001f2:	97ba                	add	a5,a5,a4
      *--d = *--s;
    800001f4:	177d                	addi	a4,a4,-1
    800001f6:	16fd                	addi	a3,a3,-1
    800001f8:	00074603          	lbu	a2,0(a4)
    800001fc:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000200:	fef71ae3          	bne	a4,a5,800001f4 <memmove+0x4a>
    80000204:	b7f1                	j	800001d0 <memmove+0x26>

0000000080000206 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000206:	1141                	addi	sp,sp,-16
    80000208:	e406                	sd	ra,8(sp)
    8000020a:	e022                	sd	s0,0(sp)
    8000020c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000020e:	f9dff0ef          	jal	800001aa <memmove>
}
    80000212:	60a2                	ld	ra,8(sp)
    80000214:	6402                	ld	s0,0(sp)
    80000216:	0141                	addi	sp,sp,16
    80000218:	8082                	ret

000000008000021a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000021a:	1141                	addi	sp,sp,-16
    8000021c:	e422                	sd	s0,8(sp)
    8000021e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000220:	ce11                	beqz	a2,8000023c <strncmp+0x22>
    80000222:	00054783          	lbu	a5,0(a0)
    80000226:	cf89                	beqz	a5,80000240 <strncmp+0x26>
    80000228:	0005c703          	lbu	a4,0(a1)
    8000022c:	00f71a63          	bne	a4,a5,80000240 <strncmp+0x26>
    n--, p++, q++;
    80000230:	367d                	addiw	a2,a2,-1
    80000232:	0505                	addi	a0,a0,1
    80000234:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000236:	f675                	bnez	a2,80000222 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000238:	4501                	li	a0,0
    8000023a:	a801                	j	8000024a <strncmp+0x30>
    8000023c:	4501                	li	a0,0
    8000023e:	a031                	j	8000024a <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000240:	00054503          	lbu	a0,0(a0)
    80000244:	0005c783          	lbu	a5,0(a1)
    80000248:	9d1d                	subw	a0,a0,a5
}
    8000024a:	6422                	ld	s0,8(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret

0000000080000250 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000256:	87aa                	mv	a5,a0
    80000258:	86b2                	mv	a3,a2
    8000025a:	367d                	addiw	a2,a2,-1
    8000025c:	02d05563          	blez	a3,80000286 <strncpy+0x36>
    80000260:	0785                	addi	a5,a5,1
    80000262:	0005c703          	lbu	a4,0(a1)
    80000266:	fee78fa3          	sb	a4,-1(a5)
    8000026a:	0585                	addi	a1,a1,1
    8000026c:	f775                	bnez	a4,80000258 <strncpy+0x8>
    ;
  while(n-- > 0)
    8000026e:	873e                	mv	a4,a5
    80000270:	9fb5                	addw	a5,a5,a3
    80000272:	37fd                	addiw	a5,a5,-1
    80000274:	00c05963          	blez	a2,80000286 <strncpy+0x36>
    *s++ = 0;
    80000278:	0705                	addi	a4,a4,1
    8000027a:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    8000027e:	40e786bb          	subw	a3,a5,a4
    80000282:	fed04be3          	bgtz	a3,80000278 <strncpy+0x28>
  return os;
}
    80000286:	6422                	ld	s0,8(sp)
    80000288:	0141                	addi	sp,sp,16
    8000028a:	8082                	ret

000000008000028c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e422                	sd	s0,8(sp)
    80000290:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000292:	02c05363          	blez	a2,800002b8 <safestrcpy+0x2c>
    80000296:	fff6069b          	addiw	a3,a2,-1
    8000029a:	1682                	slli	a3,a3,0x20
    8000029c:	9281                	srli	a3,a3,0x20
    8000029e:	96ae                	add	a3,a3,a1
    800002a0:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002a2:	00d58963          	beq	a1,a3,800002b4 <safestrcpy+0x28>
    800002a6:	0585                	addi	a1,a1,1
    800002a8:	0785                	addi	a5,a5,1
    800002aa:	fff5c703          	lbu	a4,-1(a1)
    800002ae:	fee78fa3          	sb	a4,-1(a5)
    800002b2:	fb65                	bnez	a4,800002a2 <safestrcpy+0x16>
    ;
  *s = 0;
    800002b4:	00078023          	sb	zero,0(a5)
  return os;
}
    800002b8:	6422                	ld	s0,8(sp)
    800002ba:	0141                	addi	sp,sp,16
    800002bc:	8082                	ret

00000000800002be <strlen>:

int
strlen(const char *s)
{
    800002be:	1141                	addi	sp,sp,-16
    800002c0:	e422                	sd	s0,8(sp)
    800002c2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002c4:	00054783          	lbu	a5,0(a0)
    800002c8:	cf91                	beqz	a5,800002e4 <strlen+0x26>
    800002ca:	0505                	addi	a0,a0,1
    800002cc:	87aa                	mv	a5,a0
    800002ce:	86be                	mv	a3,a5
    800002d0:	0785                	addi	a5,a5,1
    800002d2:	fff7c703          	lbu	a4,-1(a5)
    800002d6:	ff65                	bnez	a4,800002ce <strlen+0x10>
    800002d8:	40a6853b          	subw	a0,a3,a0
    800002dc:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    800002de:	6422                	ld	s0,8(sp)
    800002e0:	0141                	addi	sp,sp,16
    800002e2:	8082                	ret
  for(n = 0; s[n]; n++)
    800002e4:	4501                	li	a0,0
    800002e6:	bfe5                	j	800002de <strlen+0x20>

00000000800002e8 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800002e8:	1141                	addi	sp,sp,-16
    800002ea:	e406                	sd	ra,8(sp)
    800002ec:	e022                	sd	s0,0(sp)
    800002ee:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    800002f0:	285000ef          	jal	80000d74 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    800002f4:	0000a717          	auipc	a4,0xa
    800002f8:	ffc70713          	addi	a4,a4,-4 # 8000a2f0 <started>
  if(cpuid() == 0){
    800002fc:	c51d                	beqz	a0,8000032a <main+0x42>
    while(started == 0)
    800002fe:	431c                	lw	a5,0(a4)
    80000300:	2781                	sext.w	a5,a5
    80000302:	dff5                	beqz	a5,800002fe <main+0x16>
      ;
    __sync_synchronize();
    80000304:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000308:	26d000ef          	jal	80000d74 <cpuid>
    8000030c:	85aa                	mv	a1,a0
    8000030e:	00007517          	auipc	a0,0x7
    80000312:	d2a50513          	addi	a0,a0,-726 # 80007038 <etext+0x38>
    80000316:	72b040ef          	jal	80005240 <printf>
    kvminithart();    // turn on paging
    8000031a:	080000ef          	jal	8000039a <kvminithart>
    trapinithart();   // install kernel trap vector
    8000031e:	5fa010ef          	jal	80001918 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000322:	4d6040ef          	jal	800047f8 <plicinithart>
  }

  scheduler();        
    80000326:	737000ef          	jal	8000125c <scheduler>
    consoleinit();
    8000032a:	641040ef          	jal	8000516a <consoleinit>
    printfinit();
    8000032e:	21e050ef          	jal	8000554c <printfinit>
    printf("\n");
    80000332:	00007517          	auipc	a0,0x7
    80000336:	ce650513          	addi	a0,a0,-794 # 80007018 <etext+0x18>
    8000033a:	707040ef          	jal	80005240 <printf>
    printf("xv6 kernel is booting\n");
    8000033e:	00007517          	auipc	a0,0x7
    80000342:	ce250513          	addi	a0,a0,-798 # 80007020 <etext+0x20>
    80000346:	6fb040ef          	jal	80005240 <printf>
    printf("\n");
    8000034a:	00007517          	auipc	a0,0x7
    8000034e:	cce50513          	addi	a0,a0,-818 # 80007018 <etext+0x18>
    80000352:	6ef040ef          	jal	80005240 <printf>
    kinit();         // physical page allocator
    80000356:	d75ff0ef          	jal	800000ca <kinit>
    kvminit();       // create kernel page table
    8000035a:	2d4000ef          	jal	8000062e <kvminit>
    kvminithart();   // turn on paging
    8000035e:	03c000ef          	jal	8000039a <kvminithart>
    procinit();      // process table
    80000362:	15f000ef          	jal	80000cc0 <procinit>
    trapinit();      // trap vectors
    80000366:	58e010ef          	jal	800018f4 <trapinit>
    trapinithart();  // install kernel trap vector
    8000036a:	5ae010ef          	jal	80001918 <trapinithart>
    plicinit();      // set up interrupt controller
    8000036e:	470040ef          	jal	800047de <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000372:	486040ef          	jal	800047f8 <plicinithart>
    binit();         // buffer cache
    80000376:	429010ef          	jal	80001f9e <binit>
    iinit();         // inode table
    8000037a:	21a020ef          	jal	80002594 <iinit>
    fileinit();      // file table
    8000037e:	7c7020ef          	jal	80003344 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000382:	566040ef          	jal	800048e8 <virtio_disk_init>
    userinit();      // first user process
    80000386:	50b000ef          	jal	80001090 <userinit>
    __sync_synchronize();
    8000038a:	0330000f          	fence	rw,rw
    started = 1;
    8000038e:	4785                	li	a5,1
    80000390:	0000a717          	auipc	a4,0xa
    80000394:	f6f72023          	sw	a5,-160(a4) # 8000a2f0 <started>
    80000398:	b779                	j	80000326 <main+0x3e>

000000008000039a <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000039a:	1141                	addi	sp,sp,-16
    8000039c:	e422                	sd	s0,8(sp)
    8000039e:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800003a0:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800003a4:	0000a797          	auipc	a5,0xa
    800003a8:	f547b783          	ld	a5,-172(a5) # 8000a2f8 <kernel_pagetable>
    800003ac:	83b1                	srli	a5,a5,0xc
    800003ae:	577d                	li	a4,-1
    800003b0:	177e                	slli	a4,a4,0x3f
    800003b2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800003b4:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800003b8:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800003bc:	6422                	ld	s0,8(sp)
    800003be:	0141                	addi	sp,sp,16
    800003c0:	8082                	ret

00000000800003c2 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800003c2:	7139                	addi	sp,sp,-64
    800003c4:	fc06                	sd	ra,56(sp)
    800003c6:	f822                	sd	s0,48(sp)
    800003c8:	f426                	sd	s1,40(sp)
    800003ca:	f04a                	sd	s2,32(sp)
    800003cc:	ec4e                	sd	s3,24(sp)
    800003ce:	e852                	sd	s4,16(sp)
    800003d0:	e456                	sd	s5,8(sp)
    800003d2:	e05a                	sd	s6,0(sp)
    800003d4:	0080                	addi	s0,sp,64
    800003d6:	892a                	mv	s2,a0
    800003d8:	89ae                	mv	s3,a1
    800003da:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800003dc:	57fd                	li	a5,-1
    800003de:	83e9                	srli	a5,a5,0x1a
    800003e0:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800003e2:	4b31                	li	s6,12
  if(va >= MAXVA)
    800003e4:	02b7fb63          	bgeu	a5,a1,8000041a <walk+0x58>
    panic("walk");
    800003e8:	00007517          	auipc	a0,0x7
    800003ec:	c6850513          	addi	a0,a0,-920 # 80007050 <etext+0x50>
    800003f0:	122050ef          	jal	80005512 <panic>
      if(PTE_LEAF(*pte)) {
        return pte;
      }
#endif
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800003f4:	060a8563          	beqz	s5,8000045e <walk+0x9c>
    800003f8:	d07ff0ef          	jal	800000fe <kalloc>
    800003fc:	892a                	mv	s2,a0
    800003fe:	c135                	beqz	a0,80000462 <walk+0xa0>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000400:	6605                	lui	a2,0x1
    80000402:	4581                	li	a1,0
    80000404:	d4bff0ef          	jal	8000014e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000408:	00c95793          	srli	a5,s2,0xc
    8000040c:	07aa                	slli	a5,a5,0xa
    8000040e:	0017e793          	ori	a5,a5,1
    80000412:	e09c                	sd	a5,0(s1)
  for(int level = 2; level > 0; level--) {
    80000414:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdb7a7>
    80000416:	036a0263          	beq	s4,s6,8000043a <walk+0x78>
    pte_t *pte = &pagetable[PX(level, va)];
    8000041a:	0149d4b3          	srl	s1,s3,s4
    8000041e:	1ff4f493          	andi	s1,s1,511
    80000422:	048e                	slli	s1,s1,0x3
    80000424:	94ca                	add	s1,s1,s2
    if(*pte & PTE_V) {
    80000426:	609c                	ld	a5,0(s1)
    80000428:	0017f713          	andi	a4,a5,1
    8000042c:	d761                	beqz	a4,800003f4 <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000042e:	00a7d913          	srli	s2,a5,0xa
    80000432:	0932                	slli	s2,s2,0xc
      if(PTE_LEAF(*pte)) {
    80000434:	8bb9                	andi	a5,a5,14
    80000436:	dff9                	beqz	a5,80000414 <walk+0x52>
    80000438:	a801                	j	80000448 <walk+0x86>
    }
  }
  return &pagetable[PX(0, va)];
    8000043a:	00c9d993          	srli	s3,s3,0xc
    8000043e:	1ff9f993          	andi	s3,s3,511
    80000442:	098e                	slli	s3,s3,0x3
    80000444:	013904b3          	add	s1,s2,s3
}
    80000448:	8526                	mv	a0,s1
    8000044a:	70e2                	ld	ra,56(sp)
    8000044c:	7442                	ld	s0,48(sp)
    8000044e:	74a2                	ld	s1,40(sp)
    80000450:	7902                	ld	s2,32(sp)
    80000452:	69e2                	ld	s3,24(sp)
    80000454:	6a42                	ld	s4,16(sp)
    80000456:	6aa2                	ld	s5,8(sp)
    80000458:	6b02                	ld	s6,0(sp)
    8000045a:	6121                	addi	sp,sp,64
    8000045c:	8082                	ret
        return 0;
    8000045e:	4481                	li	s1,0
    80000460:	b7e5                	j	80000448 <walk+0x86>
    80000462:	84aa                	mv	s1,a0
    80000464:	b7d5                	j	80000448 <walk+0x86>

0000000080000466 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000466:	57fd                	li	a5,-1
    80000468:	83e9                	srli	a5,a5,0x1a
    8000046a:	00b7f463          	bgeu	a5,a1,80000472 <walkaddr+0xc>
    return 0;
    8000046e:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000470:	8082                	ret
{
    80000472:	1141                	addi	sp,sp,-16
    80000474:	e406                	sd	ra,8(sp)
    80000476:	e022                	sd	s0,0(sp)
    80000478:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000047a:	4601                	li	a2,0
    8000047c:	f47ff0ef          	jal	800003c2 <walk>
  if(pte == 0)
    80000480:	c105                	beqz	a0,800004a0 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80000482:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000484:	0117f693          	andi	a3,a5,17
    80000488:	4745                	li	a4,17
    return 0;
    8000048a:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000048c:	00e68663          	beq	a3,a4,80000498 <walkaddr+0x32>
}
    80000490:	60a2                	ld	ra,8(sp)
    80000492:	6402                	ld	s0,0(sp)
    80000494:	0141                	addi	sp,sp,16
    80000496:	8082                	ret
  pa = PTE2PA(*pte);
    80000498:	83a9                	srli	a5,a5,0xa
    8000049a:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000049e:	bfcd                	j	80000490 <walkaddr+0x2a>
    return 0;
    800004a0:	4501                	li	a0,0
    800004a2:	b7fd                	j	80000490 <walkaddr+0x2a>

00000000800004a4 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800004a4:	715d                	addi	sp,sp,-80
    800004a6:	e486                	sd	ra,72(sp)
    800004a8:	e0a2                	sd	s0,64(sp)
    800004aa:	fc26                	sd	s1,56(sp)
    800004ac:	f84a                	sd	s2,48(sp)
    800004ae:	f44e                	sd	s3,40(sp)
    800004b0:	f052                	sd	s4,32(sp)
    800004b2:	ec56                	sd	s5,24(sp)
    800004b4:	e85a                	sd	s6,16(sp)
    800004b6:	e45e                	sd	s7,8(sp)
    800004b8:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800004ba:	03459793          	slli	a5,a1,0x34
    800004be:	e7a9                	bnez	a5,80000508 <mappages+0x64>
    800004c0:	8aaa                	mv	s5,a0
    800004c2:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800004c4:	03461793          	slli	a5,a2,0x34
    800004c8:	e7b1                	bnez	a5,80000514 <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    800004ca:	ca39                	beqz	a2,80000520 <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800004cc:	77fd                	lui	a5,0xfffff
    800004ce:	963e                	add	a2,a2,a5
    800004d0:	00b609b3          	add	s3,a2,a1
  a = va;
    800004d4:	892e                	mv	s2,a1
    800004d6:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800004da:	6b85                	lui	s7,0x1
    800004dc:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    800004e0:	4605                	li	a2,1
    800004e2:	85ca                	mv	a1,s2
    800004e4:	8556                	mv	a0,s5
    800004e6:	eddff0ef          	jal	800003c2 <walk>
    800004ea:	c539                	beqz	a0,80000538 <mappages+0x94>
    if(*pte & PTE_V)
    800004ec:	611c                	ld	a5,0(a0)
    800004ee:	8b85                	andi	a5,a5,1
    800004f0:	ef95                	bnez	a5,8000052c <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800004f2:	80b1                	srli	s1,s1,0xc
    800004f4:	04aa                	slli	s1,s1,0xa
    800004f6:	0164e4b3          	or	s1,s1,s6
    800004fa:	0014e493          	ori	s1,s1,1
    800004fe:	e104                	sd	s1,0(a0)
    if(a == last)
    80000500:	05390863          	beq	s2,s3,80000550 <mappages+0xac>
    a += PGSIZE;
    80000504:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80000506:	bfd9                	j	800004dc <mappages+0x38>
    panic("mappages: va not aligned");
    80000508:	00007517          	auipc	a0,0x7
    8000050c:	b5050513          	addi	a0,a0,-1200 # 80007058 <etext+0x58>
    80000510:	002050ef          	jal	80005512 <panic>
    panic("mappages: size not aligned");
    80000514:	00007517          	auipc	a0,0x7
    80000518:	b6450513          	addi	a0,a0,-1180 # 80007078 <etext+0x78>
    8000051c:	7f7040ef          	jal	80005512 <panic>
    panic("mappages: size");
    80000520:	00007517          	auipc	a0,0x7
    80000524:	b7850513          	addi	a0,a0,-1160 # 80007098 <etext+0x98>
    80000528:	7eb040ef          	jal	80005512 <panic>
      panic("mappages: remap");
    8000052c:	00007517          	auipc	a0,0x7
    80000530:	b7c50513          	addi	a0,a0,-1156 # 800070a8 <etext+0xa8>
    80000534:	7df040ef          	jal	80005512 <panic>
      return -1;
    80000538:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000053a:	60a6                	ld	ra,72(sp)
    8000053c:	6406                	ld	s0,64(sp)
    8000053e:	74e2                	ld	s1,56(sp)
    80000540:	7942                	ld	s2,48(sp)
    80000542:	79a2                	ld	s3,40(sp)
    80000544:	7a02                	ld	s4,32(sp)
    80000546:	6ae2                	ld	s5,24(sp)
    80000548:	6b42                	ld	s6,16(sp)
    8000054a:	6ba2                	ld	s7,8(sp)
    8000054c:	6161                	addi	sp,sp,80
    8000054e:	8082                	ret
  return 0;
    80000550:	4501                	li	a0,0
    80000552:	b7e5                	j	8000053a <mappages+0x96>

0000000080000554 <kvmmap>:
{
    80000554:	1141                	addi	sp,sp,-16
    80000556:	e406                	sd	ra,8(sp)
    80000558:	e022                	sd	s0,0(sp)
    8000055a:	0800                	addi	s0,sp,16
    8000055c:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000055e:	86b2                	mv	a3,a2
    80000560:	863e                	mv	a2,a5
    80000562:	f43ff0ef          	jal	800004a4 <mappages>
    80000566:	e509                	bnez	a0,80000570 <kvmmap+0x1c>
}
    80000568:	60a2                	ld	ra,8(sp)
    8000056a:	6402                	ld	s0,0(sp)
    8000056c:	0141                	addi	sp,sp,16
    8000056e:	8082                	ret
    panic("kvmmap");
    80000570:	00007517          	auipc	a0,0x7
    80000574:	b4850513          	addi	a0,a0,-1208 # 800070b8 <etext+0xb8>
    80000578:	79b040ef          	jal	80005512 <panic>

000000008000057c <kvmmake>:
{
    8000057c:	1101                	addi	sp,sp,-32
    8000057e:	ec06                	sd	ra,24(sp)
    80000580:	e822                	sd	s0,16(sp)
    80000582:	e426                	sd	s1,8(sp)
    80000584:	e04a                	sd	s2,0(sp)
    80000586:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000588:	b77ff0ef          	jal	800000fe <kalloc>
    8000058c:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000058e:	6605                	lui	a2,0x1
    80000590:	4581                	li	a1,0
    80000592:	bbdff0ef          	jal	8000014e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000596:	4719                	li	a4,6
    80000598:	6685                	lui	a3,0x1
    8000059a:	10000637          	lui	a2,0x10000
    8000059e:	100005b7          	lui	a1,0x10000
    800005a2:	8526                	mv	a0,s1
    800005a4:	fb1ff0ef          	jal	80000554 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800005a8:	4719                	li	a4,6
    800005aa:	6685                	lui	a3,0x1
    800005ac:	10001637          	lui	a2,0x10001
    800005b0:	100015b7          	lui	a1,0x10001
    800005b4:	8526                	mv	a0,s1
    800005b6:	f9fff0ef          	jal	80000554 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800005ba:	4719                	li	a4,6
    800005bc:	040006b7          	lui	a3,0x4000
    800005c0:	0c000637          	lui	a2,0xc000
    800005c4:	0c0005b7          	lui	a1,0xc000
    800005c8:	8526                	mv	a0,s1
    800005ca:	f8bff0ef          	jal	80000554 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800005ce:	00007917          	auipc	s2,0x7
    800005d2:	a3290913          	addi	s2,s2,-1486 # 80007000 <etext>
    800005d6:	4729                	li	a4,10
    800005d8:	80007697          	auipc	a3,0x80007
    800005dc:	a2868693          	addi	a3,a3,-1496 # 7000 <_entry-0x7fff9000>
    800005e0:	4605                	li	a2,1
    800005e2:	067e                	slli	a2,a2,0x1f
    800005e4:	85b2                	mv	a1,a2
    800005e6:	8526                	mv	a0,s1
    800005e8:	f6dff0ef          	jal	80000554 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800005ec:	46c5                	li	a3,17
    800005ee:	06ee                	slli	a3,a3,0x1b
    800005f0:	4719                	li	a4,6
    800005f2:	412686b3          	sub	a3,a3,s2
    800005f6:	864a                	mv	a2,s2
    800005f8:	85ca                	mv	a1,s2
    800005fa:	8526                	mv	a0,s1
    800005fc:	f59ff0ef          	jal	80000554 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000600:	4729                	li	a4,10
    80000602:	6685                	lui	a3,0x1
    80000604:	00006617          	auipc	a2,0x6
    80000608:	9fc60613          	addi	a2,a2,-1540 # 80006000 <_trampoline>
    8000060c:	040005b7          	lui	a1,0x4000
    80000610:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000612:	05b2                	slli	a1,a1,0xc
    80000614:	8526                	mv	a0,s1
    80000616:	f3fff0ef          	jal	80000554 <kvmmap>
  proc_mapstacks(kpgtbl);
    8000061a:	8526                	mv	a0,s1
    8000061c:	60e000ef          	jal	80000c2a <proc_mapstacks>
}
    80000620:	8526                	mv	a0,s1
    80000622:	60e2                	ld	ra,24(sp)
    80000624:	6442                	ld	s0,16(sp)
    80000626:	64a2                	ld	s1,8(sp)
    80000628:	6902                	ld	s2,0(sp)
    8000062a:	6105                	addi	sp,sp,32
    8000062c:	8082                	ret

000000008000062e <kvminit>:
{
    8000062e:	1141                	addi	sp,sp,-16
    80000630:	e406                	sd	ra,8(sp)
    80000632:	e022                	sd	s0,0(sp)
    80000634:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000636:	f47ff0ef          	jal	8000057c <kvmmake>
    8000063a:	0000a797          	auipc	a5,0xa
    8000063e:	caa7bf23          	sd	a0,-834(a5) # 8000a2f8 <kernel_pagetable>
}
    80000642:	60a2                	ld	ra,8(sp)
    80000644:	6402                	ld	s0,0(sp)
    80000646:	0141                	addi	sp,sp,16
    80000648:	8082                	ret

000000008000064a <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000064a:	715d                	addi	sp,sp,-80
    8000064c:	e486                	sd	ra,72(sp)
    8000064e:	e0a2                	sd	s0,64(sp)
    80000650:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;
  int sz;

  if((va % PGSIZE) != 0)
    80000652:	03459793          	slli	a5,a1,0x34
    80000656:	e39d                	bnez	a5,8000067c <uvmunmap+0x32>
    80000658:	f84a                	sd	s2,48(sp)
    8000065a:	f44e                	sd	s3,40(sp)
    8000065c:	f052                	sd	s4,32(sp)
    8000065e:	ec56                	sd	s5,24(sp)
    80000660:	e85a                	sd	s6,16(sp)
    80000662:	e45e                	sd	s7,8(sp)
    80000664:	8a2a                	mv	s4,a0
    80000666:	892e                	mv	s2,a1
    80000668:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += sz){
    8000066a:	0632                	slli	a2,a2,0xc
    8000066c:	00b609b3          	add	s3,a2,a1
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0) {
      printf("va=%ld pte=%ld\n", a, *pte);
      panic("uvmunmap: not mapped");
    }
    if(PTE_FLAGS(*pte) == PTE_V)
    80000670:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += sz){
    80000672:	6b05                	lui	s6,0x1
    80000674:	0935f763          	bgeu	a1,s3,80000702 <uvmunmap+0xb8>
    80000678:	fc26                	sd	s1,56(sp)
    8000067a:	a8a1                	j	800006d2 <uvmunmap+0x88>
    8000067c:	fc26                	sd	s1,56(sp)
    8000067e:	f84a                	sd	s2,48(sp)
    80000680:	f44e                	sd	s3,40(sp)
    80000682:	f052                	sd	s4,32(sp)
    80000684:	ec56                	sd	s5,24(sp)
    80000686:	e85a                	sd	s6,16(sp)
    80000688:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    8000068a:	00007517          	auipc	a0,0x7
    8000068e:	a3650513          	addi	a0,a0,-1482 # 800070c0 <etext+0xc0>
    80000692:	681040ef          	jal	80005512 <panic>
      panic("uvmunmap: walk");
    80000696:	00007517          	auipc	a0,0x7
    8000069a:	a4250513          	addi	a0,a0,-1470 # 800070d8 <etext+0xd8>
    8000069e:	675040ef          	jal	80005512 <panic>
      printf("va=%ld pte=%ld\n", a, *pte);
    800006a2:	85ca                	mv	a1,s2
    800006a4:	00007517          	auipc	a0,0x7
    800006a8:	a4450513          	addi	a0,a0,-1468 # 800070e8 <etext+0xe8>
    800006ac:	395040ef          	jal	80005240 <printf>
      panic("uvmunmap: not mapped");
    800006b0:	00007517          	auipc	a0,0x7
    800006b4:	a4850513          	addi	a0,a0,-1464 # 800070f8 <etext+0xf8>
    800006b8:	65b040ef          	jal	80005512 <panic>
      panic("uvmunmap: not a leaf");
    800006bc:	00007517          	auipc	a0,0x7
    800006c0:	a5450513          	addi	a0,a0,-1452 # 80007110 <etext+0x110>
    800006c4:	64f040ef          	jal	80005512 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800006c8:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += sz){
    800006cc:	995a                	add	s2,s2,s6
    800006ce:	03397963          	bgeu	s2,s3,80000700 <uvmunmap+0xb6>
    if((pte = walk(pagetable, a, 0)) == 0)
    800006d2:	4601                	li	a2,0
    800006d4:	85ca                	mv	a1,s2
    800006d6:	8552                	mv	a0,s4
    800006d8:	cebff0ef          	jal	800003c2 <walk>
    800006dc:	84aa                	mv	s1,a0
    800006de:	dd45                	beqz	a0,80000696 <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0) {
    800006e0:	6110                	ld	a2,0(a0)
    800006e2:	00167793          	andi	a5,a2,1
    800006e6:	dfd5                	beqz	a5,800006a2 <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    800006e8:	3ff67793          	andi	a5,a2,1023
    800006ec:	fd7788e3          	beq	a5,s7,800006bc <uvmunmap+0x72>
    if(do_free){
    800006f0:	fc0a8ce3          	beqz	s5,800006c8 <uvmunmap+0x7e>
      uint64 pa = PTE2PA(*pte);
    800006f4:	8229                	srli	a2,a2,0xa
      kfree((void*)pa);
    800006f6:	00c61513          	slli	a0,a2,0xc
    800006fa:	923ff0ef          	jal	8000001c <kfree>
    800006fe:	b7e9                	j	800006c8 <uvmunmap+0x7e>
    80000700:	74e2                	ld	s1,56(sp)
    80000702:	7942                	ld	s2,48(sp)
    80000704:	79a2                	ld	s3,40(sp)
    80000706:	7a02                	ld	s4,32(sp)
    80000708:	6ae2                	ld	s5,24(sp)
    8000070a:	6b42                	ld	s6,16(sp)
    8000070c:	6ba2                	ld	s7,8(sp)
  }
}
    8000070e:	60a6                	ld	ra,72(sp)
    80000710:	6406                	ld	s0,64(sp)
    80000712:	6161                	addi	sp,sp,80
    80000714:	8082                	ret

0000000080000716 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000716:	1101                	addi	sp,sp,-32
    80000718:	ec06                	sd	ra,24(sp)
    8000071a:	e822                	sd	s0,16(sp)
    8000071c:	e426                	sd	s1,8(sp)
    8000071e:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000720:	9dfff0ef          	jal	800000fe <kalloc>
    80000724:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000726:	c509                	beqz	a0,80000730 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000728:	6605                	lui	a2,0x1
    8000072a:	4581                	li	a1,0
    8000072c:	a23ff0ef          	jal	8000014e <memset>
  return pagetable;
}
    80000730:	8526                	mv	a0,s1
    80000732:	60e2                	ld	ra,24(sp)
    80000734:	6442                	ld	s0,16(sp)
    80000736:	64a2                	ld	s1,8(sp)
    80000738:	6105                	addi	sp,sp,32
    8000073a:	8082                	ret

000000008000073c <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000073c:	7179                	addi	sp,sp,-48
    8000073e:	f406                	sd	ra,40(sp)
    80000740:	f022                	sd	s0,32(sp)
    80000742:	ec26                	sd	s1,24(sp)
    80000744:	e84a                	sd	s2,16(sp)
    80000746:	e44e                	sd	s3,8(sp)
    80000748:	e052                	sd	s4,0(sp)
    8000074a:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000074c:	6785                	lui	a5,0x1
    8000074e:	04f67063          	bgeu	a2,a5,8000078e <uvmfirst+0x52>
    80000752:	8a2a                	mv	s4,a0
    80000754:	89ae                	mv	s3,a1
    80000756:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000758:	9a7ff0ef          	jal	800000fe <kalloc>
    8000075c:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000075e:	6605                	lui	a2,0x1
    80000760:	4581                	li	a1,0
    80000762:	9edff0ef          	jal	8000014e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000766:	4779                	li	a4,30
    80000768:	86ca                	mv	a3,s2
    8000076a:	6605                	lui	a2,0x1
    8000076c:	4581                	li	a1,0
    8000076e:	8552                	mv	a0,s4
    80000770:	d35ff0ef          	jal	800004a4 <mappages>
  memmove(mem, src, sz);
    80000774:	8626                	mv	a2,s1
    80000776:	85ce                	mv	a1,s3
    80000778:	854a                	mv	a0,s2
    8000077a:	a31ff0ef          	jal	800001aa <memmove>
}
    8000077e:	70a2                	ld	ra,40(sp)
    80000780:	7402                	ld	s0,32(sp)
    80000782:	64e2                	ld	s1,24(sp)
    80000784:	6942                	ld	s2,16(sp)
    80000786:	69a2                	ld	s3,8(sp)
    80000788:	6a02                	ld	s4,0(sp)
    8000078a:	6145                	addi	sp,sp,48
    8000078c:	8082                	ret
    panic("uvmfirst: more than a page");
    8000078e:	00007517          	auipc	a0,0x7
    80000792:	99a50513          	addi	a0,a0,-1638 # 80007128 <etext+0x128>
    80000796:	57d040ef          	jal	80005512 <panic>

000000008000079a <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000079a:	1101                	addi	sp,sp,-32
    8000079c:	ec06                	sd	ra,24(sp)
    8000079e:	e822                	sd	s0,16(sp)
    800007a0:	e426                	sd	s1,8(sp)
    800007a2:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800007a4:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800007a6:	00b67d63          	bgeu	a2,a1,800007c0 <uvmdealloc+0x26>
    800007aa:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800007ac:	6785                	lui	a5,0x1
    800007ae:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007b0:	00f60733          	add	a4,a2,a5
    800007b4:	76fd                	lui	a3,0xfffff
    800007b6:	8f75                	and	a4,a4,a3
    800007b8:	97ae                	add	a5,a5,a1
    800007ba:	8ff5                	and	a5,a5,a3
    800007bc:	00f76863          	bltu	a4,a5,800007cc <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800007c0:	8526                	mv	a0,s1
    800007c2:	60e2                	ld	ra,24(sp)
    800007c4:	6442                	ld	s0,16(sp)
    800007c6:	64a2                	ld	s1,8(sp)
    800007c8:	6105                	addi	sp,sp,32
    800007ca:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800007cc:	8f99                	sub	a5,a5,a4
    800007ce:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800007d0:	4685                	li	a3,1
    800007d2:	0007861b          	sext.w	a2,a5
    800007d6:	85ba                	mv	a1,a4
    800007d8:	e73ff0ef          	jal	8000064a <uvmunmap>
    800007dc:	b7d5                	j	800007c0 <uvmdealloc+0x26>

00000000800007de <uvmalloc>:
  if(newsz < oldsz)
    800007de:	08b66f63          	bltu	a2,a1,8000087c <uvmalloc+0x9e>
{
    800007e2:	7139                	addi	sp,sp,-64
    800007e4:	fc06                	sd	ra,56(sp)
    800007e6:	f822                	sd	s0,48(sp)
    800007e8:	ec4e                	sd	s3,24(sp)
    800007ea:	e852                	sd	s4,16(sp)
    800007ec:	e456                	sd	s5,8(sp)
    800007ee:	0080                	addi	s0,sp,64
    800007f0:	8aaa                	mv	s5,a0
    800007f2:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800007f4:	6785                	lui	a5,0x1
    800007f6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007f8:	95be                	add	a1,a1,a5
    800007fa:	77fd                	lui	a5,0xfffff
    800007fc:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += sz){
    80000800:	08c9f063          	bgeu	s3,a2,80000880 <uvmalloc+0xa2>
    80000804:	f426                	sd	s1,40(sp)
    80000806:	f04a                	sd	s2,32(sp)
    80000808:	e05a                	sd	s6,0(sp)
    8000080a:	894e                	mv	s2,s3
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000080c:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000810:	8efff0ef          	jal	800000fe <kalloc>
    80000814:	84aa                	mv	s1,a0
    if(mem == 0){
    80000816:	c515                	beqz	a0,80000842 <uvmalloc+0x64>
    memset(mem, 0, sz);
    80000818:	6605                	lui	a2,0x1
    8000081a:	4581                	li	a1,0
    8000081c:	933ff0ef          	jal	8000014e <memset>
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000820:	875a                	mv	a4,s6
    80000822:	86a6                	mv	a3,s1
    80000824:	6605                	lui	a2,0x1
    80000826:	85ca                	mv	a1,s2
    80000828:	8556                	mv	a0,s5
    8000082a:	c7bff0ef          	jal	800004a4 <mappages>
    8000082e:	e915                	bnez	a0,80000862 <uvmalloc+0x84>
  for(a = oldsz; a < newsz; a += sz){
    80000830:	6785                	lui	a5,0x1
    80000832:	993e                	add	s2,s2,a5
    80000834:	fd496ee3          	bltu	s2,s4,80000810 <uvmalloc+0x32>
  return newsz;
    80000838:	8552                	mv	a0,s4
    8000083a:	74a2                	ld	s1,40(sp)
    8000083c:	7902                	ld	s2,32(sp)
    8000083e:	6b02                	ld	s6,0(sp)
    80000840:	a811                	j	80000854 <uvmalloc+0x76>
      uvmdealloc(pagetable, a, oldsz);
    80000842:	864e                	mv	a2,s3
    80000844:	85ca                	mv	a1,s2
    80000846:	8556                	mv	a0,s5
    80000848:	f53ff0ef          	jal	8000079a <uvmdealloc>
      return 0;
    8000084c:	4501                	li	a0,0
    8000084e:	74a2                	ld	s1,40(sp)
    80000850:	7902                	ld	s2,32(sp)
    80000852:	6b02                	ld	s6,0(sp)
}
    80000854:	70e2                	ld	ra,56(sp)
    80000856:	7442                	ld	s0,48(sp)
    80000858:	69e2                	ld	s3,24(sp)
    8000085a:	6a42                	ld	s4,16(sp)
    8000085c:	6aa2                	ld	s5,8(sp)
    8000085e:	6121                	addi	sp,sp,64
    80000860:	8082                	ret
      kfree(mem);
    80000862:	8526                	mv	a0,s1
    80000864:	fb8ff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000868:	864e                	mv	a2,s3
    8000086a:	85ca                	mv	a1,s2
    8000086c:	8556                	mv	a0,s5
    8000086e:	f2dff0ef          	jal	8000079a <uvmdealloc>
      return 0;
    80000872:	4501                	li	a0,0
    80000874:	74a2                	ld	s1,40(sp)
    80000876:	7902                	ld	s2,32(sp)
    80000878:	6b02                	ld	s6,0(sp)
    8000087a:	bfe9                	j	80000854 <uvmalloc+0x76>
    return oldsz;
    8000087c:	852e                	mv	a0,a1
}
    8000087e:	8082                	ret
  return newsz;
    80000880:	8532                	mv	a0,a2
    80000882:	bfc9                	j	80000854 <uvmalloc+0x76>

0000000080000884 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000884:	7179                	addi	sp,sp,-48
    80000886:	f406                	sd	ra,40(sp)
    80000888:	f022                	sd	s0,32(sp)
    8000088a:	ec26                	sd	s1,24(sp)
    8000088c:	e84a                	sd	s2,16(sp)
    8000088e:	e44e                	sd	s3,8(sp)
    80000890:	e052                	sd	s4,0(sp)
    80000892:	1800                	addi	s0,sp,48
    80000894:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000896:	84aa                	mv	s1,a0
    80000898:	6905                	lui	s2,0x1
    8000089a:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000089c:	4985                	li	s3,1
    8000089e:	a819                	j	800008b4 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800008a0:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800008a2:	00c79513          	slli	a0,a5,0xc
    800008a6:	fdfff0ef          	jal	80000884 <freewalk>
      pagetable[i] = 0;
    800008aa:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800008ae:	04a1                	addi	s1,s1,8
    800008b0:	01248f63          	beq	s1,s2,800008ce <freewalk+0x4a>
    pte_t pte = pagetable[i];
    800008b4:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800008b6:	00f7f713          	andi	a4,a5,15
    800008ba:	ff3703e3          	beq	a4,s3,800008a0 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800008be:	8b85                	andi	a5,a5,1
    800008c0:	d7fd                	beqz	a5,800008ae <freewalk+0x2a>
      panic("freewalk: leaf");
    800008c2:	00007517          	auipc	a0,0x7
    800008c6:	88650513          	addi	a0,a0,-1914 # 80007148 <etext+0x148>
    800008ca:	449040ef          	jal	80005512 <panic>
    }
  }
  kfree((void*)pagetable);
    800008ce:	8552                	mv	a0,s4
    800008d0:	f4cff0ef          	jal	8000001c <kfree>
}
    800008d4:	70a2                	ld	ra,40(sp)
    800008d6:	7402                	ld	s0,32(sp)
    800008d8:	64e2                	ld	s1,24(sp)
    800008da:	6942                	ld	s2,16(sp)
    800008dc:	69a2                	ld	s3,8(sp)
    800008de:	6a02                	ld	s4,0(sp)
    800008e0:	6145                	addi	sp,sp,48
    800008e2:	8082                	ret

00000000800008e4 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800008e4:	1101                	addi	sp,sp,-32
    800008e6:	ec06                	sd	ra,24(sp)
    800008e8:	e822                	sd	s0,16(sp)
    800008ea:	e426                	sd	s1,8(sp)
    800008ec:	1000                	addi	s0,sp,32
    800008ee:	84aa                	mv	s1,a0
  if(sz > 0)
    800008f0:	e989                	bnez	a1,80000902 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800008f2:	8526                	mv	a0,s1
    800008f4:	f91ff0ef          	jal	80000884 <freewalk>
}
    800008f8:	60e2                	ld	ra,24(sp)
    800008fa:	6442                	ld	s0,16(sp)
    800008fc:	64a2                	ld	s1,8(sp)
    800008fe:	6105                	addi	sp,sp,32
    80000900:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000902:	6785                	lui	a5,0x1
    80000904:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000906:	95be                	add	a1,a1,a5
    80000908:	4685                	li	a3,1
    8000090a:	00c5d613          	srli	a2,a1,0xc
    8000090e:	4581                	li	a1,0
    80000910:	d3bff0ef          	jal	8000064a <uvmunmap>
    80000914:	bff9                	j	800008f2 <uvmfree+0xe>

0000000080000916 <uvmcopy>:
  uint64 pa, i;
  uint flags;
  char *mem;
  int szinc;

  for(i = 0; i < sz; i += szinc){
    80000916:	c65d                	beqz	a2,800009c4 <uvmcopy+0xae>
{
    80000918:	715d                	addi	sp,sp,-80
    8000091a:	e486                	sd	ra,72(sp)
    8000091c:	e0a2                	sd	s0,64(sp)
    8000091e:	fc26                	sd	s1,56(sp)
    80000920:	f84a                	sd	s2,48(sp)
    80000922:	f44e                	sd	s3,40(sp)
    80000924:	f052                	sd	s4,32(sp)
    80000926:	ec56                	sd	s5,24(sp)
    80000928:	e85a                	sd	s6,16(sp)
    8000092a:	e45e                	sd	s7,8(sp)
    8000092c:	0880                	addi	s0,sp,80
    8000092e:	8b2a                	mv	s6,a0
    80000930:	8aae                	mv	s5,a1
    80000932:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += szinc){
    80000934:	4981                	li	s3,0
    szinc = PGSIZE;
    szinc = PGSIZE;
    if((pte = walk(old, i, 0)) == 0)
    80000936:	4601                	li	a2,0
    80000938:	85ce                	mv	a1,s3
    8000093a:	855a                	mv	a0,s6
    8000093c:	a87ff0ef          	jal	800003c2 <walk>
    80000940:	c121                	beqz	a0,80000980 <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000942:	6118                	ld	a4,0(a0)
    80000944:	00177793          	andi	a5,a4,1
    80000948:	c3b1                	beqz	a5,8000098c <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    8000094a:	00a75593          	srli	a1,a4,0xa
    8000094e:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000952:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000956:	fa8ff0ef          	jal	800000fe <kalloc>
    8000095a:	892a                	mv	s2,a0
    8000095c:	c129                	beqz	a0,8000099e <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    8000095e:	6605                	lui	a2,0x1
    80000960:	85de                	mv	a1,s7
    80000962:	849ff0ef          	jal	800001aa <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000966:	8726                	mv	a4,s1
    80000968:	86ca                	mv	a3,s2
    8000096a:	6605                	lui	a2,0x1
    8000096c:	85ce                	mv	a1,s3
    8000096e:	8556                	mv	a0,s5
    80000970:	b35ff0ef          	jal	800004a4 <mappages>
    80000974:	e115                	bnez	a0,80000998 <uvmcopy+0x82>
  for(i = 0; i < sz; i += szinc){
    80000976:	6785                	lui	a5,0x1
    80000978:	99be                	add	s3,s3,a5
    8000097a:	fb49eee3          	bltu	s3,s4,80000936 <uvmcopy+0x20>
    8000097e:	a805                	j	800009ae <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    80000980:	00006517          	auipc	a0,0x6
    80000984:	7d850513          	addi	a0,a0,2008 # 80007158 <etext+0x158>
    80000988:	38b040ef          	jal	80005512 <panic>
      panic("uvmcopy: page not present");
    8000098c:	00006517          	auipc	a0,0x6
    80000990:	7ec50513          	addi	a0,a0,2028 # 80007178 <etext+0x178>
    80000994:	37f040ef          	jal	80005512 <panic>
      kfree(mem);
    80000998:	854a                	mv	a0,s2
    8000099a:	e82ff0ef          	jal	8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    8000099e:	4685                	li	a3,1
    800009a0:	00c9d613          	srli	a2,s3,0xc
    800009a4:	4581                	li	a1,0
    800009a6:	8556                	mv	a0,s5
    800009a8:	ca3ff0ef          	jal	8000064a <uvmunmap>
  return -1;
    800009ac:	557d                	li	a0,-1
}
    800009ae:	60a6                	ld	ra,72(sp)
    800009b0:	6406                	ld	s0,64(sp)
    800009b2:	74e2                	ld	s1,56(sp)
    800009b4:	7942                	ld	s2,48(sp)
    800009b6:	79a2                	ld	s3,40(sp)
    800009b8:	7a02                	ld	s4,32(sp)
    800009ba:	6ae2                	ld	s5,24(sp)
    800009bc:	6b42                	ld	s6,16(sp)
    800009be:	6ba2                	ld	s7,8(sp)
    800009c0:	6161                	addi	sp,sp,80
    800009c2:	8082                	ret
  return 0;
    800009c4:	4501                	li	a0,0
}
    800009c6:	8082                	ret

00000000800009c8 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800009c8:	1141                	addi	sp,sp,-16
    800009ca:	e406                	sd	ra,8(sp)
    800009cc:	e022                	sd	s0,0(sp)
    800009ce:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800009d0:	4601                	li	a2,0
    800009d2:	9f1ff0ef          	jal	800003c2 <walk>
  if(pte == 0)
    800009d6:	c901                	beqz	a0,800009e6 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800009d8:	611c                	ld	a5,0(a0)
    800009da:	9bbd                	andi	a5,a5,-17
    800009dc:	e11c                	sd	a5,0(a0)
}
    800009de:	60a2                	ld	ra,8(sp)
    800009e0:	6402                	ld	s0,0(sp)
    800009e2:	0141                	addi	sp,sp,16
    800009e4:	8082                	ret
    panic("uvmclear");
    800009e6:	00006517          	auipc	a0,0x6
    800009ea:	7b250513          	addi	a0,a0,1970 # 80007198 <etext+0x198>
    800009ee:	325040ef          	jal	80005512 <panic>

00000000800009f2 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    800009f2:	cac1                	beqz	a3,80000a82 <copyout+0x90>
{
    800009f4:	711d                	addi	sp,sp,-96
    800009f6:	ec86                	sd	ra,88(sp)
    800009f8:	e8a2                	sd	s0,80(sp)
    800009fa:	e4a6                	sd	s1,72(sp)
    800009fc:	fc4e                	sd	s3,56(sp)
    800009fe:	f852                	sd	s4,48(sp)
    80000a00:	f456                	sd	s5,40(sp)
    80000a02:	f05a                	sd	s6,32(sp)
    80000a04:	1080                	addi	s0,sp,96
    80000a06:	8b2a                	mv	s6,a0
    80000a08:	8a2e                	mv	s4,a1
    80000a0a:	8ab2                	mv	s5,a2
    80000a0c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000a0e:	74fd                	lui	s1,0xfffff
    80000a10:	8ced                	and	s1,s1,a1
    if (va0 >= MAXVA)
    80000a12:	57fd                	li	a5,-1
    80000a14:	83e9                	srli	a5,a5,0x1a
    80000a16:	0697e863          	bltu	a5,s1,80000a86 <copyout+0x94>
    80000a1a:	e0ca                	sd	s2,64(sp)
    80000a1c:	ec5e                	sd	s7,24(sp)
    80000a1e:	e862                	sd	s8,16(sp)
    80000a20:	e466                	sd	s9,8(sp)
    80000a22:	6c05                	lui	s8,0x1
    80000a24:	8bbe                	mv	s7,a5
    80000a26:	a015                	j	80000a4a <copyout+0x58>
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000a28:	409a04b3          	sub	s1,s4,s1
    80000a2c:	0009061b          	sext.w	a2,s2
    80000a30:	85d6                	mv	a1,s5
    80000a32:	9526                	add	a0,a0,s1
    80000a34:	f76ff0ef          	jal	800001aa <memmove>

    len -= n;
    80000a38:	412989b3          	sub	s3,s3,s2
    src += n;
    80000a3c:	9aca                	add	s5,s5,s2
  while(len > 0){
    80000a3e:	02098c63          	beqz	s3,80000a76 <copyout+0x84>
    if (va0 >= MAXVA)
    80000a42:	059be463          	bltu	s7,s9,80000a8a <copyout+0x98>
    80000a46:	84e6                	mv	s1,s9
    80000a48:	8a66                	mv	s4,s9
    if((pte = walk(pagetable, va0, 0)) == 0) {
    80000a4a:	4601                	li	a2,0
    80000a4c:	85a6                	mv	a1,s1
    80000a4e:	855a                	mv	a0,s6
    80000a50:	973ff0ef          	jal	800003c2 <walk>
    80000a54:	c129                	beqz	a0,80000a96 <copyout+0xa4>
    if((*pte & PTE_W) == 0)
    80000a56:	611c                	ld	a5,0(a0)
    80000a58:	8b91                	andi	a5,a5,4
    80000a5a:	cfa1                	beqz	a5,80000ab2 <copyout+0xc0>
    pa0 = walkaddr(pagetable, va0);
    80000a5c:	85a6                	mv	a1,s1
    80000a5e:	855a                	mv	a0,s6
    80000a60:	a07ff0ef          	jal	80000466 <walkaddr>
    if(pa0 == 0)
    80000a64:	cd29                	beqz	a0,80000abe <copyout+0xcc>
    n = PGSIZE - (dstva - va0);
    80000a66:	01848cb3          	add	s9,s1,s8
    80000a6a:	414c8933          	sub	s2,s9,s4
    if(n > len)
    80000a6e:	fb29fde3          	bgeu	s3,s2,80000a28 <copyout+0x36>
    80000a72:	894e                	mv	s2,s3
    80000a74:	bf55                	j	80000a28 <copyout+0x36>
    dstva = va0 + PGSIZE;
  }
  return 0;
    80000a76:	4501                	li	a0,0
    80000a78:	6906                	ld	s2,64(sp)
    80000a7a:	6be2                	ld	s7,24(sp)
    80000a7c:	6c42                	ld	s8,16(sp)
    80000a7e:	6ca2                	ld	s9,8(sp)
    80000a80:	a005                	j	80000aa0 <copyout+0xae>
    80000a82:	4501                	li	a0,0
}
    80000a84:	8082                	ret
      return -1;
    80000a86:	557d                	li	a0,-1
    80000a88:	a821                	j	80000aa0 <copyout+0xae>
    80000a8a:	557d                	li	a0,-1
    80000a8c:	6906                	ld	s2,64(sp)
    80000a8e:	6be2                	ld	s7,24(sp)
    80000a90:	6c42                	ld	s8,16(sp)
    80000a92:	6ca2                	ld	s9,8(sp)
    80000a94:	a031                	j	80000aa0 <copyout+0xae>
      return -1;
    80000a96:	557d                	li	a0,-1
    80000a98:	6906                	ld	s2,64(sp)
    80000a9a:	6be2                	ld	s7,24(sp)
    80000a9c:	6c42                	ld	s8,16(sp)
    80000a9e:	6ca2                	ld	s9,8(sp)
}
    80000aa0:	60e6                	ld	ra,88(sp)
    80000aa2:	6446                	ld	s0,80(sp)
    80000aa4:	64a6                	ld	s1,72(sp)
    80000aa6:	79e2                	ld	s3,56(sp)
    80000aa8:	7a42                	ld	s4,48(sp)
    80000aaa:	7aa2                	ld	s5,40(sp)
    80000aac:	7b02                	ld	s6,32(sp)
    80000aae:	6125                	addi	sp,sp,96
    80000ab0:	8082                	ret
      return -1;
    80000ab2:	557d                	li	a0,-1
    80000ab4:	6906                	ld	s2,64(sp)
    80000ab6:	6be2                	ld	s7,24(sp)
    80000ab8:	6c42                	ld	s8,16(sp)
    80000aba:	6ca2                	ld	s9,8(sp)
    80000abc:	b7d5                	j	80000aa0 <copyout+0xae>
      return -1;
    80000abe:	557d                	li	a0,-1
    80000ac0:	6906                	ld	s2,64(sp)
    80000ac2:	6be2                	ld	s7,24(sp)
    80000ac4:	6c42                	ld	s8,16(sp)
    80000ac6:	6ca2                	ld	s9,8(sp)
    80000ac8:	bfe1                	j	80000aa0 <copyout+0xae>

0000000080000aca <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;
  
  while(len > 0){
    80000aca:	c6a5                	beqz	a3,80000b32 <copyin+0x68>
{
    80000acc:	715d                	addi	sp,sp,-80
    80000ace:	e486                	sd	ra,72(sp)
    80000ad0:	e0a2                	sd	s0,64(sp)
    80000ad2:	fc26                	sd	s1,56(sp)
    80000ad4:	f84a                	sd	s2,48(sp)
    80000ad6:	f44e                	sd	s3,40(sp)
    80000ad8:	f052                	sd	s4,32(sp)
    80000ada:	ec56                	sd	s5,24(sp)
    80000adc:	e85a                	sd	s6,16(sp)
    80000ade:	e45e                	sd	s7,8(sp)
    80000ae0:	e062                	sd	s8,0(sp)
    80000ae2:	0880                	addi	s0,sp,80
    80000ae4:	8b2a                	mv	s6,a0
    80000ae6:	8a2e                	mv	s4,a1
    80000ae8:	8c32                	mv	s8,a2
    80000aea:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000aec:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000aee:	6a85                	lui	s5,0x1
    80000af0:	a00d                	j	80000b12 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000af2:	018505b3          	add	a1,a0,s8
    80000af6:	0004861b          	sext.w	a2,s1
    80000afa:	412585b3          	sub	a1,a1,s2
    80000afe:	8552                	mv	a0,s4
    80000b00:	eaaff0ef          	jal	800001aa <memmove>

    len -= n;
    80000b04:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000b08:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000b0a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b0e:	02098063          	beqz	s3,80000b2e <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80000b12:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b16:	85ca                	mv	a1,s2
    80000b18:	855a                	mv	a0,s6
    80000b1a:	94dff0ef          	jal	80000466 <walkaddr>
    if(pa0 == 0)
    80000b1e:	cd01                	beqz	a0,80000b36 <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    80000b20:	418904b3          	sub	s1,s2,s8
    80000b24:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b26:	fc99f6e3          	bgeu	s3,s1,80000af2 <copyin+0x28>
    80000b2a:	84ce                	mv	s1,s3
    80000b2c:	b7d9                	j	80000af2 <copyin+0x28>
  }
  return 0;
    80000b2e:	4501                	li	a0,0
    80000b30:	a021                	j	80000b38 <copyin+0x6e>
    80000b32:	4501                	li	a0,0
}
    80000b34:	8082                	ret
      return -1;
    80000b36:	557d                	li	a0,-1
}
    80000b38:	60a6                	ld	ra,72(sp)
    80000b3a:	6406                	ld	s0,64(sp)
    80000b3c:	74e2                	ld	s1,56(sp)
    80000b3e:	7942                	ld	s2,48(sp)
    80000b40:	79a2                	ld	s3,40(sp)
    80000b42:	7a02                	ld	s4,32(sp)
    80000b44:	6ae2                	ld	s5,24(sp)
    80000b46:	6b42                	ld	s6,16(sp)
    80000b48:	6ba2                	ld	s7,8(sp)
    80000b4a:	6c02                	ld	s8,0(sp)
    80000b4c:	6161                	addi	sp,sp,80
    80000b4e:	8082                	ret

0000000080000b50 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000b50:	c6dd                	beqz	a3,80000bfe <copyinstr+0xae>
{
    80000b52:	715d                	addi	sp,sp,-80
    80000b54:	e486                	sd	ra,72(sp)
    80000b56:	e0a2                	sd	s0,64(sp)
    80000b58:	fc26                	sd	s1,56(sp)
    80000b5a:	f84a                	sd	s2,48(sp)
    80000b5c:	f44e                	sd	s3,40(sp)
    80000b5e:	f052                	sd	s4,32(sp)
    80000b60:	ec56                	sd	s5,24(sp)
    80000b62:	e85a                	sd	s6,16(sp)
    80000b64:	e45e                	sd	s7,8(sp)
    80000b66:	0880                	addi	s0,sp,80
    80000b68:	8a2a                	mv	s4,a0
    80000b6a:	8b2e                	mv	s6,a1
    80000b6c:	8bb2                	mv	s7,a2
    80000b6e:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000b70:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b72:	6985                	lui	s3,0x1
    80000b74:	a825                	j	80000bac <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000b76:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000b7a:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000b7c:	37fd                	addiw	a5,a5,-1
    80000b7e:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000b82:	60a6                	ld	ra,72(sp)
    80000b84:	6406                	ld	s0,64(sp)
    80000b86:	74e2                	ld	s1,56(sp)
    80000b88:	7942                	ld	s2,48(sp)
    80000b8a:	79a2                	ld	s3,40(sp)
    80000b8c:	7a02                	ld	s4,32(sp)
    80000b8e:	6ae2                	ld	s5,24(sp)
    80000b90:	6b42                	ld	s6,16(sp)
    80000b92:	6ba2                	ld	s7,8(sp)
    80000b94:	6161                	addi	sp,sp,80
    80000b96:	8082                	ret
    80000b98:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000b9c:	9742                	add	a4,a4,a6
      --max;
    80000b9e:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000ba2:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000ba6:	04e58463          	beq	a1,a4,80000bee <copyinstr+0x9e>
{
    80000baa:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000bac:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000bb0:	85a6                	mv	a1,s1
    80000bb2:	8552                	mv	a0,s4
    80000bb4:	8b3ff0ef          	jal	80000466 <walkaddr>
    if(pa0 == 0)
    80000bb8:	cd0d                	beqz	a0,80000bf2 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000bba:	417486b3          	sub	a3,s1,s7
    80000bbe:	96ce                	add	a3,a3,s3
    if(n > max)
    80000bc0:	00d97363          	bgeu	s2,a3,80000bc6 <copyinstr+0x76>
    80000bc4:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000bc6:	955e                	add	a0,a0,s7
    80000bc8:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000bca:	c695                	beqz	a3,80000bf6 <copyinstr+0xa6>
    80000bcc:	87da                	mv	a5,s6
    80000bce:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000bd0:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000bd4:	96da                	add	a3,a3,s6
    80000bd6:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000bd8:	00f60733          	add	a4,a2,a5
    80000bdc:	00074703          	lbu	a4,0(a4)
    80000be0:	db59                	beqz	a4,80000b76 <copyinstr+0x26>
        *dst = *p;
    80000be2:	00e78023          	sb	a4,0(a5)
      dst++;
    80000be6:	0785                	addi	a5,a5,1
    while(n > 0){
    80000be8:	fed797e3          	bne	a5,a3,80000bd6 <copyinstr+0x86>
    80000bec:	b775                	j	80000b98 <copyinstr+0x48>
    80000bee:	4781                	li	a5,0
    80000bf0:	b771                	j	80000b7c <copyinstr+0x2c>
      return -1;
    80000bf2:	557d                	li	a0,-1
    80000bf4:	b779                	j	80000b82 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000bf6:	6b85                	lui	s7,0x1
    80000bf8:	9ba6                	add	s7,s7,s1
    80000bfa:	87da                	mv	a5,s6
    80000bfc:	b77d                	j	80000baa <copyinstr+0x5a>
  int got_null = 0;
    80000bfe:	4781                	li	a5,0
  if(got_null){
    80000c00:	37fd                	addiw	a5,a5,-1
    80000c02:	0007851b          	sext.w	a0,a5
}
    80000c06:	8082                	ret

0000000080000c08 <vmprint>:


#ifdef LAB_PGTBL
void
vmprint(pagetable_t pagetable) {
    80000c08:	1141                	addi	sp,sp,-16
    80000c0a:	e422                	sd	s0,8(sp)
    80000c0c:	0800                	addi	s0,sp,16
  // your code here
}
    80000c0e:	6422                	ld	s0,8(sp)
    80000c10:	0141                	addi	sp,sp,16
    80000c12:	8082                	ret

0000000080000c14 <pgpte>:



#ifdef LAB_PGTBL
pte_t*
pgpte(pagetable_t pagetable, uint64 va) {
    80000c14:	1141                	addi	sp,sp,-16
    80000c16:	e406                	sd	ra,8(sp)
    80000c18:	e022                	sd	s0,0(sp)
    80000c1a:	0800                	addi	s0,sp,16
  return walk(pagetable, va, 0);
    80000c1c:	4601                	li	a2,0
    80000c1e:	fa4ff0ef          	jal	800003c2 <walk>
}
    80000c22:	60a2                	ld	ra,8(sp)
    80000c24:	6402                	ld	s0,0(sp)
    80000c26:	0141                	addi	sp,sp,16
    80000c28:	8082                	ret

0000000080000c2a <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000c2a:	7139                	addi	sp,sp,-64
    80000c2c:	fc06                	sd	ra,56(sp)
    80000c2e:	f822                	sd	s0,48(sp)
    80000c30:	f426                	sd	s1,40(sp)
    80000c32:	f04a                	sd	s2,32(sp)
    80000c34:	ec4e                	sd	s3,24(sp)
    80000c36:	e852                	sd	s4,16(sp)
    80000c38:	e456                	sd	s5,8(sp)
    80000c3a:	e05a                	sd	s6,0(sp)
    80000c3c:	0080                	addi	s0,sp,64
    80000c3e:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c40:	0000a497          	auipc	s1,0xa
    80000c44:	b3048493          	addi	s1,s1,-1232 # 8000a770 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000c48:	8b26                	mv	s6,s1
    80000c4a:	ff4df937          	lui	s2,0xff4df
    80000c4e:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bb16d>
    80000c52:	0936                	slli	s2,s2,0xd
    80000c54:	6f590913          	addi	s2,s2,1781
    80000c58:	0936                	slli	s2,s2,0xd
    80000c5a:	bd390913          	addi	s2,s2,-1069
    80000c5e:	0932                	slli	s2,s2,0xc
    80000c60:	7a790913          	addi	s2,s2,1959
    80000c64:	010009b7          	lui	s3,0x1000
    80000c68:	19fd                	addi	s3,s3,-1 # ffffff <_entry-0x7f000001>
    80000c6a:	09ba                	slli	s3,s3,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c6c:	0000fa97          	auipc	s5,0xf
    80000c70:	704a8a93          	addi	s5,s5,1796 # 80010370 <tickslock>
    char *pa = kalloc();
    80000c74:	c8aff0ef          	jal	800000fe <kalloc>
    80000c78:	862a                	mv	a2,a0
    if(pa == 0)
    80000c7a:	cd0d                	beqz	a0,80000cb4 <proc_mapstacks+0x8a>
    uint64 va = KSTACK((int) (p - proc));
    80000c7c:	416485b3          	sub	a1,s1,s6
    80000c80:	8591                	srai	a1,a1,0x4
    80000c82:	032585b3          	mul	a1,a1,s2
    80000c86:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c8a:	4719                	li	a4,6
    80000c8c:	6685                	lui	a3,0x1
    80000c8e:	40b985b3          	sub	a1,s3,a1
    80000c92:	8552                	mv	a0,s4
    80000c94:	8c1ff0ef          	jal	80000554 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c98:	17048493          	addi	s1,s1,368
    80000c9c:	fd549ce3          	bne	s1,s5,80000c74 <proc_mapstacks+0x4a>
  }
}
    80000ca0:	70e2                	ld	ra,56(sp)
    80000ca2:	7442                	ld	s0,48(sp)
    80000ca4:	74a2                	ld	s1,40(sp)
    80000ca6:	7902                	ld	s2,32(sp)
    80000ca8:	69e2                	ld	s3,24(sp)
    80000caa:	6a42                	ld	s4,16(sp)
    80000cac:	6aa2                	ld	s5,8(sp)
    80000cae:	6b02                	ld	s6,0(sp)
    80000cb0:	6121                	addi	sp,sp,64
    80000cb2:	8082                	ret
      panic("kalloc");
    80000cb4:	00006517          	auipc	a0,0x6
    80000cb8:	4f450513          	addi	a0,a0,1268 # 800071a8 <etext+0x1a8>
    80000cbc:	057040ef          	jal	80005512 <panic>

0000000080000cc0 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000cc0:	7139                	addi	sp,sp,-64
    80000cc2:	fc06                	sd	ra,56(sp)
    80000cc4:	f822                	sd	s0,48(sp)
    80000cc6:	f426                	sd	s1,40(sp)
    80000cc8:	f04a                	sd	s2,32(sp)
    80000cca:	ec4e                	sd	s3,24(sp)
    80000ccc:	e852                	sd	s4,16(sp)
    80000cce:	e456                	sd	s5,8(sp)
    80000cd0:	e05a                	sd	s6,0(sp)
    80000cd2:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000cd4:	00006597          	auipc	a1,0x6
    80000cd8:	4dc58593          	addi	a1,a1,1244 # 800071b0 <etext+0x1b0>
    80000cdc:	00009517          	auipc	a0,0x9
    80000ce0:	66450513          	addi	a0,a0,1636 # 8000a340 <pid_lock>
    80000ce4:	2dd040ef          	jal	800057c0 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000ce8:	00006597          	auipc	a1,0x6
    80000cec:	4d058593          	addi	a1,a1,1232 # 800071b8 <etext+0x1b8>
    80000cf0:	00009517          	auipc	a0,0x9
    80000cf4:	66850513          	addi	a0,a0,1640 # 8000a358 <wait_lock>
    80000cf8:	2c9040ef          	jal	800057c0 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cfc:	0000a497          	auipc	s1,0xa
    80000d00:	a7448493          	addi	s1,s1,-1420 # 8000a770 <proc>
      initlock(&p->lock, "proc");
    80000d04:	00006b17          	auipc	s6,0x6
    80000d08:	4c4b0b13          	addi	s6,s6,1220 # 800071c8 <etext+0x1c8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000d0c:	8aa6                	mv	s5,s1
    80000d0e:	ff4df937          	lui	s2,0xff4df
    80000d12:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bb16d>
    80000d16:	0936                	slli	s2,s2,0xd
    80000d18:	6f590913          	addi	s2,s2,1781
    80000d1c:	0936                	slli	s2,s2,0xd
    80000d1e:	bd390913          	addi	s2,s2,-1069
    80000d22:	0932                	slli	s2,s2,0xc
    80000d24:	7a790913          	addi	s2,s2,1959
    80000d28:	010009b7          	lui	s3,0x1000
    80000d2c:	19fd                	addi	s3,s3,-1 # ffffff <_entry-0x7f000001>
    80000d2e:	09ba                	slli	s3,s3,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d30:	0000fa17          	auipc	s4,0xf
    80000d34:	640a0a13          	addi	s4,s4,1600 # 80010370 <tickslock>
      initlock(&p->lock, "proc");
    80000d38:	85da                	mv	a1,s6
    80000d3a:	8526                	mv	a0,s1
    80000d3c:	285040ef          	jal	800057c0 <initlock>
      p->state = UNUSED;
    80000d40:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000d44:	415487b3          	sub	a5,s1,s5
    80000d48:	8791                	srai	a5,a5,0x4
    80000d4a:	032787b3          	mul	a5,a5,s2
    80000d4e:	00d7979b          	slliw	a5,a5,0xd
    80000d52:	40f987b3          	sub	a5,s3,a5
    80000d56:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d58:	17048493          	addi	s1,s1,368
    80000d5c:	fd449ee3          	bne	s1,s4,80000d38 <procinit+0x78>
  }
}
    80000d60:	70e2                	ld	ra,56(sp)
    80000d62:	7442                	ld	s0,48(sp)
    80000d64:	74a2                	ld	s1,40(sp)
    80000d66:	7902                	ld	s2,32(sp)
    80000d68:	69e2                	ld	s3,24(sp)
    80000d6a:	6a42                	ld	s4,16(sp)
    80000d6c:	6aa2                	ld	s5,8(sp)
    80000d6e:	6b02                	ld	s6,0(sp)
    80000d70:	6121                	addi	sp,sp,64
    80000d72:	8082                	ret

0000000080000d74 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000d74:	1141                	addi	sp,sp,-16
    80000d76:	e422                	sd	s0,8(sp)
    80000d78:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000d7a:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000d7c:	2501                	sext.w	a0,a0
    80000d7e:	6422                	ld	s0,8(sp)
    80000d80:	0141                	addi	sp,sp,16
    80000d82:	8082                	ret

0000000080000d84 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000d84:	1141                	addi	sp,sp,-16
    80000d86:	e422                	sd	s0,8(sp)
    80000d88:	0800                	addi	s0,sp,16
    80000d8a:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000d8c:	2781                	sext.w	a5,a5
    80000d8e:	079e                	slli	a5,a5,0x7
  return c;
}
    80000d90:	00009517          	auipc	a0,0x9
    80000d94:	5e050513          	addi	a0,a0,1504 # 8000a370 <cpus>
    80000d98:	953e                	add	a0,a0,a5
    80000d9a:	6422                	ld	s0,8(sp)
    80000d9c:	0141                	addi	sp,sp,16
    80000d9e:	8082                	ret

0000000080000da0 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000da0:	1101                	addi	sp,sp,-32
    80000da2:	ec06                	sd	ra,24(sp)
    80000da4:	e822                	sd	s0,16(sp)
    80000da6:	e426                	sd	s1,8(sp)
    80000da8:	1000                	addi	s0,sp,32
  push_off();
    80000daa:	257040ef          	jal	80005800 <push_off>
    80000dae:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000db0:	2781                	sext.w	a5,a5
    80000db2:	079e                	slli	a5,a5,0x7
    80000db4:	00009717          	auipc	a4,0x9
    80000db8:	58c70713          	addi	a4,a4,1420 # 8000a340 <pid_lock>
    80000dbc:	97ba                	add	a5,a5,a4
    80000dbe:	7b84                	ld	s1,48(a5)
  pop_off();
    80000dc0:	2c5040ef          	jal	80005884 <pop_off>
  return p;
}
    80000dc4:	8526                	mv	a0,s1
    80000dc6:	60e2                	ld	ra,24(sp)
    80000dc8:	6442                	ld	s0,16(sp)
    80000dca:	64a2                	ld	s1,8(sp)
    80000dcc:	6105                	addi	sp,sp,32
    80000dce:	8082                	ret

0000000080000dd0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000dd0:	1141                	addi	sp,sp,-16
    80000dd2:	e406                	sd	ra,8(sp)
    80000dd4:	e022                	sd	s0,0(sp)
    80000dd6:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000dd8:	fc9ff0ef          	jal	80000da0 <myproc>
    80000ddc:	2fd040ef          	jal	800058d8 <release>

  if (first) {
    80000de0:	00009797          	auipc	a5,0x9
    80000de4:	4a07a783          	lw	a5,1184(a5) # 8000a280 <first.1>
    80000de8:	e799                	bnez	a5,80000df6 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000dea:	347000ef          	jal	80001930 <usertrapret>
}
    80000dee:	60a2                	ld	ra,8(sp)
    80000df0:	6402                	ld	s0,0(sp)
    80000df2:	0141                	addi	sp,sp,16
    80000df4:	8082                	ret
    fsinit(ROOTDEV);
    80000df6:	4505                	li	a0,1
    80000df8:	730010ef          	jal	80002528 <fsinit>
    first = 0;
    80000dfc:	00009797          	auipc	a5,0x9
    80000e00:	4807a223          	sw	zero,1156(a5) # 8000a280 <first.1>
    __sync_synchronize();
    80000e04:	0330000f          	fence	rw,rw
    80000e08:	b7cd                	j	80000dea <forkret+0x1a>

0000000080000e0a <allocpid>:
{
    80000e0a:	1101                	addi	sp,sp,-32
    80000e0c:	ec06                	sd	ra,24(sp)
    80000e0e:	e822                	sd	s0,16(sp)
    80000e10:	e426                	sd	s1,8(sp)
    80000e12:	e04a                	sd	s2,0(sp)
    80000e14:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000e16:	00009917          	auipc	s2,0x9
    80000e1a:	52a90913          	addi	s2,s2,1322 # 8000a340 <pid_lock>
    80000e1e:	854a                	mv	a0,s2
    80000e20:	221040ef          	jal	80005840 <acquire>
  pid = nextpid;
    80000e24:	00009797          	auipc	a5,0x9
    80000e28:	46078793          	addi	a5,a5,1120 # 8000a284 <nextpid>
    80000e2c:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000e2e:	0014871b          	addiw	a4,s1,1
    80000e32:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000e34:	854a                	mv	a0,s2
    80000e36:	2a3040ef          	jal	800058d8 <release>
}
    80000e3a:	8526                	mv	a0,s1
    80000e3c:	60e2                	ld	ra,24(sp)
    80000e3e:	6442                	ld	s0,16(sp)
    80000e40:	64a2                	ld	s1,8(sp)
    80000e42:	6902                	ld	s2,0(sp)
    80000e44:	6105                	addi	sp,sp,32
    80000e46:	8082                	ret

0000000080000e48 <proc_pagetable>:
{
    80000e48:	1101                	addi	sp,sp,-32
    80000e4a:	ec06                	sd	ra,24(sp)
    80000e4c:	e822                	sd	s0,16(sp)
    80000e4e:	e426                	sd	s1,8(sp)
    80000e50:	e04a                	sd	s2,0(sp)
    80000e52:	1000                	addi	s0,sp,32
    80000e54:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000e56:	8c1ff0ef          	jal	80000716 <uvmcreate>
    80000e5a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000e5c:	c929                	beqz	a0,80000eae <proc_pagetable+0x66>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000e5e:	4729                	li	a4,10
    80000e60:	00005697          	auipc	a3,0x5
    80000e64:	1a068693          	addi	a3,a3,416 # 80006000 <_trampoline>
    80000e68:	6605                	lui	a2,0x1
    80000e6a:	040005b7          	lui	a1,0x4000
    80000e6e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000e70:	05b2                	slli	a1,a1,0xc
    80000e72:	e32ff0ef          	jal	800004a4 <mappages>
    80000e76:	04054363          	bltz	a0,80000ebc <proc_pagetable+0x74>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000e7a:	4719                	li	a4,6
    80000e7c:	05893683          	ld	a3,88(s2)
    80000e80:	6605                	lui	a2,0x1
    80000e82:	020005b7          	lui	a1,0x2000
    80000e86:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000e88:	05b6                	slli	a1,a1,0xd
    80000e8a:	8526                	mv	a0,s1
    80000e8c:	e18ff0ef          	jal	800004a4 <mappages>
    80000e90:	02054c63          	bltz	a0,80000ec8 <proc_pagetable+0x80>
  if (mappages(pagetable, USYSCALL, PGSIZE,
    80000e94:	4749                	li	a4,18
    80000e96:	06093683          	ld	a3,96(s2)
    80000e9a:	6605                	lui	a2,0x1
    80000e9c:	040005b7          	lui	a1,0x4000
    80000ea0:	15f5                	addi	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    80000ea2:	05b2                	slli	a1,a1,0xc
    80000ea4:	8526                	mv	a0,s1
    80000ea6:	dfeff0ef          	jal	800004a4 <mappages>
    80000eaa:	02054e63          	bltz	a0,80000ee6 <proc_pagetable+0x9e>
}
    80000eae:	8526                	mv	a0,s1
    80000eb0:	60e2                	ld	ra,24(sp)
    80000eb2:	6442                	ld	s0,16(sp)
    80000eb4:	64a2                	ld	s1,8(sp)
    80000eb6:	6902                	ld	s2,0(sp)
    80000eb8:	6105                	addi	sp,sp,32
    80000eba:	8082                	ret
    uvmfree(pagetable, 0);
    80000ebc:	4581                	li	a1,0
    80000ebe:	8526                	mv	a0,s1
    80000ec0:	a25ff0ef          	jal	800008e4 <uvmfree>
    return 0;
    80000ec4:	4481                	li	s1,0
    80000ec6:	b7e5                	j	80000eae <proc_pagetable+0x66>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000ec8:	4681                	li	a3,0
    80000eca:	4605                	li	a2,1
    80000ecc:	040005b7          	lui	a1,0x4000
    80000ed0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ed2:	05b2                	slli	a1,a1,0xc
    80000ed4:	8526                	mv	a0,s1
    80000ed6:	f74ff0ef          	jal	8000064a <uvmunmap>
    uvmfree(pagetable, 0);
    80000eda:	4581                	li	a1,0
    80000edc:	8526                	mv	a0,s1
    80000ede:	a07ff0ef          	jal	800008e4 <uvmfree>
    return 0;
    80000ee2:	4481                	li	s1,0
    80000ee4:	b7e9                	j	80000eae <proc_pagetable+0x66>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000ee6:	4681                	li	a3,0
    80000ee8:	4605                	li	a2,1
    80000eea:	020005b7          	lui	a1,0x2000
    80000eee:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000ef0:	05b6                	slli	a1,a1,0xd
    80000ef2:	8526                	mv	a0,s1
    80000ef4:	f56ff0ef          	jal	8000064a <uvmunmap>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000ef8:	4681                	li	a3,0
    80000efa:	4605                	li	a2,1
    80000efc:	040005b7          	lui	a1,0x4000
    80000f00:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f02:	05b2                	slli	a1,a1,0xc
    80000f04:	8526                	mv	a0,s1
    80000f06:	f44ff0ef          	jal	8000064a <uvmunmap>
    uvmfree(pagetable, 0);
    80000f0a:	4581                	li	a1,0
    80000f0c:	8526                	mv	a0,s1
    80000f0e:	9d7ff0ef          	jal	800008e4 <uvmfree>
    return 0;
    80000f12:	4481                	li	s1,0
    80000f14:	bf69                	j	80000eae <proc_pagetable+0x66>

0000000080000f16 <proc_freepagetable>:
{
    80000f16:	1101                	addi	sp,sp,-32
    80000f18:	ec06                	sd	ra,24(sp)
    80000f1a:	e822                	sd	s0,16(sp)
    80000f1c:	e426                	sd	s1,8(sp)
    80000f1e:	e04a                	sd	s2,0(sp)
    80000f20:	1000                	addi	s0,sp,32
    80000f22:	84aa                	mv	s1,a0
    80000f24:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f26:	4681                	li	a3,0
    80000f28:	4605                	li	a2,1
    80000f2a:	040005b7          	lui	a1,0x4000
    80000f2e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f30:	05b2                	slli	a1,a1,0xc
    80000f32:	f18ff0ef          	jal	8000064a <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000f36:	4681                	li	a3,0
    80000f38:	4605                	li	a2,1
    80000f3a:	020005b7          	lui	a1,0x2000
    80000f3e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f40:	05b6                	slli	a1,a1,0xd
    80000f42:	8526                	mv	a0,s1
    80000f44:	f06ff0ef          	jal	8000064a <uvmunmap>
  uvmunmap(pagetable, USYSCALL, 1, 0);
    80000f48:	4681                	li	a3,0
    80000f4a:	4605                	li	a2,1
    80000f4c:	040005b7          	lui	a1,0x4000
    80000f50:	15f5                	addi	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    80000f52:	05b2                	slli	a1,a1,0xc
    80000f54:	8526                	mv	a0,s1
    80000f56:	ef4ff0ef          	jal	8000064a <uvmunmap>
  uvmfree(pagetable, sz);
    80000f5a:	85ca                	mv	a1,s2
    80000f5c:	8526                	mv	a0,s1
    80000f5e:	987ff0ef          	jal	800008e4 <uvmfree>
}
    80000f62:	60e2                	ld	ra,24(sp)
    80000f64:	6442                	ld	s0,16(sp)
    80000f66:	64a2                	ld	s1,8(sp)
    80000f68:	6902                	ld	s2,0(sp)
    80000f6a:	6105                	addi	sp,sp,32
    80000f6c:	8082                	ret

0000000080000f6e <freeproc>:
{
    80000f6e:	1101                	addi	sp,sp,-32
    80000f70:	ec06                	sd	ra,24(sp)
    80000f72:	e822                	sd	s0,16(sp)
    80000f74:	e426                	sd	s1,8(sp)
    80000f76:	1000                	addi	s0,sp,32
    80000f78:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000f7a:	6d28                	ld	a0,88(a0)
    80000f7c:	c119                	beqz	a0,80000f82 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000f7e:	89eff0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80000f82:	0404bc23          	sd	zero,88(s1)
  if (p->usyscall) {
    80000f86:	70a8                	ld	a0,96(s1)
    80000f88:	c119                	beqz	a0,80000f8e <freeproc+0x20>
        kfree((void *) p->usyscall);
    80000f8a:	892ff0ef          	jal	8000001c <kfree>
  p->usyscall = 0;
    80000f8e:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    80000f92:	68a8                	ld	a0,80(s1)
    80000f94:	c501                	beqz	a0,80000f9c <freeproc+0x2e>
    proc_freepagetable(p->pagetable, p->sz);
    80000f96:	64ac                	ld	a1,72(s1)
    80000f98:	f7fff0ef          	jal	80000f16 <proc_freepagetable>
  p->pagetable = 0;
    80000f9c:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80000fa0:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80000fa4:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80000fa8:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80000fac:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80000fb0:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80000fb4:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80000fb8:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80000fbc:	0004ac23          	sw	zero,24(s1)
}
    80000fc0:	60e2                	ld	ra,24(sp)
    80000fc2:	6442                	ld	s0,16(sp)
    80000fc4:	64a2                	ld	s1,8(sp)
    80000fc6:	6105                	addi	sp,sp,32
    80000fc8:	8082                	ret

0000000080000fca <allocproc>:
{
    80000fca:	1101                	addi	sp,sp,-32
    80000fcc:	ec06                	sd	ra,24(sp)
    80000fce:	e822                	sd	s0,16(sp)
    80000fd0:	e426                	sd	s1,8(sp)
    80000fd2:	e04a                	sd	s2,0(sp)
    80000fd4:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fd6:	00009497          	auipc	s1,0x9
    80000fda:	79a48493          	addi	s1,s1,1946 # 8000a770 <proc>
    80000fde:	0000f917          	auipc	s2,0xf
    80000fe2:	39290913          	addi	s2,s2,914 # 80010370 <tickslock>
    acquire(&p->lock);
    80000fe6:	8526                	mv	a0,s1
    80000fe8:	059040ef          	jal	80005840 <acquire>
    if(p->state == UNUSED) {
    80000fec:	4c9c                	lw	a5,24(s1)
    80000fee:	cb91                	beqz	a5,80001002 <allocproc+0x38>
      release(&p->lock);
    80000ff0:	8526                	mv	a0,s1
    80000ff2:	0e7040ef          	jal	800058d8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ff6:	17048493          	addi	s1,s1,368
    80000ffa:	ff2496e3          	bne	s1,s2,80000fe6 <allocproc+0x1c>
  return 0;
    80000ffe:	4481                	li	s1,0
    80001000:	a889                	j	80001052 <allocproc+0x88>
  p->pid = allocpid();
    80001002:	e09ff0ef          	jal	80000e0a <allocpid>
    80001006:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001008:	4785                	li	a5,1
    8000100a:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000100c:	8f2ff0ef          	jal	800000fe <kalloc>
    80001010:	892a                	mv	s2,a0
    80001012:	eca8                	sd	a0,88(s1)
    80001014:	c531                	beqz	a0,80001060 <allocproc+0x96>
  if ((p->usyscall = (struct usyscall *) kalloc()) == 0) {
    80001016:	8e8ff0ef          	jal	800000fe <kalloc>
    8000101a:	892a                	mv	s2,a0
    8000101c:	f0a8                	sd	a0,96(s1)
    8000101e:	c929                	beqz	a0,80001070 <allocproc+0xa6>
  p->pagetable = proc_pagetable(p);
    80001020:	8526                	mv	a0,s1
    80001022:	e27ff0ef          	jal	80000e48 <proc_pagetable>
    80001026:	892a                	mv	s2,a0
    80001028:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000102a:	c939                	beqz	a0,80001080 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    8000102c:	07000613          	li	a2,112
    80001030:	4581                	li	a1,0
    80001032:	06848513          	addi	a0,s1,104
    80001036:	918ff0ef          	jal	8000014e <memset>
  p->context.ra = (uint64)forkret;
    8000103a:	00000797          	auipc	a5,0x0
    8000103e:	d9678793          	addi	a5,a5,-618 # 80000dd0 <forkret>
    80001042:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001044:	60bc                	ld	a5,64(s1)
    80001046:	6705                	lui	a4,0x1
    80001048:	97ba                	add	a5,a5,a4
    8000104a:	f8bc                	sd	a5,112(s1)
  p->usyscall->pid = p->pid;
    8000104c:	70bc                	ld	a5,96(s1)
    8000104e:	5898                	lw	a4,48(s1)
    80001050:	c398                	sw	a4,0(a5)
}
    80001052:	8526                	mv	a0,s1
    80001054:	60e2                	ld	ra,24(sp)
    80001056:	6442                	ld	s0,16(sp)
    80001058:	64a2                	ld	s1,8(sp)
    8000105a:	6902                	ld	s2,0(sp)
    8000105c:	6105                	addi	sp,sp,32
    8000105e:	8082                	ret
    freeproc(p);
    80001060:	8526                	mv	a0,s1
    80001062:	f0dff0ef          	jal	80000f6e <freeproc>
    release(&p->lock);
    80001066:	8526                	mv	a0,s1
    80001068:	071040ef          	jal	800058d8 <release>
    return 0;
    8000106c:	84ca                	mv	s1,s2
    8000106e:	b7d5                	j	80001052 <allocproc+0x88>
    freeproc(p);
    80001070:	8526                	mv	a0,s1
    80001072:	efdff0ef          	jal	80000f6e <freeproc>
    release(&p->lock);
    80001076:	8526                	mv	a0,s1
    80001078:	061040ef          	jal	800058d8 <release>
    return 0;
    8000107c:	84ca                	mv	s1,s2
    8000107e:	bfd1                	j	80001052 <allocproc+0x88>
    freeproc(p);
    80001080:	8526                	mv	a0,s1
    80001082:	eedff0ef          	jal	80000f6e <freeproc>
    release(&p->lock);
    80001086:	8526                	mv	a0,s1
    80001088:	051040ef          	jal	800058d8 <release>
    return 0;
    8000108c:	84ca                	mv	s1,s2
    8000108e:	b7d1                	j	80001052 <allocproc+0x88>

0000000080001090 <userinit>:
{
    80001090:	1101                	addi	sp,sp,-32
    80001092:	ec06                	sd	ra,24(sp)
    80001094:	e822                	sd	s0,16(sp)
    80001096:	e426                	sd	s1,8(sp)
    80001098:	1000                	addi	s0,sp,32
  p = allocproc();
    8000109a:	f31ff0ef          	jal	80000fca <allocproc>
    8000109e:	84aa                	mv	s1,a0
  initproc = p;
    800010a0:	00009797          	auipc	a5,0x9
    800010a4:	26a7b023          	sd	a0,608(a5) # 8000a300 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800010a8:	03400613          	li	a2,52
    800010ac:	00009597          	auipc	a1,0x9
    800010b0:	1e458593          	addi	a1,a1,484 # 8000a290 <initcode>
    800010b4:	6928                	ld	a0,80(a0)
    800010b6:	e86ff0ef          	jal	8000073c <uvmfirst>
  p->sz = PGSIZE;
    800010ba:	6785                	lui	a5,0x1
    800010bc:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800010be:	6cb8                	ld	a4,88(s1)
    800010c0:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800010c4:	6cb8                	ld	a4,88(s1)
    800010c6:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800010c8:	4641                	li	a2,16
    800010ca:	00006597          	auipc	a1,0x6
    800010ce:	10658593          	addi	a1,a1,262 # 800071d0 <etext+0x1d0>
    800010d2:	16048513          	addi	a0,s1,352
    800010d6:	9b6ff0ef          	jal	8000028c <safestrcpy>
  p->cwd = namei("/");
    800010da:	00006517          	auipc	a0,0x6
    800010de:	10650513          	addi	a0,a0,262 # 800071e0 <etext+0x1e0>
    800010e2:	555010ef          	jal	80002e36 <namei>
    800010e6:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    800010ea:	478d                	li	a5,3
    800010ec:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800010ee:	8526                	mv	a0,s1
    800010f0:	7e8040ef          	jal	800058d8 <release>
}
    800010f4:	60e2                	ld	ra,24(sp)
    800010f6:	6442                	ld	s0,16(sp)
    800010f8:	64a2                	ld	s1,8(sp)
    800010fa:	6105                	addi	sp,sp,32
    800010fc:	8082                	ret

00000000800010fe <growproc>:
{
    800010fe:	1101                	addi	sp,sp,-32
    80001100:	ec06                	sd	ra,24(sp)
    80001102:	e822                	sd	s0,16(sp)
    80001104:	e426                	sd	s1,8(sp)
    80001106:	e04a                	sd	s2,0(sp)
    80001108:	1000                	addi	s0,sp,32
    8000110a:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000110c:	c95ff0ef          	jal	80000da0 <myproc>
    80001110:	84aa                	mv	s1,a0
  sz = p->sz;
    80001112:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001114:	01204c63          	bgtz	s2,8000112c <growproc+0x2e>
  } else if(n < 0){
    80001118:	02094463          	bltz	s2,80001140 <growproc+0x42>
  p->sz = sz;
    8000111c:	e4ac                	sd	a1,72(s1)
  return 0;
    8000111e:	4501                	li	a0,0
}
    80001120:	60e2                	ld	ra,24(sp)
    80001122:	6442                	ld	s0,16(sp)
    80001124:	64a2                	ld	s1,8(sp)
    80001126:	6902                	ld	s2,0(sp)
    80001128:	6105                	addi	sp,sp,32
    8000112a:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    8000112c:	4691                	li	a3,4
    8000112e:	00b90633          	add	a2,s2,a1
    80001132:	6928                	ld	a0,80(a0)
    80001134:	eaaff0ef          	jal	800007de <uvmalloc>
    80001138:	85aa                	mv	a1,a0
    8000113a:	f16d                	bnez	a0,8000111c <growproc+0x1e>
      return -1;
    8000113c:	557d                	li	a0,-1
    8000113e:	b7cd                	j	80001120 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001140:	00b90633          	add	a2,s2,a1
    80001144:	6928                	ld	a0,80(a0)
    80001146:	e54ff0ef          	jal	8000079a <uvmdealloc>
    8000114a:	85aa                	mv	a1,a0
    8000114c:	bfc1                	j	8000111c <growproc+0x1e>

000000008000114e <fork>:
{
    8000114e:	7139                	addi	sp,sp,-64
    80001150:	fc06                	sd	ra,56(sp)
    80001152:	f822                	sd	s0,48(sp)
    80001154:	f04a                	sd	s2,32(sp)
    80001156:	e456                	sd	s5,8(sp)
    80001158:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000115a:	c47ff0ef          	jal	80000da0 <myproc>
    8000115e:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001160:	e6bff0ef          	jal	80000fca <allocproc>
    80001164:	0e050a63          	beqz	a0,80001258 <fork+0x10a>
    80001168:	e852                	sd	s4,16(sp)
    8000116a:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000116c:	048ab603          	ld	a2,72(s5)
    80001170:	692c                	ld	a1,80(a0)
    80001172:	050ab503          	ld	a0,80(s5)
    80001176:	fa0ff0ef          	jal	80000916 <uvmcopy>
    8000117a:	04054a63          	bltz	a0,800011ce <fork+0x80>
    8000117e:	f426                	sd	s1,40(sp)
    80001180:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001182:	048ab783          	ld	a5,72(s5)
    80001186:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    8000118a:	058ab683          	ld	a3,88(s5)
    8000118e:	87b6                	mv	a5,a3
    80001190:	058a3703          	ld	a4,88(s4)
    80001194:	12068693          	addi	a3,a3,288
    80001198:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000119c:	6788                	ld	a0,8(a5)
    8000119e:	6b8c                	ld	a1,16(a5)
    800011a0:	6f90                	ld	a2,24(a5)
    800011a2:	01073023          	sd	a6,0(a4)
    800011a6:	e708                	sd	a0,8(a4)
    800011a8:	eb0c                	sd	a1,16(a4)
    800011aa:	ef10                	sd	a2,24(a4)
    800011ac:	02078793          	addi	a5,a5,32
    800011b0:	02070713          	addi	a4,a4,32
    800011b4:	fed792e3          	bne	a5,a3,80001198 <fork+0x4a>
  np->trapframe->a0 = 0;
    800011b8:	058a3783          	ld	a5,88(s4)
    800011bc:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800011c0:	0d8a8493          	addi	s1,s5,216
    800011c4:	0d8a0913          	addi	s2,s4,216
    800011c8:	158a8993          	addi	s3,s5,344
    800011cc:	a831                	j	800011e8 <fork+0x9a>
    freeproc(np);
    800011ce:	8552                	mv	a0,s4
    800011d0:	d9fff0ef          	jal	80000f6e <freeproc>
    release(&np->lock);
    800011d4:	8552                	mv	a0,s4
    800011d6:	702040ef          	jal	800058d8 <release>
    return -1;
    800011da:	597d                	li	s2,-1
    800011dc:	6a42                	ld	s4,16(sp)
    800011de:	a0b5                	j	8000124a <fork+0xfc>
  for(i = 0; i < NOFILE; i++)
    800011e0:	04a1                	addi	s1,s1,8
    800011e2:	0921                	addi	s2,s2,8
    800011e4:	01348963          	beq	s1,s3,800011f6 <fork+0xa8>
    if(p->ofile[i])
    800011e8:	6088                	ld	a0,0(s1)
    800011ea:	d97d                	beqz	a0,800011e0 <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    800011ec:	1da020ef          	jal	800033c6 <filedup>
    800011f0:	00a93023          	sd	a0,0(s2)
    800011f4:	b7f5                	j	800011e0 <fork+0x92>
  np->cwd = idup(p->cwd);
    800011f6:	158ab503          	ld	a0,344(s5)
    800011fa:	52c010ef          	jal	80002726 <idup>
    800011fe:	14aa3c23          	sd	a0,344(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001202:	4641                	li	a2,16
    80001204:	160a8593          	addi	a1,s5,352
    80001208:	160a0513          	addi	a0,s4,352
    8000120c:	880ff0ef          	jal	8000028c <safestrcpy>
  pid = np->pid;
    80001210:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001214:	8552                	mv	a0,s4
    80001216:	6c2040ef          	jal	800058d8 <release>
  acquire(&wait_lock);
    8000121a:	00009497          	auipc	s1,0x9
    8000121e:	13e48493          	addi	s1,s1,318 # 8000a358 <wait_lock>
    80001222:	8526                	mv	a0,s1
    80001224:	61c040ef          	jal	80005840 <acquire>
  np->parent = p;
    80001228:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000122c:	8526                	mv	a0,s1
    8000122e:	6aa040ef          	jal	800058d8 <release>
  acquire(&np->lock);
    80001232:	8552                	mv	a0,s4
    80001234:	60c040ef          	jal	80005840 <acquire>
  np->state = RUNNABLE;
    80001238:	478d                	li	a5,3
    8000123a:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000123e:	8552                	mv	a0,s4
    80001240:	698040ef          	jal	800058d8 <release>
  return pid;
    80001244:	74a2                	ld	s1,40(sp)
    80001246:	69e2                	ld	s3,24(sp)
    80001248:	6a42                	ld	s4,16(sp)
}
    8000124a:	854a                	mv	a0,s2
    8000124c:	70e2                	ld	ra,56(sp)
    8000124e:	7442                	ld	s0,48(sp)
    80001250:	7902                	ld	s2,32(sp)
    80001252:	6aa2                	ld	s5,8(sp)
    80001254:	6121                	addi	sp,sp,64
    80001256:	8082                	ret
    return -1;
    80001258:	597d                	li	s2,-1
    8000125a:	bfc5                	j	8000124a <fork+0xfc>

000000008000125c <scheduler>:
{
    8000125c:	715d                	addi	sp,sp,-80
    8000125e:	e486                	sd	ra,72(sp)
    80001260:	e0a2                	sd	s0,64(sp)
    80001262:	fc26                	sd	s1,56(sp)
    80001264:	f84a                	sd	s2,48(sp)
    80001266:	f44e                	sd	s3,40(sp)
    80001268:	f052                	sd	s4,32(sp)
    8000126a:	ec56                	sd	s5,24(sp)
    8000126c:	e85a                	sd	s6,16(sp)
    8000126e:	e45e                	sd	s7,8(sp)
    80001270:	e062                	sd	s8,0(sp)
    80001272:	0880                	addi	s0,sp,80
    80001274:	8792                	mv	a5,tp
  int id = r_tp();
    80001276:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001278:	00779b13          	slli	s6,a5,0x7
    8000127c:	00009717          	auipc	a4,0x9
    80001280:	0c470713          	addi	a4,a4,196 # 8000a340 <pid_lock>
    80001284:	975a                	add	a4,a4,s6
    80001286:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000128a:	00009717          	auipc	a4,0x9
    8000128e:	0ee70713          	addi	a4,a4,238 # 8000a378 <cpus+0x8>
    80001292:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001294:	4c11                	li	s8,4
        c->proc = p;
    80001296:	079e                	slli	a5,a5,0x7
    80001298:	00009a17          	auipc	s4,0x9
    8000129c:	0a8a0a13          	addi	s4,s4,168 # 8000a340 <pid_lock>
    800012a0:	9a3e                	add	s4,s4,a5
        found = 1;
    800012a2:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    800012a4:	0000f997          	auipc	s3,0xf
    800012a8:	0cc98993          	addi	s3,s3,204 # 80010370 <tickslock>
    800012ac:	a0a9                	j	800012f6 <scheduler+0x9a>
      release(&p->lock);
    800012ae:	8526                	mv	a0,s1
    800012b0:	628040ef          	jal	800058d8 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800012b4:	17048493          	addi	s1,s1,368
    800012b8:	03348563          	beq	s1,s3,800012e2 <scheduler+0x86>
      acquire(&p->lock);
    800012bc:	8526                	mv	a0,s1
    800012be:	582040ef          	jal	80005840 <acquire>
      if(p->state == RUNNABLE) {
    800012c2:	4c9c                	lw	a5,24(s1)
    800012c4:	ff2795e3          	bne	a5,s2,800012ae <scheduler+0x52>
        p->state = RUNNING;
    800012c8:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    800012cc:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800012d0:	06848593          	addi	a1,s1,104
    800012d4:	855a                	mv	a0,s6
    800012d6:	5b4000ef          	jal	8000188a <swtch>
        c->proc = 0;
    800012da:	020a3823          	sd	zero,48(s4)
        found = 1;
    800012de:	8ade                	mv	s5,s7
    800012e0:	b7f9                	j	800012ae <scheduler+0x52>
    if(found == 0) {
    800012e2:	000a9a63          	bnez	s5,800012f6 <scheduler+0x9a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800012e6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800012ea:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800012ee:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    800012f2:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800012f6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800012fa:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800012fe:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001302:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001304:	00009497          	auipc	s1,0x9
    80001308:	46c48493          	addi	s1,s1,1132 # 8000a770 <proc>
      if(p->state == RUNNABLE) {
    8000130c:	490d                	li	s2,3
    8000130e:	b77d                	j	800012bc <scheduler+0x60>

0000000080001310 <sched>:
{
    80001310:	7179                	addi	sp,sp,-48
    80001312:	f406                	sd	ra,40(sp)
    80001314:	f022                	sd	s0,32(sp)
    80001316:	ec26                	sd	s1,24(sp)
    80001318:	e84a                	sd	s2,16(sp)
    8000131a:	e44e                	sd	s3,8(sp)
    8000131c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000131e:	a83ff0ef          	jal	80000da0 <myproc>
    80001322:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001324:	4b2040ef          	jal	800057d6 <holding>
    80001328:	c92d                	beqz	a0,8000139a <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000132a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000132c:	2781                	sext.w	a5,a5
    8000132e:	079e                	slli	a5,a5,0x7
    80001330:	00009717          	auipc	a4,0x9
    80001334:	01070713          	addi	a4,a4,16 # 8000a340 <pid_lock>
    80001338:	97ba                	add	a5,a5,a4
    8000133a:	0a87a703          	lw	a4,168(a5)
    8000133e:	4785                	li	a5,1
    80001340:	06f71363          	bne	a4,a5,800013a6 <sched+0x96>
  if(p->state == RUNNING)
    80001344:	4c98                	lw	a4,24(s1)
    80001346:	4791                	li	a5,4
    80001348:	06f70563          	beq	a4,a5,800013b2 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000134c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001350:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001352:	e7b5                	bnez	a5,800013be <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001354:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001356:	00009917          	auipc	s2,0x9
    8000135a:	fea90913          	addi	s2,s2,-22 # 8000a340 <pid_lock>
    8000135e:	2781                	sext.w	a5,a5
    80001360:	079e                	slli	a5,a5,0x7
    80001362:	97ca                	add	a5,a5,s2
    80001364:	0ac7a983          	lw	s3,172(a5)
    80001368:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000136a:	2781                	sext.w	a5,a5
    8000136c:	079e                	slli	a5,a5,0x7
    8000136e:	00009597          	auipc	a1,0x9
    80001372:	00a58593          	addi	a1,a1,10 # 8000a378 <cpus+0x8>
    80001376:	95be                	add	a1,a1,a5
    80001378:	06848513          	addi	a0,s1,104
    8000137c:	50e000ef          	jal	8000188a <swtch>
    80001380:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001382:	2781                	sext.w	a5,a5
    80001384:	079e                	slli	a5,a5,0x7
    80001386:	993e                	add	s2,s2,a5
    80001388:	0b392623          	sw	s3,172(s2)
}
    8000138c:	70a2                	ld	ra,40(sp)
    8000138e:	7402                	ld	s0,32(sp)
    80001390:	64e2                	ld	s1,24(sp)
    80001392:	6942                	ld	s2,16(sp)
    80001394:	69a2                	ld	s3,8(sp)
    80001396:	6145                	addi	sp,sp,48
    80001398:	8082                	ret
    panic("sched p->lock");
    8000139a:	00006517          	auipc	a0,0x6
    8000139e:	e4e50513          	addi	a0,a0,-434 # 800071e8 <etext+0x1e8>
    800013a2:	170040ef          	jal	80005512 <panic>
    panic("sched locks");
    800013a6:	00006517          	auipc	a0,0x6
    800013aa:	e5250513          	addi	a0,a0,-430 # 800071f8 <etext+0x1f8>
    800013ae:	164040ef          	jal	80005512 <panic>
    panic("sched running");
    800013b2:	00006517          	auipc	a0,0x6
    800013b6:	e5650513          	addi	a0,a0,-426 # 80007208 <etext+0x208>
    800013ba:	158040ef          	jal	80005512 <panic>
    panic("sched interruptible");
    800013be:	00006517          	auipc	a0,0x6
    800013c2:	e5a50513          	addi	a0,a0,-422 # 80007218 <etext+0x218>
    800013c6:	14c040ef          	jal	80005512 <panic>

00000000800013ca <yield>:
{
    800013ca:	1101                	addi	sp,sp,-32
    800013cc:	ec06                	sd	ra,24(sp)
    800013ce:	e822                	sd	s0,16(sp)
    800013d0:	e426                	sd	s1,8(sp)
    800013d2:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800013d4:	9cdff0ef          	jal	80000da0 <myproc>
    800013d8:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800013da:	466040ef          	jal	80005840 <acquire>
  p->state = RUNNABLE;
    800013de:	478d                	li	a5,3
    800013e0:	cc9c                	sw	a5,24(s1)
  sched();
    800013e2:	f2fff0ef          	jal	80001310 <sched>
  release(&p->lock);
    800013e6:	8526                	mv	a0,s1
    800013e8:	4f0040ef          	jal	800058d8 <release>
}
    800013ec:	60e2                	ld	ra,24(sp)
    800013ee:	6442                	ld	s0,16(sp)
    800013f0:	64a2                	ld	s1,8(sp)
    800013f2:	6105                	addi	sp,sp,32
    800013f4:	8082                	ret

00000000800013f6 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800013f6:	7179                	addi	sp,sp,-48
    800013f8:	f406                	sd	ra,40(sp)
    800013fa:	f022                	sd	s0,32(sp)
    800013fc:	ec26                	sd	s1,24(sp)
    800013fe:	e84a                	sd	s2,16(sp)
    80001400:	e44e                	sd	s3,8(sp)
    80001402:	1800                	addi	s0,sp,48
    80001404:	89aa                	mv	s3,a0
    80001406:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001408:	999ff0ef          	jal	80000da0 <myproc>
    8000140c:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000140e:	432040ef          	jal	80005840 <acquire>
  release(lk);
    80001412:	854a                	mv	a0,s2
    80001414:	4c4040ef          	jal	800058d8 <release>

  // Go to sleep.
  p->chan = chan;
    80001418:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000141c:	4789                	li	a5,2
    8000141e:	cc9c                	sw	a5,24(s1)

  sched();
    80001420:	ef1ff0ef          	jal	80001310 <sched>

  // Tidy up.
  p->chan = 0;
    80001424:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001428:	8526                	mv	a0,s1
    8000142a:	4ae040ef          	jal	800058d8 <release>
  acquire(lk);
    8000142e:	854a                	mv	a0,s2
    80001430:	410040ef          	jal	80005840 <acquire>
}
    80001434:	70a2                	ld	ra,40(sp)
    80001436:	7402                	ld	s0,32(sp)
    80001438:	64e2                	ld	s1,24(sp)
    8000143a:	6942                	ld	s2,16(sp)
    8000143c:	69a2                	ld	s3,8(sp)
    8000143e:	6145                	addi	sp,sp,48
    80001440:	8082                	ret

0000000080001442 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001442:	7139                	addi	sp,sp,-64
    80001444:	fc06                	sd	ra,56(sp)
    80001446:	f822                	sd	s0,48(sp)
    80001448:	f426                	sd	s1,40(sp)
    8000144a:	f04a                	sd	s2,32(sp)
    8000144c:	ec4e                	sd	s3,24(sp)
    8000144e:	e852                	sd	s4,16(sp)
    80001450:	e456                	sd	s5,8(sp)
    80001452:	0080                	addi	s0,sp,64
    80001454:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001456:	00009497          	auipc	s1,0x9
    8000145a:	31a48493          	addi	s1,s1,794 # 8000a770 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000145e:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001460:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001462:	0000f917          	auipc	s2,0xf
    80001466:	f0e90913          	addi	s2,s2,-242 # 80010370 <tickslock>
    8000146a:	a801                	j	8000147a <wakeup+0x38>
      }
      release(&p->lock);
    8000146c:	8526                	mv	a0,s1
    8000146e:	46a040ef          	jal	800058d8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001472:	17048493          	addi	s1,s1,368
    80001476:	03248263          	beq	s1,s2,8000149a <wakeup+0x58>
    if(p != myproc()){
    8000147a:	927ff0ef          	jal	80000da0 <myproc>
    8000147e:	fea48ae3          	beq	s1,a0,80001472 <wakeup+0x30>
      acquire(&p->lock);
    80001482:	8526                	mv	a0,s1
    80001484:	3bc040ef          	jal	80005840 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001488:	4c9c                	lw	a5,24(s1)
    8000148a:	ff3791e3          	bne	a5,s3,8000146c <wakeup+0x2a>
    8000148e:	709c                	ld	a5,32(s1)
    80001490:	fd479ee3          	bne	a5,s4,8000146c <wakeup+0x2a>
        p->state = RUNNABLE;
    80001494:	0154ac23          	sw	s5,24(s1)
    80001498:	bfd1                	j	8000146c <wakeup+0x2a>
    }
  }
}
    8000149a:	70e2                	ld	ra,56(sp)
    8000149c:	7442                	ld	s0,48(sp)
    8000149e:	74a2                	ld	s1,40(sp)
    800014a0:	7902                	ld	s2,32(sp)
    800014a2:	69e2                	ld	s3,24(sp)
    800014a4:	6a42                	ld	s4,16(sp)
    800014a6:	6aa2                	ld	s5,8(sp)
    800014a8:	6121                	addi	sp,sp,64
    800014aa:	8082                	ret

00000000800014ac <reparent>:
{
    800014ac:	7179                	addi	sp,sp,-48
    800014ae:	f406                	sd	ra,40(sp)
    800014b0:	f022                	sd	s0,32(sp)
    800014b2:	ec26                	sd	s1,24(sp)
    800014b4:	e84a                	sd	s2,16(sp)
    800014b6:	e44e                	sd	s3,8(sp)
    800014b8:	e052                	sd	s4,0(sp)
    800014ba:	1800                	addi	s0,sp,48
    800014bc:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800014be:	00009497          	auipc	s1,0x9
    800014c2:	2b248493          	addi	s1,s1,690 # 8000a770 <proc>
      pp->parent = initproc;
    800014c6:	00009a17          	auipc	s4,0x9
    800014ca:	e3aa0a13          	addi	s4,s4,-454 # 8000a300 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800014ce:	0000f997          	auipc	s3,0xf
    800014d2:	ea298993          	addi	s3,s3,-350 # 80010370 <tickslock>
    800014d6:	a029                	j	800014e0 <reparent+0x34>
    800014d8:	17048493          	addi	s1,s1,368
    800014dc:	01348b63          	beq	s1,s3,800014f2 <reparent+0x46>
    if(pp->parent == p){
    800014e0:	7c9c                	ld	a5,56(s1)
    800014e2:	ff279be3          	bne	a5,s2,800014d8 <reparent+0x2c>
      pp->parent = initproc;
    800014e6:	000a3503          	ld	a0,0(s4)
    800014ea:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800014ec:	f57ff0ef          	jal	80001442 <wakeup>
    800014f0:	b7e5                	j	800014d8 <reparent+0x2c>
}
    800014f2:	70a2                	ld	ra,40(sp)
    800014f4:	7402                	ld	s0,32(sp)
    800014f6:	64e2                	ld	s1,24(sp)
    800014f8:	6942                	ld	s2,16(sp)
    800014fa:	69a2                	ld	s3,8(sp)
    800014fc:	6a02                	ld	s4,0(sp)
    800014fe:	6145                	addi	sp,sp,48
    80001500:	8082                	ret

0000000080001502 <exit>:
{
    80001502:	7179                	addi	sp,sp,-48
    80001504:	f406                	sd	ra,40(sp)
    80001506:	f022                	sd	s0,32(sp)
    80001508:	ec26                	sd	s1,24(sp)
    8000150a:	e84a                	sd	s2,16(sp)
    8000150c:	e44e                	sd	s3,8(sp)
    8000150e:	e052                	sd	s4,0(sp)
    80001510:	1800                	addi	s0,sp,48
    80001512:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001514:	88dff0ef          	jal	80000da0 <myproc>
    80001518:	89aa                	mv	s3,a0
  if(p == initproc)
    8000151a:	00009797          	auipc	a5,0x9
    8000151e:	de67b783          	ld	a5,-538(a5) # 8000a300 <initproc>
    80001522:	0d850493          	addi	s1,a0,216
    80001526:	15850913          	addi	s2,a0,344
    8000152a:	00a79f63          	bne	a5,a0,80001548 <exit+0x46>
    panic("init exiting");
    8000152e:	00006517          	auipc	a0,0x6
    80001532:	d0250513          	addi	a0,a0,-766 # 80007230 <etext+0x230>
    80001536:	7dd030ef          	jal	80005512 <panic>
      fileclose(f);
    8000153a:	6d3010ef          	jal	8000340c <fileclose>
      p->ofile[fd] = 0;
    8000153e:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001542:	04a1                	addi	s1,s1,8
    80001544:	01248563          	beq	s1,s2,8000154e <exit+0x4c>
    if(p->ofile[fd]){
    80001548:	6088                	ld	a0,0(s1)
    8000154a:	f965                	bnez	a0,8000153a <exit+0x38>
    8000154c:	bfdd                	j	80001542 <exit+0x40>
  begin_op();
    8000154e:	2a5010ef          	jal	80002ff2 <begin_op>
  iput(p->cwd);
    80001552:	1589b503          	ld	a0,344(s3)
    80001556:	388010ef          	jal	800028de <iput>
  end_op();
    8000155a:	303010ef          	jal	8000305c <end_op>
  p->cwd = 0;
    8000155e:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    80001562:	00009497          	auipc	s1,0x9
    80001566:	df648493          	addi	s1,s1,-522 # 8000a358 <wait_lock>
    8000156a:	8526                	mv	a0,s1
    8000156c:	2d4040ef          	jal	80005840 <acquire>
  reparent(p);
    80001570:	854e                	mv	a0,s3
    80001572:	f3bff0ef          	jal	800014ac <reparent>
  wakeup(p->parent);
    80001576:	0389b503          	ld	a0,56(s3)
    8000157a:	ec9ff0ef          	jal	80001442 <wakeup>
  acquire(&p->lock);
    8000157e:	854e                	mv	a0,s3
    80001580:	2c0040ef          	jal	80005840 <acquire>
  p->xstate = status;
    80001584:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001588:	4795                	li	a5,5
    8000158a:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000158e:	8526                	mv	a0,s1
    80001590:	348040ef          	jal	800058d8 <release>
  sched();
    80001594:	d7dff0ef          	jal	80001310 <sched>
  panic("zombie exit");
    80001598:	00006517          	auipc	a0,0x6
    8000159c:	ca850513          	addi	a0,a0,-856 # 80007240 <etext+0x240>
    800015a0:	773030ef          	jal	80005512 <panic>

00000000800015a4 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800015a4:	7179                	addi	sp,sp,-48
    800015a6:	f406                	sd	ra,40(sp)
    800015a8:	f022                	sd	s0,32(sp)
    800015aa:	ec26                	sd	s1,24(sp)
    800015ac:	e84a                	sd	s2,16(sp)
    800015ae:	e44e                	sd	s3,8(sp)
    800015b0:	1800                	addi	s0,sp,48
    800015b2:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800015b4:	00009497          	auipc	s1,0x9
    800015b8:	1bc48493          	addi	s1,s1,444 # 8000a770 <proc>
    800015bc:	0000f997          	auipc	s3,0xf
    800015c0:	db498993          	addi	s3,s3,-588 # 80010370 <tickslock>
    acquire(&p->lock);
    800015c4:	8526                	mv	a0,s1
    800015c6:	27a040ef          	jal	80005840 <acquire>
    if(p->pid == pid){
    800015ca:	589c                	lw	a5,48(s1)
    800015cc:	01278b63          	beq	a5,s2,800015e2 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800015d0:	8526                	mv	a0,s1
    800015d2:	306040ef          	jal	800058d8 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800015d6:	17048493          	addi	s1,s1,368
    800015da:	ff3495e3          	bne	s1,s3,800015c4 <kill+0x20>
  }
  return -1;
    800015de:	557d                	li	a0,-1
    800015e0:	a819                	j	800015f6 <kill+0x52>
      p->killed = 1;
    800015e2:	4785                	li	a5,1
    800015e4:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800015e6:	4c98                	lw	a4,24(s1)
    800015e8:	4789                	li	a5,2
    800015ea:	00f70d63          	beq	a4,a5,80001604 <kill+0x60>
      release(&p->lock);
    800015ee:	8526                	mv	a0,s1
    800015f0:	2e8040ef          	jal	800058d8 <release>
      return 0;
    800015f4:	4501                	li	a0,0
}
    800015f6:	70a2                	ld	ra,40(sp)
    800015f8:	7402                	ld	s0,32(sp)
    800015fa:	64e2                	ld	s1,24(sp)
    800015fc:	6942                	ld	s2,16(sp)
    800015fe:	69a2                	ld	s3,8(sp)
    80001600:	6145                	addi	sp,sp,48
    80001602:	8082                	ret
        p->state = RUNNABLE;
    80001604:	478d                	li	a5,3
    80001606:	cc9c                	sw	a5,24(s1)
    80001608:	b7dd                	j	800015ee <kill+0x4a>

000000008000160a <setkilled>:

void
setkilled(struct proc *p)
{
    8000160a:	1101                	addi	sp,sp,-32
    8000160c:	ec06                	sd	ra,24(sp)
    8000160e:	e822                	sd	s0,16(sp)
    80001610:	e426                	sd	s1,8(sp)
    80001612:	1000                	addi	s0,sp,32
    80001614:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001616:	22a040ef          	jal	80005840 <acquire>
  p->killed = 1;
    8000161a:	4785                	li	a5,1
    8000161c:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000161e:	8526                	mv	a0,s1
    80001620:	2b8040ef          	jal	800058d8 <release>
}
    80001624:	60e2                	ld	ra,24(sp)
    80001626:	6442                	ld	s0,16(sp)
    80001628:	64a2                	ld	s1,8(sp)
    8000162a:	6105                	addi	sp,sp,32
    8000162c:	8082                	ret

000000008000162e <killed>:

int
killed(struct proc *p)
{
    8000162e:	1101                	addi	sp,sp,-32
    80001630:	ec06                	sd	ra,24(sp)
    80001632:	e822                	sd	s0,16(sp)
    80001634:	e426                	sd	s1,8(sp)
    80001636:	e04a                	sd	s2,0(sp)
    80001638:	1000                	addi	s0,sp,32
    8000163a:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000163c:	204040ef          	jal	80005840 <acquire>
  k = p->killed;
    80001640:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001644:	8526                	mv	a0,s1
    80001646:	292040ef          	jal	800058d8 <release>
  return k;
}
    8000164a:	854a                	mv	a0,s2
    8000164c:	60e2                	ld	ra,24(sp)
    8000164e:	6442                	ld	s0,16(sp)
    80001650:	64a2                	ld	s1,8(sp)
    80001652:	6902                	ld	s2,0(sp)
    80001654:	6105                	addi	sp,sp,32
    80001656:	8082                	ret

0000000080001658 <wait>:
{
    80001658:	715d                	addi	sp,sp,-80
    8000165a:	e486                	sd	ra,72(sp)
    8000165c:	e0a2                	sd	s0,64(sp)
    8000165e:	fc26                	sd	s1,56(sp)
    80001660:	f84a                	sd	s2,48(sp)
    80001662:	f44e                	sd	s3,40(sp)
    80001664:	f052                	sd	s4,32(sp)
    80001666:	ec56                	sd	s5,24(sp)
    80001668:	e85a                	sd	s6,16(sp)
    8000166a:	e45e                	sd	s7,8(sp)
    8000166c:	e062                	sd	s8,0(sp)
    8000166e:	0880                	addi	s0,sp,80
    80001670:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001672:	f2eff0ef          	jal	80000da0 <myproc>
    80001676:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001678:	00009517          	auipc	a0,0x9
    8000167c:	ce050513          	addi	a0,a0,-800 # 8000a358 <wait_lock>
    80001680:	1c0040ef          	jal	80005840 <acquire>
    havekids = 0;
    80001684:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001686:	4a15                	li	s4,5
        havekids = 1;
    80001688:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000168a:	0000f997          	auipc	s3,0xf
    8000168e:	ce698993          	addi	s3,s3,-794 # 80010370 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001692:	00009c17          	auipc	s8,0x9
    80001696:	cc6c0c13          	addi	s8,s8,-826 # 8000a358 <wait_lock>
    8000169a:	a871                	j	80001736 <wait+0xde>
          pid = pp->pid;
    8000169c:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800016a0:	000b0c63          	beqz	s6,800016b8 <wait+0x60>
    800016a4:	4691                	li	a3,4
    800016a6:	02c48613          	addi	a2,s1,44
    800016aa:	85da                	mv	a1,s6
    800016ac:	05093503          	ld	a0,80(s2)
    800016b0:	b42ff0ef          	jal	800009f2 <copyout>
    800016b4:	02054b63          	bltz	a0,800016ea <wait+0x92>
          freeproc(pp);
    800016b8:	8526                	mv	a0,s1
    800016ba:	8b5ff0ef          	jal	80000f6e <freeproc>
          release(&pp->lock);
    800016be:	8526                	mv	a0,s1
    800016c0:	218040ef          	jal	800058d8 <release>
          release(&wait_lock);
    800016c4:	00009517          	auipc	a0,0x9
    800016c8:	c9450513          	addi	a0,a0,-876 # 8000a358 <wait_lock>
    800016cc:	20c040ef          	jal	800058d8 <release>
}
    800016d0:	854e                	mv	a0,s3
    800016d2:	60a6                	ld	ra,72(sp)
    800016d4:	6406                	ld	s0,64(sp)
    800016d6:	74e2                	ld	s1,56(sp)
    800016d8:	7942                	ld	s2,48(sp)
    800016da:	79a2                	ld	s3,40(sp)
    800016dc:	7a02                	ld	s4,32(sp)
    800016de:	6ae2                	ld	s5,24(sp)
    800016e0:	6b42                	ld	s6,16(sp)
    800016e2:	6ba2                	ld	s7,8(sp)
    800016e4:	6c02                	ld	s8,0(sp)
    800016e6:	6161                	addi	sp,sp,80
    800016e8:	8082                	ret
            release(&pp->lock);
    800016ea:	8526                	mv	a0,s1
    800016ec:	1ec040ef          	jal	800058d8 <release>
            release(&wait_lock);
    800016f0:	00009517          	auipc	a0,0x9
    800016f4:	c6850513          	addi	a0,a0,-920 # 8000a358 <wait_lock>
    800016f8:	1e0040ef          	jal	800058d8 <release>
            return -1;
    800016fc:	59fd                	li	s3,-1
    800016fe:	bfc9                	j	800016d0 <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001700:	17048493          	addi	s1,s1,368
    80001704:	03348063          	beq	s1,s3,80001724 <wait+0xcc>
      if(pp->parent == p){
    80001708:	7c9c                	ld	a5,56(s1)
    8000170a:	ff279be3          	bne	a5,s2,80001700 <wait+0xa8>
        acquire(&pp->lock);
    8000170e:	8526                	mv	a0,s1
    80001710:	130040ef          	jal	80005840 <acquire>
        if(pp->state == ZOMBIE){
    80001714:	4c9c                	lw	a5,24(s1)
    80001716:	f94783e3          	beq	a5,s4,8000169c <wait+0x44>
        release(&pp->lock);
    8000171a:	8526                	mv	a0,s1
    8000171c:	1bc040ef          	jal	800058d8 <release>
        havekids = 1;
    80001720:	8756                	mv	a4,s5
    80001722:	bff9                	j	80001700 <wait+0xa8>
    if(!havekids || killed(p)){
    80001724:	cf19                	beqz	a4,80001742 <wait+0xea>
    80001726:	854a                	mv	a0,s2
    80001728:	f07ff0ef          	jal	8000162e <killed>
    8000172c:	e919                	bnez	a0,80001742 <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000172e:	85e2                	mv	a1,s8
    80001730:	854a                	mv	a0,s2
    80001732:	cc5ff0ef          	jal	800013f6 <sleep>
    havekids = 0;
    80001736:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001738:	00009497          	auipc	s1,0x9
    8000173c:	03848493          	addi	s1,s1,56 # 8000a770 <proc>
    80001740:	b7e1                	j	80001708 <wait+0xb0>
      release(&wait_lock);
    80001742:	00009517          	auipc	a0,0x9
    80001746:	c1650513          	addi	a0,a0,-1002 # 8000a358 <wait_lock>
    8000174a:	18e040ef          	jal	800058d8 <release>
      return -1;
    8000174e:	59fd                	li	s3,-1
    80001750:	b741                	j	800016d0 <wait+0x78>

0000000080001752 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001752:	7179                	addi	sp,sp,-48
    80001754:	f406                	sd	ra,40(sp)
    80001756:	f022                	sd	s0,32(sp)
    80001758:	ec26                	sd	s1,24(sp)
    8000175a:	e84a                	sd	s2,16(sp)
    8000175c:	e44e                	sd	s3,8(sp)
    8000175e:	e052                	sd	s4,0(sp)
    80001760:	1800                	addi	s0,sp,48
    80001762:	84aa                	mv	s1,a0
    80001764:	892e                	mv	s2,a1
    80001766:	89b2                	mv	s3,a2
    80001768:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000176a:	e36ff0ef          	jal	80000da0 <myproc>
  if(user_dst){
    8000176e:	cc99                	beqz	s1,8000178c <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80001770:	86d2                	mv	a3,s4
    80001772:	864e                	mv	a2,s3
    80001774:	85ca                	mv	a1,s2
    80001776:	6928                	ld	a0,80(a0)
    80001778:	a7aff0ef          	jal	800009f2 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000177c:	70a2                	ld	ra,40(sp)
    8000177e:	7402                	ld	s0,32(sp)
    80001780:	64e2                	ld	s1,24(sp)
    80001782:	6942                	ld	s2,16(sp)
    80001784:	69a2                	ld	s3,8(sp)
    80001786:	6a02                	ld	s4,0(sp)
    80001788:	6145                	addi	sp,sp,48
    8000178a:	8082                	ret
    memmove((char *)dst, src, len);
    8000178c:	000a061b          	sext.w	a2,s4
    80001790:	85ce                	mv	a1,s3
    80001792:	854a                	mv	a0,s2
    80001794:	a17fe0ef          	jal	800001aa <memmove>
    return 0;
    80001798:	8526                	mv	a0,s1
    8000179a:	b7cd                	j	8000177c <either_copyout+0x2a>

000000008000179c <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000179c:	7179                	addi	sp,sp,-48
    8000179e:	f406                	sd	ra,40(sp)
    800017a0:	f022                	sd	s0,32(sp)
    800017a2:	ec26                	sd	s1,24(sp)
    800017a4:	e84a                	sd	s2,16(sp)
    800017a6:	e44e                	sd	s3,8(sp)
    800017a8:	e052                	sd	s4,0(sp)
    800017aa:	1800                	addi	s0,sp,48
    800017ac:	892a                	mv	s2,a0
    800017ae:	84ae                	mv	s1,a1
    800017b0:	89b2                	mv	s3,a2
    800017b2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800017b4:	decff0ef          	jal	80000da0 <myproc>
  if(user_src){
    800017b8:	cc99                	beqz	s1,800017d6 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800017ba:	86d2                	mv	a3,s4
    800017bc:	864e                	mv	a2,s3
    800017be:	85ca                	mv	a1,s2
    800017c0:	6928                	ld	a0,80(a0)
    800017c2:	b08ff0ef          	jal	80000aca <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800017c6:	70a2                	ld	ra,40(sp)
    800017c8:	7402                	ld	s0,32(sp)
    800017ca:	64e2                	ld	s1,24(sp)
    800017cc:	6942                	ld	s2,16(sp)
    800017ce:	69a2                	ld	s3,8(sp)
    800017d0:	6a02                	ld	s4,0(sp)
    800017d2:	6145                	addi	sp,sp,48
    800017d4:	8082                	ret
    memmove(dst, (char*)src, len);
    800017d6:	000a061b          	sext.w	a2,s4
    800017da:	85ce                	mv	a1,s3
    800017dc:	854a                	mv	a0,s2
    800017de:	9cdfe0ef          	jal	800001aa <memmove>
    return 0;
    800017e2:	8526                	mv	a0,s1
    800017e4:	b7cd                	j	800017c6 <either_copyin+0x2a>

00000000800017e6 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800017e6:	715d                	addi	sp,sp,-80
    800017e8:	e486                	sd	ra,72(sp)
    800017ea:	e0a2                	sd	s0,64(sp)
    800017ec:	fc26                	sd	s1,56(sp)
    800017ee:	f84a                	sd	s2,48(sp)
    800017f0:	f44e                	sd	s3,40(sp)
    800017f2:	f052                	sd	s4,32(sp)
    800017f4:	ec56                	sd	s5,24(sp)
    800017f6:	e85a                	sd	s6,16(sp)
    800017f8:	e45e                	sd	s7,8(sp)
    800017fa:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800017fc:	00006517          	auipc	a0,0x6
    80001800:	81c50513          	addi	a0,a0,-2020 # 80007018 <etext+0x18>
    80001804:	23d030ef          	jal	80005240 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001808:	00009497          	auipc	s1,0x9
    8000180c:	0c848493          	addi	s1,s1,200 # 8000a8d0 <proc+0x160>
    80001810:	0000f917          	auipc	s2,0xf
    80001814:	cc090913          	addi	s2,s2,-832 # 800104d0 <bcache+0x148>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001818:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000181a:	00006997          	auipc	s3,0x6
    8000181e:	a3698993          	addi	s3,s3,-1482 # 80007250 <etext+0x250>
    printf("%d %s %s", p->pid, state, p->name);
    80001822:	00006a97          	auipc	s5,0x6
    80001826:	a36a8a93          	addi	s5,s5,-1482 # 80007258 <etext+0x258>
    printf("\n");
    8000182a:	00005a17          	auipc	s4,0x5
    8000182e:	7eea0a13          	addi	s4,s4,2030 # 80007018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001832:	00006b97          	auipc	s7,0x6
    80001836:	f4eb8b93          	addi	s7,s7,-178 # 80007780 <states.0>
    8000183a:	a829                	j	80001854 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    8000183c:	ed06a583          	lw	a1,-304(a3)
    80001840:	8556                	mv	a0,s5
    80001842:	1ff030ef          	jal	80005240 <printf>
    printf("\n");
    80001846:	8552                	mv	a0,s4
    80001848:	1f9030ef          	jal	80005240 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000184c:	17048493          	addi	s1,s1,368
    80001850:	03248263          	beq	s1,s2,80001874 <procdump+0x8e>
    if(p->state == UNUSED)
    80001854:	86a6                	mv	a3,s1
    80001856:	eb84a783          	lw	a5,-328(s1)
    8000185a:	dbed                	beqz	a5,8000184c <procdump+0x66>
      state = "???";
    8000185c:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000185e:	fcfb6fe3          	bltu	s6,a5,8000183c <procdump+0x56>
    80001862:	02079713          	slli	a4,a5,0x20
    80001866:	01d75793          	srli	a5,a4,0x1d
    8000186a:	97de                	add	a5,a5,s7
    8000186c:	6390                	ld	a2,0(a5)
    8000186e:	f679                	bnez	a2,8000183c <procdump+0x56>
      state = "???";
    80001870:	864e                	mv	a2,s3
    80001872:	b7e9                	j	8000183c <procdump+0x56>
  }
}
    80001874:	60a6                	ld	ra,72(sp)
    80001876:	6406                	ld	s0,64(sp)
    80001878:	74e2                	ld	s1,56(sp)
    8000187a:	7942                	ld	s2,48(sp)
    8000187c:	79a2                	ld	s3,40(sp)
    8000187e:	7a02                	ld	s4,32(sp)
    80001880:	6ae2                	ld	s5,24(sp)
    80001882:	6b42                	ld	s6,16(sp)
    80001884:	6ba2                	ld	s7,8(sp)
    80001886:	6161                	addi	sp,sp,80
    80001888:	8082                	ret

000000008000188a <swtch>:
    8000188a:	00153023          	sd	ra,0(a0)
    8000188e:	00253423          	sd	sp,8(a0)
    80001892:	e900                	sd	s0,16(a0)
    80001894:	ed04                	sd	s1,24(a0)
    80001896:	03253023          	sd	s2,32(a0)
    8000189a:	03353423          	sd	s3,40(a0)
    8000189e:	03453823          	sd	s4,48(a0)
    800018a2:	03553c23          	sd	s5,56(a0)
    800018a6:	05653023          	sd	s6,64(a0)
    800018aa:	05753423          	sd	s7,72(a0)
    800018ae:	05853823          	sd	s8,80(a0)
    800018b2:	05953c23          	sd	s9,88(a0)
    800018b6:	07a53023          	sd	s10,96(a0)
    800018ba:	07b53423          	sd	s11,104(a0)
    800018be:	0005b083          	ld	ra,0(a1)
    800018c2:	0085b103          	ld	sp,8(a1)
    800018c6:	6980                	ld	s0,16(a1)
    800018c8:	6d84                	ld	s1,24(a1)
    800018ca:	0205b903          	ld	s2,32(a1)
    800018ce:	0285b983          	ld	s3,40(a1)
    800018d2:	0305ba03          	ld	s4,48(a1)
    800018d6:	0385ba83          	ld	s5,56(a1)
    800018da:	0405bb03          	ld	s6,64(a1)
    800018de:	0485bb83          	ld	s7,72(a1)
    800018e2:	0505bc03          	ld	s8,80(a1)
    800018e6:	0585bc83          	ld	s9,88(a1)
    800018ea:	0605bd03          	ld	s10,96(a1)
    800018ee:	0685bd83          	ld	s11,104(a1)
    800018f2:	8082                	ret

00000000800018f4 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800018f4:	1141                	addi	sp,sp,-16
    800018f6:	e406                	sd	ra,8(sp)
    800018f8:	e022                	sd	s0,0(sp)
    800018fa:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800018fc:	00006597          	auipc	a1,0x6
    80001900:	99c58593          	addi	a1,a1,-1636 # 80007298 <etext+0x298>
    80001904:	0000f517          	auipc	a0,0xf
    80001908:	a6c50513          	addi	a0,a0,-1428 # 80010370 <tickslock>
    8000190c:	6b5030ef          	jal	800057c0 <initlock>
}
    80001910:	60a2                	ld	ra,8(sp)
    80001912:	6402                	ld	s0,0(sp)
    80001914:	0141                	addi	sp,sp,16
    80001916:	8082                	ret

0000000080001918 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001918:	1141                	addi	sp,sp,-16
    8000191a:	e422                	sd	s0,8(sp)
    8000191c:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000191e:	00003797          	auipc	a5,0x3
    80001922:	e6278793          	addi	a5,a5,-414 # 80004780 <kernelvec>
    80001926:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000192a:	6422                	ld	s0,8(sp)
    8000192c:	0141                	addi	sp,sp,16
    8000192e:	8082                	ret

0000000080001930 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001930:	1141                	addi	sp,sp,-16
    80001932:	e406                	sd	ra,8(sp)
    80001934:	e022                	sd	s0,0(sp)
    80001936:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001938:	c68ff0ef          	jal	80000da0 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000193c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001940:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001942:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001946:	00004697          	auipc	a3,0x4
    8000194a:	6ba68693          	addi	a3,a3,1722 # 80006000 <_trampoline>
    8000194e:	00004717          	auipc	a4,0x4
    80001952:	6b270713          	addi	a4,a4,1714 # 80006000 <_trampoline>
    80001956:	8f15                	sub	a4,a4,a3
    80001958:	040007b7          	lui	a5,0x4000
    8000195c:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    8000195e:	07b2                	slli	a5,a5,0xc
    80001960:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001962:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001966:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001968:	18002673          	csrr	a2,satp
    8000196c:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000196e:	6d30                	ld	a2,88(a0)
    80001970:	6138                	ld	a4,64(a0)
    80001972:	6585                	lui	a1,0x1
    80001974:	972e                	add	a4,a4,a1
    80001976:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001978:	6d38                	ld	a4,88(a0)
    8000197a:	00000617          	auipc	a2,0x0
    8000197e:	11060613          	addi	a2,a2,272 # 80001a8a <usertrap>
    80001982:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001984:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001986:	8612                	mv	a2,tp
    80001988:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000198a:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000198e:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001992:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001996:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    8000199a:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000199c:	6f18                	ld	a4,24(a4)
    8000199e:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800019a2:	6928                	ld	a0,80(a0)
    800019a4:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800019a6:	00004717          	auipc	a4,0x4
    800019aa:	6f670713          	addi	a4,a4,1782 # 8000609c <userret>
    800019ae:	8f15                	sub	a4,a4,a3
    800019b0:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800019b2:	577d                	li	a4,-1
    800019b4:	177e                	slli	a4,a4,0x3f
    800019b6:	8d59                	or	a0,a0,a4
    800019b8:	9782                	jalr	a5
}
    800019ba:	60a2                	ld	ra,8(sp)
    800019bc:	6402                	ld	s0,0(sp)
    800019be:	0141                	addi	sp,sp,16
    800019c0:	8082                	ret

00000000800019c2 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800019c2:	1101                	addi	sp,sp,-32
    800019c4:	ec06                	sd	ra,24(sp)
    800019c6:	e822                	sd	s0,16(sp)
    800019c8:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    800019ca:	baaff0ef          	jal	80000d74 <cpuid>
    800019ce:	cd11                	beqz	a0,800019ea <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    800019d0:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    800019d4:	000f4737          	lui	a4,0xf4
    800019d8:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800019dc:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800019de:	14d79073          	csrw	stimecmp,a5
}
    800019e2:	60e2                	ld	ra,24(sp)
    800019e4:	6442                	ld	s0,16(sp)
    800019e6:	6105                	addi	sp,sp,32
    800019e8:	8082                	ret
    800019ea:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    800019ec:	0000f497          	auipc	s1,0xf
    800019f0:	98448493          	addi	s1,s1,-1660 # 80010370 <tickslock>
    800019f4:	8526                	mv	a0,s1
    800019f6:	64b030ef          	jal	80005840 <acquire>
    ticks++;
    800019fa:	00009517          	auipc	a0,0x9
    800019fe:	90e50513          	addi	a0,a0,-1778 # 8000a308 <ticks>
    80001a02:	411c                	lw	a5,0(a0)
    80001a04:	2785                	addiw	a5,a5,1
    80001a06:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80001a08:	a3bff0ef          	jal	80001442 <wakeup>
    release(&tickslock);
    80001a0c:	8526                	mv	a0,s1
    80001a0e:	6cb030ef          	jal	800058d8 <release>
    80001a12:	64a2                	ld	s1,8(sp)
    80001a14:	bf75                	j	800019d0 <clockintr+0xe>

0000000080001a16 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001a16:	1101                	addi	sp,sp,-32
    80001a18:	ec06                	sd	ra,24(sp)
    80001a1a:	e822                	sd	s0,16(sp)
    80001a1c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a1e:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80001a22:	57fd                	li	a5,-1
    80001a24:	17fe                	slli	a5,a5,0x3f
    80001a26:	07a5                	addi	a5,a5,9
    80001a28:	00f70c63          	beq	a4,a5,80001a40 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80001a2c:	57fd                	li	a5,-1
    80001a2e:	17fe                	slli	a5,a5,0x3f
    80001a30:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80001a32:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80001a34:	04f70763          	beq	a4,a5,80001a82 <devintr+0x6c>
  }
}
    80001a38:	60e2                	ld	ra,24(sp)
    80001a3a:	6442                	ld	s0,16(sp)
    80001a3c:	6105                	addi	sp,sp,32
    80001a3e:	8082                	ret
    80001a40:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001a42:	5eb020ef          	jal	8000482c <plic_claim>
    80001a46:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001a48:	47a9                	li	a5,10
    80001a4a:	00f50963          	beq	a0,a5,80001a5c <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    80001a4e:	4785                	li	a5,1
    80001a50:	00f50963          	beq	a0,a5,80001a62 <devintr+0x4c>
    return 1;
    80001a54:	4505                	li	a0,1
    } else if(irq){
    80001a56:	e889                	bnez	s1,80001a68 <devintr+0x52>
    80001a58:	64a2                	ld	s1,8(sp)
    80001a5a:	bff9                	j	80001a38 <devintr+0x22>
      uartintr();
    80001a5c:	529030ef          	jal	80005784 <uartintr>
    if(irq)
    80001a60:	a819                	j	80001a76 <devintr+0x60>
      virtio_disk_intr();
    80001a62:	290030ef          	jal	80004cf2 <virtio_disk_intr>
    if(irq)
    80001a66:	a801                	j	80001a76 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80001a68:	85a6                	mv	a1,s1
    80001a6a:	00006517          	auipc	a0,0x6
    80001a6e:	83650513          	addi	a0,a0,-1994 # 800072a0 <etext+0x2a0>
    80001a72:	7ce030ef          	jal	80005240 <printf>
      plic_complete(irq);
    80001a76:	8526                	mv	a0,s1
    80001a78:	5d5020ef          	jal	8000484c <plic_complete>
    return 1;
    80001a7c:	4505                	li	a0,1
    80001a7e:	64a2                	ld	s1,8(sp)
    80001a80:	bf65                	j	80001a38 <devintr+0x22>
    clockintr();
    80001a82:	f41ff0ef          	jal	800019c2 <clockintr>
    return 2;
    80001a86:	4509                	li	a0,2
    80001a88:	bf45                	j	80001a38 <devintr+0x22>

0000000080001a8a <usertrap>:
{
    80001a8a:	1101                	addi	sp,sp,-32
    80001a8c:	ec06                	sd	ra,24(sp)
    80001a8e:	e822                	sd	s0,16(sp)
    80001a90:	e426                	sd	s1,8(sp)
    80001a92:	e04a                	sd	s2,0(sp)
    80001a94:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a96:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001a9a:	1007f793          	andi	a5,a5,256
    80001a9e:	ef85                	bnez	a5,80001ad6 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001aa0:	00003797          	auipc	a5,0x3
    80001aa4:	ce078793          	addi	a5,a5,-800 # 80004780 <kernelvec>
    80001aa8:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001aac:	af4ff0ef          	jal	80000da0 <myproc>
    80001ab0:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001ab2:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ab4:	14102773          	csrr	a4,sepc
    80001ab8:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001aba:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001abe:	47a1                	li	a5,8
    80001ac0:	02f70163          	beq	a4,a5,80001ae2 <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    80001ac4:	f53ff0ef          	jal	80001a16 <devintr>
    80001ac8:	892a                	mv	s2,a0
    80001aca:	c135                	beqz	a0,80001b2e <usertrap+0xa4>
  if(killed(p))
    80001acc:	8526                	mv	a0,s1
    80001ace:	b61ff0ef          	jal	8000162e <killed>
    80001ad2:	cd1d                	beqz	a0,80001b10 <usertrap+0x86>
    80001ad4:	a81d                	j	80001b0a <usertrap+0x80>
    panic("usertrap: not from user mode");
    80001ad6:	00005517          	auipc	a0,0x5
    80001ada:	7ea50513          	addi	a0,a0,2026 # 800072c0 <etext+0x2c0>
    80001ade:	235030ef          	jal	80005512 <panic>
    if(killed(p))
    80001ae2:	b4dff0ef          	jal	8000162e <killed>
    80001ae6:	e121                	bnez	a0,80001b26 <usertrap+0x9c>
    p->trapframe->epc += 4;
    80001ae8:	6cb8                	ld	a4,88(s1)
    80001aea:	6f1c                	ld	a5,24(a4)
    80001aec:	0791                	addi	a5,a5,4
    80001aee:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001af0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001af4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001af8:	10079073          	csrw	sstatus,a5
    syscall();
    80001afc:	248000ef          	jal	80001d44 <syscall>
  if(killed(p))
    80001b00:	8526                	mv	a0,s1
    80001b02:	b2dff0ef          	jal	8000162e <killed>
    80001b06:	c901                	beqz	a0,80001b16 <usertrap+0x8c>
    80001b08:	4901                	li	s2,0
    exit(-1);
    80001b0a:	557d                	li	a0,-1
    80001b0c:	9f7ff0ef          	jal	80001502 <exit>
  if(which_dev == 2)
    80001b10:	4789                	li	a5,2
    80001b12:	04f90563          	beq	s2,a5,80001b5c <usertrap+0xd2>
  usertrapret();
    80001b16:	e1bff0ef          	jal	80001930 <usertrapret>
}
    80001b1a:	60e2                	ld	ra,24(sp)
    80001b1c:	6442                	ld	s0,16(sp)
    80001b1e:	64a2                	ld	s1,8(sp)
    80001b20:	6902                	ld	s2,0(sp)
    80001b22:	6105                	addi	sp,sp,32
    80001b24:	8082                	ret
      exit(-1);
    80001b26:	557d                	li	a0,-1
    80001b28:	9dbff0ef          	jal	80001502 <exit>
    80001b2c:	bf75                	j	80001ae8 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b2e:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001b32:	5890                	lw	a2,48(s1)
    80001b34:	00005517          	auipc	a0,0x5
    80001b38:	7ac50513          	addi	a0,a0,1964 # 800072e0 <etext+0x2e0>
    80001b3c:	704030ef          	jal	80005240 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b40:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b44:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001b48:	00005517          	auipc	a0,0x5
    80001b4c:	7c850513          	addi	a0,a0,1992 # 80007310 <etext+0x310>
    80001b50:	6f0030ef          	jal	80005240 <printf>
    setkilled(p);
    80001b54:	8526                	mv	a0,s1
    80001b56:	ab5ff0ef          	jal	8000160a <setkilled>
    80001b5a:	b75d                	j	80001b00 <usertrap+0x76>
    yield();
    80001b5c:	86fff0ef          	jal	800013ca <yield>
    80001b60:	bf5d                	j	80001b16 <usertrap+0x8c>

0000000080001b62 <kerneltrap>:
{
    80001b62:	7179                	addi	sp,sp,-48
    80001b64:	f406                	sd	ra,40(sp)
    80001b66:	f022                	sd	s0,32(sp)
    80001b68:	ec26                	sd	s1,24(sp)
    80001b6a:	e84a                	sd	s2,16(sp)
    80001b6c:	e44e                	sd	s3,8(sp)
    80001b6e:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b70:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b74:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b78:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001b7c:	1004f793          	andi	a5,s1,256
    80001b80:	c795                	beqz	a5,80001bac <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b82:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001b86:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001b88:	eb85                	bnez	a5,80001bb8 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001b8a:	e8dff0ef          	jal	80001a16 <devintr>
    80001b8e:	c91d                	beqz	a0,80001bc4 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001b90:	4789                	li	a5,2
    80001b92:	04f50a63          	beq	a0,a5,80001be6 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b96:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b9a:	10049073          	csrw	sstatus,s1
}
    80001b9e:	70a2                	ld	ra,40(sp)
    80001ba0:	7402                	ld	s0,32(sp)
    80001ba2:	64e2                	ld	s1,24(sp)
    80001ba4:	6942                	ld	s2,16(sp)
    80001ba6:	69a2                	ld	s3,8(sp)
    80001ba8:	6145                	addi	sp,sp,48
    80001baa:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001bac:	00005517          	auipc	a0,0x5
    80001bb0:	78c50513          	addi	a0,a0,1932 # 80007338 <etext+0x338>
    80001bb4:	15f030ef          	jal	80005512 <panic>
    panic("kerneltrap: interrupts enabled");
    80001bb8:	00005517          	auipc	a0,0x5
    80001bbc:	7a850513          	addi	a0,a0,1960 # 80007360 <etext+0x360>
    80001bc0:	153030ef          	jal	80005512 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001bc4:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001bc8:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001bcc:	85ce                	mv	a1,s3
    80001bce:	00005517          	auipc	a0,0x5
    80001bd2:	7b250513          	addi	a0,a0,1970 # 80007380 <etext+0x380>
    80001bd6:	66a030ef          	jal	80005240 <printf>
    panic("kerneltrap");
    80001bda:	00005517          	auipc	a0,0x5
    80001bde:	7ce50513          	addi	a0,a0,1998 # 800073a8 <etext+0x3a8>
    80001be2:	131030ef          	jal	80005512 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001be6:	9baff0ef          	jal	80000da0 <myproc>
    80001bea:	d555                	beqz	a0,80001b96 <kerneltrap+0x34>
    yield();
    80001bec:	fdeff0ef          	jal	800013ca <yield>
    80001bf0:	b75d                	j	80001b96 <kerneltrap+0x34>

0000000080001bf2 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001bf2:	1101                	addi	sp,sp,-32
    80001bf4:	ec06                	sd	ra,24(sp)
    80001bf6:	e822                	sd	s0,16(sp)
    80001bf8:	e426                	sd	s1,8(sp)
    80001bfa:	1000                	addi	s0,sp,32
    80001bfc:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001bfe:	9a2ff0ef          	jal	80000da0 <myproc>
  switch (n) {
    80001c02:	4795                	li	a5,5
    80001c04:	0497e163          	bltu	a5,s1,80001c46 <argraw+0x54>
    80001c08:	048a                	slli	s1,s1,0x2
    80001c0a:	00006717          	auipc	a4,0x6
    80001c0e:	ba670713          	addi	a4,a4,-1114 # 800077b0 <states.0+0x30>
    80001c12:	94ba                	add	s1,s1,a4
    80001c14:	409c                	lw	a5,0(s1)
    80001c16:	97ba                	add	a5,a5,a4
    80001c18:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001c1a:	6d3c                	ld	a5,88(a0)
    80001c1c:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001c1e:	60e2                	ld	ra,24(sp)
    80001c20:	6442                	ld	s0,16(sp)
    80001c22:	64a2                	ld	s1,8(sp)
    80001c24:	6105                	addi	sp,sp,32
    80001c26:	8082                	ret
    return p->trapframe->a1;
    80001c28:	6d3c                	ld	a5,88(a0)
    80001c2a:	7fa8                	ld	a0,120(a5)
    80001c2c:	bfcd                	j	80001c1e <argraw+0x2c>
    return p->trapframe->a2;
    80001c2e:	6d3c                	ld	a5,88(a0)
    80001c30:	63c8                	ld	a0,128(a5)
    80001c32:	b7f5                	j	80001c1e <argraw+0x2c>
    return p->trapframe->a3;
    80001c34:	6d3c                	ld	a5,88(a0)
    80001c36:	67c8                	ld	a0,136(a5)
    80001c38:	b7dd                	j	80001c1e <argraw+0x2c>
    return p->trapframe->a4;
    80001c3a:	6d3c                	ld	a5,88(a0)
    80001c3c:	6bc8                	ld	a0,144(a5)
    80001c3e:	b7c5                	j	80001c1e <argraw+0x2c>
    return p->trapframe->a5;
    80001c40:	6d3c                	ld	a5,88(a0)
    80001c42:	6fc8                	ld	a0,152(a5)
    80001c44:	bfe9                	j	80001c1e <argraw+0x2c>
  panic("argraw");
    80001c46:	00005517          	auipc	a0,0x5
    80001c4a:	77250513          	addi	a0,a0,1906 # 800073b8 <etext+0x3b8>
    80001c4e:	0c5030ef          	jal	80005512 <panic>

0000000080001c52 <fetchaddr>:
{
    80001c52:	1101                	addi	sp,sp,-32
    80001c54:	ec06                	sd	ra,24(sp)
    80001c56:	e822                	sd	s0,16(sp)
    80001c58:	e426                	sd	s1,8(sp)
    80001c5a:	e04a                	sd	s2,0(sp)
    80001c5c:	1000                	addi	s0,sp,32
    80001c5e:	84aa                	mv	s1,a0
    80001c60:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001c62:	93eff0ef          	jal	80000da0 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001c66:	653c                	ld	a5,72(a0)
    80001c68:	02f4f663          	bgeu	s1,a5,80001c94 <fetchaddr+0x42>
    80001c6c:	00848713          	addi	a4,s1,8
    80001c70:	02e7e463          	bltu	a5,a4,80001c98 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001c74:	46a1                	li	a3,8
    80001c76:	8626                	mv	a2,s1
    80001c78:	85ca                	mv	a1,s2
    80001c7a:	6928                	ld	a0,80(a0)
    80001c7c:	e4ffe0ef          	jal	80000aca <copyin>
    80001c80:	00a03533          	snez	a0,a0
    80001c84:	40a00533          	neg	a0,a0
}
    80001c88:	60e2                	ld	ra,24(sp)
    80001c8a:	6442                	ld	s0,16(sp)
    80001c8c:	64a2                	ld	s1,8(sp)
    80001c8e:	6902                	ld	s2,0(sp)
    80001c90:	6105                	addi	sp,sp,32
    80001c92:	8082                	ret
    return -1;
    80001c94:	557d                	li	a0,-1
    80001c96:	bfcd                	j	80001c88 <fetchaddr+0x36>
    80001c98:	557d                	li	a0,-1
    80001c9a:	b7fd                	j	80001c88 <fetchaddr+0x36>

0000000080001c9c <fetchstr>:
{
    80001c9c:	7179                	addi	sp,sp,-48
    80001c9e:	f406                	sd	ra,40(sp)
    80001ca0:	f022                	sd	s0,32(sp)
    80001ca2:	ec26                	sd	s1,24(sp)
    80001ca4:	e84a                	sd	s2,16(sp)
    80001ca6:	e44e                	sd	s3,8(sp)
    80001ca8:	1800                	addi	s0,sp,48
    80001caa:	892a                	mv	s2,a0
    80001cac:	84ae                	mv	s1,a1
    80001cae:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001cb0:	8f0ff0ef          	jal	80000da0 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001cb4:	86ce                	mv	a3,s3
    80001cb6:	864a                	mv	a2,s2
    80001cb8:	85a6                	mv	a1,s1
    80001cba:	6928                	ld	a0,80(a0)
    80001cbc:	e95fe0ef          	jal	80000b50 <copyinstr>
    80001cc0:	00054c63          	bltz	a0,80001cd8 <fetchstr+0x3c>
  return strlen(buf);
    80001cc4:	8526                	mv	a0,s1
    80001cc6:	df8fe0ef          	jal	800002be <strlen>
}
    80001cca:	70a2                	ld	ra,40(sp)
    80001ccc:	7402                	ld	s0,32(sp)
    80001cce:	64e2                	ld	s1,24(sp)
    80001cd0:	6942                	ld	s2,16(sp)
    80001cd2:	69a2                	ld	s3,8(sp)
    80001cd4:	6145                	addi	sp,sp,48
    80001cd6:	8082                	ret
    return -1;
    80001cd8:	557d                	li	a0,-1
    80001cda:	bfc5                	j	80001cca <fetchstr+0x2e>

0000000080001cdc <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001cdc:	1101                	addi	sp,sp,-32
    80001cde:	ec06                	sd	ra,24(sp)
    80001ce0:	e822                	sd	s0,16(sp)
    80001ce2:	e426                	sd	s1,8(sp)
    80001ce4:	1000                	addi	s0,sp,32
    80001ce6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001ce8:	f0bff0ef          	jal	80001bf2 <argraw>
    80001cec:	c088                	sw	a0,0(s1)
}
    80001cee:	60e2                	ld	ra,24(sp)
    80001cf0:	6442                	ld	s0,16(sp)
    80001cf2:	64a2                	ld	s1,8(sp)
    80001cf4:	6105                	addi	sp,sp,32
    80001cf6:	8082                	ret

0000000080001cf8 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001cf8:	1101                	addi	sp,sp,-32
    80001cfa:	ec06                	sd	ra,24(sp)
    80001cfc:	e822                	sd	s0,16(sp)
    80001cfe:	e426                	sd	s1,8(sp)
    80001d00:	1000                	addi	s0,sp,32
    80001d02:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001d04:	eefff0ef          	jal	80001bf2 <argraw>
    80001d08:	e088                	sd	a0,0(s1)
}
    80001d0a:	60e2                	ld	ra,24(sp)
    80001d0c:	6442                	ld	s0,16(sp)
    80001d0e:	64a2                	ld	s1,8(sp)
    80001d10:	6105                	addi	sp,sp,32
    80001d12:	8082                	ret

0000000080001d14 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001d14:	7179                	addi	sp,sp,-48
    80001d16:	f406                	sd	ra,40(sp)
    80001d18:	f022                	sd	s0,32(sp)
    80001d1a:	ec26                	sd	s1,24(sp)
    80001d1c:	e84a                	sd	s2,16(sp)
    80001d1e:	1800                	addi	s0,sp,48
    80001d20:	84ae                	mv	s1,a1
    80001d22:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001d24:	fd840593          	addi	a1,s0,-40
    80001d28:	fd1ff0ef          	jal	80001cf8 <argaddr>
  return fetchstr(addr, buf, max);
    80001d2c:	864a                	mv	a2,s2
    80001d2e:	85a6                	mv	a1,s1
    80001d30:	fd843503          	ld	a0,-40(s0)
    80001d34:	f69ff0ef          	jal	80001c9c <fetchstr>
}
    80001d38:	70a2                	ld	ra,40(sp)
    80001d3a:	7402                	ld	s0,32(sp)
    80001d3c:	64e2                	ld	s1,24(sp)
    80001d3e:	6942                	ld	s2,16(sp)
    80001d40:	6145                	addi	sp,sp,48
    80001d42:	8082                	ret

0000000080001d44 <syscall>:



void
syscall(void)
{
    80001d44:	1101                	addi	sp,sp,-32
    80001d46:	ec06                	sd	ra,24(sp)
    80001d48:	e822                	sd	s0,16(sp)
    80001d4a:	e426                	sd	s1,8(sp)
    80001d4c:	e04a                	sd	s2,0(sp)
    80001d4e:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001d50:	850ff0ef          	jal	80000da0 <myproc>
    80001d54:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001d56:	05853903          	ld	s2,88(a0)
    80001d5a:	0a893783          	ld	a5,168(s2)
    80001d5e:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001d62:	37fd                	addiw	a5,a5,-1
    80001d64:	02100713          	li	a4,33
    80001d68:	00f76f63          	bltu	a4,a5,80001d86 <syscall+0x42>
    80001d6c:	00369713          	slli	a4,a3,0x3
    80001d70:	00006797          	auipc	a5,0x6
    80001d74:	a5878793          	addi	a5,a5,-1448 # 800077c8 <syscalls>
    80001d78:	97ba                	add	a5,a5,a4
    80001d7a:	639c                	ld	a5,0(a5)
    80001d7c:	c789                	beqz	a5,80001d86 <syscall+0x42>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001d7e:	9782                	jalr	a5
    80001d80:	06a93823          	sd	a0,112(s2)
    80001d84:	a829                	j	80001d9e <syscall+0x5a>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001d86:	16048613          	addi	a2,s1,352
    80001d8a:	588c                	lw	a1,48(s1)
    80001d8c:	00005517          	auipc	a0,0x5
    80001d90:	63450513          	addi	a0,a0,1588 # 800073c0 <etext+0x3c0>
    80001d94:	4ac030ef          	jal	80005240 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001d98:	6cbc                	ld	a5,88(s1)
    80001d9a:	577d                	li	a4,-1
    80001d9c:	fbb8                	sd	a4,112(a5)
  }
}
    80001d9e:	60e2                	ld	ra,24(sp)
    80001da0:	6442                	ld	s0,16(sp)
    80001da2:	64a2                	ld	s1,8(sp)
    80001da4:	6902                	ld	s2,0(sp)
    80001da6:	6105                	addi	sp,sp,32
    80001da8:	8082                	ret

0000000080001daa <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80001daa:	1101                	addi	sp,sp,-32
    80001dac:	ec06                	sd	ra,24(sp)
    80001dae:	e822                	sd	s0,16(sp)
    80001db0:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001db2:	fec40593          	addi	a1,s0,-20
    80001db6:	4501                	li	a0,0
    80001db8:	f25ff0ef          	jal	80001cdc <argint>
  exit(n);
    80001dbc:	fec42503          	lw	a0,-20(s0)
    80001dc0:	f42ff0ef          	jal	80001502 <exit>
  return 0;  // not reached
}
    80001dc4:	4501                	li	a0,0
    80001dc6:	60e2                	ld	ra,24(sp)
    80001dc8:	6442                	ld	s0,16(sp)
    80001dca:	6105                	addi	sp,sp,32
    80001dcc:	8082                	ret

0000000080001dce <sys_getpid>:

uint64
sys_getpid(void)
{
    80001dce:	1141                	addi	sp,sp,-16
    80001dd0:	e406                	sd	ra,8(sp)
    80001dd2:	e022                	sd	s0,0(sp)
    80001dd4:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001dd6:	fcbfe0ef          	jal	80000da0 <myproc>
}
    80001dda:	5908                	lw	a0,48(a0)
    80001ddc:	60a2                	ld	ra,8(sp)
    80001dde:	6402                	ld	s0,0(sp)
    80001de0:	0141                	addi	sp,sp,16
    80001de2:	8082                	ret

0000000080001de4 <sys_fork>:

uint64
sys_fork(void)
{
    80001de4:	1141                	addi	sp,sp,-16
    80001de6:	e406                	sd	ra,8(sp)
    80001de8:	e022                	sd	s0,0(sp)
    80001dea:	0800                	addi	s0,sp,16
  return fork();
    80001dec:	b62ff0ef          	jal	8000114e <fork>
}
    80001df0:	60a2                	ld	ra,8(sp)
    80001df2:	6402                	ld	s0,0(sp)
    80001df4:	0141                	addi	sp,sp,16
    80001df6:	8082                	ret

0000000080001df8 <sys_wait>:

uint64
sys_wait(void)
{
    80001df8:	1101                	addi	sp,sp,-32
    80001dfa:	ec06                	sd	ra,24(sp)
    80001dfc:	e822                	sd	s0,16(sp)
    80001dfe:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001e00:	fe840593          	addi	a1,s0,-24
    80001e04:	4501                	li	a0,0
    80001e06:	ef3ff0ef          	jal	80001cf8 <argaddr>
  return wait(p);
    80001e0a:	fe843503          	ld	a0,-24(s0)
    80001e0e:	84bff0ef          	jal	80001658 <wait>
}
    80001e12:	60e2                	ld	ra,24(sp)
    80001e14:	6442                	ld	s0,16(sp)
    80001e16:	6105                	addi	sp,sp,32
    80001e18:	8082                	ret

0000000080001e1a <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001e1a:	7179                	addi	sp,sp,-48
    80001e1c:	f406                	sd	ra,40(sp)
    80001e1e:	f022                	sd	s0,32(sp)
    80001e20:	ec26                	sd	s1,24(sp)
    80001e22:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80001e24:	fdc40593          	addi	a1,s0,-36
    80001e28:	4501                	li	a0,0
    80001e2a:	eb3ff0ef          	jal	80001cdc <argint>
  addr = myproc()->sz;
    80001e2e:	f73fe0ef          	jal	80000da0 <myproc>
    80001e32:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80001e34:	fdc42503          	lw	a0,-36(s0)
    80001e38:	ac6ff0ef          	jal	800010fe <growproc>
    80001e3c:	00054863          	bltz	a0,80001e4c <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80001e40:	8526                	mv	a0,s1
    80001e42:	70a2                	ld	ra,40(sp)
    80001e44:	7402                	ld	s0,32(sp)
    80001e46:	64e2                	ld	s1,24(sp)
    80001e48:	6145                	addi	sp,sp,48
    80001e4a:	8082                	ret
    return -1;
    80001e4c:	54fd                	li	s1,-1
    80001e4e:	bfcd                	j	80001e40 <sys_sbrk+0x26>

0000000080001e50 <sys_sleep>:

uint64
sys_sleep(void)
{
    80001e50:	7139                	addi	sp,sp,-64
    80001e52:	fc06                	sd	ra,56(sp)
    80001e54:	f822                	sd	s0,48(sp)
    80001e56:	f04a                	sd	s2,32(sp)
    80001e58:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  argint(0, &n);
    80001e5a:	fcc40593          	addi	a1,s0,-52
    80001e5e:	4501                	li	a0,0
    80001e60:	e7dff0ef          	jal	80001cdc <argint>
  if(n < 0)
    80001e64:	fcc42783          	lw	a5,-52(s0)
    80001e68:	0607c763          	bltz	a5,80001ed6 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80001e6c:	0000e517          	auipc	a0,0xe
    80001e70:	50450513          	addi	a0,a0,1284 # 80010370 <tickslock>
    80001e74:	1cd030ef          	jal	80005840 <acquire>
  ticks0 = ticks;
    80001e78:	00008917          	auipc	s2,0x8
    80001e7c:	49092903          	lw	s2,1168(s2) # 8000a308 <ticks>
  while(ticks - ticks0 < n){
    80001e80:	fcc42783          	lw	a5,-52(s0)
    80001e84:	cf8d                	beqz	a5,80001ebe <sys_sleep+0x6e>
    80001e86:	f426                	sd	s1,40(sp)
    80001e88:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001e8a:	0000e997          	auipc	s3,0xe
    80001e8e:	4e698993          	addi	s3,s3,1254 # 80010370 <tickslock>
    80001e92:	00008497          	auipc	s1,0x8
    80001e96:	47648493          	addi	s1,s1,1142 # 8000a308 <ticks>
    if(killed(myproc())){
    80001e9a:	f07fe0ef          	jal	80000da0 <myproc>
    80001e9e:	f90ff0ef          	jal	8000162e <killed>
    80001ea2:	ed0d                	bnez	a0,80001edc <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80001ea4:	85ce                	mv	a1,s3
    80001ea6:	8526                	mv	a0,s1
    80001ea8:	d4eff0ef          	jal	800013f6 <sleep>
  while(ticks - ticks0 < n){
    80001eac:	409c                	lw	a5,0(s1)
    80001eae:	412787bb          	subw	a5,a5,s2
    80001eb2:	fcc42703          	lw	a4,-52(s0)
    80001eb6:	fee7e2e3          	bltu	a5,a4,80001e9a <sys_sleep+0x4a>
    80001eba:	74a2                	ld	s1,40(sp)
    80001ebc:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80001ebe:	0000e517          	auipc	a0,0xe
    80001ec2:	4b250513          	addi	a0,a0,1202 # 80010370 <tickslock>
    80001ec6:	213030ef          	jal	800058d8 <release>
  return 0;
    80001eca:	4501                	li	a0,0
}
    80001ecc:	70e2                	ld	ra,56(sp)
    80001ece:	7442                	ld	s0,48(sp)
    80001ed0:	7902                	ld	s2,32(sp)
    80001ed2:	6121                	addi	sp,sp,64
    80001ed4:	8082                	ret
    n = 0;
    80001ed6:	fc042623          	sw	zero,-52(s0)
    80001eda:	bf49                	j	80001e6c <sys_sleep+0x1c>
      release(&tickslock);
    80001edc:	0000e517          	auipc	a0,0xe
    80001ee0:	49450513          	addi	a0,a0,1172 # 80010370 <tickslock>
    80001ee4:	1f5030ef          	jal	800058d8 <release>
      return -1;
    80001ee8:	557d                	li	a0,-1
    80001eea:	74a2                	ld	s1,40(sp)
    80001eec:	69e2                	ld	s3,24(sp)
    80001eee:	bff9                	j	80001ecc <sys_sleep+0x7c>

0000000080001ef0 <sys_pgpte>:


#ifdef LAB_PGTBL
int
sys_pgpte(void)
{
    80001ef0:	7179                	addi	sp,sp,-48
    80001ef2:	f406                	sd	ra,40(sp)
    80001ef4:	f022                	sd	s0,32(sp)
    80001ef6:	ec26                	sd	s1,24(sp)
    80001ef8:	1800                	addi	s0,sp,48
  uint64 va;
  struct proc *p;  

  p = myproc();
    80001efa:	ea7fe0ef          	jal	80000da0 <myproc>
    80001efe:	84aa                	mv	s1,a0
  argaddr(0, &va);
    80001f00:	fd840593          	addi	a1,s0,-40
    80001f04:	4501                	li	a0,0
    80001f06:	df3ff0ef          	jal	80001cf8 <argaddr>
  pte_t *pte = pgpte(p->pagetable, va);
    80001f0a:	fd843583          	ld	a1,-40(s0)
    80001f0e:	68a8                	ld	a0,80(s1)
    80001f10:	d05fe0ef          	jal	80000c14 <pgpte>
    80001f14:	87aa                	mv	a5,a0
  if(pte != 0) {
      return (uint64) *pte;
  }
  return 0;
    80001f16:	4501                	li	a0,0
  if(pte != 0) {
    80001f18:	c391                	beqz	a5,80001f1c <sys_pgpte+0x2c>
      return (uint64) *pte;
    80001f1a:	4388                	lw	a0,0(a5)
}
    80001f1c:	70a2                	ld	ra,40(sp)
    80001f1e:	7402                	ld	s0,32(sp)
    80001f20:	64e2                	ld	s1,24(sp)
    80001f22:	6145                	addi	sp,sp,48
    80001f24:	8082                	ret

0000000080001f26 <sys_kpgtbl>:
#endif

#ifdef LAB_PGTBL
int
sys_kpgtbl(void)
{
    80001f26:	1141                	addi	sp,sp,-16
    80001f28:	e406                	sd	ra,8(sp)
    80001f2a:	e022                	sd	s0,0(sp)
    80001f2c:	0800                	addi	s0,sp,16
  struct proc *p;  

  p = myproc();
    80001f2e:	e73fe0ef          	jal	80000da0 <myproc>
  vmprint(p->pagetable);
    80001f32:	6928                	ld	a0,80(a0)
    80001f34:	cd5fe0ef          	jal	80000c08 <vmprint>
  return 0;
}
    80001f38:	4501                	li	a0,0
    80001f3a:	60a2                	ld	ra,8(sp)
    80001f3c:	6402                	ld	s0,0(sp)
    80001f3e:	0141                	addi	sp,sp,16
    80001f40:	8082                	ret

0000000080001f42 <sys_kill>:
#endif


uint64
sys_kill(void)
{
    80001f42:	1101                	addi	sp,sp,-32
    80001f44:	ec06                	sd	ra,24(sp)
    80001f46:	e822                	sd	s0,16(sp)
    80001f48:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001f4a:	fec40593          	addi	a1,s0,-20
    80001f4e:	4501                	li	a0,0
    80001f50:	d8dff0ef          	jal	80001cdc <argint>
  return kill(pid);
    80001f54:	fec42503          	lw	a0,-20(s0)
    80001f58:	e4cff0ef          	jal	800015a4 <kill>
}
    80001f5c:	60e2                	ld	ra,24(sp)
    80001f5e:	6442                	ld	s0,16(sp)
    80001f60:	6105                	addi	sp,sp,32
    80001f62:	8082                	ret

0000000080001f64 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001f64:	1101                	addi	sp,sp,-32
    80001f66:	ec06                	sd	ra,24(sp)
    80001f68:	e822                	sd	s0,16(sp)
    80001f6a:	e426                	sd	s1,8(sp)
    80001f6c:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001f6e:	0000e517          	auipc	a0,0xe
    80001f72:	40250513          	addi	a0,a0,1026 # 80010370 <tickslock>
    80001f76:	0cb030ef          	jal	80005840 <acquire>
  xticks = ticks;
    80001f7a:	00008497          	auipc	s1,0x8
    80001f7e:	38e4a483          	lw	s1,910(s1) # 8000a308 <ticks>
  release(&tickslock);
    80001f82:	0000e517          	auipc	a0,0xe
    80001f86:	3ee50513          	addi	a0,a0,1006 # 80010370 <tickslock>
    80001f8a:	14f030ef          	jal	800058d8 <release>
  return xticks;
}
    80001f8e:	02049513          	slli	a0,s1,0x20
    80001f92:	9101                	srli	a0,a0,0x20
    80001f94:	60e2                	ld	ra,24(sp)
    80001f96:	6442                	ld	s0,16(sp)
    80001f98:	64a2                	ld	s1,8(sp)
    80001f9a:	6105                	addi	sp,sp,32
    80001f9c:	8082                	ret

0000000080001f9e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80001f9e:	7179                	addi	sp,sp,-48
    80001fa0:	f406                	sd	ra,40(sp)
    80001fa2:	f022                	sd	s0,32(sp)
    80001fa4:	ec26                	sd	s1,24(sp)
    80001fa6:	e84a                	sd	s2,16(sp)
    80001fa8:	e44e                	sd	s3,8(sp)
    80001faa:	e052                	sd	s4,0(sp)
    80001fac:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80001fae:	00005597          	auipc	a1,0x5
    80001fb2:	43258593          	addi	a1,a1,1074 # 800073e0 <etext+0x3e0>
    80001fb6:	0000e517          	auipc	a0,0xe
    80001fba:	3d250513          	addi	a0,a0,978 # 80010388 <bcache>
    80001fbe:	003030ef          	jal	800057c0 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80001fc2:	00016797          	auipc	a5,0x16
    80001fc6:	3c678793          	addi	a5,a5,966 # 80018388 <bcache+0x8000>
    80001fca:	00016717          	auipc	a4,0x16
    80001fce:	62670713          	addi	a4,a4,1574 # 800185f0 <bcache+0x8268>
    80001fd2:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80001fd6:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001fda:	0000e497          	auipc	s1,0xe
    80001fde:	3c648493          	addi	s1,s1,966 # 800103a0 <bcache+0x18>
    b->next = bcache.head.next;
    80001fe2:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80001fe4:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80001fe6:	00005a17          	auipc	s4,0x5
    80001fea:	402a0a13          	addi	s4,s4,1026 # 800073e8 <etext+0x3e8>
    b->next = bcache.head.next;
    80001fee:	2b893783          	ld	a5,696(s2)
    80001ff2:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80001ff4:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80001ff8:	85d2                	mv	a1,s4
    80001ffa:	01048513          	addi	a0,s1,16
    80001ffe:	248010ef          	jal	80003246 <initsleeplock>
    bcache.head.next->prev = b;
    80002002:	2b893783          	ld	a5,696(s2)
    80002006:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002008:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000200c:	45848493          	addi	s1,s1,1112
    80002010:	fd349fe3          	bne	s1,s3,80001fee <binit+0x50>
  }
}
    80002014:	70a2                	ld	ra,40(sp)
    80002016:	7402                	ld	s0,32(sp)
    80002018:	64e2                	ld	s1,24(sp)
    8000201a:	6942                	ld	s2,16(sp)
    8000201c:	69a2                	ld	s3,8(sp)
    8000201e:	6a02                	ld	s4,0(sp)
    80002020:	6145                	addi	sp,sp,48
    80002022:	8082                	ret

0000000080002024 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002024:	7179                	addi	sp,sp,-48
    80002026:	f406                	sd	ra,40(sp)
    80002028:	f022                	sd	s0,32(sp)
    8000202a:	ec26                	sd	s1,24(sp)
    8000202c:	e84a                	sd	s2,16(sp)
    8000202e:	e44e                	sd	s3,8(sp)
    80002030:	1800                	addi	s0,sp,48
    80002032:	892a                	mv	s2,a0
    80002034:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002036:	0000e517          	auipc	a0,0xe
    8000203a:	35250513          	addi	a0,a0,850 # 80010388 <bcache>
    8000203e:	003030ef          	jal	80005840 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002042:	00016497          	auipc	s1,0x16
    80002046:	5fe4b483          	ld	s1,1534(s1) # 80018640 <bcache+0x82b8>
    8000204a:	00016797          	auipc	a5,0x16
    8000204e:	5a678793          	addi	a5,a5,1446 # 800185f0 <bcache+0x8268>
    80002052:	02f48b63          	beq	s1,a5,80002088 <bread+0x64>
    80002056:	873e                	mv	a4,a5
    80002058:	a021                	j	80002060 <bread+0x3c>
    8000205a:	68a4                	ld	s1,80(s1)
    8000205c:	02e48663          	beq	s1,a4,80002088 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002060:	449c                	lw	a5,8(s1)
    80002062:	ff279ce3          	bne	a5,s2,8000205a <bread+0x36>
    80002066:	44dc                	lw	a5,12(s1)
    80002068:	ff3799e3          	bne	a5,s3,8000205a <bread+0x36>
      b->refcnt++;
    8000206c:	40bc                	lw	a5,64(s1)
    8000206e:	2785                	addiw	a5,a5,1
    80002070:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002072:	0000e517          	auipc	a0,0xe
    80002076:	31650513          	addi	a0,a0,790 # 80010388 <bcache>
    8000207a:	05f030ef          	jal	800058d8 <release>
      acquiresleep(&b->lock);
    8000207e:	01048513          	addi	a0,s1,16
    80002082:	1fa010ef          	jal	8000327c <acquiresleep>
      return b;
    80002086:	a889                	j	800020d8 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002088:	00016497          	auipc	s1,0x16
    8000208c:	5b04b483          	ld	s1,1456(s1) # 80018638 <bcache+0x82b0>
    80002090:	00016797          	auipc	a5,0x16
    80002094:	56078793          	addi	a5,a5,1376 # 800185f0 <bcache+0x8268>
    80002098:	00f48863          	beq	s1,a5,800020a8 <bread+0x84>
    8000209c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000209e:	40bc                	lw	a5,64(s1)
    800020a0:	cb91                	beqz	a5,800020b4 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800020a2:	64a4                	ld	s1,72(s1)
    800020a4:	fee49de3          	bne	s1,a4,8000209e <bread+0x7a>
  panic("bget: no buffers");
    800020a8:	00005517          	auipc	a0,0x5
    800020ac:	34850513          	addi	a0,a0,840 # 800073f0 <etext+0x3f0>
    800020b0:	462030ef          	jal	80005512 <panic>
      b->dev = dev;
    800020b4:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800020b8:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800020bc:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800020c0:	4785                	li	a5,1
    800020c2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800020c4:	0000e517          	auipc	a0,0xe
    800020c8:	2c450513          	addi	a0,a0,708 # 80010388 <bcache>
    800020cc:	00d030ef          	jal	800058d8 <release>
      acquiresleep(&b->lock);
    800020d0:	01048513          	addi	a0,s1,16
    800020d4:	1a8010ef          	jal	8000327c <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800020d8:	409c                	lw	a5,0(s1)
    800020da:	cb89                	beqz	a5,800020ec <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800020dc:	8526                	mv	a0,s1
    800020de:	70a2                	ld	ra,40(sp)
    800020e0:	7402                	ld	s0,32(sp)
    800020e2:	64e2                	ld	s1,24(sp)
    800020e4:	6942                	ld	s2,16(sp)
    800020e6:	69a2                	ld	s3,8(sp)
    800020e8:	6145                	addi	sp,sp,48
    800020ea:	8082                	ret
    virtio_disk_rw(b, 0);
    800020ec:	4581                	li	a1,0
    800020ee:	8526                	mv	a0,s1
    800020f0:	1f1020ef          	jal	80004ae0 <virtio_disk_rw>
    b->valid = 1;
    800020f4:	4785                	li	a5,1
    800020f6:	c09c                	sw	a5,0(s1)
  return b;
    800020f8:	b7d5                	j	800020dc <bread+0xb8>

00000000800020fa <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800020fa:	1101                	addi	sp,sp,-32
    800020fc:	ec06                	sd	ra,24(sp)
    800020fe:	e822                	sd	s0,16(sp)
    80002100:	e426                	sd	s1,8(sp)
    80002102:	1000                	addi	s0,sp,32
    80002104:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002106:	0541                	addi	a0,a0,16
    80002108:	1f2010ef          	jal	800032fa <holdingsleep>
    8000210c:	c911                	beqz	a0,80002120 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000210e:	4585                	li	a1,1
    80002110:	8526                	mv	a0,s1
    80002112:	1cf020ef          	jal	80004ae0 <virtio_disk_rw>
}
    80002116:	60e2                	ld	ra,24(sp)
    80002118:	6442                	ld	s0,16(sp)
    8000211a:	64a2                	ld	s1,8(sp)
    8000211c:	6105                	addi	sp,sp,32
    8000211e:	8082                	ret
    panic("bwrite");
    80002120:	00005517          	auipc	a0,0x5
    80002124:	2e850513          	addi	a0,a0,744 # 80007408 <etext+0x408>
    80002128:	3ea030ef          	jal	80005512 <panic>

000000008000212c <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000212c:	1101                	addi	sp,sp,-32
    8000212e:	ec06                	sd	ra,24(sp)
    80002130:	e822                	sd	s0,16(sp)
    80002132:	e426                	sd	s1,8(sp)
    80002134:	e04a                	sd	s2,0(sp)
    80002136:	1000                	addi	s0,sp,32
    80002138:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000213a:	01050913          	addi	s2,a0,16
    8000213e:	854a                	mv	a0,s2
    80002140:	1ba010ef          	jal	800032fa <holdingsleep>
    80002144:	c135                	beqz	a0,800021a8 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    80002146:	854a                	mv	a0,s2
    80002148:	17a010ef          	jal	800032c2 <releasesleep>

  acquire(&bcache.lock);
    8000214c:	0000e517          	auipc	a0,0xe
    80002150:	23c50513          	addi	a0,a0,572 # 80010388 <bcache>
    80002154:	6ec030ef          	jal	80005840 <acquire>
  b->refcnt--;
    80002158:	40bc                	lw	a5,64(s1)
    8000215a:	37fd                	addiw	a5,a5,-1
    8000215c:	0007871b          	sext.w	a4,a5
    80002160:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002162:	e71d                	bnez	a4,80002190 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002164:	68b8                	ld	a4,80(s1)
    80002166:	64bc                	ld	a5,72(s1)
    80002168:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    8000216a:	68b8                	ld	a4,80(s1)
    8000216c:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000216e:	00016797          	auipc	a5,0x16
    80002172:	21a78793          	addi	a5,a5,538 # 80018388 <bcache+0x8000>
    80002176:	2b87b703          	ld	a4,696(a5)
    8000217a:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000217c:	00016717          	auipc	a4,0x16
    80002180:	47470713          	addi	a4,a4,1140 # 800185f0 <bcache+0x8268>
    80002184:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002186:	2b87b703          	ld	a4,696(a5)
    8000218a:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000218c:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002190:	0000e517          	auipc	a0,0xe
    80002194:	1f850513          	addi	a0,a0,504 # 80010388 <bcache>
    80002198:	740030ef          	jal	800058d8 <release>
}
    8000219c:	60e2                	ld	ra,24(sp)
    8000219e:	6442                	ld	s0,16(sp)
    800021a0:	64a2                	ld	s1,8(sp)
    800021a2:	6902                	ld	s2,0(sp)
    800021a4:	6105                	addi	sp,sp,32
    800021a6:	8082                	ret
    panic("brelse");
    800021a8:	00005517          	auipc	a0,0x5
    800021ac:	26850513          	addi	a0,a0,616 # 80007410 <etext+0x410>
    800021b0:	362030ef          	jal	80005512 <panic>

00000000800021b4 <bpin>:

void
bpin(struct buf *b) {
    800021b4:	1101                	addi	sp,sp,-32
    800021b6:	ec06                	sd	ra,24(sp)
    800021b8:	e822                	sd	s0,16(sp)
    800021ba:	e426                	sd	s1,8(sp)
    800021bc:	1000                	addi	s0,sp,32
    800021be:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800021c0:	0000e517          	auipc	a0,0xe
    800021c4:	1c850513          	addi	a0,a0,456 # 80010388 <bcache>
    800021c8:	678030ef          	jal	80005840 <acquire>
  b->refcnt++;
    800021cc:	40bc                	lw	a5,64(s1)
    800021ce:	2785                	addiw	a5,a5,1
    800021d0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800021d2:	0000e517          	auipc	a0,0xe
    800021d6:	1b650513          	addi	a0,a0,438 # 80010388 <bcache>
    800021da:	6fe030ef          	jal	800058d8 <release>
}
    800021de:	60e2                	ld	ra,24(sp)
    800021e0:	6442                	ld	s0,16(sp)
    800021e2:	64a2                	ld	s1,8(sp)
    800021e4:	6105                	addi	sp,sp,32
    800021e6:	8082                	ret

00000000800021e8 <bunpin>:

void
bunpin(struct buf *b) {
    800021e8:	1101                	addi	sp,sp,-32
    800021ea:	ec06                	sd	ra,24(sp)
    800021ec:	e822                	sd	s0,16(sp)
    800021ee:	e426                	sd	s1,8(sp)
    800021f0:	1000                	addi	s0,sp,32
    800021f2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800021f4:	0000e517          	auipc	a0,0xe
    800021f8:	19450513          	addi	a0,a0,404 # 80010388 <bcache>
    800021fc:	644030ef          	jal	80005840 <acquire>
  b->refcnt--;
    80002200:	40bc                	lw	a5,64(s1)
    80002202:	37fd                	addiw	a5,a5,-1
    80002204:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002206:	0000e517          	auipc	a0,0xe
    8000220a:	18250513          	addi	a0,a0,386 # 80010388 <bcache>
    8000220e:	6ca030ef          	jal	800058d8 <release>
}
    80002212:	60e2                	ld	ra,24(sp)
    80002214:	6442                	ld	s0,16(sp)
    80002216:	64a2                	ld	s1,8(sp)
    80002218:	6105                	addi	sp,sp,32
    8000221a:	8082                	ret

000000008000221c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000221c:	1101                	addi	sp,sp,-32
    8000221e:	ec06                	sd	ra,24(sp)
    80002220:	e822                	sd	s0,16(sp)
    80002222:	e426                	sd	s1,8(sp)
    80002224:	e04a                	sd	s2,0(sp)
    80002226:	1000                	addi	s0,sp,32
    80002228:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000222a:	00d5d59b          	srliw	a1,a1,0xd
    8000222e:	00017797          	auipc	a5,0x17
    80002232:	8367a783          	lw	a5,-1994(a5) # 80018a64 <sb+0x1c>
    80002236:	9dbd                	addw	a1,a1,a5
    80002238:	dedff0ef          	jal	80002024 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000223c:	0074f713          	andi	a4,s1,7
    80002240:	4785                	li	a5,1
    80002242:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002246:	14ce                	slli	s1,s1,0x33
    80002248:	90d9                	srli	s1,s1,0x36
    8000224a:	00950733          	add	a4,a0,s1
    8000224e:	05874703          	lbu	a4,88(a4)
    80002252:	00e7f6b3          	and	a3,a5,a4
    80002256:	c29d                	beqz	a3,8000227c <bfree+0x60>
    80002258:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000225a:	94aa                	add	s1,s1,a0
    8000225c:	fff7c793          	not	a5,a5
    80002260:	8f7d                	and	a4,a4,a5
    80002262:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002266:	711000ef          	jal	80003176 <log_write>
  brelse(bp);
    8000226a:	854a                	mv	a0,s2
    8000226c:	ec1ff0ef          	jal	8000212c <brelse>
}
    80002270:	60e2                	ld	ra,24(sp)
    80002272:	6442                	ld	s0,16(sp)
    80002274:	64a2                	ld	s1,8(sp)
    80002276:	6902                	ld	s2,0(sp)
    80002278:	6105                	addi	sp,sp,32
    8000227a:	8082                	ret
    panic("freeing free block");
    8000227c:	00005517          	auipc	a0,0x5
    80002280:	19c50513          	addi	a0,a0,412 # 80007418 <etext+0x418>
    80002284:	28e030ef          	jal	80005512 <panic>

0000000080002288 <balloc>:
{
    80002288:	711d                	addi	sp,sp,-96
    8000228a:	ec86                	sd	ra,88(sp)
    8000228c:	e8a2                	sd	s0,80(sp)
    8000228e:	e4a6                	sd	s1,72(sp)
    80002290:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002292:	00016797          	auipc	a5,0x16
    80002296:	7ba7a783          	lw	a5,1978(a5) # 80018a4c <sb+0x4>
    8000229a:	0e078f63          	beqz	a5,80002398 <balloc+0x110>
    8000229e:	e0ca                	sd	s2,64(sp)
    800022a0:	fc4e                	sd	s3,56(sp)
    800022a2:	f852                	sd	s4,48(sp)
    800022a4:	f456                	sd	s5,40(sp)
    800022a6:	f05a                	sd	s6,32(sp)
    800022a8:	ec5e                	sd	s7,24(sp)
    800022aa:	e862                	sd	s8,16(sp)
    800022ac:	e466                	sd	s9,8(sp)
    800022ae:	8baa                	mv	s7,a0
    800022b0:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800022b2:	00016b17          	auipc	s6,0x16
    800022b6:	796b0b13          	addi	s6,s6,1942 # 80018a48 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800022ba:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800022bc:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800022be:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800022c0:	6c89                	lui	s9,0x2
    800022c2:	a0b5                	j	8000232e <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    800022c4:	97ca                	add	a5,a5,s2
    800022c6:	8e55                	or	a2,a2,a3
    800022c8:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800022cc:	854a                	mv	a0,s2
    800022ce:	6a9000ef          	jal	80003176 <log_write>
        brelse(bp);
    800022d2:	854a                	mv	a0,s2
    800022d4:	e59ff0ef          	jal	8000212c <brelse>
  bp = bread(dev, bno);
    800022d8:	85a6                	mv	a1,s1
    800022da:	855e                	mv	a0,s7
    800022dc:	d49ff0ef          	jal	80002024 <bread>
    800022e0:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800022e2:	40000613          	li	a2,1024
    800022e6:	4581                	li	a1,0
    800022e8:	05850513          	addi	a0,a0,88
    800022ec:	e63fd0ef          	jal	8000014e <memset>
  log_write(bp);
    800022f0:	854a                	mv	a0,s2
    800022f2:	685000ef          	jal	80003176 <log_write>
  brelse(bp);
    800022f6:	854a                	mv	a0,s2
    800022f8:	e35ff0ef          	jal	8000212c <brelse>
}
    800022fc:	6906                	ld	s2,64(sp)
    800022fe:	79e2                	ld	s3,56(sp)
    80002300:	7a42                	ld	s4,48(sp)
    80002302:	7aa2                	ld	s5,40(sp)
    80002304:	7b02                	ld	s6,32(sp)
    80002306:	6be2                	ld	s7,24(sp)
    80002308:	6c42                	ld	s8,16(sp)
    8000230a:	6ca2                	ld	s9,8(sp)
}
    8000230c:	8526                	mv	a0,s1
    8000230e:	60e6                	ld	ra,88(sp)
    80002310:	6446                	ld	s0,80(sp)
    80002312:	64a6                	ld	s1,72(sp)
    80002314:	6125                	addi	sp,sp,96
    80002316:	8082                	ret
    brelse(bp);
    80002318:	854a                	mv	a0,s2
    8000231a:	e13ff0ef          	jal	8000212c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000231e:	015c87bb          	addw	a5,s9,s5
    80002322:	00078a9b          	sext.w	s5,a5
    80002326:	004b2703          	lw	a4,4(s6)
    8000232a:	04eaff63          	bgeu	s5,a4,80002388 <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    8000232e:	41fad79b          	sraiw	a5,s5,0x1f
    80002332:	0137d79b          	srliw	a5,a5,0x13
    80002336:	015787bb          	addw	a5,a5,s5
    8000233a:	40d7d79b          	sraiw	a5,a5,0xd
    8000233e:	01cb2583          	lw	a1,28(s6)
    80002342:	9dbd                	addw	a1,a1,a5
    80002344:	855e                	mv	a0,s7
    80002346:	cdfff0ef          	jal	80002024 <bread>
    8000234a:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000234c:	004b2503          	lw	a0,4(s6)
    80002350:	000a849b          	sext.w	s1,s5
    80002354:	8762                	mv	a4,s8
    80002356:	fca4f1e3          	bgeu	s1,a0,80002318 <balloc+0x90>
      m = 1 << (bi % 8);
    8000235a:	00777693          	andi	a3,a4,7
    8000235e:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002362:	41f7579b          	sraiw	a5,a4,0x1f
    80002366:	01d7d79b          	srliw	a5,a5,0x1d
    8000236a:	9fb9                	addw	a5,a5,a4
    8000236c:	4037d79b          	sraiw	a5,a5,0x3
    80002370:	00f90633          	add	a2,s2,a5
    80002374:	05864603          	lbu	a2,88(a2)
    80002378:	00c6f5b3          	and	a1,a3,a2
    8000237c:	d5a1                	beqz	a1,800022c4 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000237e:	2705                	addiw	a4,a4,1
    80002380:	2485                	addiw	s1,s1,1
    80002382:	fd471ae3          	bne	a4,s4,80002356 <balloc+0xce>
    80002386:	bf49                	j	80002318 <balloc+0x90>
    80002388:	6906                	ld	s2,64(sp)
    8000238a:	79e2                	ld	s3,56(sp)
    8000238c:	7a42                	ld	s4,48(sp)
    8000238e:	7aa2                	ld	s5,40(sp)
    80002390:	7b02                	ld	s6,32(sp)
    80002392:	6be2                	ld	s7,24(sp)
    80002394:	6c42                	ld	s8,16(sp)
    80002396:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80002398:	00005517          	auipc	a0,0x5
    8000239c:	09850513          	addi	a0,a0,152 # 80007430 <etext+0x430>
    800023a0:	6a1020ef          	jal	80005240 <printf>
  return 0;
    800023a4:	4481                	li	s1,0
    800023a6:	b79d                	j	8000230c <balloc+0x84>

00000000800023a8 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800023a8:	7179                	addi	sp,sp,-48
    800023aa:	f406                	sd	ra,40(sp)
    800023ac:	f022                	sd	s0,32(sp)
    800023ae:	ec26                	sd	s1,24(sp)
    800023b0:	e84a                	sd	s2,16(sp)
    800023b2:	e44e                	sd	s3,8(sp)
    800023b4:	1800                	addi	s0,sp,48
    800023b6:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800023b8:	47ad                	li	a5,11
    800023ba:	02b7e663          	bltu	a5,a1,800023e6 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    800023be:	02059793          	slli	a5,a1,0x20
    800023c2:	01e7d593          	srli	a1,a5,0x1e
    800023c6:	00b504b3          	add	s1,a0,a1
    800023ca:	0504a903          	lw	s2,80(s1)
    800023ce:	06091a63          	bnez	s2,80002442 <bmap+0x9a>
      addr = balloc(ip->dev);
    800023d2:	4108                	lw	a0,0(a0)
    800023d4:	eb5ff0ef          	jal	80002288 <balloc>
    800023d8:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800023dc:	06090363          	beqz	s2,80002442 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    800023e0:	0524a823          	sw	s2,80(s1)
    800023e4:	a8b9                	j	80002442 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    800023e6:	ff45849b          	addiw	s1,a1,-12
    800023ea:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800023ee:	0ff00793          	li	a5,255
    800023f2:	06e7ee63          	bltu	a5,a4,8000246e <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800023f6:	08052903          	lw	s2,128(a0)
    800023fa:	00091d63          	bnez	s2,80002414 <bmap+0x6c>
      addr = balloc(ip->dev);
    800023fe:	4108                	lw	a0,0(a0)
    80002400:	e89ff0ef          	jal	80002288 <balloc>
    80002404:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002408:	02090d63          	beqz	s2,80002442 <bmap+0x9a>
    8000240c:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000240e:	0929a023          	sw	s2,128(s3)
    80002412:	a011                	j	80002416 <bmap+0x6e>
    80002414:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002416:	85ca                	mv	a1,s2
    80002418:	0009a503          	lw	a0,0(s3)
    8000241c:	c09ff0ef          	jal	80002024 <bread>
    80002420:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002422:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002426:	02049713          	slli	a4,s1,0x20
    8000242a:	01e75593          	srli	a1,a4,0x1e
    8000242e:	00b784b3          	add	s1,a5,a1
    80002432:	0004a903          	lw	s2,0(s1)
    80002436:	00090e63          	beqz	s2,80002452 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000243a:	8552                	mv	a0,s4
    8000243c:	cf1ff0ef          	jal	8000212c <brelse>
    return addr;
    80002440:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002442:	854a                	mv	a0,s2
    80002444:	70a2                	ld	ra,40(sp)
    80002446:	7402                	ld	s0,32(sp)
    80002448:	64e2                	ld	s1,24(sp)
    8000244a:	6942                	ld	s2,16(sp)
    8000244c:	69a2                	ld	s3,8(sp)
    8000244e:	6145                	addi	sp,sp,48
    80002450:	8082                	ret
      addr = balloc(ip->dev);
    80002452:	0009a503          	lw	a0,0(s3)
    80002456:	e33ff0ef          	jal	80002288 <balloc>
    8000245a:	0005091b          	sext.w	s2,a0
      if(addr){
    8000245e:	fc090ee3          	beqz	s2,8000243a <bmap+0x92>
        a[bn] = addr;
    80002462:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002466:	8552                	mv	a0,s4
    80002468:	50f000ef          	jal	80003176 <log_write>
    8000246c:	b7f9                	j	8000243a <bmap+0x92>
    8000246e:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002470:	00005517          	auipc	a0,0x5
    80002474:	fd850513          	addi	a0,a0,-40 # 80007448 <etext+0x448>
    80002478:	09a030ef          	jal	80005512 <panic>

000000008000247c <iget>:
{
    8000247c:	7179                	addi	sp,sp,-48
    8000247e:	f406                	sd	ra,40(sp)
    80002480:	f022                	sd	s0,32(sp)
    80002482:	ec26                	sd	s1,24(sp)
    80002484:	e84a                	sd	s2,16(sp)
    80002486:	e44e                	sd	s3,8(sp)
    80002488:	e052                	sd	s4,0(sp)
    8000248a:	1800                	addi	s0,sp,48
    8000248c:	89aa                	mv	s3,a0
    8000248e:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002490:	00016517          	auipc	a0,0x16
    80002494:	5d850513          	addi	a0,a0,1496 # 80018a68 <itable>
    80002498:	3a8030ef          	jal	80005840 <acquire>
  empty = 0;
    8000249c:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000249e:	00016497          	auipc	s1,0x16
    800024a2:	5e248493          	addi	s1,s1,1506 # 80018a80 <itable+0x18>
    800024a6:	00018697          	auipc	a3,0x18
    800024aa:	06a68693          	addi	a3,a3,106 # 8001a510 <log>
    800024ae:	a039                	j	800024bc <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800024b0:	02090963          	beqz	s2,800024e2 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800024b4:	08848493          	addi	s1,s1,136
    800024b8:	02d48863          	beq	s1,a3,800024e8 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800024bc:	449c                	lw	a5,8(s1)
    800024be:	fef059e3          	blez	a5,800024b0 <iget+0x34>
    800024c2:	4098                	lw	a4,0(s1)
    800024c4:	ff3716e3          	bne	a4,s3,800024b0 <iget+0x34>
    800024c8:	40d8                	lw	a4,4(s1)
    800024ca:	ff4713e3          	bne	a4,s4,800024b0 <iget+0x34>
      ip->ref++;
    800024ce:	2785                	addiw	a5,a5,1
    800024d0:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800024d2:	00016517          	auipc	a0,0x16
    800024d6:	59650513          	addi	a0,a0,1430 # 80018a68 <itable>
    800024da:	3fe030ef          	jal	800058d8 <release>
      return ip;
    800024de:	8926                	mv	s2,s1
    800024e0:	a02d                	j	8000250a <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800024e2:	fbe9                	bnez	a5,800024b4 <iget+0x38>
      empty = ip;
    800024e4:	8926                	mv	s2,s1
    800024e6:	b7f9                	j	800024b4 <iget+0x38>
  if(empty == 0)
    800024e8:	02090a63          	beqz	s2,8000251c <iget+0xa0>
  ip->dev = dev;
    800024ec:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800024f0:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800024f4:	4785                	li	a5,1
    800024f6:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800024fa:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800024fe:	00016517          	auipc	a0,0x16
    80002502:	56a50513          	addi	a0,a0,1386 # 80018a68 <itable>
    80002506:	3d2030ef          	jal	800058d8 <release>
}
    8000250a:	854a                	mv	a0,s2
    8000250c:	70a2                	ld	ra,40(sp)
    8000250e:	7402                	ld	s0,32(sp)
    80002510:	64e2                	ld	s1,24(sp)
    80002512:	6942                	ld	s2,16(sp)
    80002514:	69a2                	ld	s3,8(sp)
    80002516:	6a02                	ld	s4,0(sp)
    80002518:	6145                	addi	sp,sp,48
    8000251a:	8082                	ret
    panic("iget: no inodes");
    8000251c:	00005517          	auipc	a0,0x5
    80002520:	f4450513          	addi	a0,a0,-188 # 80007460 <etext+0x460>
    80002524:	7ef020ef          	jal	80005512 <panic>

0000000080002528 <fsinit>:
fsinit(int dev) {
    80002528:	7179                	addi	sp,sp,-48
    8000252a:	f406                	sd	ra,40(sp)
    8000252c:	f022                	sd	s0,32(sp)
    8000252e:	ec26                	sd	s1,24(sp)
    80002530:	e84a                	sd	s2,16(sp)
    80002532:	e44e                	sd	s3,8(sp)
    80002534:	1800                	addi	s0,sp,48
    80002536:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002538:	4585                	li	a1,1
    8000253a:	aebff0ef          	jal	80002024 <bread>
    8000253e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002540:	00016997          	auipc	s3,0x16
    80002544:	50898993          	addi	s3,s3,1288 # 80018a48 <sb>
    80002548:	02000613          	li	a2,32
    8000254c:	05850593          	addi	a1,a0,88
    80002550:	854e                	mv	a0,s3
    80002552:	c59fd0ef          	jal	800001aa <memmove>
  brelse(bp);
    80002556:	8526                	mv	a0,s1
    80002558:	bd5ff0ef          	jal	8000212c <brelse>
  if(sb.magic != FSMAGIC)
    8000255c:	0009a703          	lw	a4,0(s3)
    80002560:	102037b7          	lui	a5,0x10203
    80002564:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002568:	02f71063          	bne	a4,a5,80002588 <fsinit+0x60>
  initlog(dev, &sb);
    8000256c:	00016597          	auipc	a1,0x16
    80002570:	4dc58593          	addi	a1,a1,1244 # 80018a48 <sb>
    80002574:	854a                	mv	a0,s2
    80002576:	1f9000ef          	jal	80002f6e <initlog>
}
    8000257a:	70a2                	ld	ra,40(sp)
    8000257c:	7402                	ld	s0,32(sp)
    8000257e:	64e2                	ld	s1,24(sp)
    80002580:	6942                	ld	s2,16(sp)
    80002582:	69a2                	ld	s3,8(sp)
    80002584:	6145                	addi	sp,sp,48
    80002586:	8082                	ret
    panic("invalid file system");
    80002588:	00005517          	auipc	a0,0x5
    8000258c:	ee850513          	addi	a0,a0,-280 # 80007470 <etext+0x470>
    80002590:	783020ef          	jal	80005512 <panic>

0000000080002594 <iinit>:
{
    80002594:	7179                	addi	sp,sp,-48
    80002596:	f406                	sd	ra,40(sp)
    80002598:	f022                	sd	s0,32(sp)
    8000259a:	ec26                	sd	s1,24(sp)
    8000259c:	e84a                	sd	s2,16(sp)
    8000259e:	e44e                	sd	s3,8(sp)
    800025a0:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800025a2:	00005597          	auipc	a1,0x5
    800025a6:	ee658593          	addi	a1,a1,-282 # 80007488 <etext+0x488>
    800025aa:	00016517          	auipc	a0,0x16
    800025ae:	4be50513          	addi	a0,a0,1214 # 80018a68 <itable>
    800025b2:	20e030ef          	jal	800057c0 <initlock>
  for(i = 0; i < NINODE; i++) {
    800025b6:	00016497          	auipc	s1,0x16
    800025ba:	4da48493          	addi	s1,s1,1242 # 80018a90 <itable+0x28>
    800025be:	00018997          	auipc	s3,0x18
    800025c2:	f6298993          	addi	s3,s3,-158 # 8001a520 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800025c6:	00005917          	auipc	s2,0x5
    800025ca:	eca90913          	addi	s2,s2,-310 # 80007490 <etext+0x490>
    800025ce:	85ca                	mv	a1,s2
    800025d0:	8526                	mv	a0,s1
    800025d2:	475000ef          	jal	80003246 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800025d6:	08848493          	addi	s1,s1,136
    800025da:	ff349ae3          	bne	s1,s3,800025ce <iinit+0x3a>
}
    800025de:	70a2                	ld	ra,40(sp)
    800025e0:	7402                	ld	s0,32(sp)
    800025e2:	64e2                	ld	s1,24(sp)
    800025e4:	6942                	ld	s2,16(sp)
    800025e6:	69a2                	ld	s3,8(sp)
    800025e8:	6145                	addi	sp,sp,48
    800025ea:	8082                	ret

00000000800025ec <ialloc>:
{
    800025ec:	7139                	addi	sp,sp,-64
    800025ee:	fc06                	sd	ra,56(sp)
    800025f0:	f822                	sd	s0,48(sp)
    800025f2:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800025f4:	00016717          	auipc	a4,0x16
    800025f8:	46072703          	lw	a4,1120(a4) # 80018a54 <sb+0xc>
    800025fc:	4785                	li	a5,1
    800025fe:	06e7f063          	bgeu	a5,a4,8000265e <ialloc+0x72>
    80002602:	f426                	sd	s1,40(sp)
    80002604:	f04a                	sd	s2,32(sp)
    80002606:	ec4e                	sd	s3,24(sp)
    80002608:	e852                	sd	s4,16(sp)
    8000260a:	e456                	sd	s5,8(sp)
    8000260c:	e05a                	sd	s6,0(sp)
    8000260e:	8aaa                	mv	s5,a0
    80002610:	8b2e                	mv	s6,a1
    80002612:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002614:	00016a17          	auipc	s4,0x16
    80002618:	434a0a13          	addi	s4,s4,1076 # 80018a48 <sb>
    8000261c:	00495593          	srli	a1,s2,0x4
    80002620:	018a2783          	lw	a5,24(s4)
    80002624:	9dbd                	addw	a1,a1,a5
    80002626:	8556                	mv	a0,s5
    80002628:	9fdff0ef          	jal	80002024 <bread>
    8000262c:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000262e:	05850993          	addi	s3,a0,88
    80002632:	00f97793          	andi	a5,s2,15
    80002636:	079a                	slli	a5,a5,0x6
    80002638:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000263a:	00099783          	lh	a5,0(s3)
    8000263e:	cb9d                	beqz	a5,80002674 <ialloc+0x88>
    brelse(bp);
    80002640:	aedff0ef          	jal	8000212c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002644:	0905                	addi	s2,s2,1
    80002646:	00ca2703          	lw	a4,12(s4)
    8000264a:	0009079b          	sext.w	a5,s2
    8000264e:	fce7e7e3          	bltu	a5,a4,8000261c <ialloc+0x30>
    80002652:	74a2                	ld	s1,40(sp)
    80002654:	7902                	ld	s2,32(sp)
    80002656:	69e2                	ld	s3,24(sp)
    80002658:	6a42                	ld	s4,16(sp)
    8000265a:	6aa2                	ld	s5,8(sp)
    8000265c:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    8000265e:	00005517          	auipc	a0,0x5
    80002662:	e3a50513          	addi	a0,a0,-454 # 80007498 <etext+0x498>
    80002666:	3db020ef          	jal	80005240 <printf>
  return 0;
    8000266a:	4501                	li	a0,0
}
    8000266c:	70e2                	ld	ra,56(sp)
    8000266e:	7442                	ld	s0,48(sp)
    80002670:	6121                	addi	sp,sp,64
    80002672:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002674:	04000613          	li	a2,64
    80002678:	4581                	li	a1,0
    8000267a:	854e                	mv	a0,s3
    8000267c:	ad3fd0ef          	jal	8000014e <memset>
      dip->type = type;
    80002680:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002684:	8526                	mv	a0,s1
    80002686:	2f1000ef          	jal	80003176 <log_write>
      brelse(bp);
    8000268a:	8526                	mv	a0,s1
    8000268c:	aa1ff0ef          	jal	8000212c <brelse>
      return iget(dev, inum);
    80002690:	0009059b          	sext.w	a1,s2
    80002694:	8556                	mv	a0,s5
    80002696:	de7ff0ef          	jal	8000247c <iget>
    8000269a:	74a2                	ld	s1,40(sp)
    8000269c:	7902                	ld	s2,32(sp)
    8000269e:	69e2                	ld	s3,24(sp)
    800026a0:	6a42                	ld	s4,16(sp)
    800026a2:	6aa2                	ld	s5,8(sp)
    800026a4:	6b02                	ld	s6,0(sp)
    800026a6:	b7d9                	j	8000266c <ialloc+0x80>

00000000800026a8 <iupdate>:
{
    800026a8:	1101                	addi	sp,sp,-32
    800026aa:	ec06                	sd	ra,24(sp)
    800026ac:	e822                	sd	s0,16(sp)
    800026ae:	e426                	sd	s1,8(sp)
    800026b0:	e04a                	sd	s2,0(sp)
    800026b2:	1000                	addi	s0,sp,32
    800026b4:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800026b6:	415c                	lw	a5,4(a0)
    800026b8:	0047d79b          	srliw	a5,a5,0x4
    800026bc:	00016597          	auipc	a1,0x16
    800026c0:	3a45a583          	lw	a1,932(a1) # 80018a60 <sb+0x18>
    800026c4:	9dbd                	addw	a1,a1,a5
    800026c6:	4108                	lw	a0,0(a0)
    800026c8:	95dff0ef          	jal	80002024 <bread>
    800026cc:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800026ce:	05850793          	addi	a5,a0,88
    800026d2:	40d8                	lw	a4,4(s1)
    800026d4:	8b3d                	andi	a4,a4,15
    800026d6:	071a                	slli	a4,a4,0x6
    800026d8:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800026da:	04449703          	lh	a4,68(s1)
    800026de:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800026e2:	04649703          	lh	a4,70(s1)
    800026e6:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800026ea:	04849703          	lh	a4,72(s1)
    800026ee:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800026f2:	04a49703          	lh	a4,74(s1)
    800026f6:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800026fa:	44f8                	lw	a4,76(s1)
    800026fc:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800026fe:	03400613          	li	a2,52
    80002702:	05048593          	addi	a1,s1,80
    80002706:	00c78513          	addi	a0,a5,12
    8000270a:	aa1fd0ef          	jal	800001aa <memmove>
  log_write(bp);
    8000270e:	854a                	mv	a0,s2
    80002710:	267000ef          	jal	80003176 <log_write>
  brelse(bp);
    80002714:	854a                	mv	a0,s2
    80002716:	a17ff0ef          	jal	8000212c <brelse>
}
    8000271a:	60e2                	ld	ra,24(sp)
    8000271c:	6442                	ld	s0,16(sp)
    8000271e:	64a2                	ld	s1,8(sp)
    80002720:	6902                	ld	s2,0(sp)
    80002722:	6105                	addi	sp,sp,32
    80002724:	8082                	ret

0000000080002726 <idup>:
{
    80002726:	1101                	addi	sp,sp,-32
    80002728:	ec06                	sd	ra,24(sp)
    8000272a:	e822                	sd	s0,16(sp)
    8000272c:	e426                	sd	s1,8(sp)
    8000272e:	1000                	addi	s0,sp,32
    80002730:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002732:	00016517          	auipc	a0,0x16
    80002736:	33650513          	addi	a0,a0,822 # 80018a68 <itable>
    8000273a:	106030ef          	jal	80005840 <acquire>
  ip->ref++;
    8000273e:	449c                	lw	a5,8(s1)
    80002740:	2785                	addiw	a5,a5,1
    80002742:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002744:	00016517          	auipc	a0,0x16
    80002748:	32450513          	addi	a0,a0,804 # 80018a68 <itable>
    8000274c:	18c030ef          	jal	800058d8 <release>
}
    80002750:	8526                	mv	a0,s1
    80002752:	60e2                	ld	ra,24(sp)
    80002754:	6442                	ld	s0,16(sp)
    80002756:	64a2                	ld	s1,8(sp)
    80002758:	6105                	addi	sp,sp,32
    8000275a:	8082                	ret

000000008000275c <ilock>:
{
    8000275c:	1101                	addi	sp,sp,-32
    8000275e:	ec06                	sd	ra,24(sp)
    80002760:	e822                	sd	s0,16(sp)
    80002762:	e426                	sd	s1,8(sp)
    80002764:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002766:	cd19                	beqz	a0,80002784 <ilock+0x28>
    80002768:	84aa                	mv	s1,a0
    8000276a:	451c                	lw	a5,8(a0)
    8000276c:	00f05c63          	blez	a5,80002784 <ilock+0x28>
  acquiresleep(&ip->lock);
    80002770:	0541                	addi	a0,a0,16
    80002772:	30b000ef          	jal	8000327c <acquiresleep>
  if(ip->valid == 0){
    80002776:	40bc                	lw	a5,64(s1)
    80002778:	cf89                	beqz	a5,80002792 <ilock+0x36>
}
    8000277a:	60e2                	ld	ra,24(sp)
    8000277c:	6442                	ld	s0,16(sp)
    8000277e:	64a2                	ld	s1,8(sp)
    80002780:	6105                	addi	sp,sp,32
    80002782:	8082                	ret
    80002784:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002786:	00005517          	auipc	a0,0x5
    8000278a:	d2a50513          	addi	a0,a0,-726 # 800074b0 <etext+0x4b0>
    8000278e:	585020ef          	jal	80005512 <panic>
    80002792:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002794:	40dc                	lw	a5,4(s1)
    80002796:	0047d79b          	srliw	a5,a5,0x4
    8000279a:	00016597          	auipc	a1,0x16
    8000279e:	2c65a583          	lw	a1,710(a1) # 80018a60 <sb+0x18>
    800027a2:	9dbd                	addw	a1,a1,a5
    800027a4:	4088                	lw	a0,0(s1)
    800027a6:	87fff0ef          	jal	80002024 <bread>
    800027aa:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800027ac:	05850593          	addi	a1,a0,88
    800027b0:	40dc                	lw	a5,4(s1)
    800027b2:	8bbd                	andi	a5,a5,15
    800027b4:	079a                	slli	a5,a5,0x6
    800027b6:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800027b8:	00059783          	lh	a5,0(a1)
    800027bc:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800027c0:	00259783          	lh	a5,2(a1)
    800027c4:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800027c8:	00459783          	lh	a5,4(a1)
    800027cc:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800027d0:	00659783          	lh	a5,6(a1)
    800027d4:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800027d8:	459c                	lw	a5,8(a1)
    800027da:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800027dc:	03400613          	li	a2,52
    800027e0:	05b1                	addi	a1,a1,12
    800027e2:	05048513          	addi	a0,s1,80
    800027e6:	9c5fd0ef          	jal	800001aa <memmove>
    brelse(bp);
    800027ea:	854a                	mv	a0,s2
    800027ec:	941ff0ef          	jal	8000212c <brelse>
    ip->valid = 1;
    800027f0:	4785                	li	a5,1
    800027f2:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800027f4:	04449783          	lh	a5,68(s1)
    800027f8:	c399                	beqz	a5,800027fe <ilock+0xa2>
    800027fa:	6902                	ld	s2,0(sp)
    800027fc:	bfbd                	j	8000277a <ilock+0x1e>
      panic("ilock: no type");
    800027fe:	00005517          	auipc	a0,0x5
    80002802:	cba50513          	addi	a0,a0,-838 # 800074b8 <etext+0x4b8>
    80002806:	50d020ef          	jal	80005512 <panic>

000000008000280a <iunlock>:
{
    8000280a:	1101                	addi	sp,sp,-32
    8000280c:	ec06                	sd	ra,24(sp)
    8000280e:	e822                	sd	s0,16(sp)
    80002810:	e426                	sd	s1,8(sp)
    80002812:	e04a                	sd	s2,0(sp)
    80002814:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002816:	c505                	beqz	a0,8000283e <iunlock+0x34>
    80002818:	84aa                	mv	s1,a0
    8000281a:	01050913          	addi	s2,a0,16
    8000281e:	854a                	mv	a0,s2
    80002820:	2db000ef          	jal	800032fa <holdingsleep>
    80002824:	cd09                	beqz	a0,8000283e <iunlock+0x34>
    80002826:	449c                	lw	a5,8(s1)
    80002828:	00f05b63          	blez	a5,8000283e <iunlock+0x34>
  releasesleep(&ip->lock);
    8000282c:	854a                	mv	a0,s2
    8000282e:	295000ef          	jal	800032c2 <releasesleep>
}
    80002832:	60e2                	ld	ra,24(sp)
    80002834:	6442                	ld	s0,16(sp)
    80002836:	64a2                	ld	s1,8(sp)
    80002838:	6902                	ld	s2,0(sp)
    8000283a:	6105                	addi	sp,sp,32
    8000283c:	8082                	ret
    panic("iunlock");
    8000283e:	00005517          	auipc	a0,0x5
    80002842:	c8a50513          	addi	a0,a0,-886 # 800074c8 <etext+0x4c8>
    80002846:	4cd020ef          	jal	80005512 <panic>

000000008000284a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000284a:	7179                	addi	sp,sp,-48
    8000284c:	f406                	sd	ra,40(sp)
    8000284e:	f022                	sd	s0,32(sp)
    80002850:	ec26                	sd	s1,24(sp)
    80002852:	e84a                	sd	s2,16(sp)
    80002854:	e44e                	sd	s3,8(sp)
    80002856:	1800                	addi	s0,sp,48
    80002858:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000285a:	05050493          	addi	s1,a0,80
    8000285e:	08050913          	addi	s2,a0,128
    80002862:	a021                	j	8000286a <itrunc+0x20>
    80002864:	0491                	addi	s1,s1,4
    80002866:	01248b63          	beq	s1,s2,8000287c <itrunc+0x32>
    if(ip->addrs[i]){
    8000286a:	408c                	lw	a1,0(s1)
    8000286c:	dde5                	beqz	a1,80002864 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    8000286e:	0009a503          	lw	a0,0(s3)
    80002872:	9abff0ef          	jal	8000221c <bfree>
      ip->addrs[i] = 0;
    80002876:	0004a023          	sw	zero,0(s1)
    8000287a:	b7ed                	j	80002864 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    8000287c:	0809a583          	lw	a1,128(s3)
    80002880:	ed89                	bnez	a1,8000289a <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002882:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002886:	854e                	mv	a0,s3
    80002888:	e21ff0ef          	jal	800026a8 <iupdate>
}
    8000288c:	70a2                	ld	ra,40(sp)
    8000288e:	7402                	ld	s0,32(sp)
    80002890:	64e2                	ld	s1,24(sp)
    80002892:	6942                	ld	s2,16(sp)
    80002894:	69a2                	ld	s3,8(sp)
    80002896:	6145                	addi	sp,sp,48
    80002898:	8082                	ret
    8000289a:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000289c:	0009a503          	lw	a0,0(s3)
    800028a0:	f84ff0ef          	jal	80002024 <bread>
    800028a4:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800028a6:	05850493          	addi	s1,a0,88
    800028aa:	45850913          	addi	s2,a0,1112
    800028ae:	a021                	j	800028b6 <itrunc+0x6c>
    800028b0:	0491                	addi	s1,s1,4
    800028b2:	01248963          	beq	s1,s2,800028c4 <itrunc+0x7a>
      if(a[j])
    800028b6:	408c                	lw	a1,0(s1)
    800028b8:	dde5                	beqz	a1,800028b0 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    800028ba:	0009a503          	lw	a0,0(s3)
    800028be:	95fff0ef          	jal	8000221c <bfree>
    800028c2:	b7fd                	j	800028b0 <itrunc+0x66>
    brelse(bp);
    800028c4:	8552                	mv	a0,s4
    800028c6:	867ff0ef          	jal	8000212c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800028ca:	0809a583          	lw	a1,128(s3)
    800028ce:	0009a503          	lw	a0,0(s3)
    800028d2:	94bff0ef          	jal	8000221c <bfree>
    ip->addrs[NDIRECT] = 0;
    800028d6:	0809a023          	sw	zero,128(s3)
    800028da:	6a02                	ld	s4,0(sp)
    800028dc:	b75d                	j	80002882 <itrunc+0x38>

00000000800028de <iput>:
{
    800028de:	1101                	addi	sp,sp,-32
    800028e0:	ec06                	sd	ra,24(sp)
    800028e2:	e822                	sd	s0,16(sp)
    800028e4:	e426                	sd	s1,8(sp)
    800028e6:	1000                	addi	s0,sp,32
    800028e8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800028ea:	00016517          	auipc	a0,0x16
    800028ee:	17e50513          	addi	a0,a0,382 # 80018a68 <itable>
    800028f2:	74f020ef          	jal	80005840 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800028f6:	4498                	lw	a4,8(s1)
    800028f8:	4785                	li	a5,1
    800028fa:	02f70063          	beq	a4,a5,8000291a <iput+0x3c>
  ip->ref--;
    800028fe:	449c                	lw	a5,8(s1)
    80002900:	37fd                	addiw	a5,a5,-1
    80002902:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002904:	00016517          	auipc	a0,0x16
    80002908:	16450513          	addi	a0,a0,356 # 80018a68 <itable>
    8000290c:	7cd020ef          	jal	800058d8 <release>
}
    80002910:	60e2                	ld	ra,24(sp)
    80002912:	6442                	ld	s0,16(sp)
    80002914:	64a2                	ld	s1,8(sp)
    80002916:	6105                	addi	sp,sp,32
    80002918:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000291a:	40bc                	lw	a5,64(s1)
    8000291c:	d3ed                	beqz	a5,800028fe <iput+0x20>
    8000291e:	04a49783          	lh	a5,74(s1)
    80002922:	fff1                	bnez	a5,800028fe <iput+0x20>
    80002924:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002926:	01048913          	addi	s2,s1,16
    8000292a:	854a                	mv	a0,s2
    8000292c:	151000ef          	jal	8000327c <acquiresleep>
    release(&itable.lock);
    80002930:	00016517          	auipc	a0,0x16
    80002934:	13850513          	addi	a0,a0,312 # 80018a68 <itable>
    80002938:	7a1020ef          	jal	800058d8 <release>
    itrunc(ip);
    8000293c:	8526                	mv	a0,s1
    8000293e:	f0dff0ef          	jal	8000284a <itrunc>
    ip->type = 0;
    80002942:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002946:	8526                	mv	a0,s1
    80002948:	d61ff0ef          	jal	800026a8 <iupdate>
    ip->valid = 0;
    8000294c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002950:	854a                	mv	a0,s2
    80002952:	171000ef          	jal	800032c2 <releasesleep>
    acquire(&itable.lock);
    80002956:	00016517          	auipc	a0,0x16
    8000295a:	11250513          	addi	a0,a0,274 # 80018a68 <itable>
    8000295e:	6e3020ef          	jal	80005840 <acquire>
    80002962:	6902                	ld	s2,0(sp)
    80002964:	bf69                	j	800028fe <iput+0x20>

0000000080002966 <iunlockput>:
{
    80002966:	1101                	addi	sp,sp,-32
    80002968:	ec06                	sd	ra,24(sp)
    8000296a:	e822                	sd	s0,16(sp)
    8000296c:	e426                	sd	s1,8(sp)
    8000296e:	1000                	addi	s0,sp,32
    80002970:	84aa                	mv	s1,a0
  iunlock(ip);
    80002972:	e99ff0ef          	jal	8000280a <iunlock>
  iput(ip);
    80002976:	8526                	mv	a0,s1
    80002978:	f67ff0ef          	jal	800028de <iput>
}
    8000297c:	60e2                	ld	ra,24(sp)
    8000297e:	6442                	ld	s0,16(sp)
    80002980:	64a2                	ld	s1,8(sp)
    80002982:	6105                	addi	sp,sp,32
    80002984:	8082                	ret

0000000080002986 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002986:	1141                	addi	sp,sp,-16
    80002988:	e422                	sd	s0,8(sp)
    8000298a:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000298c:	411c                	lw	a5,0(a0)
    8000298e:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002990:	415c                	lw	a5,4(a0)
    80002992:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002994:	04451783          	lh	a5,68(a0)
    80002998:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000299c:	04a51783          	lh	a5,74(a0)
    800029a0:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800029a4:	04c56783          	lwu	a5,76(a0)
    800029a8:	e99c                	sd	a5,16(a1)
}
    800029aa:	6422                	ld	s0,8(sp)
    800029ac:	0141                	addi	sp,sp,16
    800029ae:	8082                	ret

00000000800029b0 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800029b0:	457c                	lw	a5,76(a0)
    800029b2:	0ed7eb63          	bltu	a5,a3,80002aa8 <readi+0xf8>
{
    800029b6:	7159                	addi	sp,sp,-112
    800029b8:	f486                	sd	ra,104(sp)
    800029ba:	f0a2                	sd	s0,96(sp)
    800029bc:	eca6                	sd	s1,88(sp)
    800029be:	e0d2                	sd	s4,64(sp)
    800029c0:	fc56                	sd	s5,56(sp)
    800029c2:	f85a                	sd	s6,48(sp)
    800029c4:	f45e                	sd	s7,40(sp)
    800029c6:	1880                	addi	s0,sp,112
    800029c8:	8b2a                	mv	s6,a0
    800029ca:	8bae                	mv	s7,a1
    800029cc:	8a32                	mv	s4,a2
    800029ce:	84b6                	mv	s1,a3
    800029d0:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800029d2:	9f35                	addw	a4,a4,a3
    return 0;
    800029d4:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800029d6:	0cd76063          	bltu	a4,a3,80002a96 <readi+0xe6>
    800029da:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    800029dc:	00e7f463          	bgeu	a5,a4,800029e4 <readi+0x34>
    n = ip->size - off;
    800029e0:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800029e4:	080a8f63          	beqz	s5,80002a82 <readi+0xd2>
    800029e8:	e8ca                	sd	s2,80(sp)
    800029ea:	f062                	sd	s8,32(sp)
    800029ec:	ec66                	sd	s9,24(sp)
    800029ee:	e86a                	sd	s10,16(sp)
    800029f0:	e46e                	sd	s11,8(sp)
    800029f2:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800029f4:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800029f8:	5c7d                	li	s8,-1
    800029fa:	a80d                	j	80002a2c <readi+0x7c>
    800029fc:	020d1d93          	slli	s11,s10,0x20
    80002a00:	020ddd93          	srli	s11,s11,0x20
    80002a04:	05890613          	addi	a2,s2,88
    80002a08:	86ee                	mv	a3,s11
    80002a0a:	963a                	add	a2,a2,a4
    80002a0c:	85d2                	mv	a1,s4
    80002a0e:	855e                	mv	a0,s7
    80002a10:	d43fe0ef          	jal	80001752 <either_copyout>
    80002a14:	05850763          	beq	a0,s8,80002a62 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002a18:	854a                	mv	a0,s2
    80002a1a:	f12ff0ef          	jal	8000212c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a1e:	013d09bb          	addw	s3,s10,s3
    80002a22:	009d04bb          	addw	s1,s10,s1
    80002a26:	9a6e                	add	s4,s4,s11
    80002a28:	0559f763          	bgeu	s3,s5,80002a76 <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80002a2c:	00a4d59b          	srliw	a1,s1,0xa
    80002a30:	855a                	mv	a0,s6
    80002a32:	977ff0ef          	jal	800023a8 <bmap>
    80002a36:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002a3a:	c5b1                	beqz	a1,80002a86 <readi+0xd6>
    bp = bread(ip->dev, addr);
    80002a3c:	000b2503          	lw	a0,0(s6)
    80002a40:	de4ff0ef          	jal	80002024 <bread>
    80002a44:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002a46:	3ff4f713          	andi	a4,s1,1023
    80002a4a:	40ec87bb          	subw	a5,s9,a4
    80002a4e:	413a86bb          	subw	a3,s5,s3
    80002a52:	8d3e                	mv	s10,a5
    80002a54:	2781                	sext.w	a5,a5
    80002a56:	0006861b          	sext.w	a2,a3
    80002a5a:	faf671e3          	bgeu	a2,a5,800029fc <readi+0x4c>
    80002a5e:	8d36                	mv	s10,a3
    80002a60:	bf71                	j	800029fc <readi+0x4c>
      brelse(bp);
    80002a62:	854a                	mv	a0,s2
    80002a64:	ec8ff0ef          	jal	8000212c <brelse>
      tot = -1;
    80002a68:	59fd                	li	s3,-1
      break;
    80002a6a:	6946                	ld	s2,80(sp)
    80002a6c:	7c02                	ld	s8,32(sp)
    80002a6e:	6ce2                	ld	s9,24(sp)
    80002a70:	6d42                	ld	s10,16(sp)
    80002a72:	6da2                	ld	s11,8(sp)
    80002a74:	a831                	j	80002a90 <readi+0xe0>
    80002a76:	6946                	ld	s2,80(sp)
    80002a78:	7c02                	ld	s8,32(sp)
    80002a7a:	6ce2                	ld	s9,24(sp)
    80002a7c:	6d42                	ld	s10,16(sp)
    80002a7e:	6da2                	ld	s11,8(sp)
    80002a80:	a801                	j	80002a90 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a82:	89d6                	mv	s3,s5
    80002a84:	a031                	j	80002a90 <readi+0xe0>
    80002a86:	6946                	ld	s2,80(sp)
    80002a88:	7c02                	ld	s8,32(sp)
    80002a8a:	6ce2                	ld	s9,24(sp)
    80002a8c:	6d42                	ld	s10,16(sp)
    80002a8e:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002a90:	0009851b          	sext.w	a0,s3
    80002a94:	69a6                	ld	s3,72(sp)
}
    80002a96:	70a6                	ld	ra,104(sp)
    80002a98:	7406                	ld	s0,96(sp)
    80002a9a:	64e6                	ld	s1,88(sp)
    80002a9c:	6a06                	ld	s4,64(sp)
    80002a9e:	7ae2                	ld	s5,56(sp)
    80002aa0:	7b42                	ld	s6,48(sp)
    80002aa2:	7ba2                	ld	s7,40(sp)
    80002aa4:	6165                	addi	sp,sp,112
    80002aa6:	8082                	ret
    return 0;
    80002aa8:	4501                	li	a0,0
}
    80002aaa:	8082                	ret

0000000080002aac <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002aac:	457c                	lw	a5,76(a0)
    80002aae:	10d7e063          	bltu	a5,a3,80002bae <writei+0x102>
{
    80002ab2:	7159                	addi	sp,sp,-112
    80002ab4:	f486                	sd	ra,104(sp)
    80002ab6:	f0a2                	sd	s0,96(sp)
    80002ab8:	e8ca                	sd	s2,80(sp)
    80002aba:	e0d2                	sd	s4,64(sp)
    80002abc:	fc56                	sd	s5,56(sp)
    80002abe:	f85a                	sd	s6,48(sp)
    80002ac0:	f45e                	sd	s7,40(sp)
    80002ac2:	1880                	addi	s0,sp,112
    80002ac4:	8aaa                	mv	s5,a0
    80002ac6:	8bae                	mv	s7,a1
    80002ac8:	8a32                	mv	s4,a2
    80002aca:	8936                	mv	s2,a3
    80002acc:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002ace:	00e687bb          	addw	a5,a3,a4
    80002ad2:	0ed7e063          	bltu	a5,a3,80002bb2 <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002ad6:	00043737          	lui	a4,0x43
    80002ada:	0cf76e63          	bltu	a4,a5,80002bb6 <writei+0x10a>
    80002ade:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ae0:	0a0b0f63          	beqz	s6,80002b9e <writei+0xf2>
    80002ae4:	eca6                	sd	s1,88(sp)
    80002ae6:	f062                	sd	s8,32(sp)
    80002ae8:	ec66                	sd	s9,24(sp)
    80002aea:	e86a                	sd	s10,16(sp)
    80002aec:	e46e                	sd	s11,8(sp)
    80002aee:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002af0:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002af4:	5c7d                	li	s8,-1
    80002af6:	a825                	j	80002b2e <writei+0x82>
    80002af8:	020d1d93          	slli	s11,s10,0x20
    80002afc:	020ddd93          	srli	s11,s11,0x20
    80002b00:	05848513          	addi	a0,s1,88
    80002b04:	86ee                	mv	a3,s11
    80002b06:	8652                	mv	a2,s4
    80002b08:	85de                	mv	a1,s7
    80002b0a:	953a                	add	a0,a0,a4
    80002b0c:	c91fe0ef          	jal	8000179c <either_copyin>
    80002b10:	05850a63          	beq	a0,s8,80002b64 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002b14:	8526                	mv	a0,s1
    80002b16:	660000ef          	jal	80003176 <log_write>
    brelse(bp);
    80002b1a:	8526                	mv	a0,s1
    80002b1c:	e10ff0ef          	jal	8000212c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002b20:	013d09bb          	addw	s3,s10,s3
    80002b24:	012d093b          	addw	s2,s10,s2
    80002b28:	9a6e                	add	s4,s4,s11
    80002b2a:	0569f063          	bgeu	s3,s6,80002b6a <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002b2e:	00a9559b          	srliw	a1,s2,0xa
    80002b32:	8556                	mv	a0,s5
    80002b34:	875ff0ef          	jal	800023a8 <bmap>
    80002b38:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002b3c:	c59d                	beqz	a1,80002b6a <writei+0xbe>
    bp = bread(ip->dev, addr);
    80002b3e:	000aa503          	lw	a0,0(s5)
    80002b42:	ce2ff0ef          	jal	80002024 <bread>
    80002b46:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b48:	3ff97713          	andi	a4,s2,1023
    80002b4c:	40ec87bb          	subw	a5,s9,a4
    80002b50:	413b06bb          	subw	a3,s6,s3
    80002b54:	8d3e                	mv	s10,a5
    80002b56:	2781                	sext.w	a5,a5
    80002b58:	0006861b          	sext.w	a2,a3
    80002b5c:	f8f67ee3          	bgeu	a2,a5,80002af8 <writei+0x4c>
    80002b60:	8d36                	mv	s10,a3
    80002b62:	bf59                	j	80002af8 <writei+0x4c>
      brelse(bp);
    80002b64:	8526                	mv	a0,s1
    80002b66:	dc6ff0ef          	jal	8000212c <brelse>
  }

  if(off > ip->size)
    80002b6a:	04caa783          	lw	a5,76(s5)
    80002b6e:	0327fa63          	bgeu	a5,s2,80002ba2 <writei+0xf6>
    ip->size = off;
    80002b72:	052aa623          	sw	s2,76(s5)
    80002b76:	64e6                	ld	s1,88(sp)
    80002b78:	7c02                	ld	s8,32(sp)
    80002b7a:	6ce2                	ld	s9,24(sp)
    80002b7c:	6d42                	ld	s10,16(sp)
    80002b7e:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002b80:	8556                	mv	a0,s5
    80002b82:	b27ff0ef          	jal	800026a8 <iupdate>

  return tot;
    80002b86:	0009851b          	sext.w	a0,s3
    80002b8a:	69a6                	ld	s3,72(sp)
}
    80002b8c:	70a6                	ld	ra,104(sp)
    80002b8e:	7406                	ld	s0,96(sp)
    80002b90:	6946                	ld	s2,80(sp)
    80002b92:	6a06                	ld	s4,64(sp)
    80002b94:	7ae2                	ld	s5,56(sp)
    80002b96:	7b42                	ld	s6,48(sp)
    80002b98:	7ba2                	ld	s7,40(sp)
    80002b9a:	6165                	addi	sp,sp,112
    80002b9c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002b9e:	89da                	mv	s3,s6
    80002ba0:	b7c5                	j	80002b80 <writei+0xd4>
    80002ba2:	64e6                	ld	s1,88(sp)
    80002ba4:	7c02                	ld	s8,32(sp)
    80002ba6:	6ce2                	ld	s9,24(sp)
    80002ba8:	6d42                	ld	s10,16(sp)
    80002baa:	6da2                	ld	s11,8(sp)
    80002bac:	bfd1                	j	80002b80 <writei+0xd4>
    return -1;
    80002bae:	557d                	li	a0,-1
}
    80002bb0:	8082                	ret
    return -1;
    80002bb2:	557d                	li	a0,-1
    80002bb4:	bfe1                	j	80002b8c <writei+0xe0>
    return -1;
    80002bb6:	557d                	li	a0,-1
    80002bb8:	bfd1                	j	80002b8c <writei+0xe0>

0000000080002bba <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002bba:	1141                	addi	sp,sp,-16
    80002bbc:	e406                	sd	ra,8(sp)
    80002bbe:	e022                	sd	s0,0(sp)
    80002bc0:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002bc2:	4639                	li	a2,14
    80002bc4:	e56fd0ef          	jal	8000021a <strncmp>
}
    80002bc8:	60a2                	ld	ra,8(sp)
    80002bca:	6402                	ld	s0,0(sp)
    80002bcc:	0141                	addi	sp,sp,16
    80002bce:	8082                	ret

0000000080002bd0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002bd0:	7139                	addi	sp,sp,-64
    80002bd2:	fc06                	sd	ra,56(sp)
    80002bd4:	f822                	sd	s0,48(sp)
    80002bd6:	f426                	sd	s1,40(sp)
    80002bd8:	f04a                	sd	s2,32(sp)
    80002bda:	ec4e                	sd	s3,24(sp)
    80002bdc:	e852                	sd	s4,16(sp)
    80002bde:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002be0:	04451703          	lh	a4,68(a0)
    80002be4:	4785                	li	a5,1
    80002be6:	00f71a63          	bne	a4,a5,80002bfa <dirlookup+0x2a>
    80002bea:	892a                	mv	s2,a0
    80002bec:	89ae                	mv	s3,a1
    80002bee:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002bf0:	457c                	lw	a5,76(a0)
    80002bf2:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002bf4:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002bf6:	e39d                	bnez	a5,80002c1c <dirlookup+0x4c>
    80002bf8:	a095                	j	80002c5c <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80002bfa:	00005517          	auipc	a0,0x5
    80002bfe:	8d650513          	addi	a0,a0,-1834 # 800074d0 <etext+0x4d0>
    80002c02:	111020ef          	jal	80005512 <panic>
      panic("dirlookup read");
    80002c06:	00005517          	auipc	a0,0x5
    80002c0a:	8e250513          	addi	a0,a0,-1822 # 800074e8 <etext+0x4e8>
    80002c0e:	105020ef          	jal	80005512 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c12:	24c1                	addiw	s1,s1,16
    80002c14:	04c92783          	lw	a5,76(s2)
    80002c18:	04f4f163          	bgeu	s1,a5,80002c5a <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002c1c:	4741                	li	a4,16
    80002c1e:	86a6                	mv	a3,s1
    80002c20:	fc040613          	addi	a2,s0,-64
    80002c24:	4581                	li	a1,0
    80002c26:	854a                	mv	a0,s2
    80002c28:	d89ff0ef          	jal	800029b0 <readi>
    80002c2c:	47c1                	li	a5,16
    80002c2e:	fcf51ce3          	bne	a0,a5,80002c06 <dirlookup+0x36>
    if(de.inum == 0)
    80002c32:	fc045783          	lhu	a5,-64(s0)
    80002c36:	dff1                	beqz	a5,80002c12 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80002c38:	fc240593          	addi	a1,s0,-62
    80002c3c:	854e                	mv	a0,s3
    80002c3e:	f7dff0ef          	jal	80002bba <namecmp>
    80002c42:	f961                	bnez	a0,80002c12 <dirlookup+0x42>
      if(poff)
    80002c44:	000a0463          	beqz	s4,80002c4c <dirlookup+0x7c>
        *poff = off;
    80002c48:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002c4c:	fc045583          	lhu	a1,-64(s0)
    80002c50:	00092503          	lw	a0,0(s2)
    80002c54:	829ff0ef          	jal	8000247c <iget>
    80002c58:	a011                	j	80002c5c <dirlookup+0x8c>
  return 0;
    80002c5a:	4501                	li	a0,0
}
    80002c5c:	70e2                	ld	ra,56(sp)
    80002c5e:	7442                	ld	s0,48(sp)
    80002c60:	74a2                	ld	s1,40(sp)
    80002c62:	7902                	ld	s2,32(sp)
    80002c64:	69e2                	ld	s3,24(sp)
    80002c66:	6a42                	ld	s4,16(sp)
    80002c68:	6121                	addi	sp,sp,64
    80002c6a:	8082                	ret

0000000080002c6c <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002c6c:	711d                	addi	sp,sp,-96
    80002c6e:	ec86                	sd	ra,88(sp)
    80002c70:	e8a2                	sd	s0,80(sp)
    80002c72:	e4a6                	sd	s1,72(sp)
    80002c74:	e0ca                	sd	s2,64(sp)
    80002c76:	fc4e                	sd	s3,56(sp)
    80002c78:	f852                	sd	s4,48(sp)
    80002c7a:	f456                	sd	s5,40(sp)
    80002c7c:	f05a                	sd	s6,32(sp)
    80002c7e:	ec5e                	sd	s7,24(sp)
    80002c80:	e862                	sd	s8,16(sp)
    80002c82:	e466                	sd	s9,8(sp)
    80002c84:	1080                	addi	s0,sp,96
    80002c86:	84aa                	mv	s1,a0
    80002c88:	8b2e                	mv	s6,a1
    80002c8a:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002c8c:	00054703          	lbu	a4,0(a0)
    80002c90:	02f00793          	li	a5,47
    80002c94:	00f70e63          	beq	a4,a5,80002cb0 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002c98:	908fe0ef          	jal	80000da0 <myproc>
    80002c9c:	15853503          	ld	a0,344(a0)
    80002ca0:	a87ff0ef          	jal	80002726 <idup>
    80002ca4:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002ca6:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002caa:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002cac:	4b85                	li	s7,1
    80002cae:	a871                	j	80002d4a <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80002cb0:	4585                	li	a1,1
    80002cb2:	4505                	li	a0,1
    80002cb4:	fc8ff0ef          	jal	8000247c <iget>
    80002cb8:	8a2a                	mv	s4,a0
    80002cba:	b7f5                	j	80002ca6 <namex+0x3a>
      iunlockput(ip);
    80002cbc:	8552                	mv	a0,s4
    80002cbe:	ca9ff0ef          	jal	80002966 <iunlockput>
      return 0;
    80002cc2:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002cc4:	8552                	mv	a0,s4
    80002cc6:	60e6                	ld	ra,88(sp)
    80002cc8:	6446                	ld	s0,80(sp)
    80002cca:	64a6                	ld	s1,72(sp)
    80002ccc:	6906                	ld	s2,64(sp)
    80002cce:	79e2                	ld	s3,56(sp)
    80002cd0:	7a42                	ld	s4,48(sp)
    80002cd2:	7aa2                	ld	s5,40(sp)
    80002cd4:	7b02                	ld	s6,32(sp)
    80002cd6:	6be2                	ld	s7,24(sp)
    80002cd8:	6c42                	ld	s8,16(sp)
    80002cda:	6ca2                	ld	s9,8(sp)
    80002cdc:	6125                	addi	sp,sp,96
    80002cde:	8082                	ret
      iunlock(ip);
    80002ce0:	8552                	mv	a0,s4
    80002ce2:	b29ff0ef          	jal	8000280a <iunlock>
      return ip;
    80002ce6:	bff9                	j	80002cc4 <namex+0x58>
      iunlockput(ip);
    80002ce8:	8552                	mv	a0,s4
    80002cea:	c7dff0ef          	jal	80002966 <iunlockput>
      return 0;
    80002cee:	8a4e                	mv	s4,s3
    80002cf0:	bfd1                	j	80002cc4 <namex+0x58>
  len = path - s;
    80002cf2:	40998633          	sub	a2,s3,s1
    80002cf6:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80002cfa:	099c5063          	bge	s8,s9,80002d7a <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80002cfe:	4639                	li	a2,14
    80002d00:	85a6                	mv	a1,s1
    80002d02:	8556                	mv	a0,s5
    80002d04:	ca6fd0ef          	jal	800001aa <memmove>
    80002d08:	84ce                	mv	s1,s3
  while(*path == '/')
    80002d0a:	0004c783          	lbu	a5,0(s1)
    80002d0e:	01279763          	bne	a5,s2,80002d1c <namex+0xb0>
    path++;
    80002d12:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002d14:	0004c783          	lbu	a5,0(s1)
    80002d18:	ff278de3          	beq	a5,s2,80002d12 <namex+0xa6>
    ilock(ip);
    80002d1c:	8552                	mv	a0,s4
    80002d1e:	a3fff0ef          	jal	8000275c <ilock>
    if(ip->type != T_DIR){
    80002d22:	044a1783          	lh	a5,68(s4)
    80002d26:	f9779be3          	bne	a5,s7,80002cbc <namex+0x50>
    if(nameiparent && *path == '\0'){
    80002d2a:	000b0563          	beqz	s6,80002d34 <namex+0xc8>
    80002d2e:	0004c783          	lbu	a5,0(s1)
    80002d32:	d7dd                	beqz	a5,80002ce0 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002d34:	4601                	li	a2,0
    80002d36:	85d6                	mv	a1,s5
    80002d38:	8552                	mv	a0,s4
    80002d3a:	e97ff0ef          	jal	80002bd0 <dirlookup>
    80002d3e:	89aa                	mv	s3,a0
    80002d40:	d545                	beqz	a0,80002ce8 <namex+0x7c>
    iunlockput(ip);
    80002d42:	8552                	mv	a0,s4
    80002d44:	c23ff0ef          	jal	80002966 <iunlockput>
    ip = next;
    80002d48:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002d4a:	0004c783          	lbu	a5,0(s1)
    80002d4e:	01279763          	bne	a5,s2,80002d5c <namex+0xf0>
    path++;
    80002d52:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002d54:	0004c783          	lbu	a5,0(s1)
    80002d58:	ff278de3          	beq	a5,s2,80002d52 <namex+0xe6>
  if(*path == 0)
    80002d5c:	cb8d                	beqz	a5,80002d8e <namex+0x122>
  while(*path != '/' && *path != 0)
    80002d5e:	0004c783          	lbu	a5,0(s1)
    80002d62:	89a6                	mv	s3,s1
  len = path - s;
    80002d64:	4c81                	li	s9,0
    80002d66:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80002d68:	01278963          	beq	a5,s2,80002d7a <namex+0x10e>
    80002d6c:	d3d9                	beqz	a5,80002cf2 <namex+0x86>
    path++;
    80002d6e:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002d70:	0009c783          	lbu	a5,0(s3)
    80002d74:	ff279ce3          	bne	a5,s2,80002d6c <namex+0x100>
    80002d78:	bfad                	j	80002cf2 <namex+0x86>
    memmove(name, s, len);
    80002d7a:	2601                	sext.w	a2,a2
    80002d7c:	85a6                	mv	a1,s1
    80002d7e:	8556                	mv	a0,s5
    80002d80:	c2afd0ef          	jal	800001aa <memmove>
    name[len] = 0;
    80002d84:	9cd6                	add	s9,s9,s5
    80002d86:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80002d8a:	84ce                	mv	s1,s3
    80002d8c:	bfbd                	j	80002d0a <namex+0x9e>
  if(nameiparent){
    80002d8e:	f20b0be3          	beqz	s6,80002cc4 <namex+0x58>
    iput(ip);
    80002d92:	8552                	mv	a0,s4
    80002d94:	b4bff0ef          	jal	800028de <iput>
    return 0;
    80002d98:	4a01                	li	s4,0
    80002d9a:	b72d                	j	80002cc4 <namex+0x58>

0000000080002d9c <dirlink>:
{
    80002d9c:	7139                	addi	sp,sp,-64
    80002d9e:	fc06                	sd	ra,56(sp)
    80002da0:	f822                	sd	s0,48(sp)
    80002da2:	f04a                	sd	s2,32(sp)
    80002da4:	ec4e                	sd	s3,24(sp)
    80002da6:	e852                	sd	s4,16(sp)
    80002da8:	0080                	addi	s0,sp,64
    80002daa:	892a                	mv	s2,a0
    80002dac:	8a2e                	mv	s4,a1
    80002dae:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002db0:	4601                	li	a2,0
    80002db2:	e1fff0ef          	jal	80002bd0 <dirlookup>
    80002db6:	e535                	bnez	a0,80002e22 <dirlink+0x86>
    80002db8:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002dba:	04c92483          	lw	s1,76(s2)
    80002dbe:	c48d                	beqz	s1,80002de8 <dirlink+0x4c>
    80002dc0:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002dc2:	4741                	li	a4,16
    80002dc4:	86a6                	mv	a3,s1
    80002dc6:	fc040613          	addi	a2,s0,-64
    80002dca:	4581                	li	a1,0
    80002dcc:	854a                	mv	a0,s2
    80002dce:	be3ff0ef          	jal	800029b0 <readi>
    80002dd2:	47c1                	li	a5,16
    80002dd4:	04f51b63          	bne	a0,a5,80002e2a <dirlink+0x8e>
    if(de.inum == 0)
    80002dd8:	fc045783          	lhu	a5,-64(s0)
    80002ddc:	c791                	beqz	a5,80002de8 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002dde:	24c1                	addiw	s1,s1,16
    80002de0:	04c92783          	lw	a5,76(s2)
    80002de4:	fcf4efe3          	bltu	s1,a5,80002dc2 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80002de8:	4639                	li	a2,14
    80002dea:	85d2                	mv	a1,s4
    80002dec:	fc240513          	addi	a0,s0,-62
    80002df0:	c60fd0ef          	jal	80000250 <strncpy>
  de.inum = inum;
    80002df4:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002df8:	4741                	li	a4,16
    80002dfa:	86a6                	mv	a3,s1
    80002dfc:	fc040613          	addi	a2,s0,-64
    80002e00:	4581                	li	a1,0
    80002e02:	854a                	mv	a0,s2
    80002e04:	ca9ff0ef          	jal	80002aac <writei>
    80002e08:	1541                	addi	a0,a0,-16
    80002e0a:	00a03533          	snez	a0,a0
    80002e0e:	40a00533          	neg	a0,a0
    80002e12:	74a2                	ld	s1,40(sp)
}
    80002e14:	70e2                	ld	ra,56(sp)
    80002e16:	7442                	ld	s0,48(sp)
    80002e18:	7902                	ld	s2,32(sp)
    80002e1a:	69e2                	ld	s3,24(sp)
    80002e1c:	6a42                	ld	s4,16(sp)
    80002e1e:	6121                	addi	sp,sp,64
    80002e20:	8082                	ret
    iput(ip);
    80002e22:	abdff0ef          	jal	800028de <iput>
    return -1;
    80002e26:	557d                	li	a0,-1
    80002e28:	b7f5                	j	80002e14 <dirlink+0x78>
      panic("dirlink read");
    80002e2a:	00004517          	auipc	a0,0x4
    80002e2e:	6ce50513          	addi	a0,a0,1742 # 800074f8 <etext+0x4f8>
    80002e32:	6e0020ef          	jal	80005512 <panic>

0000000080002e36 <namei>:

struct inode*
namei(char *path)
{
    80002e36:	1101                	addi	sp,sp,-32
    80002e38:	ec06                	sd	ra,24(sp)
    80002e3a:	e822                	sd	s0,16(sp)
    80002e3c:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002e3e:	fe040613          	addi	a2,s0,-32
    80002e42:	4581                	li	a1,0
    80002e44:	e29ff0ef          	jal	80002c6c <namex>
}
    80002e48:	60e2                	ld	ra,24(sp)
    80002e4a:	6442                	ld	s0,16(sp)
    80002e4c:	6105                	addi	sp,sp,32
    80002e4e:	8082                	ret

0000000080002e50 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002e50:	1141                	addi	sp,sp,-16
    80002e52:	e406                	sd	ra,8(sp)
    80002e54:	e022                	sd	s0,0(sp)
    80002e56:	0800                	addi	s0,sp,16
    80002e58:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002e5a:	4585                	li	a1,1
    80002e5c:	e11ff0ef          	jal	80002c6c <namex>
}
    80002e60:	60a2                	ld	ra,8(sp)
    80002e62:	6402                	ld	s0,0(sp)
    80002e64:	0141                	addi	sp,sp,16
    80002e66:	8082                	ret

0000000080002e68 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002e68:	1101                	addi	sp,sp,-32
    80002e6a:	ec06                	sd	ra,24(sp)
    80002e6c:	e822                	sd	s0,16(sp)
    80002e6e:	e426                	sd	s1,8(sp)
    80002e70:	e04a                	sd	s2,0(sp)
    80002e72:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002e74:	00017917          	auipc	s2,0x17
    80002e78:	69c90913          	addi	s2,s2,1692 # 8001a510 <log>
    80002e7c:	01892583          	lw	a1,24(s2)
    80002e80:	02892503          	lw	a0,40(s2)
    80002e84:	9a0ff0ef          	jal	80002024 <bread>
    80002e88:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002e8a:	02c92603          	lw	a2,44(s2)
    80002e8e:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002e90:	00c05f63          	blez	a2,80002eae <write_head+0x46>
    80002e94:	00017717          	auipc	a4,0x17
    80002e98:	6ac70713          	addi	a4,a4,1708 # 8001a540 <log+0x30>
    80002e9c:	87aa                	mv	a5,a0
    80002e9e:	060a                	slli	a2,a2,0x2
    80002ea0:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80002ea2:	4314                	lw	a3,0(a4)
    80002ea4:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80002ea6:	0711                	addi	a4,a4,4
    80002ea8:	0791                	addi	a5,a5,4
    80002eaa:	fec79ce3          	bne	a5,a2,80002ea2 <write_head+0x3a>
  }
  bwrite(buf);
    80002eae:	8526                	mv	a0,s1
    80002eb0:	a4aff0ef          	jal	800020fa <bwrite>
  brelse(buf);
    80002eb4:	8526                	mv	a0,s1
    80002eb6:	a76ff0ef          	jal	8000212c <brelse>
}
    80002eba:	60e2                	ld	ra,24(sp)
    80002ebc:	6442                	ld	s0,16(sp)
    80002ebe:	64a2                	ld	s1,8(sp)
    80002ec0:	6902                	ld	s2,0(sp)
    80002ec2:	6105                	addi	sp,sp,32
    80002ec4:	8082                	ret

0000000080002ec6 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002ec6:	00017797          	auipc	a5,0x17
    80002eca:	6767a783          	lw	a5,1654(a5) # 8001a53c <log+0x2c>
    80002ece:	08f05f63          	blez	a5,80002f6c <install_trans+0xa6>
{
    80002ed2:	7139                	addi	sp,sp,-64
    80002ed4:	fc06                	sd	ra,56(sp)
    80002ed6:	f822                	sd	s0,48(sp)
    80002ed8:	f426                	sd	s1,40(sp)
    80002eda:	f04a                	sd	s2,32(sp)
    80002edc:	ec4e                	sd	s3,24(sp)
    80002ede:	e852                	sd	s4,16(sp)
    80002ee0:	e456                	sd	s5,8(sp)
    80002ee2:	e05a                	sd	s6,0(sp)
    80002ee4:	0080                	addi	s0,sp,64
    80002ee6:	8b2a                	mv	s6,a0
    80002ee8:	00017a97          	auipc	s5,0x17
    80002eec:	658a8a93          	addi	s5,s5,1624 # 8001a540 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002ef0:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002ef2:	00017997          	auipc	s3,0x17
    80002ef6:	61e98993          	addi	s3,s3,1566 # 8001a510 <log>
    80002efa:	a829                	j	80002f14 <install_trans+0x4e>
    brelse(lbuf);
    80002efc:	854a                	mv	a0,s2
    80002efe:	a2eff0ef          	jal	8000212c <brelse>
    brelse(dbuf);
    80002f02:	8526                	mv	a0,s1
    80002f04:	a28ff0ef          	jal	8000212c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f08:	2a05                	addiw	s4,s4,1
    80002f0a:	0a91                	addi	s5,s5,4
    80002f0c:	02c9a783          	lw	a5,44(s3)
    80002f10:	04fa5463          	bge	s4,a5,80002f58 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002f14:	0189a583          	lw	a1,24(s3)
    80002f18:	014585bb          	addw	a1,a1,s4
    80002f1c:	2585                	addiw	a1,a1,1
    80002f1e:	0289a503          	lw	a0,40(s3)
    80002f22:	902ff0ef          	jal	80002024 <bread>
    80002f26:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80002f28:	000aa583          	lw	a1,0(s5)
    80002f2c:	0289a503          	lw	a0,40(s3)
    80002f30:	8f4ff0ef          	jal	80002024 <bread>
    80002f34:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002f36:	40000613          	li	a2,1024
    80002f3a:	05890593          	addi	a1,s2,88
    80002f3e:	05850513          	addi	a0,a0,88
    80002f42:	a68fd0ef          	jal	800001aa <memmove>
    bwrite(dbuf);  // write dst to disk
    80002f46:	8526                	mv	a0,s1
    80002f48:	9b2ff0ef          	jal	800020fa <bwrite>
    if(recovering == 0)
    80002f4c:	fa0b18e3          	bnez	s6,80002efc <install_trans+0x36>
      bunpin(dbuf);
    80002f50:	8526                	mv	a0,s1
    80002f52:	a96ff0ef          	jal	800021e8 <bunpin>
    80002f56:	b75d                	j	80002efc <install_trans+0x36>
}
    80002f58:	70e2                	ld	ra,56(sp)
    80002f5a:	7442                	ld	s0,48(sp)
    80002f5c:	74a2                	ld	s1,40(sp)
    80002f5e:	7902                	ld	s2,32(sp)
    80002f60:	69e2                	ld	s3,24(sp)
    80002f62:	6a42                	ld	s4,16(sp)
    80002f64:	6aa2                	ld	s5,8(sp)
    80002f66:	6b02                	ld	s6,0(sp)
    80002f68:	6121                	addi	sp,sp,64
    80002f6a:	8082                	ret
    80002f6c:	8082                	ret

0000000080002f6e <initlog>:
{
    80002f6e:	7179                	addi	sp,sp,-48
    80002f70:	f406                	sd	ra,40(sp)
    80002f72:	f022                	sd	s0,32(sp)
    80002f74:	ec26                	sd	s1,24(sp)
    80002f76:	e84a                	sd	s2,16(sp)
    80002f78:	e44e                	sd	s3,8(sp)
    80002f7a:	1800                	addi	s0,sp,48
    80002f7c:	892a                	mv	s2,a0
    80002f7e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80002f80:	00017497          	auipc	s1,0x17
    80002f84:	59048493          	addi	s1,s1,1424 # 8001a510 <log>
    80002f88:	00004597          	auipc	a1,0x4
    80002f8c:	58058593          	addi	a1,a1,1408 # 80007508 <etext+0x508>
    80002f90:	8526                	mv	a0,s1
    80002f92:	02f020ef          	jal	800057c0 <initlock>
  log.start = sb->logstart;
    80002f96:	0149a583          	lw	a1,20(s3)
    80002f9a:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80002f9c:	0109a783          	lw	a5,16(s3)
    80002fa0:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80002fa2:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80002fa6:	854a                	mv	a0,s2
    80002fa8:	87cff0ef          	jal	80002024 <bread>
  log.lh.n = lh->n;
    80002fac:	4d30                	lw	a2,88(a0)
    80002fae:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80002fb0:	00c05f63          	blez	a2,80002fce <initlog+0x60>
    80002fb4:	87aa                	mv	a5,a0
    80002fb6:	00017717          	auipc	a4,0x17
    80002fba:	58a70713          	addi	a4,a4,1418 # 8001a540 <log+0x30>
    80002fbe:	060a                	slli	a2,a2,0x2
    80002fc0:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80002fc2:	4ff4                	lw	a3,92(a5)
    80002fc4:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80002fc6:	0791                	addi	a5,a5,4
    80002fc8:	0711                	addi	a4,a4,4
    80002fca:	fec79ce3          	bne	a5,a2,80002fc2 <initlog+0x54>
  brelse(buf);
    80002fce:	95eff0ef          	jal	8000212c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80002fd2:	4505                	li	a0,1
    80002fd4:	ef3ff0ef          	jal	80002ec6 <install_trans>
  log.lh.n = 0;
    80002fd8:	00017797          	auipc	a5,0x17
    80002fdc:	5607a223          	sw	zero,1380(a5) # 8001a53c <log+0x2c>
  write_head(); // clear the log
    80002fe0:	e89ff0ef          	jal	80002e68 <write_head>
}
    80002fe4:	70a2                	ld	ra,40(sp)
    80002fe6:	7402                	ld	s0,32(sp)
    80002fe8:	64e2                	ld	s1,24(sp)
    80002fea:	6942                	ld	s2,16(sp)
    80002fec:	69a2                	ld	s3,8(sp)
    80002fee:	6145                	addi	sp,sp,48
    80002ff0:	8082                	ret

0000000080002ff2 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80002ff2:	1101                	addi	sp,sp,-32
    80002ff4:	ec06                	sd	ra,24(sp)
    80002ff6:	e822                	sd	s0,16(sp)
    80002ff8:	e426                	sd	s1,8(sp)
    80002ffa:	e04a                	sd	s2,0(sp)
    80002ffc:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80002ffe:	00017517          	auipc	a0,0x17
    80003002:	51250513          	addi	a0,a0,1298 # 8001a510 <log>
    80003006:	03b020ef          	jal	80005840 <acquire>
  while(1){
    if(log.committing){
    8000300a:	00017497          	auipc	s1,0x17
    8000300e:	50648493          	addi	s1,s1,1286 # 8001a510 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003012:	4979                	li	s2,30
    80003014:	a029                	j	8000301e <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003016:	85a6                	mv	a1,s1
    80003018:	8526                	mv	a0,s1
    8000301a:	bdcfe0ef          	jal	800013f6 <sleep>
    if(log.committing){
    8000301e:	50dc                	lw	a5,36(s1)
    80003020:	fbfd                	bnez	a5,80003016 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003022:	5098                	lw	a4,32(s1)
    80003024:	2705                	addiw	a4,a4,1
    80003026:	0027179b          	slliw	a5,a4,0x2
    8000302a:	9fb9                	addw	a5,a5,a4
    8000302c:	0017979b          	slliw	a5,a5,0x1
    80003030:	54d4                	lw	a3,44(s1)
    80003032:	9fb5                	addw	a5,a5,a3
    80003034:	00f95763          	bge	s2,a5,80003042 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003038:	85a6                	mv	a1,s1
    8000303a:	8526                	mv	a0,s1
    8000303c:	bbafe0ef          	jal	800013f6 <sleep>
    80003040:	bff9                	j	8000301e <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003042:	00017517          	auipc	a0,0x17
    80003046:	4ce50513          	addi	a0,a0,1230 # 8001a510 <log>
    8000304a:	d118                	sw	a4,32(a0)
      release(&log.lock);
    8000304c:	08d020ef          	jal	800058d8 <release>
      break;
    }
  }
}
    80003050:	60e2                	ld	ra,24(sp)
    80003052:	6442                	ld	s0,16(sp)
    80003054:	64a2                	ld	s1,8(sp)
    80003056:	6902                	ld	s2,0(sp)
    80003058:	6105                	addi	sp,sp,32
    8000305a:	8082                	ret

000000008000305c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000305c:	7139                	addi	sp,sp,-64
    8000305e:	fc06                	sd	ra,56(sp)
    80003060:	f822                	sd	s0,48(sp)
    80003062:	f426                	sd	s1,40(sp)
    80003064:	f04a                	sd	s2,32(sp)
    80003066:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003068:	00017497          	auipc	s1,0x17
    8000306c:	4a848493          	addi	s1,s1,1192 # 8001a510 <log>
    80003070:	8526                	mv	a0,s1
    80003072:	7ce020ef          	jal	80005840 <acquire>
  log.outstanding -= 1;
    80003076:	509c                	lw	a5,32(s1)
    80003078:	37fd                	addiw	a5,a5,-1
    8000307a:	0007891b          	sext.w	s2,a5
    8000307e:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003080:	50dc                	lw	a5,36(s1)
    80003082:	ef9d                	bnez	a5,800030c0 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80003084:	04091763          	bnez	s2,800030d2 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003088:	00017497          	auipc	s1,0x17
    8000308c:	48848493          	addi	s1,s1,1160 # 8001a510 <log>
    80003090:	4785                	li	a5,1
    80003092:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003094:	8526                	mv	a0,s1
    80003096:	043020ef          	jal	800058d8 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000309a:	54dc                	lw	a5,44(s1)
    8000309c:	04f04b63          	bgtz	a5,800030f2 <end_op+0x96>
    acquire(&log.lock);
    800030a0:	00017497          	auipc	s1,0x17
    800030a4:	47048493          	addi	s1,s1,1136 # 8001a510 <log>
    800030a8:	8526                	mv	a0,s1
    800030aa:	796020ef          	jal	80005840 <acquire>
    log.committing = 0;
    800030ae:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800030b2:	8526                	mv	a0,s1
    800030b4:	b8efe0ef          	jal	80001442 <wakeup>
    release(&log.lock);
    800030b8:	8526                	mv	a0,s1
    800030ba:	01f020ef          	jal	800058d8 <release>
}
    800030be:	a025                	j	800030e6 <end_op+0x8a>
    800030c0:	ec4e                	sd	s3,24(sp)
    800030c2:	e852                	sd	s4,16(sp)
    800030c4:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800030c6:	00004517          	auipc	a0,0x4
    800030ca:	44a50513          	addi	a0,a0,1098 # 80007510 <etext+0x510>
    800030ce:	444020ef          	jal	80005512 <panic>
    wakeup(&log);
    800030d2:	00017497          	auipc	s1,0x17
    800030d6:	43e48493          	addi	s1,s1,1086 # 8001a510 <log>
    800030da:	8526                	mv	a0,s1
    800030dc:	b66fe0ef          	jal	80001442 <wakeup>
  release(&log.lock);
    800030e0:	8526                	mv	a0,s1
    800030e2:	7f6020ef          	jal	800058d8 <release>
}
    800030e6:	70e2                	ld	ra,56(sp)
    800030e8:	7442                	ld	s0,48(sp)
    800030ea:	74a2                	ld	s1,40(sp)
    800030ec:	7902                	ld	s2,32(sp)
    800030ee:	6121                	addi	sp,sp,64
    800030f0:	8082                	ret
    800030f2:	ec4e                	sd	s3,24(sp)
    800030f4:	e852                	sd	s4,16(sp)
    800030f6:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800030f8:	00017a97          	auipc	s5,0x17
    800030fc:	448a8a93          	addi	s5,s5,1096 # 8001a540 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003100:	00017a17          	auipc	s4,0x17
    80003104:	410a0a13          	addi	s4,s4,1040 # 8001a510 <log>
    80003108:	018a2583          	lw	a1,24(s4)
    8000310c:	012585bb          	addw	a1,a1,s2
    80003110:	2585                	addiw	a1,a1,1
    80003112:	028a2503          	lw	a0,40(s4)
    80003116:	f0ffe0ef          	jal	80002024 <bread>
    8000311a:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000311c:	000aa583          	lw	a1,0(s5)
    80003120:	028a2503          	lw	a0,40(s4)
    80003124:	f01fe0ef          	jal	80002024 <bread>
    80003128:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000312a:	40000613          	li	a2,1024
    8000312e:	05850593          	addi	a1,a0,88
    80003132:	05848513          	addi	a0,s1,88
    80003136:	874fd0ef          	jal	800001aa <memmove>
    bwrite(to);  // write the log
    8000313a:	8526                	mv	a0,s1
    8000313c:	fbffe0ef          	jal	800020fa <bwrite>
    brelse(from);
    80003140:	854e                	mv	a0,s3
    80003142:	febfe0ef          	jal	8000212c <brelse>
    brelse(to);
    80003146:	8526                	mv	a0,s1
    80003148:	fe5fe0ef          	jal	8000212c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000314c:	2905                	addiw	s2,s2,1
    8000314e:	0a91                	addi	s5,s5,4
    80003150:	02ca2783          	lw	a5,44(s4)
    80003154:	faf94ae3          	blt	s2,a5,80003108 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003158:	d11ff0ef          	jal	80002e68 <write_head>
    install_trans(0); // Now install writes to home locations
    8000315c:	4501                	li	a0,0
    8000315e:	d69ff0ef          	jal	80002ec6 <install_trans>
    log.lh.n = 0;
    80003162:	00017797          	auipc	a5,0x17
    80003166:	3c07ad23          	sw	zero,986(a5) # 8001a53c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000316a:	cffff0ef          	jal	80002e68 <write_head>
    8000316e:	69e2                	ld	s3,24(sp)
    80003170:	6a42                	ld	s4,16(sp)
    80003172:	6aa2                	ld	s5,8(sp)
    80003174:	b735                	j	800030a0 <end_op+0x44>

0000000080003176 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003176:	1101                	addi	sp,sp,-32
    80003178:	ec06                	sd	ra,24(sp)
    8000317a:	e822                	sd	s0,16(sp)
    8000317c:	e426                	sd	s1,8(sp)
    8000317e:	e04a                	sd	s2,0(sp)
    80003180:	1000                	addi	s0,sp,32
    80003182:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003184:	00017917          	auipc	s2,0x17
    80003188:	38c90913          	addi	s2,s2,908 # 8001a510 <log>
    8000318c:	854a                	mv	a0,s2
    8000318e:	6b2020ef          	jal	80005840 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003192:	02c92603          	lw	a2,44(s2)
    80003196:	47f5                	li	a5,29
    80003198:	06c7c363          	blt	a5,a2,800031fe <log_write+0x88>
    8000319c:	00017797          	auipc	a5,0x17
    800031a0:	3907a783          	lw	a5,912(a5) # 8001a52c <log+0x1c>
    800031a4:	37fd                	addiw	a5,a5,-1
    800031a6:	04f65c63          	bge	a2,a5,800031fe <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800031aa:	00017797          	auipc	a5,0x17
    800031ae:	3867a783          	lw	a5,902(a5) # 8001a530 <log+0x20>
    800031b2:	04f05c63          	blez	a5,8000320a <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800031b6:	4781                	li	a5,0
    800031b8:	04c05f63          	blez	a2,80003216 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800031bc:	44cc                	lw	a1,12(s1)
    800031be:	00017717          	auipc	a4,0x17
    800031c2:	38270713          	addi	a4,a4,898 # 8001a540 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800031c6:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800031c8:	4314                	lw	a3,0(a4)
    800031ca:	04b68663          	beq	a3,a1,80003216 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    800031ce:	2785                	addiw	a5,a5,1
    800031d0:	0711                	addi	a4,a4,4
    800031d2:	fef61be3          	bne	a2,a5,800031c8 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    800031d6:	0621                	addi	a2,a2,8
    800031d8:	060a                	slli	a2,a2,0x2
    800031da:	00017797          	auipc	a5,0x17
    800031de:	33678793          	addi	a5,a5,822 # 8001a510 <log>
    800031e2:	97b2                	add	a5,a5,a2
    800031e4:	44d8                	lw	a4,12(s1)
    800031e6:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800031e8:	8526                	mv	a0,s1
    800031ea:	fcbfe0ef          	jal	800021b4 <bpin>
    log.lh.n++;
    800031ee:	00017717          	auipc	a4,0x17
    800031f2:	32270713          	addi	a4,a4,802 # 8001a510 <log>
    800031f6:	575c                	lw	a5,44(a4)
    800031f8:	2785                	addiw	a5,a5,1
    800031fa:	d75c                	sw	a5,44(a4)
    800031fc:	a80d                	j	8000322e <log_write+0xb8>
    panic("too big a transaction");
    800031fe:	00004517          	auipc	a0,0x4
    80003202:	32250513          	addi	a0,a0,802 # 80007520 <etext+0x520>
    80003206:	30c020ef          	jal	80005512 <panic>
    panic("log_write outside of trans");
    8000320a:	00004517          	auipc	a0,0x4
    8000320e:	32e50513          	addi	a0,a0,814 # 80007538 <etext+0x538>
    80003212:	300020ef          	jal	80005512 <panic>
  log.lh.block[i] = b->blockno;
    80003216:	00878693          	addi	a3,a5,8
    8000321a:	068a                	slli	a3,a3,0x2
    8000321c:	00017717          	auipc	a4,0x17
    80003220:	2f470713          	addi	a4,a4,756 # 8001a510 <log>
    80003224:	9736                	add	a4,a4,a3
    80003226:	44d4                	lw	a3,12(s1)
    80003228:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000322a:	faf60fe3          	beq	a2,a5,800031e8 <log_write+0x72>
  }
  release(&log.lock);
    8000322e:	00017517          	auipc	a0,0x17
    80003232:	2e250513          	addi	a0,a0,738 # 8001a510 <log>
    80003236:	6a2020ef          	jal	800058d8 <release>
}
    8000323a:	60e2                	ld	ra,24(sp)
    8000323c:	6442                	ld	s0,16(sp)
    8000323e:	64a2                	ld	s1,8(sp)
    80003240:	6902                	ld	s2,0(sp)
    80003242:	6105                	addi	sp,sp,32
    80003244:	8082                	ret

0000000080003246 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003246:	1101                	addi	sp,sp,-32
    80003248:	ec06                	sd	ra,24(sp)
    8000324a:	e822                	sd	s0,16(sp)
    8000324c:	e426                	sd	s1,8(sp)
    8000324e:	e04a                	sd	s2,0(sp)
    80003250:	1000                	addi	s0,sp,32
    80003252:	84aa                	mv	s1,a0
    80003254:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003256:	00004597          	auipc	a1,0x4
    8000325a:	30258593          	addi	a1,a1,770 # 80007558 <etext+0x558>
    8000325e:	0521                	addi	a0,a0,8
    80003260:	560020ef          	jal	800057c0 <initlock>
  lk->name = name;
    80003264:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003268:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000326c:	0204a423          	sw	zero,40(s1)
}
    80003270:	60e2                	ld	ra,24(sp)
    80003272:	6442                	ld	s0,16(sp)
    80003274:	64a2                	ld	s1,8(sp)
    80003276:	6902                	ld	s2,0(sp)
    80003278:	6105                	addi	sp,sp,32
    8000327a:	8082                	ret

000000008000327c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000327c:	1101                	addi	sp,sp,-32
    8000327e:	ec06                	sd	ra,24(sp)
    80003280:	e822                	sd	s0,16(sp)
    80003282:	e426                	sd	s1,8(sp)
    80003284:	e04a                	sd	s2,0(sp)
    80003286:	1000                	addi	s0,sp,32
    80003288:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000328a:	00850913          	addi	s2,a0,8
    8000328e:	854a                	mv	a0,s2
    80003290:	5b0020ef          	jal	80005840 <acquire>
  while (lk->locked) {
    80003294:	409c                	lw	a5,0(s1)
    80003296:	c799                	beqz	a5,800032a4 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003298:	85ca                	mv	a1,s2
    8000329a:	8526                	mv	a0,s1
    8000329c:	95afe0ef          	jal	800013f6 <sleep>
  while (lk->locked) {
    800032a0:	409c                	lw	a5,0(s1)
    800032a2:	fbfd                	bnez	a5,80003298 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    800032a4:	4785                	li	a5,1
    800032a6:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800032a8:	af9fd0ef          	jal	80000da0 <myproc>
    800032ac:	591c                	lw	a5,48(a0)
    800032ae:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800032b0:	854a                	mv	a0,s2
    800032b2:	626020ef          	jal	800058d8 <release>
}
    800032b6:	60e2                	ld	ra,24(sp)
    800032b8:	6442                	ld	s0,16(sp)
    800032ba:	64a2                	ld	s1,8(sp)
    800032bc:	6902                	ld	s2,0(sp)
    800032be:	6105                	addi	sp,sp,32
    800032c0:	8082                	ret

00000000800032c2 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800032c2:	1101                	addi	sp,sp,-32
    800032c4:	ec06                	sd	ra,24(sp)
    800032c6:	e822                	sd	s0,16(sp)
    800032c8:	e426                	sd	s1,8(sp)
    800032ca:	e04a                	sd	s2,0(sp)
    800032cc:	1000                	addi	s0,sp,32
    800032ce:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800032d0:	00850913          	addi	s2,a0,8
    800032d4:	854a                	mv	a0,s2
    800032d6:	56a020ef          	jal	80005840 <acquire>
  lk->locked = 0;
    800032da:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800032de:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800032e2:	8526                	mv	a0,s1
    800032e4:	95efe0ef          	jal	80001442 <wakeup>
  release(&lk->lk);
    800032e8:	854a                	mv	a0,s2
    800032ea:	5ee020ef          	jal	800058d8 <release>
}
    800032ee:	60e2                	ld	ra,24(sp)
    800032f0:	6442                	ld	s0,16(sp)
    800032f2:	64a2                	ld	s1,8(sp)
    800032f4:	6902                	ld	s2,0(sp)
    800032f6:	6105                	addi	sp,sp,32
    800032f8:	8082                	ret

00000000800032fa <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800032fa:	7179                	addi	sp,sp,-48
    800032fc:	f406                	sd	ra,40(sp)
    800032fe:	f022                	sd	s0,32(sp)
    80003300:	ec26                	sd	s1,24(sp)
    80003302:	e84a                	sd	s2,16(sp)
    80003304:	1800                	addi	s0,sp,48
    80003306:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003308:	00850913          	addi	s2,a0,8
    8000330c:	854a                	mv	a0,s2
    8000330e:	532020ef          	jal	80005840 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003312:	409c                	lw	a5,0(s1)
    80003314:	ef81                	bnez	a5,8000332c <holdingsleep+0x32>
    80003316:	4481                	li	s1,0
  release(&lk->lk);
    80003318:	854a                	mv	a0,s2
    8000331a:	5be020ef          	jal	800058d8 <release>
  return r;
}
    8000331e:	8526                	mv	a0,s1
    80003320:	70a2                	ld	ra,40(sp)
    80003322:	7402                	ld	s0,32(sp)
    80003324:	64e2                	ld	s1,24(sp)
    80003326:	6942                	ld	s2,16(sp)
    80003328:	6145                	addi	sp,sp,48
    8000332a:	8082                	ret
    8000332c:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    8000332e:	0284a983          	lw	s3,40(s1)
    80003332:	a6ffd0ef          	jal	80000da0 <myproc>
    80003336:	5904                	lw	s1,48(a0)
    80003338:	413484b3          	sub	s1,s1,s3
    8000333c:	0014b493          	seqz	s1,s1
    80003340:	69a2                	ld	s3,8(sp)
    80003342:	bfd9                	j	80003318 <holdingsleep+0x1e>

0000000080003344 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003344:	1141                	addi	sp,sp,-16
    80003346:	e406                	sd	ra,8(sp)
    80003348:	e022                	sd	s0,0(sp)
    8000334a:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000334c:	00004597          	auipc	a1,0x4
    80003350:	21c58593          	addi	a1,a1,540 # 80007568 <etext+0x568>
    80003354:	00017517          	auipc	a0,0x17
    80003358:	30450513          	addi	a0,a0,772 # 8001a658 <ftable>
    8000335c:	464020ef          	jal	800057c0 <initlock>
}
    80003360:	60a2                	ld	ra,8(sp)
    80003362:	6402                	ld	s0,0(sp)
    80003364:	0141                	addi	sp,sp,16
    80003366:	8082                	ret

0000000080003368 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003368:	1101                	addi	sp,sp,-32
    8000336a:	ec06                	sd	ra,24(sp)
    8000336c:	e822                	sd	s0,16(sp)
    8000336e:	e426                	sd	s1,8(sp)
    80003370:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003372:	00017517          	auipc	a0,0x17
    80003376:	2e650513          	addi	a0,a0,742 # 8001a658 <ftable>
    8000337a:	4c6020ef          	jal	80005840 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000337e:	00017497          	auipc	s1,0x17
    80003382:	2f248493          	addi	s1,s1,754 # 8001a670 <ftable+0x18>
    80003386:	00018717          	auipc	a4,0x18
    8000338a:	28a70713          	addi	a4,a4,650 # 8001b610 <disk>
    if(f->ref == 0){
    8000338e:	40dc                	lw	a5,4(s1)
    80003390:	cf89                	beqz	a5,800033aa <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003392:	02848493          	addi	s1,s1,40
    80003396:	fee49ce3          	bne	s1,a4,8000338e <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000339a:	00017517          	auipc	a0,0x17
    8000339e:	2be50513          	addi	a0,a0,702 # 8001a658 <ftable>
    800033a2:	536020ef          	jal	800058d8 <release>
  return 0;
    800033a6:	4481                	li	s1,0
    800033a8:	a809                	j	800033ba <filealloc+0x52>
      f->ref = 1;
    800033aa:	4785                	li	a5,1
    800033ac:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800033ae:	00017517          	auipc	a0,0x17
    800033b2:	2aa50513          	addi	a0,a0,682 # 8001a658 <ftable>
    800033b6:	522020ef          	jal	800058d8 <release>
}
    800033ba:	8526                	mv	a0,s1
    800033bc:	60e2                	ld	ra,24(sp)
    800033be:	6442                	ld	s0,16(sp)
    800033c0:	64a2                	ld	s1,8(sp)
    800033c2:	6105                	addi	sp,sp,32
    800033c4:	8082                	ret

00000000800033c6 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800033c6:	1101                	addi	sp,sp,-32
    800033c8:	ec06                	sd	ra,24(sp)
    800033ca:	e822                	sd	s0,16(sp)
    800033cc:	e426                	sd	s1,8(sp)
    800033ce:	1000                	addi	s0,sp,32
    800033d0:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800033d2:	00017517          	auipc	a0,0x17
    800033d6:	28650513          	addi	a0,a0,646 # 8001a658 <ftable>
    800033da:	466020ef          	jal	80005840 <acquire>
  if(f->ref < 1)
    800033de:	40dc                	lw	a5,4(s1)
    800033e0:	02f05063          	blez	a5,80003400 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800033e4:	2785                	addiw	a5,a5,1
    800033e6:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800033e8:	00017517          	auipc	a0,0x17
    800033ec:	27050513          	addi	a0,a0,624 # 8001a658 <ftable>
    800033f0:	4e8020ef          	jal	800058d8 <release>
  return f;
}
    800033f4:	8526                	mv	a0,s1
    800033f6:	60e2                	ld	ra,24(sp)
    800033f8:	6442                	ld	s0,16(sp)
    800033fa:	64a2                	ld	s1,8(sp)
    800033fc:	6105                	addi	sp,sp,32
    800033fe:	8082                	ret
    panic("filedup");
    80003400:	00004517          	auipc	a0,0x4
    80003404:	17050513          	addi	a0,a0,368 # 80007570 <etext+0x570>
    80003408:	10a020ef          	jal	80005512 <panic>

000000008000340c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000340c:	7139                	addi	sp,sp,-64
    8000340e:	fc06                	sd	ra,56(sp)
    80003410:	f822                	sd	s0,48(sp)
    80003412:	f426                	sd	s1,40(sp)
    80003414:	0080                	addi	s0,sp,64
    80003416:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003418:	00017517          	auipc	a0,0x17
    8000341c:	24050513          	addi	a0,a0,576 # 8001a658 <ftable>
    80003420:	420020ef          	jal	80005840 <acquire>
  if(f->ref < 1)
    80003424:	40dc                	lw	a5,4(s1)
    80003426:	04f05a63          	blez	a5,8000347a <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    8000342a:	37fd                	addiw	a5,a5,-1
    8000342c:	0007871b          	sext.w	a4,a5
    80003430:	c0dc                	sw	a5,4(s1)
    80003432:	04e04e63          	bgtz	a4,8000348e <fileclose+0x82>
    80003436:	f04a                	sd	s2,32(sp)
    80003438:	ec4e                	sd	s3,24(sp)
    8000343a:	e852                	sd	s4,16(sp)
    8000343c:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000343e:	0004a903          	lw	s2,0(s1)
    80003442:	0094ca83          	lbu	s5,9(s1)
    80003446:	0104ba03          	ld	s4,16(s1)
    8000344a:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000344e:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003452:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003456:	00017517          	auipc	a0,0x17
    8000345a:	20250513          	addi	a0,a0,514 # 8001a658 <ftable>
    8000345e:	47a020ef          	jal	800058d8 <release>

  if(ff.type == FD_PIPE){
    80003462:	4785                	li	a5,1
    80003464:	04f90063          	beq	s2,a5,800034a4 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003468:	3979                	addiw	s2,s2,-2
    8000346a:	4785                	li	a5,1
    8000346c:	0527f563          	bgeu	a5,s2,800034b6 <fileclose+0xaa>
    80003470:	7902                	ld	s2,32(sp)
    80003472:	69e2                	ld	s3,24(sp)
    80003474:	6a42                	ld	s4,16(sp)
    80003476:	6aa2                	ld	s5,8(sp)
    80003478:	a00d                	j	8000349a <fileclose+0x8e>
    8000347a:	f04a                	sd	s2,32(sp)
    8000347c:	ec4e                	sd	s3,24(sp)
    8000347e:	e852                	sd	s4,16(sp)
    80003480:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003482:	00004517          	auipc	a0,0x4
    80003486:	0f650513          	addi	a0,a0,246 # 80007578 <etext+0x578>
    8000348a:	088020ef          	jal	80005512 <panic>
    release(&ftable.lock);
    8000348e:	00017517          	auipc	a0,0x17
    80003492:	1ca50513          	addi	a0,a0,458 # 8001a658 <ftable>
    80003496:	442020ef          	jal	800058d8 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    8000349a:	70e2                	ld	ra,56(sp)
    8000349c:	7442                	ld	s0,48(sp)
    8000349e:	74a2                	ld	s1,40(sp)
    800034a0:	6121                	addi	sp,sp,64
    800034a2:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800034a4:	85d6                	mv	a1,s5
    800034a6:	8552                	mv	a0,s4
    800034a8:	336000ef          	jal	800037de <pipeclose>
    800034ac:	7902                	ld	s2,32(sp)
    800034ae:	69e2                	ld	s3,24(sp)
    800034b0:	6a42                	ld	s4,16(sp)
    800034b2:	6aa2                	ld	s5,8(sp)
    800034b4:	b7dd                	j	8000349a <fileclose+0x8e>
    begin_op();
    800034b6:	b3dff0ef          	jal	80002ff2 <begin_op>
    iput(ff.ip);
    800034ba:	854e                	mv	a0,s3
    800034bc:	c22ff0ef          	jal	800028de <iput>
    end_op();
    800034c0:	b9dff0ef          	jal	8000305c <end_op>
    800034c4:	7902                	ld	s2,32(sp)
    800034c6:	69e2                	ld	s3,24(sp)
    800034c8:	6a42                	ld	s4,16(sp)
    800034ca:	6aa2                	ld	s5,8(sp)
    800034cc:	b7f9                	j	8000349a <fileclose+0x8e>

00000000800034ce <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800034ce:	715d                	addi	sp,sp,-80
    800034d0:	e486                	sd	ra,72(sp)
    800034d2:	e0a2                	sd	s0,64(sp)
    800034d4:	fc26                	sd	s1,56(sp)
    800034d6:	f44e                	sd	s3,40(sp)
    800034d8:	0880                	addi	s0,sp,80
    800034da:	84aa                	mv	s1,a0
    800034dc:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800034de:	8c3fd0ef          	jal	80000da0 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800034e2:	409c                	lw	a5,0(s1)
    800034e4:	37f9                	addiw	a5,a5,-2
    800034e6:	4705                	li	a4,1
    800034e8:	04f76063          	bltu	a4,a5,80003528 <filestat+0x5a>
    800034ec:	f84a                	sd	s2,48(sp)
    800034ee:	892a                	mv	s2,a0
    ilock(f->ip);
    800034f0:	6c88                	ld	a0,24(s1)
    800034f2:	a6aff0ef          	jal	8000275c <ilock>
    stati(f->ip, &st);
    800034f6:	fb840593          	addi	a1,s0,-72
    800034fa:	6c88                	ld	a0,24(s1)
    800034fc:	c8aff0ef          	jal	80002986 <stati>
    iunlock(f->ip);
    80003500:	6c88                	ld	a0,24(s1)
    80003502:	b08ff0ef          	jal	8000280a <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003506:	46e1                	li	a3,24
    80003508:	fb840613          	addi	a2,s0,-72
    8000350c:	85ce                	mv	a1,s3
    8000350e:	05093503          	ld	a0,80(s2)
    80003512:	ce0fd0ef          	jal	800009f2 <copyout>
    80003516:	41f5551b          	sraiw	a0,a0,0x1f
    8000351a:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    8000351c:	60a6                	ld	ra,72(sp)
    8000351e:	6406                	ld	s0,64(sp)
    80003520:	74e2                	ld	s1,56(sp)
    80003522:	79a2                	ld	s3,40(sp)
    80003524:	6161                	addi	sp,sp,80
    80003526:	8082                	ret
  return -1;
    80003528:	557d                	li	a0,-1
    8000352a:	bfcd                	j	8000351c <filestat+0x4e>

000000008000352c <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    8000352c:	7179                	addi	sp,sp,-48
    8000352e:	f406                	sd	ra,40(sp)
    80003530:	f022                	sd	s0,32(sp)
    80003532:	e84a                	sd	s2,16(sp)
    80003534:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003536:	00854783          	lbu	a5,8(a0)
    8000353a:	cfd1                	beqz	a5,800035d6 <fileread+0xaa>
    8000353c:	ec26                	sd	s1,24(sp)
    8000353e:	e44e                	sd	s3,8(sp)
    80003540:	84aa                	mv	s1,a0
    80003542:	89ae                	mv	s3,a1
    80003544:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003546:	411c                	lw	a5,0(a0)
    80003548:	4705                	li	a4,1
    8000354a:	04e78363          	beq	a5,a4,80003590 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000354e:	470d                	li	a4,3
    80003550:	04e78763          	beq	a5,a4,8000359e <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003554:	4709                	li	a4,2
    80003556:	06e79a63          	bne	a5,a4,800035ca <fileread+0x9e>
    ilock(f->ip);
    8000355a:	6d08                	ld	a0,24(a0)
    8000355c:	a00ff0ef          	jal	8000275c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003560:	874a                	mv	a4,s2
    80003562:	5094                	lw	a3,32(s1)
    80003564:	864e                	mv	a2,s3
    80003566:	4585                	li	a1,1
    80003568:	6c88                	ld	a0,24(s1)
    8000356a:	c46ff0ef          	jal	800029b0 <readi>
    8000356e:	892a                	mv	s2,a0
    80003570:	00a05563          	blez	a0,8000357a <fileread+0x4e>
      f->off += r;
    80003574:	509c                	lw	a5,32(s1)
    80003576:	9fa9                	addw	a5,a5,a0
    80003578:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000357a:	6c88                	ld	a0,24(s1)
    8000357c:	a8eff0ef          	jal	8000280a <iunlock>
    80003580:	64e2                	ld	s1,24(sp)
    80003582:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003584:	854a                	mv	a0,s2
    80003586:	70a2                	ld	ra,40(sp)
    80003588:	7402                	ld	s0,32(sp)
    8000358a:	6942                	ld	s2,16(sp)
    8000358c:	6145                	addi	sp,sp,48
    8000358e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003590:	6908                	ld	a0,16(a0)
    80003592:	388000ef          	jal	8000391a <piperead>
    80003596:	892a                	mv	s2,a0
    80003598:	64e2                	ld	s1,24(sp)
    8000359a:	69a2                	ld	s3,8(sp)
    8000359c:	b7e5                	j	80003584 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000359e:	02451783          	lh	a5,36(a0)
    800035a2:	03079693          	slli	a3,a5,0x30
    800035a6:	92c1                	srli	a3,a3,0x30
    800035a8:	4725                	li	a4,9
    800035aa:	02d76863          	bltu	a4,a3,800035da <fileread+0xae>
    800035ae:	0792                	slli	a5,a5,0x4
    800035b0:	00017717          	auipc	a4,0x17
    800035b4:	00870713          	addi	a4,a4,8 # 8001a5b8 <devsw>
    800035b8:	97ba                	add	a5,a5,a4
    800035ba:	639c                	ld	a5,0(a5)
    800035bc:	c39d                	beqz	a5,800035e2 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    800035be:	4505                	li	a0,1
    800035c0:	9782                	jalr	a5
    800035c2:	892a                	mv	s2,a0
    800035c4:	64e2                	ld	s1,24(sp)
    800035c6:	69a2                	ld	s3,8(sp)
    800035c8:	bf75                	j	80003584 <fileread+0x58>
    panic("fileread");
    800035ca:	00004517          	auipc	a0,0x4
    800035ce:	fbe50513          	addi	a0,a0,-66 # 80007588 <etext+0x588>
    800035d2:	741010ef          	jal	80005512 <panic>
    return -1;
    800035d6:	597d                	li	s2,-1
    800035d8:	b775                	j	80003584 <fileread+0x58>
      return -1;
    800035da:	597d                	li	s2,-1
    800035dc:	64e2                	ld	s1,24(sp)
    800035de:	69a2                	ld	s3,8(sp)
    800035e0:	b755                	j	80003584 <fileread+0x58>
    800035e2:	597d                	li	s2,-1
    800035e4:	64e2                	ld	s1,24(sp)
    800035e6:	69a2                	ld	s3,8(sp)
    800035e8:	bf71                	j	80003584 <fileread+0x58>

00000000800035ea <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800035ea:	00954783          	lbu	a5,9(a0)
    800035ee:	10078b63          	beqz	a5,80003704 <filewrite+0x11a>
{
    800035f2:	715d                	addi	sp,sp,-80
    800035f4:	e486                	sd	ra,72(sp)
    800035f6:	e0a2                	sd	s0,64(sp)
    800035f8:	f84a                	sd	s2,48(sp)
    800035fa:	f052                	sd	s4,32(sp)
    800035fc:	e85a                	sd	s6,16(sp)
    800035fe:	0880                	addi	s0,sp,80
    80003600:	892a                	mv	s2,a0
    80003602:	8b2e                	mv	s6,a1
    80003604:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003606:	411c                	lw	a5,0(a0)
    80003608:	4705                	li	a4,1
    8000360a:	02e78763          	beq	a5,a4,80003638 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000360e:	470d                	li	a4,3
    80003610:	02e78863          	beq	a5,a4,80003640 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003614:	4709                	li	a4,2
    80003616:	0ce79c63          	bne	a5,a4,800036ee <filewrite+0x104>
    8000361a:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    8000361c:	0ac05863          	blez	a2,800036cc <filewrite+0xe2>
    80003620:	fc26                	sd	s1,56(sp)
    80003622:	ec56                	sd	s5,24(sp)
    80003624:	e45e                	sd	s7,8(sp)
    80003626:	e062                	sd	s8,0(sp)
    int i = 0;
    80003628:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    8000362a:	6b85                	lui	s7,0x1
    8000362c:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003630:	6c05                	lui	s8,0x1
    80003632:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003636:	a8b5                	j	800036b2 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    80003638:	6908                	ld	a0,16(a0)
    8000363a:	1fc000ef          	jal	80003836 <pipewrite>
    8000363e:	a04d                	j	800036e0 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003640:	02451783          	lh	a5,36(a0)
    80003644:	03079693          	slli	a3,a5,0x30
    80003648:	92c1                	srli	a3,a3,0x30
    8000364a:	4725                	li	a4,9
    8000364c:	0ad76e63          	bltu	a4,a3,80003708 <filewrite+0x11e>
    80003650:	0792                	slli	a5,a5,0x4
    80003652:	00017717          	auipc	a4,0x17
    80003656:	f6670713          	addi	a4,a4,-154 # 8001a5b8 <devsw>
    8000365a:	97ba                	add	a5,a5,a4
    8000365c:	679c                	ld	a5,8(a5)
    8000365e:	c7dd                	beqz	a5,8000370c <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    80003660:	4505                	li	a0,1
    80003662:	9782                	jalr	a5
    80003664:	a8b5                	j	800036e0 <filewrite+0xf6>
      if(n1 > max)
    80003666:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    8000366a:	989ff0ef          	jal	80002ff2 <begin_op>
      ilock(f->ip);
    8000366e:	01893503          	ld	a0,24(s2)
    80003672:	8eaff0ef          	jal	8000275c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003676:	8756                	mv	a4,s5
    80003678:	02092683          	lw	a3,32(s2)
    8000367c:	01698633          	add	a2,s3,s6
    80003680:	4585                	li	a1,1
    80003682:	01893503          	ld	a0,24(s2)
    80003686:	c26ff0ef          	jal	80002aac <writei>
    8000368a:	84aa                	mv	s1,a0
    8000368c:	00a05763          	blez	a0,8000369a <filewrite+0xb0>
        f->off += r;
    80003690:	02092783          	lw	a5,32(s2)
    80003694:	9fa9                	addw	a5,a5,a0
    80003696:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000369a:	01893503          	ld	a0,24(s2)
    8000369e:	96cff0ef          	jal	8000280a <iunlock>
      end_op();
    800036a2:	9bbff0ef          	jal	8000305c <end_op>

      if(r != n1){
    800036a6:	029a9563          	bne	s5,s1,800036d0 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    800036aa:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800036ae:	0149da63          	bge	s3,s4,800036c2 <filewrite+0xd8>
      int n1 = n - i;
    800036b2:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    800036b6:	0004879b          	sext.w	a5,s1
    800036ba:	fafbd6e3          	bge	s7,a5,80003666 <filewrite+0x7c>
    800036be:	84e2                	mv	s1,s8
    800036c0:	b75d                	j	80003666 <filewrite+0x7c>
    800036c2:	74e2                	ld	s1,56(sp)
    800036c4:	6ae2                	ld	s5,24(sp)
    800036c6:	6ba2                	ld	s7,8(sp)
    800036c8:	6c02                	ld	s8,0(sp)
    800036ca:	a039                	j	800036d8 <filewrite+0xee>
    int i = 0;
    800036cc:	4981                	li	s3,0
    800036ce:	a029                	j	800036d8 <filewrite+0xee>
    800036d0:	74e2                	ld	s1,56(sp)
    800036d2:	6ae2                	ld	s5,24(sp)
    800036d4:	6ba2                	ld	s7,8(sp)
    800036d6:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    800036d8:	033a1c63          	bne	s4,s3,80003710 <filewrite+0x126>
    800036dc:	8552                	mv	a0,s4
    800036de:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800036e0:	60a6                	ld	ra,72(sp)
    800036e2:	6406                	ld	s0,64(sp)
    800036e4:	7942                	ld	s2,48(sp)
    800036e6:	7a02                	ld	s4,32(sp)
    800036e8:	6b42                	ld	s6,16(sp)
    800036ea:	6161                	addi	sp,sp,80
    800036ec:	8082                	ret
    800036ee:	fc26                	sd	s1,56(sp)
    800036f0:	f44e                	sd	s3,40(sp)
    800036f2:	ec56                	sd	s5,24(sp)
    800036f4:	e45e                	sd	s7,8(sp)
    800036f6:	e062                	sd	s8,0(sp)
    panic("filewrite");
    800036f8:	00004517          	auipc	a0,0x4
    800036fc:	ea050513          	addi	a0,a0,-352 # 80007598 <etext+0x598>
    80003700:	613010ef          	jal	80005512 <panic>
    return -1;
    80003704:	557d                	li	a0,-1
}
    80003706:	8082                	ret
      return -1;
    80003708:	557d                	li	a0,-1
    8000370a:	bfd9                	j	800036e0 <filewrite+0xf6>
    8000370c:	557d                	li	a0,-1
    8000370e:	bfc9                	j	800036e0 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    80003710:	557d                	li	a0,-1
    80003712:	79a2                	ld	s3,40(sp)
    80003714:	b7f1                	j	800036e0 <filewrite+0xf6>

0000000080003716 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003716:	7179                	addi	sp,sp,-48
    80003718:	f406                	sd	ra,40(sp)
    8000371a:	f022                	sd	s0,32(sp)
    8000371c:	ec26                	sd	s1,24(sp)
    8000371e:	e052                	sd	s4,0(sp)
    80003720:	1800                	addi	s0,sp,48
    80003722:	84aa                	mv	s1,a0
    80003724:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003726:	0005b023          	sd	zero,0(a1)
    8000372a:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8000372e:	c3bff0ef          	jal	80003368 <filealloc>
    80003732:	e088                	sd	a0,0(s1)
    80003734:	c549                	beqz	a0,800037be <pipealloc+0xa8>
    80003736:	c33ff0ef          	jal	80003368 <filealloc>
    8000373a:	00aa3023          	sd	a0,0(s4)
    8000373e:	cd25                	beqz	a0,800037b6 <pipealloc+0xa0>
    80003740:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003742:	9bdfc0ef          	jal	800000fe <kalloc>
    80003746:	892a                	mv	s2,a0
    80003748:	c12d                	beqz	a0,800037aa <pipealloc+0x94>
    8000374a:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    8000374c:	4985                	li	s3,1
    8000374e:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003752:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003756:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000375a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000375e:	00004597          	auipc	a1,0x4
    80003762:	e4a58593          	addi	a1,a1,-438 # 800075a8 <etext+0x5a8>
    80003766:	05a020ef          	jal	800057c0 <initlock>
  (*f0)->type = FD_PIPE;
    8000376a:	609c                	ld	a5,0(s1)
    8000376c:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003770:	609c                	ld	a5,0(s1)
    80003772:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003776:	609c                	ld	a5,0(s1)
    80003778:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000377c:	609c                	ld	a5,0(s1)
    8000377e:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003782:	000a3783          	ld	a5,0(s4)
    80003786:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000378a:	000a3783          	ld	a5,0(s4)
    8000378e:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003792:	000a3783          	ld	a5,0(s4)
    80003796:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000379a:	000a3783          	ld	a5,0(s4)
    8000379e:	0127b823          	sd	s2,16(a5)
  return 0;
    800037a2:	4501                	li	a0,0
    800037a4:	6942                	ld	s2,16(sp)
    800037a6:	69a2                	ld	s3,8(sp)
    800037a8:	a01d                	j	800037ce <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800037aa:	6088                	ld	a0,0(s1)
    800037ac:	c119                	beqz	a0,800037b2 <pipealloc+0x9c>
    800037ae:	6942                	ld	s2,16(sp)
    800037b0:	a029                	j	800037ba <pipealloc+0xa4>
    800037b2:	6942                	ld	s2,16(sp)
    800037b4:	a029                	j	800037be <pipealloc+0xa8>
    800037b6:	6088                	ld	a0,0(s1)
    800037b8:	c10d                	beqz	a0,800037da <pipealloc+0xc4>
    fileclose(*f0);
    800037ba:	c53ff0ef          	jal	8000340c <fileclose>
  if(*f1)
    800037be:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800037c2:	557d                	li	a0,-1
  if(*f1)
    800037c4:	c789                	beqz	a5,800037ce <pipealloc+0xb8>
    fileclose(*f1);
    800037c6:	853e                	mv	a0,a5
    800037c8:	c45ff0ef          	jal	8000340c <fileclose>
  return -1;
    800037cc:	557d                	li	a0,-1
}
    800037ce:	70a2                	ld	ra,40(sp)
    800037d0:	7402                	ld	s0,32(sp)
    800037d2:	64e2                	ld	s1,24(sp)
    800037d4:	6a02                	ld	s4,0(sp)
    800037d6:	6145                	addi	sp,sp,48
    800037d8:	8082                	ret
  return -1;
    800037da:	557d                	li	a0,-1
    800037dc:	bfcd                	j	800037ce <pipealloc+0xb8>

00000000800037de <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800037de:	1101                	addi	sp,sp,-32
    800037e0:	ec06                	sd	ra,24(sp)
    800037e2:	e822                	sd	s0,16(sp)
    800037e4:	e426                	sd	s1,8(sp)
    800037e6:	e04a                	sd	s2,0(sp)
    800037e8:	1000                	addi	s0,sp,32
    800037ea:	84aa                	mv	s1,a0
    800037ec:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800037ee:	052020ef          	jal	80005840 <acquire>
  if(writable){
    800037f2:	02090763          	beqz	s2,80003820 <pipeclose+0x42>
    pi->writeopen = 0;
    800037f6:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800037fa:	21848513          	addi	a0,s1,536
    800037fe:	c45fd0ef          	jal	80001442 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003802:	2204b783          	ld	a5,544(s1)
    80003806:	e785                	bnez	a5,8000382e <pipeclose+0x50>
    release(&pi->lock);
    80003808:	8526                	mv	a0,s1
    8000380a:	0ce020ef          	jal	800058d8 <release>
    kfree((char*)pi);
    8000380e:	8526                	mv	a0,s1
    80003810:	80dfc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003814:	60e2                	ld	ra,24(sp)
    80003816:	6442                	ld	s0,16(sp)
    80003818:	64a2                	ld	s1,8(sp)
    8000381a:	6902                	ld	s2,0(sp)
    8000381c:	6105                	addi	sp,sp,32
    8000381e:	8082                	ret
    pi->readopen = 0;
    80003820:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003824:	21c48513          	addi	a0,s1,540
    80003828:	c1bfd0ef          	jal	80001442 <wakeup>
    8000382c:	bfd9                	j	80003802 <pipeclose+0x24>
    release(&pi->lock);
    8000382e:	8526                	mv	a0,s1
    80003830:	0a8020ef          	jal	800058d8 <release>
}
    80003834:	b7c5                	j	80003814 <pipeclose+0x36>

0000000080003836 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003836:	711d                	addi	sp,sp,-96
    80003838:	ec86                	sd	ra,88(sp)
    8000383a:	e8a2                	sd	s0,80(sp)
    8000383c:	e4a6                	sd	s1,72(sp)
    8000383e:	e0ca                	sd	s2,64(sp)
    80003840:	fc4e                	sd	s3,56(sp)
    80003842:	f852                	sd	s4,48(sp)
    80003844:	f456                	sd	s5,40(sp)
    80003846:	1080                	addi	s0,sp,96
    80003848:	84aa                	mv	s1,a0
    8000384a:	8aae                	mv	s5,a1
    8000384c:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000384e:	d52fd0ef          	jal	80000da0 <myproc>
    80003852:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003854:	8526                	mv	a0,s1
    80003856:	7eb010ef          	jal	80005840 <acquire>
  while(i < n){
    8000385a:	0b405a63          	blez	s4,8000390e <pipewrite+0xd8>
    8000385e:	f05a                	sd	s6,32(sp)
    80003860:	ec5e                	sd	s7,24(sp)
    80003862:	e862                	sd	s8,16(sp)
  int i = 0;
    80003864:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003866:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003868:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000386c:	21c48b93          	addi	s7,s1,540
    80003870:	a81d                	j	800038a6 <pipewrite+0x70>
      release(&pi->lock);
    80003872:	8526                	mv	a0,s1
    80003874:	064020ef          	jal	800058d8 <release>
      return -1;
    80003878:	597d                	li	s2,-1
    8000387a:	7b02                	ld	s6,32(sp)
    8000387c:	6be2                	ld	s7,24(sp)
    8000387e:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003880:	854a                	mv	a0,s2
    80003882:	60e6                	ld	ra,88(sp)
    80003884:	6446                	ld	s0,80(sp)
    80003886:	64a6                	ld	s1,72(sp)
    80003888:	6906                	ld	s2,64(sp)
    8000388a:	79e2                	ld	s3,56(sp)
    8000388c:	7a42                	ld	s4,48(sp)
    8000388e:	7aa2                	ld	s5,40(sp)
    80003890:	6125                	addi	sp,sp,96
    80003892:	8082                	ret
      wakeup(&pi->nread);
    80003894:	8562                	mv	a0,s8
    80003896:	badfd0ef          	jal	80001442 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000389a:	85a6                	mv	a1,s1
    8000389c:	855e                	mv	a0,s7
    8000389e:	b59fd0ef          	jal	800013f6 <sleep>
  while(i < n){
    800038a2:	05495b63          	bge	s2,s4,800038f8 <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    800038a6:	2204a783          	lw	a5,544(s1)
    800038aa:	d7e1                	beqz	a5,80003872 <pipewrite+0x3c>
    800038ac:	854e                	mv	a0,s3
    800038ae:	d81fd0ef          	jal	8000162e <killed>
    800038b2:	f161                	bnez	a0,80003872 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800038b4:	2184a783          	lw	a5,536(s1)
    800038b8:	21c4a703          	lw	a4,540(s1)
    800038bc:	2007879b          	addiw	a5,a5,512
    800038c0:	fcf70ae3          	beq	a4,a5,80003894 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800038c4:	4685                	li	a3,1
    800038c6:	01590633          	add	a2,s2,s5
    800038ca:	faf40593          	addi	a1,s0,-81
    800038ce:	0509b503          	ld	a0,80(s3)
    800038d2:	9f8fd0ef          	jal	80000aca <copyin>
    800038d6:	03650e63          	beq	a0,s6,80003912 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800038da:	21c4a783          	lw	a5,540(s1)
    800038de:	0017871b          	addiw	a4,a5,1
    800038e2:	20e4ae23          	sw	a4,540(s1)
    800038e6:	1ff7f793          	andi	a5,a5,511
    800038ea:	97a6                	add	a5,a5,s1
    800038ec:	faf44703          	lbu	a4,-81(s0)
    800038f0:	00e78c23          	sb	a4,24(a5)
      i++;
    800038f4:	2905                	addiw	s2,s2,1
    800038f6:	b775                	j	800038a2 <pipewrite+0x6c>
    800038f8:	7b02                	ld	s6,32(sp)
    800038fa:	6be2                	ld	s7,24(sp)
    800038fc:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    800038fe:	21848513          	addi	a0,s1,536
    80003902:	b41fd0ef          	jal	80001442 <wakeup>
  release(&pi->lock);
    80003906:	8526                	mv	a0,s1
    80003908:	7d1010ef          	jal	800058d8 <release>
  return i;
    8000390c:	bf95                	j	80003880 <pipewrite+0x4a>
  int i = 0;
    8000390e:	4901                	li	s2,0
    80003910:	b7fd                	j	800038fe <pipewrite+0xc8>
    80003912:	7b02                	ld	s6,32(sp)
    80003914:	6be2                	ld	s7,24(sp)
    80003916:	6c42                	ld	s8,16(sp)
    80003918:	b7dd                	j	800038fe <pipewrite+0xc8>

000000008000391a <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000391a:	715d                	addi	sp,sp,-80
    8000391c:	e486                	sd	ra,72(sp)
    8000391e:	e0a2                	sd	s0,64(sp)
    80003920:	fc26                	sd	s1,56(sp)
    80003922:	f84a                	sd	s2,48(sp)
    80003924:	f44e                	sd	s3,40(sp)
    80003926:	f052                	sd	s4,32(sp)
    80003928:	ec56                	sd	s5,24(sp)
    8000392a:	0880                	addi	s0,sp,80
    8000392c:	84aa                	mv	s1,a0
    8000392e:	892e                	mv	s2,a1
    80003930:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003932:	c6efd0ef          	jal	80000da0 <myproc>
    80003936:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003938:	8526                	mv	a0,s1
    8000393a:	707010ef          	jal	80005840 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000393e:	2184a703          	lw	a4,536(s1)
    80003942:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003946:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000394a:	02f71563          	bne	a4,a5,80003974 <piperead+0x5a>
    8000394e:	2244a783          	lw	a5,548(s1)
    80003952:	cb85                	beqz	a5,80003982 <piperead+0x68>
    if(killed(pr)){
    80003954:	8552                	mv	a0,s4
    80003956:	cd9fd0ef          	jal	8000162e <killed>
    8000395a:	ed19                	bnez	a0,80003978 <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000395c:	85a6                	mv	a1,s1
    8000395e:	854e                	mv	a0,s3
    80003960:	a97fd0ef          	jal	800013f6 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003964:	2184a703          	lw	a4,536(s1)
    80003968:	21c4a783          	lw	a5,540(s1)
    8000396c:	fef701e3          	beq	a4,a5,8000394e <piperead+0x34>
    80003970:	e85a                	sd	s6,16(sp)
    80003972:	a809                	j	80003984 <piperead+0x6a>
    80003974:	e85a                	sd	s6,16(sp)
    80003976:	a039                	j	80003984 <piperead+0x6a>
      release(&pi->lock);
    80003978:	8526                	mv	a0,s1
    8000397a:	75f010ef          	jal	800058d8 <release>
      return -1;
    8000397e:	59fd                	li	s3,-1
    80003980:	a8b1                	j	800039dc <piperead+0xc2>
    80003982:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003984:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003986:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003988:	05505263          	blez	s5,800039cc <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    8000398c:	2184a783          	lw	a5,536(s1)
    80003990:	21c4a703          	lw	a4,540(s1)
    80003994:	02f70c63          	beq	a4,a5,800039cc <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003998:	0017871b          	addiw	a4,a5,1
    8000399c:	20e4ac23          	sw	a4,536(s1)
    800039a0:	1ff7f793          	andi	a5,a5,511
    800039a4:	97a6                	add	a5,a5,s1
    800039a6:	0187c783          	lbu	a5,24(a5)
    800039aa:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800039ae:	4685                	li	a3,1
    800039b0:	fbf40613          	addi	a2,s0,-65
    800039b4:	85ca                	mv	a1,s2
    800039b6:	050a3503          	ld	a0,80(s4)
    800039ba:	838fd0ef          	jal	800009f2 <copyout>
    800039be:	01650763          	beq	a0,s6,800039cc <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800039c2:	2985                	addiw	s3,s3,1
    800039c4:	0905                	addi	s2,s2,1
    800039c6:	fd3a93e3          	bne	s5,s3,8000398c <piperead+0x72>
    800039ca:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800039cc:	21c48513          	addi	a0,s1,540
    800039d0:	a73fd0ef          	jal	80001442 <wakeup>
  release(&pi->lock);
    800039d4:	8526                	mv	a0,s1
    800039d6:	703010ef          	jal	800058d8 <release>
    800039da:	6b42                	ld	s6,16(sp)
  return i;
}
    800039dc:	854e                	mv	a0,s3
    800039de:	60a6                	ld	ra,72(sp)
    800039e0:	6406                	ld	s0,64(sp)
    800039e2:	74e2                	ld	s1,56(sp)
    800039e4:	7942                	ld	s2,48(sp)
    800039e6:	79a2                	ld	s3,40(sp)
    800039e8:	7a02                	ld	s4,32(sp)
    800039ea:	6ae2                	ld	s5,24(sp)
    800039ec:	6161                	addi	sp,sp,80
    800039ee:	8082                	ret

00000000800039f0 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800039f0:	1141                	addi	sp,sp,-16
    800039f2:	e422                	sd	s0,8(sp)
    800039f4:	0800                	addi	s0,sp,16
    800039f6:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800039f8:	8905                	andi	a0,a0,1
    800039fa:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800039fc:	8b89                	andi	a5,a5,2
    800039fe:	c399                	beqz	a5,80003a04 <flags2perm+0x14>
      perm |= PTE_W;
    80003a00:	00456513          	ori	a0,a0,4
    return perm;
}
    80003a04:	6422                	ld	s0,8(sp)
    80003a06:	0141                	addi	sp,sp,16
    80003a08:	8082                	ret

0000000080003a0a <exec>:

int
exec(char *path, char **argv)
{
    80003a0a:	df010113          	addi	sp,sp,-528
    80003a0e:	20113423          	sd	ra,520(sp)
    80003a12:	20813023          	sd	s0,512(sp)
    80003a16:	ffa6                	sd	s1,504(sp)
    80003a18:	fbca                	sd	s2,496(sp)
    80003a1a:	0c00                	addi	s0,sp,528
    80003a1c:	892a                	mv	s2,a0
    80003a1e:	dea43c23          	sd	a0,-520(s0)
    80003a22:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003a26:	b7afd0ef          	jal	80000da0 <myproc>
    80003a2a:	84aa                	mv	s1,a0

  begin_op();
    80003a2c:	dc6ff0ef          	jal	80002ff2 <begin_op>

  if((ip = namei(path)) == 0){
    80003a30:	854a                	mv	a0,s2
    80003a32:	c04ff0ef          	jal	80002e36 <namei>
    80003a36:	c931                	beqz	a0,80003a8a <exec+0x80>
    80003a38:	f3d2                	sd	s4,480(sp)
    80003a3a:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003a3c:	d21fe0ef          	jal	8000275c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003a40:	04000713          	li	a4,64
    80003a44:	4681                	li	a3,0
    80003a46:	e5040613          	addi	a2,s0,-432
    80003a4a:	4581                	li	a1,0
    80003a4c:	8552                	mv	a0,s4
    80003a4e:	f63fe0ef          	jal	800029b0 <readi>
    80003a52:	04000793          	li	a5,64
    80003a56:	00f51a63          	bne	a0,a5,80003a6a <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80003a5a:	e5042703          	lw	a4,-432(s0)
    80003a5e:	464c47b7          	lui	a5,0x464c4
    80003a62:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003a66:	02f70663          	beq	a4,a5,80003a92 <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003a6a:	8552                	mv	a0,s4
    80003a6c:	efbfe0ef          	jal	80002966 <iunlockput>
    end_op();
    80003a70:	decff0ef          	jal	8000305c <end_op>
  }
  return -1;
    80003a74:	557d                	li	a0,-1
    80003a76:	7a1e                	ld	s4,480(sp)
}
    80003a78:	20813083          	ld	ra,520(sp)
    80003a7c:	20013403          	ld	s0,512(sp)
    80003a80:	74fe                	ld	s1,504(sp)
    80003a82:	795e                	ld	s2,496(sp)
    80003a84:	21010113          	addi	sp,sp,528
    80003a88:	8082                	ret
    end_op();
    80003a8a:	dd2ff0ef          	jal	8000305c <end_op>
    return -1;
    80003a8e:	557d                	li	a0,-1
    80003a90:	b7e5                	j	80003a78 <exec+0x6e>
    80003a92:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003a94:	8526                	mv	a0,s1
    80003a96:	bb2fd0ef          	jal	80000e48 <proc_pagetable>
    80003a9a:	8b2a                	mv	s6,a0
    80003a9c:	2c050b63          	beqz	a0,80003d72 <exec+0x368>
    80003aa0:	f7ce                	sd	s3,488(sp)
    80003aa2:	efd6                	sd	s5,472(sp)
    80003aa4:	e7de                	sd	s7,456(sp)
    80003aa6:	e3e2                	sd	s8,448(sp)
    80003aa8:	ff66                	sd	s9,440(sp)
    80003aaa:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003aac:	e7042d03          	lw	s10,-400(s0)
    80003ab0:	e8845783          	lhu	a5,-376(s0)
    80003ab4:	12078963          	beqz	a5,80003be6 <exec+0x1dc>
    80003ab8:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003aba:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003abc:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80003abe:	6c85                	lui	s9,0x1
    80003ac0:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003ac4:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003ac8:	6a85                	lui	s5,0x1
    80003aca:	a085                	j	80003b2a <exec+0x120>
      panic("loadseg: address should exist");
    80003acc:	00004517          	auipc	a0,0x4
    80003ad0:	ae450513          	addi	a0,a0,-1308 # 800075b0 <etext+0x5b0>
    80003ad4:	23f010ef          	jal	80005512 <panic>
    if(sz - i < PGSIZE)
    80003ad8:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003ada:	8726                	mv	a4,s1
    80003adc:	012c06bb          	addw	a3,s8,s2
    80003ae0:	4581                	li	a1,0
    80003ae2:	8552                	mv	a0,s4
    80003ae4:	ecdfe0ef          	jal	800029b0 <readi>
    80003ae8:	2501                	sext.w	a0,a0
    80003aea:	24a49a63          	bne	s1,a0,80003d3e <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80003aee:	012a893b          	addw	s2,s5,s2
    80003af2:	03397363          	bgeu	s2,s3,80003b18 <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80003af6:	02091593          	slli	a1,s2,0x20
    80003afa:	9181                	srli	a1,a1,0x20
    80003afc:	95de                	add	a1,a1,s7
    80003afe:	855a                	mv	a0,s6
    80003b00:	967fc0ef          	jal	80000466 <walkaddr>
    80003b04:	862a                	mv	a2,a0
    if(pa == 0)
    80003b06:	d179                	beqz	a0,80003acc <exec+0xc2>
    if(sz - i < PGSIZE)
    80003b08:	412984bb          	subw	s1,s3,s2
    80003b0c:	0004879b          	sext.w	a5,s1
    80003b10:	fcfcf4e3          	bgeu	s9,a5,80003ad8 <exec+0xce>
    80003b14:	84d6                	mv	s1,s5
    80003b16:	b7c9                	j	80003ad8 <exec+0xce>
    sz = sz1;
    80003b18:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b1c:	2d85                	addiw	s11,s11,1
    80003b1e:	038d0d1b          	addiw	s10,s10,56
    80003b22:	e8845783          	lhu	a5,-376(s0)
    80003b26:	08fdd063          	bge	s11,a5,80003ba6 <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003b2a:	2d01                	sext.w	s10,s10
    80003b2c:	03800713          	li	a4,56
    80003b30:	86ea                	mv	a3,s10
    80003b32:	e1840613          	addi	a2,s0,-488
    80003b36:	4581                	li	a1,0
    80003b38:	8552                	mv	a0,s4
    80003b3a:	e77fe0ef          	jal	800029b0 <readi>
    80003b3e:	03800793          	li	a5,56
    80003b42:	1cf51663          	bne	a0,a5,80003d0e <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80003b46:	e1842783          	lw	a5,-488(s0)
    80003b4a:	4705                	li	a4,1
    80003b4c:	fce798e3          	bne	a5,a4,80003b1c <exec+0x112>
    if(ph.memsz < ph.filesz)
    80003b50:	e4043483          	ld	s1,-448(s0)
    80003b54:	e3843783          	ld	a5,-456(s0)
    80003b58:	1af4ef63          	bltu	s1,a5,80003d16 <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003b5c:	e2843783          	ld	a5,-472(s0)
    80003b60:	94be                	add	s1,s1,a5
    80003b62:	1af4ee63          	bltu	s1,a5,80003d1e <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80003b66:	df043703          	ld	a4,-528(s0)
    80003b6a:	8ff9                	and	a5,a5,a4
    80003b6c:	1a079d63          	bnez	a5,80003d26 <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003b70:	e1c42503          	lw	a0,-484(s0)
    80003b74:	e7dff0ef          	jal	800039f0 <flags2perm>
    80003b78:	86aa                	mv	a3,a0
    80003b7a:	8626                	mv	a2,s1
    80003b7c:	85ca                	mv	a1,s2
    80003b7e:	855a                	mv	a0,s6
    80003b80:	c5ffc0ef          	jal	800007de <uvmalloc>
    80003b84:	e0a43423          	sd	a0,-504(s0)
    80003b88:	1a050363          	beqz	a0,80003d2e <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003b8c:	e2843b83          	ld	s7,-472(s0)
    80003b90:	e2042c03          	lw	s8,-480(s0)
    80003b94:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003b98:	00098463          	beqz	s3,80003ba0 <exec+0x196>
    80003b9c:	4901                	li	s2,0
    80003b9e:	bfa1                	j	80003af6 <exec+0xec>
    sz = sz1;
    80003ba0:	e0843903          	ld	s2,-504(s0)
    80003ba4:	bfa5                	j	80003b1c <exec+0x112>
    80003ba6:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80003ba8:	8552                	mv	a0,s4
    80003baa:	dbdfe0ef          	jal	80002966 <iunlockput>
  end_op();
    80003bae:	caeff0ef          	jal	8000305c <end_op>
  p = myproc();
    80003bb2:	9eefd0ef          	jal	80000da0 <myproc>
    80003bb6:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003bb8:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80003bbc:	6985                	lui	s3,0x1
    80003bbe:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003bc0:	99ca                	add	s3,s3,s2
    80003bc2:	77fd                	lui	a5,0xfffff
    80003bc4:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003bc8:	4691                	li	a3,4
    80003bca:	6609                	lui	a2,0x2
    80003bcc:	964e                	add	a2,a2,s3
    80003bce:	85ce                	mv	a1,s3
    80003bd0:	855a                	mv	a0,s6
    80003bd2:	c0dfc0ef          	jal	800007de <uvmalloc>
    80003bd6:	892a                	mv	s2,a0
    80003bd8:	e0a43423          	sd	a0,-504(s0)
    80003bdc:	e519                	bnez	a0,80003bea <exec+0x1e0>
  if(pagetable)
    80003bde:	e1343423          	sd	s3,-504(s0)
    80003be2:	4a01                	li	s4,0
    80003be4:	aab1                	j	80003d40 <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003be6:	4901                	li	s2,0
    80003be8:	b7c1                	j	80003ba8 <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003bea:	75f9                	lui	a1,0xffffe
    80003bec:	95aa                	add	a1,a1,a0
    80003bee:	855a                	mv	a0,s6
    80003bf0:	dd9fc0ef          	jal	800009c8 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003bf4:	7bfd                	lui	s7,0xfffff
    80003bf6:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80003bf8:	e0043783          	ld	a5,-512(s0)
    80003bfc:	6388                	ld	a0,0(a5)
    80003bfe:	cd39                	beqz	a0,80003c5c <exec+0x252>
    80003c00:	e9040993          	addi	s3,s0,-368
    80003c04:	f9040c13          	addi	s8,s0,-112
    80003c08:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80003c0a:	eb4fc0ef          	jal	800002be <strlen>
    80003c0e:	0015079b          	addiw	a5,a0,1
    80003c12:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003c16:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003c1a:	11796e63          	bltu	s2,s7,80003d36 <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003c1e:	e0043d03          	ld	s10,-512(s0)
    80003c22:	000d3a03          	ld	s4,0(s10)
    80003c26:	8552                	mv	a0,s4
    80003c28:	e96fc0ef          	jal	800002be <strlen>
    80003c2c:	0015069b          	addiw	a3,a0,1
    80003c30:	8652                	mv	a2,s4
    80003c32:	85ca                	mv	a1,s2
    80003c34:	855a                	mv	a0,s6
    80003c36:	dbdfc0ef          	jal	800009f2 <copyout>
    80003c3a:	10054063          	bltz	a0,80003d3a <exec+0x330>
    ustack[argc] = sp;
    80003c3e:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80003c42:	0485                	addi	s1,s1,1
    80003c44:	008d0793          	addi	a5,s10,8
    80003c48:	e0f43023          	sd	a5,-512(s0)
    80003c4c:	008d3503          	ld	a0,8(s10)
    80003c50:	c909                	beqz	a0,80003c62 <exec+0x258>
    if(argc >= MAXARG)
    80003c52:	09a1                	addi	s3,s3,8
    80003c54:	fb899be3          	bne	s3,s8,80003c0a <exec+0x200>
  ip = 0;
    80003c58:	4a01                	li	s4,0
    80003c5a:	a0dd                	j	80003d40 <exec+0x336>
  sp = sz;
    80003c5c:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80003c60:	4481                	li	s1,0
  ustack[argc] = 0;
    80003c62:	00349793          	slli	a5,s1,0x3
    80003c66:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdb740>
    80003c6a:	97a2                	add	a5,a5,s0
    80003c6c:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003c70:	00148693          	addi	a3,s1,1
    80003c74:	068e                	slli	a3,a3,0x3
    80003c76:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003c7a:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003c7e:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80003c82:	f5796ee3          	bltu	s2,s7,80003bde <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003c86:	e9040613          	addi	a2,s0,-368
    80003c8a:	85ca                	mv	a1,s2
    80003c8c:	855a                	mv	a0,s6
    80003c8e:	d65fc0ef          	jal	800009f2 <copyout>
    80003c92:	0e054263          	bltz	a0,80003d76 <exec+0x36c>
  p->trapframe->a1 = sp;
    80003c96:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003c9a:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003c9e:	df843783          	ld	a5,-520(s0)
    80003ca2:	0007c703          	lbu	a4,0(a5)
    80003ca6:	cf11                	beqz	a4,80003cc2 <exec+0x2b8>
    80003ca8:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003caa:	02f00693          	li	a3,47
    80003cae:	a039                	j	80003cbc <exec+0x2b2>
      last = s+1;
    80003cb0:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80003cb4:	0785                	addi	a5,a5,1
    80003cb6:	fff7c703          	lbu	a4,-1(a5)
    80003cba:	c701                	beqz	a4,80003cc2 <exec+0x2b8>
    if(*s == '/')
    80003cbc:	fed71ce3          	bne	a4,a3,80003cb4 <exec+0x2aa>
    80003cc0:	bfc5                	j	80003cb0 <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80003cc2:	4641                	li	a2,16
    80003cc4:	df843583          	ld	a1,-520(s0)
    80003cc8:	160a8513          	addi	a0,s5,352
    80003ccc:	dc0fc0ef          	jal	8000028c <safestrcpy>
  oldpagetable = p->pagetable;
    80003cd0:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003cd4:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003cd8:	e0843783          	ld	a5,-504(s0)
    80003cdc:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003ce0:	058ab783          	ld	a5,88(s5)
    80003ce4:	e6843703          	ld	a4,-408(s0)
    80003ce8:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003cea:	058ab783          	ld	a5,88(s5)
    80003cee:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003cf2:	85e6                	mv	a1,s9
    80003cf4:	a22fd0ef          	jal	80000f16 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003cf8:	0004851b          	sext.w	a0,s1
    80003cfc:	79be                	ld	s3,488(sp)
    80003cfe:	7a1e                	ld	s4,480(sp)
    80003d00:	6afe                	ld	s5,472(sp)
    80003d02:	6b5e                	ld	s6,464(sp)
    80003d04:	6bbe                	ld	s7,456(sp)
    80003d06:	6c1e                	ld	s8,448(sp)
    80003d08:	7cfa                	ld	s9,440(sp)
    80003d0a:	7d5a                	ld	s10,432(sp)
    80003d0c:	b3b5                	j	80003a78 <exec+0x6e>
    80003d0e:	e1243423          	sd	s2,-504(s0)
    80003d12:	7dba                	ld	s11,424(sp)
    80003d14:	a035                	j	80003d40 <exec+0x336>
    80003d16:	e1243423          	sd	s2,-504(s0)
    80003d1a:	7dba                	ld	s11,424(sp)
    80003d1c:	a015                	j	80003d40 <exec+0x336>
    80003d1e:	e1243423          	sd	s2,-504(s0)
    80003d22:	7dba                	ld	s11,424(sp)
    80003d24:	a831                	j	80003d40 <exec+0x336>
    80003d26:	e1243423          	sd	s2,-504(s0)
    80003d2a:	7dba                	ld	s11,424(sp)
    80003d2c:	a811                	j	80003d40 <exec+0x336>
    80003d2e:	e1243423          	sd	s2,-504(s0)
    80003d32:	7dba                	ld	s11,424(sp)
    80003d34:	a031                	j	80003d40 <exec+0x336>
  ip = 0;
    80003d36:	4a01                	li	s4,0
    80003d38:	a021                	j	80003d40 <exec+0x336>
    80003d3a:	4a01                	li	s4,0
  if(pagetable)
    80003d3c:	a011                	j	80003d40 <exec+0x336>
    80003d3e:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80003d40:	e0843583          	ld	a1,-504(s0)
    80003d44:	855a                	mv	a0,s6
    80003d46:	9d0fd0ef          	jal	80000f16 <proc_freepagetable>
  return -1;
    80003d4a:	557d                	li	a0,-1
  if(ip){
    80003d4c:	000a1b63          	bnez	s4,80003d62 <exec+0x358>
    80003d50:	79be                	ld	s3,488(sp)
    80003d52:	7a1e                	ld	s4,480(sp)
    80003d54:	6afe                	ld	s5,472(sp)
    80003d56:	6b5e                	ld	s6,464(sp)
    80003d58:	6bbe                	ld	s7,456(sp)
    80003d5a:	6c1e                	ld	s8,448(sp)
    80003d5c:	7cfa                	ld	s9,440(sp)
    80003d5e:	7d5a                	ld	s10,432(sp)
    80003d60:	bb21                	j	80003a78 <exec+0x6e>
    80003d62:	79be                	ld	s3,488(sp)
    80003d64:	6afe                	ld	s5,472(sp)
    80003d66:	6b5e                	ld	s6,464(sp)
    80003d68:	6bbe                	ld	s7,456(sp)
    80003d6a:	6c1e                	ld	s8,448(sp)
    80003d6c:	7cfa                	ld	s9,440(sp)
    80003d6e:	7d5a                	ld	s10,432(sp)
    80003d70:	b9ed                	j	80003a6a <exec+0x60>
    80003d72:	6b5e                	ld	s6,464(sp)
    80003d74:	b9dd                	j	80003a6a <exec+0x60>
  sz = sz1;
    80003d76:	e0843983          	ld	s3,-504(s0)
    80003d7a:	b595                	j	80003bde <exec+0x1d4>

0000000080003d7c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003d7c:	7179                	addi	sp,sp,-48
    80003d7e:	f406                	sd	ra,40(sp)
    80003d80:	f022                	sd	s0,32(sp)
    80003d82:	ec26                	sd	s1,24(sp)
    80003d84:	e84a                	sd	s2,16(sp)
    80003d86:	1800                	addi	s0,sp,48
    80003d88:	892e                	mv	s2,a1
    80003d8a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003d8c:	fdc40593          	addi	a1,s0,-36
    80003d90:	f4dfd0ef          	jal	80001cdc <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003d94:	fdc42703          	lw	a4,-36(s0)
    80003d98:	47bd                	li	a5,15
    80003d9a:	02e7e963          	bltu	a5,a4,80003dcc <argfd+0x50>
    80003d9e:	802fd0ef          	jal	80000da0 <myproc>
    80003da2:	fdc42703          	lw	a4,-36(s0)
    80003da6:	01a70793          	addi	a5,a4,26
    80003daa:	078e                	slli	a5,a5,0x3
    80003dac:	953e                	add	a0,a0,a5
    80003dae:	651c                	ld	a5,8(a0)
    80003db0:	c385                	beqz	a5,80003dd0 <argfd+0x54>
    return -1;
  if(pfd)
    80003db2:	00090463          	beqz	s2,80003dba <argfd+0x3e>
    *pfd = fd;
    80003db6:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003dba:	4501                	li	a0,0
  if(pf)
    80003dbc:	c091                	beqz	s1,80003dc0 <argfd+0x44>
    *pf = f;
    80003dbe:	e09c                	sd	a5,0(s1)
}
    80003dc0:	70a2                	ld	ra,40(sp)
    80003dc2:	7402                	ld	s0,32(sp)
    80003dc4:	64e2                	ld	s1,24(sp)
    80003dc6:	6942                	ld	s2,16(sp)
    80003dc8:	6145                	addi	sp,sp,48
    80003dca:	8082                	ret
    return -1;
    80003dcc:	557d                	li	a0,-1
    80003dce:	bfcd                	j	80003dc0 <argfd+0x44>
    80003dd0:	557d                	li	a0,-1
    80003dd2:	b7fd                	j	80003dc0 <argfd+0x44>

0000000080003dd4 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003dd4:	1101                	addi	sp,sp,-32
    80003dd6:	ec06                	sd	ra,24(sp)
    80003dd8:	e822                	sd	s0,16(sp)
    80003dda:	e426                	sd	s1,8(sp)
    80003ddc:	1000                	addi	s0,sp,32
    80003dde:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003de0:	fc1fc0ef          	jal	80000da0 <myproc>
    80003de4:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003de6:	0d850793          	addi	a5,a0,216
    80003dea:	4501                	li	a0,0
    80003dec:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003dee:	6398                	ld	a4,0(a5)
    80003df0:	cb19                	beqz	a4,80003e06 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003df2:	2505                	addiw	a0,a0,1
    80003df4:	07a1                	addi	a5,a5,8
    80003df6:	fed51ce3          	bne	a0,a3,80003dee <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003dfa:	557d                	li	a0,-1
}
    80003dfc:	60e2                	ld	ra,24(sp)
    80003dfe:	6442                	ld	s0,16(sp)
    80003e00:	64a2                	ld	s1,8(sp)
    80003e02:	6105                	addi	sp,sp,32
    80003e04:	8082                	ret
      p->ofile[fd] = f;
    80003e06:	01a50793          	addi	a5,a0,26
    80003e0a:	078e                	slli	a5,a5,0x3
    80003e0c:	963e                	add	a2,a2,a5
    80003e0e:	e604                	sd	s1,8(a2)
      return fd;
    80003e10:	b7f5                	j	80003dfc <fdalloc+0x28>

0000000080003e12 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003e12:	715d                	addi	sp,sp,-80
    80003e14:	e486                	sd	ra,72(sp)
    80003e16:	e0a2                	sd	s0,64(sp)
    80003e18:	fc26                	sd	s1,56(sp)
    80003e1a:	f84a                	sd	s2,48(sp)
    80003e1c:	f44e                	sd	s3,40(sp)
    80003e1e:	ec56                	sd	s5,24(sp)
    80003e20:	e85a                	sd	s6,16(sp)
    80003e22:	0880                	addi	s0,sp,80
    80003e24:	8b2e                	mv	s6,a1
    80003e26:	89b2                	mv	s3,a2
    80003e28:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003e2a:	fb040593          	addi	a1,s0,-80
    80003e2e:	822ff0ef          	jal	80002e50 <nameiparent>
    80003e32:	84aa                	mv	s1,a0
    80003e34:	10050a63          	beqz	a0,80003f48 <create+0x136>
    return 0;

  ilock(dp);
    80003e38:	925fe0ef          	jal	8000275c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003e3c:	4601                	li	a2,0
    80003e3e:	fb040593          	addi	a1,s0,-80
    80003e42:	8526                	mv	a0,s1
    80003e44:	d8dfe0ef          	jal	80002bd0 <dirlookup>
    80003e48:	8aaa                	mv	s5,a0
    80003e4a:	c129                	beqz	a0,80003e8c <create+0x7a>
    iunlockput(dp);
    80003e4c:	8526                	mv	a0,s1
    80003e4e:	b19fe0ef          	jal	80002966 <iunlockput>
    ilock(ip);
    80003e52:	8556                	mv	a0,s5
    80003e54:	909fe0ef          	jal	8000275c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003e58:	4789                	li	a5,2
    80003e5a:	02fb1463          	bne	s6,a5,80003e82 <create+0x70>
    80003e5e:	044ad783          	lhu	a5,68(s5)
    80003e62:	37f9                	addiw	a5,a5,-2
    80003e64:	17c2                	slli	a5,a5,0x30
    80003e66:	93c1                	srli	a5,a5,0x30
    80003e68:	4705                	li	a4,1
    80003e6a:	00f76c63          	bltu	a4,a5,80003e82 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003e6e:	8556                	mv	a0,s5
    80003e70:	60a6                	ld	ra,72(sp)
    80003e72:	6406                	ld	s0,64(sp)
    80003e74:	74e2                	ld	s1,56(sp)
    80003e76:	7942                	ld	s2,48(sp)
    80003e78:	79a2                	ld	s3,40(sp)
    80003e7a:	6ae2                	ld	s5,24(sp)
    80003e7c:	6b42                	ld	s6,16(sp)
    80003e7e:	6161                	addi	sp,sp,80
    80003e80:	8082                	ret
    iunlockput(ip);
    80003e82:	8556                	mv	a0,s5
    80003e84:	ae3fe0ef          	jal	80002966 <iunlockput>
    return 0;
    80003e88:	4a81                	li	s5,0
    80003e8a:	b7d5                	j	80003e6e <create+0x5c>
    80003e8c:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80003e8e:	85da                	mv	a1,s6
    80003e90:	4088                	lw	a0,0(s1)
    80003e92:	f5afe0ef          	jal	800025ec <ialloc>
    80003e96:	8a2a                	mv	s4,a0
    80003e98:	cd15                	beqz	a0,80003ed4 <create+0xc2>
  ilock(ip);
    80003e9a:	8c3fe0ef          	jal	8000275c <ilock>
  ip->major = major;
    80003e9e:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80003ea2:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80003ea6:	4905                	li	s2,1
    80003ea8:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80003eac:	8552                	mv	a0,s4
    80003eae:	ffafe0ef          	jal	800026a8 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003eb2:	032b0763          	beq	s6,s2,80003ee0 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80003eb6:	004a2603          	lw	a2,4(s4)
    80003eba:	fb040593          	addi	a1,s0,-80
    80003ebe:	8526                	mv	a0,s1
    80003ec0:	eddfe0ef          	jal	80002d9c <dirlink>
    80003ec4:	06054563          	bltz	a0,80003f2e <create+0x11c>
  iunlockput(dp);
    80003ec8:	8526                	mv	a0,s1
    80003eca:	a9dfe0ef          	jal	80002966 <iunlockput>
  return ip;
    80003ece:	8ad2                	mv	s5,s4
    80003ed0:	7a02                	ld	s4,32(sp)
    80003ed2:	bf71                	j	80003e6e <create+0x5c>
    iunlockput(dp);
    80003ed4:	8526                	mv	a0,s1
    80003ed6:	a91fe0ef          	jal	80002966 <iunlockput>
    return 0;
    80003eda:	8ad2                	mv	s5,s4
    80003edc:	7a02                	ld	s4,32(sp)
    80003ede:	bf41                	j	80003e6e <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003ee0:	004a2603          	lw	a2,4(s4)
    80003ee4:	00003597          	auipc	a1,0x3
    80003ee8:	6ec58593          	addi	a1,a1,1772 # 800075d0 <etext+0x5d0>
    80003eec:	8552                	mv	a0,s4
    80003eee:	eaffe0ef          	jal	80002d9c <dirlink>
    80003ef2:	02054e63          	bltz	a0,80003f2e <create+0x11c>
    80003ef6:	40d0                	lw	a2,4(s1)
    80003ef8:	00003597          	auipc	a1,0x3
    80003efc:	6e058593          	addi	a1,a1,1760 # 800075d8 <etext+0x5d8>
    80003f00:	8552                	mv	a0,s4
    80003f02:	e9bfe0ef          	jal	80002d9c <dirlink>
    80003f06:	02054463          	bltz	a0,80003f2e <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80003f0a:	004a2603          	lw	a2,4(s4)
    80003f0e:	fb040593          	addi	a1,s0,-80
    80003f12:	8526                	mv	a0,s1
    80003f14:	e89fe0ef          	jal	80002d9c <dirlink>
    80003f18:	00054b63          	bltz	a0,80003f2e <create+0x11c>
    dp->nlink++;  // for ".."
    80003f1c:	04a4d783          	lhu	a5,74(s1)
    80003f20:	2785                	addiw	a5,a5,1
    80003f22:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80003f26:	8526                	mv	a0,s1
    80003f28:	f80fe0ef          	jal	800026a8 <iupdate>
    80003f2c:	bf71                	j	80003ec8 <create+0xb6>
  ip->nlink = 0;
    80003f2e:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80003f32:	8552                	mv	a0,s4
    80003f34:	f74fe0ef          	jal	800026a8 <iupdate>
  iunlockput(ip);
    80003f38:	8552                	mv	a0,s4
    80003f3a:	a2dfe0ef          	jal	80002966 <iunlockput>
  iunlockput(dp);
    80003f3e:	8526                	mv	a0,s1
    80003f40:	a27fe0ef          	jal	80002966 <iunlockput>
  return 0;
    80003f44:	7a02                	ld	s4,32(sp)
    80003f46:	b725                	j	80003e6e <create+0x5c>
    return 0;
    80003f48:	8aaa                	mv	s5,a0
    80003f4a:	b715                	j	80003e6e <create+0x5c>

0000000080003f4c <sys_dup>:
{
    80003f4c:	7179                	addi	sp,sp,-48
    80003f4e:	f406                	sd	ra,40(sp)
    80003f50:	f022                	sd	s0,32(sp)
    80003f52:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80003f54:	fd840613          	addi	a2,s0,-40
    80003f58:	4581                	li	a1,0
    80003f5a:	4501                	li	a0,0
    80003f5c:	e21ff0ef          	jal	80003d7c <argfd>
    return -1;
    80003f60:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80003f62:	02054363          	bltz	a0,80003f88 <sys_dup+0x3c>
    80003f66:	ec26                	sd	s1,24(sp)
    80003f68:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80003f6a:	fd843903          	ld	s2,-40(s0)
    80003f6e:	854a                	mv	a0,s2
    80003f70:	e65ff0ef          	jal	80003dd4 <fdalloc>
    80003f74:	84aa                	mv	s1,a0
    return -1;
    80003f76:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80003f78:	00054d63          	bltz	a0,80003f92 <sys_dup+0x46>
  filedup(f);
    80003f7c:	854a                	mv	a0,s2
    80003f7e:	c48ff0ef          	jal	800033c6 <filedup>
  return fd;
    80003f82:	87a6                	mv	a5,s1
    80003f84:	64e2                	ld	s1,24(sp)
    80003f86:	6942                	ld	s2,16(sp)
}
    80003f88:	853e                	mv	a0,a5
    80003f8a:	70a2                	ld	ra,40(sp)
    80003f8c:	7402                	ld	s0,32(sp)
    80003f8e:	6145                	addi	sp,sp,48
    80003f90:	8082                	ret
    80003f92:	64e2                	ld	s1,24(sp)
    80003f94:	6942                	ld	s2,16(sp)
    80003f96:	bfcd                	j	80003f88 <sys_dup+0x3c>

0000000080003f98 <sys_read>:
{
    80003f98:	7179                	addi	sp,sp,-48
    80003f9a:	f406                	sd	ra,40(sp)
    80003f9c:	f022                	sd	s0,32(sp)
    80003f9e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003fa0:	fd840593          	addi	a1,s0,-40
    80003fa4:	4505                	li	a0,1
    80003fa6:	d53fd0ef          	jal	80001cf8 <argaddr>
  argint(2, &n);
    80003faa:	fe440593          	addi	a1,s0,-28
    80003fae:	4509                	li	a0,2
    80003fb0:	d2dfd0ef          	jal	80001cdc <argint>
  if(argfd(0, 0, &f) < 0)
    80003fb4:	fe840613          	addi	a2,s0,-24
    80003fb8:	4581                	li	a1,0
    80003fba:	4501                	li	a0,0
    80003fbc:	dc1ff0ef          	jal	80003d7c <argfd>
    80003fc0:	87aa                	mv	a5,a0
    return -1;
    80003fc2:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003fc4:	0007ca63          	bltz	a5,80003fd8 <sys_read+0x40>
  return fileread(f, p, n);
    80003fc8:	fe442603          	lw	a2,-28(s0)
    80003fcc:	fd843583          	ld	a1,-40(s0)
    80003fd0:	fe843503          	ld	a0,-24(s0)
    80003fd4:	d58ff0ef          	jal	8000352c <fileread>
}
    80003fd8:	70a2                	ld	ra,40(sp)
    80003fda:	7402                	ld	s0,32(sp)
    80003fdc:	6145                	addi	sp,sp,48
    80003fde:	8082                	ret

0000000080003fe0 <sys_write>:
{
    80003fe0:	7179                	addi	sp,sp,-48
    80003fe2:	f406                	sd	ra,40(sp)
    80003fe4:	f022                	sd	s0,32(sp)
    80003fe6:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003fe8:	fd840593          	addi	a1,s0,-40
    80003fec:	4505                	li	a0,1
    80003fee:	d0bfd0ef          	jal	80001cf8 <argaddr>
  argint(2, &n);
    80003ff2:	fe440593          	addi	a1,s0,-28
    80003ff6:	4509                	li	a0,2
    80003ff8:	ce5fd0ef          	jal	80001cdc <argint>
  if(argfd(0, 0, &f) < 0)
    80003ffc:	fe840613          	addi	a2,s0,-24
    80004000:	4581                	li	a1,0
    80004002:	4501                	li	a0,0
    80004004:	d79ff0ef          	jal	80003d7c <argfd>
    80004008:	87aa                	mv	a5,a0
    return -1;
    8000400a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000400c:	0007ca63          	bltz	a5,80004020 <sys_write+0x40>
  return filewrite(f, p, n);
    80004010:	fe442603          	lw	a2,-28(s0)
    80004014:	fd843583          	ld	a1,-40(s0)
    80004018:	fe843503          	ld	a0,-24(s0)
    8000401c:	dceff0ef          	jal	800035ea <filewrite>
}
    80004020:	70a2                	ld	ra,40(sp)
    80004022:	7402                	ld	s0,32(sp)
    80004024:	6145                	addi	sp,sp,48
    80004026:	8082                	ret

0000000080004028 <sys_close>:
{
    80004028:	1101                	addi	sp,sp,-32
    8000402a:	ec06                	sd	ra,24(sp)
    8000402c:	e822                	sd	s0,16(sp)
    8000402e:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004030:	fe040613          	addi	a2,s0,-32
    80004034:	fec40593          	addi	a1,s0,-20
    80004038:	4501                	li	a0,0
    8000403a:	d43ff0ef          	jal	80003d7c <argfd>
    return -1;
    8000403e:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004040:	02054063          	bltz	a0,80004060 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004044:	d5dfc0ef          	jal	80000da0 <myproc>
    80004048:	fec42783          	lw	a5,-20(s0)
    8000404c:	07e9                	addi	a5,a5,26
    8000404e:	078e                	slli	a5,a5,0x3
    80004050:	953e                	add	a0,a0,a5
    80004052:	00053423          	sd	zero,8(a0)
  fileclose(f);
    80004056:	fe043503          	ld	a0,-32(s0)
    8000405a:	bb2ff0ef          	jal	8000340c <fileclose>
  return 0;
    8000405e:	4781                	li	a5,0
}
    80004060:	853e                	mv	a0,a5
    80004062:	60e2                	ld	ra,24(sp)
    80004064:	6442                	ld	s0,16(sp)
    80004066:	6105                	addi	sp,sp,32
    80004068:	8082                	ret

000000008000406a <sys_fstat>:
{
    8000406a:	1101                	addi	sp,sp,-32
    8000406c:	ec06                	sd	ra,24(sp)
    8000406e:	e822                	sd	s0,16(sp)
    80004070:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004072:	fe040593          	addi	a1,s0,-32
    80004076:	4505                	li	a0,1
    80004078:	c81fd0ef          	jal	80001cf8 <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000407c:	fe840613          	addi	a2,s0,-24
    80004080:	4581                	li	a1,0
    80004082:	4501                	li	a0,0
    80004084:	cf9ff0ef          	jal	80003d7c <argfd>
    80004088:	87aa                	mv	a5,a0
    return -1;
    8000408a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000408c:	0007c863          	bltz	a5,8000409c <sys_fstat+0x32>
  return filestat(f, st);
    80004090:	fe043583          	ld	a1,-32(s0)
    80004094:	fe843503          	ld	a0,-24(s0)
    80004098:	c36ff0ef          	jal	800034ce <filestat>
}
    8000409c:	60e2                	ld	ra,24(sp)
    8000409e:	6442                	ld	s0,16(sp)
    800040a0:	6105                	addi	sp,sp,32
    800040a2:	8082                	ret

00000000800040a4 <sys_link>:
{
    800040a4:	7169                	addi	sp,sp,-304
    800040a6:	f606                	sd	ra,296(sp)
    800040a8:	f222                	sd	s0,288(sp)
    800040aa:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800040ac:	08000613          	li	a2,128
    800040b0:	ed040593          	addi	a1,s0,-304
    800040b4:	4501                	li	a0,0
    800040b6:	c5ffd0ef          	jal	80001d14 <argstr>
    return -1;
    800040ba:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800040bc:	0c054e63          	bltz	a0,80004198 <sys_link+0xf4>
    800040c0:	08000613          	li	a2,128
    800040c4:	f5040593          	addi	a1,s0,-176
    800040c8:	4505                	li	a0,1
    800040ca:	c4bfd0ef          	jal	80001d14 <argstr>
    return -1;
    800040ce:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800040d0:	0c054463          	bltz	a0,80004198 <sys_link+0xf4>
    800040d4:	ee26                	sd	s1,280(sp)
  begin_op();
    800040d6:	f1dfe0ef          	jal	80002ff2 <begin_op>
  if((ip = namei(old)) == 0){
    800040da:	ed040513          	addi	a0,s0,-304
    800040de:	d59fe0ef          	jal	80002e36 <namei>
    800040e2:	84aa                	mv	s1,a0
    800040e4:	c53d                	beqz	a0,80004152 <sys_link+0xae>
  ilock(ip);
    800040e6:	e76fe0ef          	jal	8000275c <ilock>
  if(ip->type == T_DIR){
    800040ea:	04449703          	lh	a4,68(s1)
    800040ee:	4785                	li	a5,1
    800040f0:	06f70663          	beq	a4,a5,8000415c <sys_link+0xb8>
    800040f4:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800040f6:	04a4d783          	lhu	a5,74(s1)
    800040fa:	2785                	addiw	a5,a5,1
    800040fc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004100:	8526                	mv	a0,s1
    80004102:	da6fe0ef          	jal	800026a8 <iupdate>
  iunlock(ip);
    80004106:	8526                	mv	a0,s1
    80004108:	f02fe0ef          	jal	8000280a <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000410c:	fd040593          	addi	a1,s0,-48
    80004110:	f5040513          	addi	a0,s0,-176
    80004114:	d3dfe0ef          	jal	80002e50 <nameiparent>
    80004118:	892a                	mv	s2,a0
    8000411a:	cd21                	beqz	a0,80004172 <sys_link+0xce>
  ilock(dp);
    8000411c:	e40fe0ef          	jal	8000275c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004120:	00092703          	lw	a4,0(s2)
    80004124:	409c                	lw	a5,0(s1)
    80004126:	04f71363          	bne	a4,a5,8000416c <sys_link+0xc8>
    8000412a:	40d0                	lw	a2,4(s1)
    8000412c:	fd040593          	addi	a1,s0,-48
    80004130:	854a                	mv	a0,s2
    80004132:	c6bfe0ef          	jal	80002d9c <dirlink>
    80004136:	02054b63          	bltz	a0,8000416c <sys_link+0xc8>
  iunlockput(dp);
    8000413a:	854a                	mv	a0,s2
    8000413c:	82bfe0ef          	jal	80002966 <iunlockput>
  iput(ip);
    80004140:	8526                	mv	a0,s1
    80004142:	f9cfe0ef          	jal	800028de <iput>
  end_op();
    80004146:	f17fe0ef          	jal	8000305c <end_op>
  return 0;
    8000414a:	4781                	li	a5,0
    8000414c:	64f2                	ld	s1,280(sp)
    8000414e:	6952                	ld	s2,272(sp)
    80004150:	a0a1                	j	80004198 <sys_link+0xf4>
    end_op();
    80004152:	f0bfe0ef          	jal	8000305c <end_op>
    return -1;
    80004156:	57fd                	li	a5,-1
    80004158:	64f2                	ld	s1,280(sp)
    8000415a:	a83d                	j	80004198 <sys_link+0xf4>
    iunlockput(ip);
    8000415c:	8526                	mv	a0,s1
    8000415e:	809fe0ef          	jal	80002966 <iunlockput>
    end_op();
    80004162:	efbfe0ef          	jal	8000305c <end_op>
    return -1;
    80004166:	57fd                	li	a5,-1
    80004168:	64f2                	ld	s1,280(sp)
    8000416a:	a03d                	j	80004198 <sys_link+0xf4>
    iunlockput(dp);
    8000416c:	854a                	mv	a0,s2
    8000416e:	ff8fe0ef          	jal	80002966 <iunlockput>
  ilock(ip);
    80004172:	8526                	mv	a0,s1
    80004174:	de8fe0ef          	jal	8000275c <ilock>
  ip->nlink--;
    80004178:	04a4d783          	lhu	a5,74(s1)
    8000417c:	37fd                	addiw	a5,a5,-1
    8000417e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004182:	8526                	mv	a0,s1
    80004184:	d24fe0ef          	jal	800026a8 <iupdate>
  iunlockput(ip);
    80004188:	8526                	mv	a0,s1
    8000418a:	fdcfe0ef          	jal	80002966 <iunlockput>
  end_op();
    8000418e:	ecffe0ef          	jal	8000305c <end_op>
  return -1;
    80004192:	57fd                	li	a5,-1
    80004194:	64f2                	ld	s1,280(sp)
    80004196:	6952                	ld	s2,272(sp)
}
    80004198:	853e                	mv	a0,a5
    8000419a:	70b2                	ld	ra,296(sp)
    8000419c:	7412                	ld	s0,288(sp)
    8000419e:	6155                	addi	sp,sp,304
    800041a0:	8082                	ret

00000000800041a2 <sys_unlink>:
{
    800041a2:	7151                	addi	sp,sp,-240
    800041a4:	f586                	sd	ra,232(sp)
    800041a6:	f1a2                	sd	s0,224(sp)
    800041a8:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800041aa:	08000613          	li	a2,128
    800041ae:	f3040593          	addi	a1,s0,-208
    800041b2:	4501                	li	a0,0
    800041b4:	b61fd0ef          	jal	80001d14 <argstr>
    800041b8:	16054063          	bltz	a0,80004318 <sys_unlink+0x176>
    800041bc:	eda6                	sd	s1,216(sp)
  begin_op();
    800041be:	e35fe0ef          	jal	80002ff2 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800041c2:	fb040593          	addi	a1,s0,-80
    800041c6:	f3040513          	addi	a0,s0,-208
    800041ca:	c87fe0ef          	jal	80002e50 <nameiparent>
    800041ce:	84aa                	mv	s1,a0
    800041d0:	c945                	beqz	a0,80004280 <sys_unlink+0xde>
  ilock(dp);
    800041d2:	d8afe0ef          	jal	8000275c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800041d6:	00003597          	auipc	a1,0x3
    800041da:	3fa58593          	addi	a1,a1,1018 # 800075d0 <etext+0x5d0>
    800041de:	fb040513          	addi	a0,s0,-80
    800041e2:	9d9fe0ef          	jal	80002bba <namecmp>
    800041e6:	10050e63          	beqz	a0,80004302 <sys_unlink+0x160>
    800041ea:	00003597          	auipc	a1,0x3
    800041ee:	3ee58593          	addi	a1,a1,1006 # 800075d8 <etext+0x5d8>
    800041f2:	fb040513          	addi	a0,s0,-80
    800041f6:	9c5fe0ef          	jal	80002bba <namecmp>
    800041fa:	10050463          	beqz	a0,80004302 <sys_unlink+0x160>
    800041fe:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004200:	f2c40613          	addi	a2,s0,-212
    80004204:	fb040593          	addi	a1,s0,-80
    80004208:	8526                	mv	a0,s1
    8000420a:	9c7fe0ef          	jal	80002bd0 <dirlookup>
    8000420e:	892a                	mv	s2,a0
    80004210:	0e050863          	beqz	a0,80004300 <sys_unlink+0x15e>
  ilock(ip);
    80004214:	d48fe0ef          	jal	8000275c <ilock>
  if(ip->nlink < 1)
    80004218:	04a91783          	lh	a5,74(s2)
    8000421c:	06f05763          	blez	a5,8000428a <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004220:	04491703          	lh	a4,68(s2)
    80004224:	4785                	li	a5,1
    80004226:	06f70963          	beq	a4,a5,80004298 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    8000422a:	4641                	li	a2,16
    8000422c:	4581                	li	a1,0
    8000422e:	fc040513          	addi	a0,s0,-64
    80004232:	f1dfb0ef          	jal	8000014e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004236:	4741                	li	a4,16
    80004238:	f2c42683          	lw	a3,-212(s0)
    8000423c:	fc040613          	addi	a2,s0,-64
    80004240:	4581                	li	a1,0
    80004242:	8526                	mv	a0,s1
    80004244:	869fe0ef          	jal	80002aac <writei>
    80004248:	47c1                	li	a5,16
    8000424a:	08f51b63          	bne	a0,a5,800042e0 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    8000424e:	04491703          	lh	a4,68(s2)
    80004252:	4785                	li	a5,1
    80004254:	08f70d63          	beq	a4,a5,800042ee <sys_unlink+0x14c>
  iunlockput(dp);
    80004258:	8526                	mv	a0,s1
    8000425a:	f0cfe0ef          	jal	80002966 <iunlockput>
  ip->nlink--;
    8000425e:	04a95783          	lhu	a5,74(s2)
    80004262:	37fd                	addiw	a5,a5,-1
    80004264:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004268:	854a                	mv	a0,s2
    8000426a:	c3efe0ef          	jal	800026a8 <iupdate>
  iunlockput(ip);
    8000426e:	854a                	mv	a0,s2
    80004270:	ef6fe0ef          	jal	80002966 <iunlockput>
  end_op();
    80004274:	de9fe0ef          	jal	8000305c <end_op>
  return 0;
    80004278:	4501                	li	a0,0
    8000427a:	64ee                	ld	s1,216(sp)
    8000427c:	694e                	ld	s2,208(sp)
    8000427e:	a849                	j	80004310 <sys_unlink+0x16e>
    end_op();
    80004280:	dddfe0ef          	jal	8000305c <end_op>
    return -1;
    80004284:	557d                	li	a0,-1
    80004286:	64ee                	ld	s1,216(sp)
    80004288:	a061                	j	80004310 <sys_unlink+0x16e>
    8000428a:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    8000428c:	00003517          	auipc	a0,0x3
    80004290:	35450513          	addi	a0,a0,852 # 800075e0 <etext+0x5e0>
    80004294:	27e010ef          	jal	80005512 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004298:	04c92703          	lw	a4,76(s2)
    8000429c:	02000793          	li	a5,32
    800042a0:	f8e7f5e3          	bgeu	a5,a4,8000422a <sys_unlink+0x88>
    800042a4:	e5ce                	sd	s3,200(sp)
    800042a6:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800042aa:	4741                	li	a4,16
    800042ac:	86ce                	mv	a3,s3
    800042ae:	f1840613          	addi	a2,s0,-232
    800042b2:	4581                	li	a1,0
    800042b4:	854a                	mv	a0,s2
    800042b6:	efafe0ef          	jal	800029b0 <readi>
    800042ba:	47c1                	li	a5,16
    800042bc:	00f51c63          	bne	a0,a5,800042d4 <sys_unlink+0x132>
    if(de.inum != 0)
    800042c0:	f1845783          	lhu	a5,-232(s0)
    800042c4:	efa1                	bnez	a5,8000431c <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800042c6:	29c1                	addiw	s3,s3,16
    800042c8:	04c92783          	lw	a5,76(s2)
    800042cc:	fcf9efe3          	bltu	s3,a5,800042aa <sys_unlink+0x108>
    800042d0:	69ae                	ld	s3,200(sp)
    800042d2:	bfa1                	j	8000422a <sys_unlink+0x88>
      panic("isdirempty: readi");
    800042d4:	00003517          	auipc	a0,0x3
    800042d8:	32450513          	addi	a0,a0,804 # 800075f8 <etext+0x5f8>
    800042dc:	236010ef          	jal	80005512 <panic>
    800042e0:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    800042e2:	00003517          	auipc	a0,0x3
    800042e6:	32e50513          	addi	a0,a0,814 # 80007610 <etext+0x610>
    800042ea:	228010ef          	jal	80005512 <panic>
    dp->nlink--;
    800042ee:	04a4d783          	lhu	a5,74(s1)
    800042f2:	37fd                	addiw	a5,a5,-1
    800042f4:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800042f8:	8526                	mv	a0,s1
    800042fa:	baefe0ef          	jal	800026a8 <iupdate>
    800042fe:	bfa9                	j	80004258 <sys_unlink+0xb6>
    80004300:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004302:	8526                	mv	a0,s1
    80004304:	e62fe0ef          	jal	80002966 <iunlockput>
  end_op();
    80004308:	d55fe0ef          	jal	8000305c <end_op>
  return -1;
    8000430c:	557d                	li	a0,-1
    8000430e:	64ee                	ld	s1,216(sp)
}
    80004310:	70ae                	ld	ra,232(sp)
    80004312:	740e                	ld	s0,224(sp)
    80004314:	616d                	addi	sp,sp,240
    80004316:	8082                	ret
    return -1;
    80004318:	557d                	li	a0,-1
    8000431a:	bfdd                	j	80004310 <sys_unlink+0x16e>
    iunlockput(ip);
    8000431c:	854a                	mv	a0,s2
    8000431e:	e48fe0ef          	jal	80002966 <iunlockput>
    goto bad;
    80004322:	694e                	ld	s2,208(sp)
    80004324:	69ae                	ld	s3,200(sp)
    80004326:	bff1                	j	80004302 <sys_unlink+0x160>

0000000080004328 <sys_open>:

uint64
sys_open(void)
{
    80004328:	7131                	addi	sp,sp,-192
    8000432a:	fd06                	sd	ra,184(sp)
    8000432c:	f922                	sd	s0,176(sp)
    8000432e:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004330:	f4c40593          	addi	a1,s0,-180
    80004334:	4505                	li	a0,1
    80004336:	9a7fd0ef          	jal	80001cdc <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000433a:	08000613          	li	a2,128
    8000433e:	f5040593          	addi	a1,s0,-176
    80004342:	4501                	li	a0,0
    80004344:	9d1fd0ef          	jal	80001d14 <argstr>
    80004348:	87aa                	mv	a5,a0
    return -1;
    8000434a:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000434c:	0a07c263          	bltz	a5,800043f0 <sys_open+0xc8>
    80004350:	f526                	sd	s1,168(sp)

  begin_op();
    80004352:	ca1fe0ef          	jal	80002ff2 <begin_op>

  if(omode & O_CREATE){
    80004356:	f4c42783          	lw	a5,-180(s0)
    8000435a:	2007f793          	andi	a5,a5,512
    8000435e:	c3d5                	beqz	a5,80004402 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80004360:	4681                	li	a3,0
    80004362:	4601                	li	a2,0
    80004364:	4589                	li	a1,2
    80004366:	f5040513          	addi	a0,s0,-176
    8000436a:	aa9ff0ef          	jal	80003e12 <create>
    8000436e:	84aa                	mv	s1,a0
    if(ip == 0){
    80004370:	c541                	beqz	a0,800043f8 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004372:	04449703          	lh	a4,68(s1)
    80004376:	478d                	li	a5,3
    80004378:	00f71763          	bne	a4,a5,80004386 <sys_open+0x5e>
    8000437c:	0464d703          	lhu	a4,70(s1)
    80004380:	47a5                	li	a5,9
    80004382:	0ae7ed63          	bltu	a5,a4,8000443c <sys_open+0x114>
    80004386:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004388:	fe1fe0ef          	jal	80003368 <filealloc>
    8000438c:	892a                	mv	s2,a0
    8000438e:	c179                	beqz	a0,80004454 <sys_open+0x12c>
    80004390:	ed4e                	sd	s3,152(sp)
    80004392:	a43ff0ef          	jal	80003dd4 <fdalloc>
    80004396:	89aa                	mv	s3,a0
    80004398:	0a054a63          	bltz	a0,8000444c <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000439c:	04449703          	lh	a4,68(s1)
    800043a0:	478d                	li	a5,3
    800043a2:	0cf70263          	beq	a4,a5,80004466 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800043a6:	4789                	li	a5,2
    800043a8:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    800043ac:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    800043b0:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    800043b4:	f4c42783          	lw	a5,-180(s0)
    800043b8:	0017c713          	xori	a4,a5,1
    800043bc:	8b05                	andi	a4,a4,1
    800043be:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800043c2:	0037f713          	andi	a4,a5,3
    800043c6:	00e03733          	snez	a4,a4
    800043ca:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800043ce:	4007f793          	andi	a5,a5,1024
    800043d2:	c791                	beqz	a5,800043de <sys_open+0xb6>
    800043d4:	04449703          	lh	a4,68(s1)
    800043d8:	4789                	li	a5,2
    800043da:	08f70d63          	beq	a4,a5,80004474 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    800043de:	8526                	mv	a0,s1
    800043e0:	c2afe0ef          	jal	8000280a <iunlock>
  end_op();
    800043e4:	c79fe0ef          	jal	8000305c <end_op>

  return fd;
    800043e8:	854e                	mv	a0,s3
    800043ea:	74aa                	ld	s1,168(sp)
    800043ec:	790a                	ld	s2,160(sp)
    800043ee:	69ea                	ld	s3,152(sp)
}
    800043f0:	70ea                	ld	ra,184(sp)
    800043f2:	744a                	ld	s0,176(sp)
    800043f4:	6129                	addi	sp,sp,192
    800043f6:	8082                	ret
      end_op();
    800043f8:	c65fe0ef          	jal	8000305c <end_op>
      return -1;
    800043fc:	557d                	li	a0,-1
    800043fe:	74aa                	ld	s1,168(sp)
    80004400:	bfc5                	j	800043f0 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    80004402:	f5040513          	addi	a0,s0,-176
    80004406:	a31fe0ef          	jal	80002e36 <namei>
    8000440a:	84aa                	mv	s1,a0
    8000440c:	c11d                	beqz	a0,80004432 <sys_open+0x10a>
    ilock(ip);
    8000440e:	b4efe0ef          	jal	8000275c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004412:	04449703          	lh	a4,68(s1)
    80004416:	4785                	li	a5,1
    80004418:	f4f71de3          	bne	a4,a5,80004372 <sys_open+0x4a>
    8000441c:	f4c42783          	lw	a5,-180(s0)
    80004420:	d3bd                	beqz	a5,80004386 <sys_open+0x5e>
      iunlockput(ip);
    80004422:	8526                	mv	a0,s1
    80004424:	d42fe0ef          	jal	80002966 <iunlockput>
      end_op();
    80004428:	c35fe0ef          	jal	8000305c <end_op>
      return -1;
    8000442c:	557d                	li	a0,-1
    8000442e:	74aa                	ld	s1,168(sp)
    80004430:	b7c1                	j	800043f0 <sys_open+0xc8>
      end_op();
    80004432:	c2bfe0ef          	jal	8000305c <end_op>
      return -1;
    80004436:	557d                	li	a0,-1
    80004438:	74aa                	ld	s1,168(sp)
    8000443a:	bf5d                	j	800043f0 <sys_open+0xc8>
    iunlockput(ip);
    8000443c:	8526                	mv	a0,s1
    8000443e:	d28fe0ef          	jal	80002966 <iunlockput>
    end_op();
    80004442:	c1bfe0ef          	jal	8000305c <end_op>
    return -1;
    80004446:	557d                	li	a0,-1
    80004448:	74aa                	ld	s1,168(sp)
    8000444a:	b75d                	j	800043f0 <sys_open+0xc8>
      fileclose(f);
    8000444c:	854a                	mv	a0,s2
    8000444e:	fbffe0ef          	jal	8000340c <fileclose>
    80004452:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004454:	8526                	mv	a0,s1
    80004456:	d10fe0ef          	jal	80002966 <iunlockput>
    end_op();
    8000445a:	c03fe0ef          	jal	8000305c <end_op>
    return -1;
    8000445e:	557d                	li	a0,-1
    80004460:	74aa                	ld	s1,168(sp)
    80004462:	790a                	ld	s2,160(sp)
    80004464:	b771                	j	800043f0 <sys_open+0xc8>
    f->type = FD_DEVICE;
    80004466:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    8000446a:	04649783          	lh	a5,70(s1)
    8000446e:	02f91223          	sh	a5,36(s2)
    80004472:	bf3d                	j	800043b0 <sys_open+0x88>
    itrunc(ip);
    80004474:	8526                	mv	a0,s1
    80004476:	bd4fe0ef          	jal	8000284a <itrunc>
    8000447a:	b795                	j	800043de <sys_open+0xb6>

000000008000447c <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000447c:	7175                	addi	sp,sp,-144
    8000447e:	e506                	sd	ra,136(sp)
    80004480:	e122                	sd	s0,128(sp)
    80004482:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004484:	b6ffe0ef          	jal	80002ff2 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004488:	08000613          	li	a2,128
    8000448c:	f7040593          	addi	a1,s0,-144
    80004490:	4501                	li	a0,0
    80004492:	883fd0ef          	jal	80001d14 <argstr>
    80004496:	02054363          	bltz	a0,800044bc <sys_mkdir+0x40>
    8000449a:	4681                	li	a3,0
    8000449c:	4601                	li	a2,0
    8000449e:	4585                	li	a1,1
    800044a0:	f7040513          	addi	a0,s0,-144
    800044a4:	96fff0ef          	jal	80003e12 <create>
    800044a8:	c911                	beqz	a0,800044bc <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800044aa:	cbcfe0ef          	jal	80002966 <iunlockput>
  end_op();
    800044ae:	baffe0ef          	jal	8000305c <end_op>
  return 0;
    800044b2:	4501                	li	a0,0
}
    800044b4:	60aa                	ld	ra,136(sp)
    800044b6:	640a                	ld	s0,128(sp)
    800044b8:	6149                	addi	sp,sp,144
    800044ba:	8082                	ret
    end_op();
    800044bc:	ba1fe0ef          	jal	8000305c <end_op>
    return -1;
    800044c0:	557d                	li	a0,-1
    800044c2:	bfcd                	j	800044b4 <sys_mkdir+0x38>

00000000800044c4 <sys_mknod>:

uint64
sys_mknod(void)
{
    800044c4:	7135                	addi	sp,sp,-160
    800044c6:	ed06                	sd	ra,152(sp)
    800044c8:	e922                	sd	s0,144(sp)
    800044ca:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800044cc:	b27fe0ef          	jal	80002ff2 <begin_op>
  argint(1, &major);
    800044d0:	f6c40593          	addi	a1,s0,-148
    800044d4:	4505                	li	a0,1
    800044d6:	807fd0ef          	jal	80001cdc <argint>
  argint(2, &minor);
    800044da:	f6840593          	addi	a1,s0,-152
    800044de:	4509                	li	a0,2
    800044e0:	ffcfd0ef          	jal	80001cdc <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800044e4:	08000613          	li	a2,128
    800044e8:	f7040593          	addi	a1,s0,-144
    800044ec:	4501                	li	a0,0
    800044ee:	827fd0ef          	jal	80001d14 <argstr>
    800044f2:	02054563          	bltz	a0,8000451c <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800044f6:	f6841683          	lh	a3,-152(s0)
    800044fa:	f6c41603          	lh	a2,-148(s0)
    800044fe:	458d                	li	a1,3
    80004500:	f7040513          	addi	a0,s0,-144
    80004504:	90fff0ef          	jal	80003e12 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004508:	c911                	beqz	a0,8000451c <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000450a:	c5cfe0ef          	jal	80002966 <iunlockput>
  end_op();
    8000450e:	b4ffe0ef          	jal	8000305c <end_op>
  return 0;
    80004512:	4501                	li	a0,0
}
    80004514:	60ea                	ld	ra,152(sp)
    80004516:	644a                	ld	s0,144(sp)
    80004518:	610d                	addi	sp,sp,160
    8000451a:	8082                	ret
    end_op();
    8000451c:	b41fe0ef          	jal	8000305c <end_op>
    return -1;
    80004520:	557d                	li	a0,-1
    80004522:	bfcd                	j	80004514 <sys_mknod+0x50>

0000000080004524 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004524:	7135                	addi	sp,sp,-160
    80004526:	ed06                	sd	ra,152(sp)
    80004528:	e922                	sd	s0,144(sp)
    8000452a:	e14a                	sd	s2,128(sp)
    8000452c:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000452e:	873fc0ef          	jal	80000da0 <myproc>
    80004532:	892a                	mv	s2,a0
  
  begin_op();
    80004534:	abffe0ef          	jal	80002ff2 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004538:	08000613          	li	a2,128
    8000453c:	f6040593          	addi	a1,s0,-160
    80004540:	4501                	li	a0,0
    80004542:	fd2fd0ef          	jal	80001d14 <argstr>
    80004546:	04054363          	bltz	a0,8000458c <sys_chdir+0x68>
    8000454a:	e526                	sd	s1,136(sp)
    8000454c:	f6040513          	addi	a0,s0,-160
    80004550:	8e7fe0ef          	jal	80002e36 <namei>
    80004554:	84aa                	mv	s1,a0
    80004556:	c915                	beqz	a0,8000458a <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004558:	a04fe0ef          	jal	8000275c <ilock>
  if(ip->type != T_DIR){
    8000455c:	04449703          	lh	a4,68(s1)
    80004560:	4785                	li	a5,1
    80004562:	02f71963          	bne	a4,a5,80004594 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004566:	8526                	mv	a0,s1
    80004568:	aa2fe0ef          	jal	8000280a <iunlock>
  iput(p->cwd);
    8000456c:	15893503          	ld	a0,344(s2)
    80004570:	b6efe0ef          	jal	800028de <iput>
  end_op();
    80004574:	ae9fe0ef          	jal	8000305c <end_op>
  p->cwd = ip;
    80004578:	14993c23          	sd	s1,344(s2)
  return 0;
    8000457c:	4501                	li	a0,0
    8000457e:	64aa                	ld	s1,136(sp)
}
    80004580:	60ea                	ld	ra,152(sp)
    80004582:	644a                	ld	s0,144(sp)
    80004584:	690a                	ld	s2,128(sp)
    80004586:	610d                	addi	sp,sp,160
    80004588:	8082                	ret
    8000458a:	64aa                	ld	s1,136(sp)
    end_op();
    8000458c:	ad1fe0ef          	jal	8000305c <end_op>
    return -1;
    80004590:	557d                	li	a0,-1
    80004592:	b7fd                	j	80004580 <sys_chdir+0x5c>
    iunlockput(ip);
    80004594:	8526                	mv	a0,s1
    80004596:	bd0fe0ef          	jal	80002966 <iunlockput>
    end_op();
    8000459a:	ac3fe0ef          	jal	8000305c <end_op>
    return -1;
    8000459e:	557d                	li	a0,-1
    800045a0:	64aa                	ld	s1,136(sp)
    800045a2:	bff9                	j	80004580 <sys_chdir+0x5c>

00000000800045a4 <sys_exec>:

uint64
sys_exec(void)
{
    800045a4:	7121                	addi	sp,sp,-448
    800045a6:	ff06                	sd	ra,440(sp)
    800045a8:	fb22                	sd	s0,432(sp)
    800045aa:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800045ac:	e4840593          	addi	a1,s0,-440
    800045b0:	4505                	li	a0,1
    800045b2:	f46fd0ef          	jal	80001cf8 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800045b6:	08000613          	li	a2,128
    800045ba:	f5040593          	addi	a1,s0,-176
    800045be:	4501                	li	a0,0
    800045c0:	f54fd0ef          	jal	80001d14 <argstr>
    800045c4:	87aa                	mv	a5,a0
    return -1;
    800045c6:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800045c8:	0c07c463          	bltz	a5,80004690 <sys_exec+0xec>
    800045cc:	f726                	sd	s1,424(sp)
    800045ce:	f34a                	sd	s2,416(sp)
    800045d0:	ef4e                	sd	s3,408(sp)
    800045d2:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    800045d4:	10000613          	li	a2,256
    800045d8:	4581                	li	a1,0
    800045da:	e5040513          	addi	a0,s0,-432
    800045de:	b71fb0ef          	jal	8000014e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800045e2:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800045e6:	89a6                	mv	s3,s1
    800045e8:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800045ea:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800045ee:	00391513          	slli	a0,s2,0x3
    800045f2:	e4040593          	addi	a1,s0,-448
    800045f6:	e4843783          	ld	a5,-440(s0)
    800045fa:	953e                	add	a0,a0,a5
    800045fc:	e56fd0ef          	jal	80001c52 <fetchaddr>
    80004600:	02054663          	bltz	a0,8000462c <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    80004604:	e4043783          	ld	a5,-448(s0)
    80004608:	c3a9                	beqz	a5,8000464a <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000460a:	af5fb0ef          	jal	800000fe <kalloc>
    8000460e:	85aa                	mv	a1,a0
    80004610:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004614:	cd01                	beqz	a0,8000462c <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004616:	6605                	lui	a2,0x1
    80004618:	e4043503          	ld	a0,-448(s0)
    8000461c:	e80fd0ef          	jal	80001c9c <fetchstr>
    80004620:	00054663          	bltz	a0,8000462c <sys_exec+0x88>
    if(i >= NELEM(argv)){
    80004624:	0905                	addi	s2,s2,1
    80004626:	09a1                	addi	s3,s3,8
    80004628:	fd4913e3          	bne	s2,s4,800045ee <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000462c:	f5040913          	addi	s2,s0,-176
    80004630:	6088                	ld	a0,0(s1)
    80004632:	c931                	beqz	a0,80004686 <sys_exec+0xe2>
    kfree(argv[i]);
    80004634:	9e9fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004638:	04a1                	addi	s1,s1,8
    8000463a:	ff249be3          	bne	s1,s2,80004630 <sys_exec+0x8c>
  return -1;
    8000463e:	557d                	li	a0,-1
    80004640:	74ba                	ld	s1,424(sp)
    80004642:	791a                	ld	s2,416(sp)
    80004644:	69fa                	ld	s3,408(sp)
    80004646:	6a5a                	ld	s4,400(sp)
    80004648:	a0a1                	j	80004690 <sys_exec+0xec>
      argv[i] = 0;
    8000464a:	0009079b          	sext.w	a5,s2
    8000464e:	078e                	slli	a5,a5,0x3
    80004650:	fd078793          	addi	a5,a5,-48
    80004654:	97a2                	add	a5,a5,s0
    80004656:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    8000465a:	e5040593          	addi	a1,s0,-432
    8000465e:	f5040513          	addi	a0,s0,-176
    80004662:	ba8ff0ef          	jal	80003a0a <exec>
    80004666:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004668:	f5040993          	addi	s3,s0,-176
    8000466c:	6088                	ld	a0,0(s1)
    8000466e:	c511                	beqz	a0,8000467a <sys_exec+0xd6>
    kfree(argv[i]);
    80004670:	9adfb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004674:	04a1                	addi	s1,s1,8
    80004676:	ff349be3          	bne	s1,s3,8000466c <sys_exec+0xc8>
  return ret;
    8000467a:	854a                	mv	a0,s2
    8000467c:	74ba                	ld	s1,424(sp)
    8000467e:	791a                	ld	s2,416(sp)
    80004680:	69fa                	ld	s3,408(sp)
    80004682:	6a5a                	ld	s4,400(sp)
    80004684:	a031                	j	80004690 <sys_exec+0xec>
  return -1;
    80004686:	557d                	li	a0,-1
    80004688:	74ba                	ld	s1,424(sp)
    8000468a:	791a                	ld	s2,416(sp)
    8000468c:	69fa                	ld	s3,408(sp)
    8000468e:	6a5a                	ld	s4,400(sp)
}
    80004690:	70fa                	ld	ra,440(sp)
    80004692:	745a                	ld	s0,432(sp)
    80004694:	6139                	addi	sp,sp,448
    80004696:	8082                	ret

0000000080004698 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004698:	7139                	addi	sp,sp,-64
    8000469a:	fc06                	sd	ra,56(sp)
    8000469c:	f822                	sd	s0,48(sp)
    8000469e:	f426                	sd	s1,40(sp)
    800046a0:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800046a2:	efefc0ef          	jal	80000da0 <myproc>
    800046a6:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800046a8:	fd840593          	addi	a1,s0,-40
    800046ac:	4501                	li	a0,0
    800046ae:	e4afd0ef          	jal	80001cf8 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800046b2:	fc840593          	addi	a1,s0,-56
    800046b6:	fd040513          	addi	a0,s0,-48
    800046ba:	85cff0ef          	jal	80003716 <pipealloc>
    return -1;
    800046be:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800046c0:	0a054463          	bltz	a0,80004768 <sys_pipe+0xd0>
  fd0 = -1;
    800046c4:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800046c8:	fd043503          	ld	a0,-48(s0)
    800046cc:	f08ff0ef          	jal	80003dd4 <fdalloc>
    800046d0:	fca42223          	sw	a0,-60(s0)
    800046d4:	08054163          	bltz	a0,80004756 <sys_pipe+0xbe>
    800046d8:	fc843503          	ld	a0,-56(s0)
    800046dc:	ef8ff0ef          	jal	80003dd4 <fdalloc>
    800046e0:	fca42023          	sw	a0,-64(s0)
    800046e4:	06054063          	bltz	a0,80004744 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800046e8:	4691                	li	a3,4
    800046ea:	fc440613          	addi	a2,s0,-60
    800046ee:	fd843583          	ld	a1,-40(s0)
    800046f2:	68a8                	ld	a0,80(s1)
    800046f4:	afefc0ef          	jal	800009f2 <copyout>
    800046f8:	00054e63          	bltz	a0,80004714 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800046fc:	4691                	li	a3,4
    800046fe:	fc040613          	addi	a2,s0,-64
    80004702:	fd843583          	ld	a1,-40(s0)
    80004706:	0591                	addi	a1,a1,4
    80004708:	68a8                	ld	a0,80(s1)
    8000470a:	ae8fc0ef          	jal	800009f2 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000470e:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004710:	04055c63          	bgez	a0,80004768 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80004714:	fc442783          	lw	a5,-60(s0)
    80004718:	07e9                	addi	a5,a5,26
    8000471a:	078e                	slli	a5,a5,0x3
    8000471c:	97a6                	add	a5,a5,s1
    8000471e:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80004722:	fc042783          	lw	a5,-64(s0)
    80004726:	07e9                	addi	a5,a5,26
    80004728:	078e                	slli	a5,a5,0x3
    8000472a:	94be                	add	s1,s1,a5
    8000472c:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    80004730:	fd043503          	ld	a0,-48(s0)
    80004734:	cd9fe0ef          	jal	8000340c <fileclose>
    fileclose(wf);
    80004738:	fc843503          	ld	a0,-56(s0)
    8000473c:	cd1fe0ef          	jal	8000340c <fileclose>
    return -1;
    80004740:	57fd                	li	a5,-1
    80004742:	a01d                	j	80004768 <sys_pipe+0xd0>
    if(fd0 >= 0)
    80004744:	fc442783          	lw	a5,-60(s0)
    80004748:	0007c763          	bltz	a5,80004756 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    8000474c:	07e9                	addi	a5,a5,26
    8000474e:	078e                	slli	a5,a5,0x3
    80004750:	97a6                	add	a5,a5,s1
    80004752:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    80004756:	fd043503          	ld	a0,-48(s0)
    8000475a:	cb3fe0ef          	jal	8000340c <fileclose>
    fileclose(wf);
    8000475e:	fc843503          	ld	a0,-56(s0)
    80004762:	cabfe0ef          	jal	8000340c <fileclose>
    return -1;
    80004766:	57fd                	li	a5,-1
}
    80004768:	853e                	mv	a0,a5
    8000476a:	70e2                	ld	ra,56(sp)
    8000476c:	7442                	ld	s0,48(sp)
    8000476e:	74a2                	ld	s1,40(sp)
    80004770:	6121                	addi	sp,sp,64
    80004772:	8082                	ret
	...

0000000080004780 <kernelvec>:
    80004780:	7111                	addi	sp,sp,-256
    80004782:	e006                	sd	ra,0(sp)
    80004784:	e40a                	sd	sp,8(sp)
    80004786:	e80e                	sd	gp,16(sp)
    80004788:	ec12                	sd	tp,24(sp)
    8000478a:	f016                	sd	t0,32(sp)
    8000478c:	f41a                	sd	t1,40(sp)
    8000478e:	f81e                	sd	t2,48(sp)
    80004790:	e4aa                	sd	a0,72(sp)
    80004792:	e8ae                	sd	a1,80(sp)
    80004794:	ecb2                	sd	a2,88(sp)
    80004796:	f0b6                	sd	a3,96(sp)
    80004798:	f4ba                	sd	a4,104(sp)
    8000479a:	f8be                	sd	a5,112(sp)
    8000479c:	fcc2                	sd	a6,120(sp)
    8000479e:	e146                	sd	a7,128(sp)
    800047a0:	edf2                	sd	t3,216(sp)
    800047a2:	f1f6                	sd	t4,224(sp)
    800047a4:	f5fa                	sd	t5,232(sp)
    800047a6:	f9fe                	sd	t6,240(sp)
    800047a8:	bbafd0ef          	jal	80001b62 <kerneltrap>
    800047ac:	6082                	ld	ra,0(sp)
    800047ae:	6122                	ld	sp,8(sp)
    800047b0:	61c2                	ld	gp,16(sp)
    800047b2:	7282                	ld	t0,32(sp)
    800047b4:	7322                	ld	t1,40(sp)
    800047b6:	73c2                	ld	t2,48(sp)
    800047b8:	6526                	ld	a0,72(sp)
    800047ba:	65c6                	ld	a1,80(sp)
    800047bc:	6666                	ld	a2,88(sp)
    800047be:	7686                	ld	a3,96(sp)
    800047c0:	7726                	ld	a4,104(sp)
    800047c2:	77c6                	ld	a5,112(sp)
    800047c4:	7866                	ld	a6,120(sp)
    800047c6:	688a                	ld	a7,128(sp)
    800047c8:	6e6e                	ld	t3,216(sp)
    800047ca:	7e8e                	ld	t4,224(sp)
    800047cc:	7f2e                	ld	t5,232(sp)
    800047ce:	7fce                	ld	t6,240(sp)
    800047d0:	6111                	addi	sp,sp,256
    800047d2:	10200073          	sret
	...

00000000800047de <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800047de:	1141                	addi	sp,sp,-16
    800047e0:	e422                	sd	s0,8(sp)
    800047e2:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800047e4:	0c0007b7          	lui	a5,0xc000
    800047e8:	4705                	li	a4,1
    800047ea:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800047ec:	0c0007b7          	lui	a5,0xc000
    800047f0:	c3d8                	sw	a4,4(a5)
}
    800047f2:	6422                	ld	s0,8(sp)
    800047f4:	0141                	addi	sp,sp,16
    800047f6:	8082                	ret

00000000800047f8 <plicinithart>:

void
plicinithart(void)
{
    800047f8:	1141                	addi	sp,sp,-16
    800047fa:	e406                	sd	ra,8(sp)
    800047fc:	e022                	sd	s0,0(sp)
    800047fe:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004800:	d74fc0ef          	jal	80000d74 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004804:	0085171b          	slliw	a4,a0,0x8
    80004808:	0c0027b7          	lui	a5,0xc002
    8000480c:	97ba                	add	a5,a5,a4
    8000480e:	40200713          	li	a4,1026
    80004812:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004816:	00d5151b          	slliw	a0,a0,0xd
    8000481a:	0c2017b7          	lui	a5,0xc201
    8000481e:	97aa                	add	a5,a5,a0
    80004820:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80004824:	60a2                	ld	ra,8(sp)
    80004826:	6402                	ld	s0,0(sp)
    80004828:	0141                	addi	sp,sp,16
    8000482a:	8082                	ret

000000008000482c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000482c:	1141                	addi	sp,sp,-16
    8000482e:	e406                	sd	ra,8(sp)
    80004830:	e022                	sd	s0,0(sp)
    80004832:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004834:	d40fc0ef          	jal	80000d74 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004838:	00d5151b          	slliw	a0,a0,0xd
    8000483c:	0c2017b7          	lui	a5,0xc201
    80004840:	97aa                	add	a5,a5,a0
  return irq;
}
    80004842:	43c8                	lw	a0,4(a5)
    80004844:	60a2                	ld	ra,8(sp)
    80004846:	6402                	ld	s0,0(sp)
    80004848:	0141                	addi	sp,sp,16
    8000484a:	8082                	ret

000000008000484c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000484c:	1101                	addi	sp,sp,-32
    8000484e:	ec06                	sd	ra,24(sp)
    80004850:	e822                	sd	s0,16(sp)
    80004852:	e426                	sd	s1,8(sp)
    80004854:	1000                	addi	s0,sp,32
    80004856:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004858:	d1cfc0ef          	jal	80000d74 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000485c:	00d5151b          	slliw	a0,a0,0xd
    80004860:	0c2017b7          	lui	a5,0xc201
    80004864:	97aa                	add	a5,a5,a0
    80004866:	c3c4                	sw	s1,4(a5)
}
    80004868:	60e2                	ld	ra,24(sp)
    8000486a:	6442                	ld	s0,16(sp)
    8000486c:	64a2                	ld	s1,8(sp)
    8000486e:	6105                	addi	sp,sp,32
    80004870:	8082                	ret

0000000080004872 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004872:	1141                	addi	sp,sp,-16
    80004874:	e406                	sd	ra,8(sp)
    80004876:	e022                	sd	s0,0(sp)
    80004878:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000487a:	479d                	li	a5,7
    8000487c:	04a7ca63          	blt	a5,a0,800048d0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004880:	00017797          	auipc	a5,0x17
    80004884:	d9078793          	addi	a5,a5,-624 # 8001b610 <disk>
    80004888:	97aa                	add	a5,a5,a0
    8000488a:	0187c783          	lbu	a5,24(a5)
    8000488e:	e7b9                	bnez	a5,800048dc <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004890:	00451693          	slli	a3,a0,0x4
    80004894:	00017797          	auipc	a5,0x17
    80004898:	d7c78793          	addi	a5,a5,-644 # 8001b610 <disk>
    8000489c:	6398                	ld	a4,0(a5)
    8000489e:	9736                	add	a4,a4,a3
    800048a0:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    800048a4:	6398                	ld	a4,0(a5)
    800048a6:	9736                	add	a4,a4,a3
    800048a8:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800048ac:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800048b0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800048b4:	97aa                	add	a5,a5,a0
    800048b6:	4705                	li	a4,1
    800048b8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800048bc:	00017517          	auipc	a0,0x17
    800048c0:	d6c50513          	addi	a0,a0,-660 # 8001b628 <disk+0x18>
    800048c4:	b7ffc0ef          	jal	80001442 <wakeup>
}
    800048c8:	60a2                	ld	ra,8(sp)
    800048ca:	6402                	ld	s0,0(sp)
    800048cc:	0141                	addi	sp,sp,16
    800048ce:	8082                	ret
    panic("free_desc 1");
    800048d0:	00003517          	auipc	a0,0x3
    800048d4:	d5050513          	addi	a0,a0,-688 # 80007620 <etext+0x620>
    800048d8:	43b000ef          	jal	80005512 <panic>
    panic("free_desc 2");
    800048dc:	00003517          	auipc	a0,0x3
    800048e0:	d5450513          	addi	a0,a0,-684 # 80007630 <etext+0x630>
    800048e4:	42f000ef          	jal	80005512 <panic>

00000000800048e8 <virtio_disk_init>:
{
    800048e8:	1101                	addi	sp,sp,-32
    800048ea:	ec06                	sd	ra,24(sp)
    800048ec:	e822                	sd	s0,16(sp)
    800048ee:	e426                	sd	s1,8(sp)
    800048f0:	e04a                	sd	s2,0(sp)
    800048f2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800048f4:	00003597          	auipc	a1,0x3
    800048f8:	d4c58593          	addi	a1,a1,-692 # 80007640 <etext+0x640>
    800048fc:	00017517          	auipc	a0,0x17
    80004900:	e3c50513          	addi	a0,a0,-452 # 8001b738 <disk+0x128>
    80004904:	6bd000ef          	jal	800057c0 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004908:	100017b7          	lui	a5,0x10001
    8000490c:	4398                	lw	a4,0(a5)
    8000490e:	2701                	sext.w	a4,a4
    80004910:	747277b7          	lui	a5,0x74727
    80004914:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004918:	18f71063          	bne	a4,a5,80004a98 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000491c:	100017b7          	lui	a5,0x10001
    80004920:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80004922:	439c                	lw	a5,0(a5)
    80004924:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004926:	4709                	li	a4,2
    80004928:	16e79863          	bne	a5,a4,80004a98 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000492c:	100017b7          	lui	a5,0x10001
    80004930:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80004932:	439c                	lw	a5,0(a5)
    80004934:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004936:	16e79163          	bne	a5,a4,80004a98 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000493a:	100017b7          	lui	a5,0x10001
    8000493e:	47d8                	lw	a4,12(a5)
    80004940:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004942:	554d47b7          	lui	a5,0x554d4
    80004946:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000494a:	14f71763          	bne	a4,a5,80004a98 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000494e:	100017b7          	lui	a5,0x10001
    80004952:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004956:	4705                	li	a4,1
    80004958:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000495a:	470d                	li	a4,3
    8000495c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000495e:	10001737          	lui	a4,0x10001
    80004962:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004964:	c7ffe737          	lui	a4,0xc7ffe
    80004968:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdaf0f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000496c:	8ef9                	and	a3,a3,a4
    8000496e:	10001737          	lui	a4,0x10001
    80004972:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004974:	472d                	li	a4,11
    80004976:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004978:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    8000497c:	439c                	lw	a5,0(a5)
    8000497e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004982:	8ba1                	andi	a5,a5,8
    80004984:	12078063          	beqz	a5,80004aa4 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004988:	100017b7          	lui	a5,0x10001
    8000498c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004990:	100017b7          	lui	a5,0x10001
    80004994:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80004998:	439c                	lw	a5,0(a5)
    8000499a:	2781                	sext.w	a5,a5
    8000499c:	10079a63          	bnez	a5,80004ab0 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800049a0:	100017b7          	lui	a5,0x10001
    800049a4:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    800049a8:	439c                	lw	a5,0(a5)
    800049aa:	2781                	sext.w	a5,a5
  if(max == 0)
    800049ac:	10078863          	beqz	a5,80004abc <virtio_disk_init+0x1d4>
  if(max < NUM)
    800049b0:	471d                	li	a4,7
    800049b2:	10f77b63          	bgeu	a4,a5,80004ac8 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    800049b6:	f48fb0ef          	jal	800000fe <kalloc>
    800049ba:	00017497          	auipc	s1,0x17
    800049be:	c5648493          	addi	s1,s1,-938 # 8001b610 <disk>
    800049c2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800049c4:	f3afb0ef          	jal	800000fe <kalloc>
    800049c8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800049ca:	f34fb0ef          	jal	800000fe <kalloc>
    800049ce:	87aa                	mv	a5,a0
    800049d0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800049d2:	6088                	ld	a0,0(s1)
    800049d4:	10050063          	beqz	a0,80004ad4 <virtio_disk_init+0x1ec>
    800049d8:	00017717          	auipc	a4,0x17
    800049dc:	c4073703          	ld	a4,-960(a4) # 8001b618 <disk+0x8>
    800049e0:	0e070a63          	beqz	a4,80004ad4 <virtio_disk_init+0x1ec>
    800049e4:	0e078863          	beqz	a5,80004ad4 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    800049e8:	6605                	lui	a2,0x1
    800049ea:	4581                	li	a1,0
    800049ec:	f62fb0ef          	jal	8000014e <memset>
  memset(disk.avail, 0, PGSIZE);
    800049f0:	00017497          	auipc	s1,0x17
    800049f4:	c2048493          	addi	s1,s1,-992 # 8001b610 <disk>
    800049f8:	6605                	lui	a2,0x1
    800049fa:	4581                	li	a1,0
    800049fc:	6488                	ld	a0,8(s1)
    800049fe:	f50fb0ef          	jal	8000014e <memset>
  memset(disk.used, 0, PGSIZE);
    80004a02:	6605                	lui	a2,0x1
    80004a04:	4581                	li	a1,0
    80004a06:	6888                	ld	a0,16(s1)
    80004a08:	f46fb0ef          	jal	8000014e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004a0c:	100017b7          	lui	a5,0x10001
    80004a10:	4721                	li	a4,8
    80004a12:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004a14:	4098                	lw	a4,0(s1)
    80004a16:	100017b7          	lui	a5,0x10001
    80004a1a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004a1e:	40d8                	lw	a4,4(s1)
    80004a20:	100017b7          	lui	a5,0x10001
    80004a24:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004a28:	649c                	ld	a5,8(s1)
    80004a2a:	0007869b          	sext.w	a3,a5
    80004a2e:	10001737          	lui	a4,0x10001
    80004a32:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004a36:	9781                	srai	a5,a5,0x20
    80004a38:	10001737          	lui	a4,0x10001
    80004a3c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004a40:	689c                	ld	a5,16(s1)
    80004a42:	0007869b          	sext.w	a3,a5
    80004a46:	10001737          	lui	a4,0x10001
    80004a4a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004a4e:	9781                	srai	a5,a5,0x20
    80004a50:	10001737          	lui	a4,0x10001
    80004a54:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004a58:	10001737          	lui	a4,0x10001
    80004a5c:	4785                	li	a5,1
    80004a5e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004a60:	00f48c23          	sb	a5,24(s1)
    80004a64:	00f48ca3          	sb	a5,25(s1)
    80004a68:	00f48d23          	sb	a5,26(s1)
    80004a6c:	00f48da3          	sb	a5,27(s1)
    80004a70:	00f48e23          	sb	a5,28(s1)
    80004a74:	00f48ea3          	sb	a5,29(s1)
    80004a78:	00f48f23          	sb	a5,30(s1)
    80004a7c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004a80:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a84:	100017b7          	lui	a5,0x10001
    80004a88:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    80004a8c:	60e2                	ld	ra,24(sp)
    80004a8e:	6442                	ld	s0,16(sp)
    80004a90:	64a2                	ld	s1,8(sp)
    80004a92:	6902                	ld	s2,0(sp)
    80004a94:	6105                	addi	sp,sp,32
    80004a96:	8082                	ret
    panic("could not find virtio disk");
    80004a98:	00003517          	auipc	a0,0x3
    80004a9c:	bb850513          	addi	a0,a0,-1096 # 80007650 <etext+0x650>
    80004aa0:	273000ef          	jal	80005512 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004aa4:	00003517          	auipc	a0,0x3
    80004aa8:	bcc50513          	addi	a0,a0,-1076 # 80007670 <etext+0x670>
    80004aac:	267000ef          	jal	80005512 <panic>
    panic("virtio disk should not be ready");
    80004ab0:	00003517          	auipc	a0,0x3
    80004ab4:	be050513          	addi	a0,a0,-1056 # 80007690 <etext+0x690>
    80004ab8:	25b000ef          	jal	80005512 <panic>
    panic("virtio disk has no queue 0");
    80004abc:	00003517          	auipc	a0,0x3
    80004ac0:	bf450513          	addi	a0,a0,-1036 # 800076b0 <etext+0x6b0>
    80004ac4:	24f000ef          	jal	80005512 <panic>
    panic("virtio disk max queue too short");
    80004ac8:	00003517          	auipc	a0,0x3
    80004acc:	c0850513          	addi	a0,a0,-1016 # 800076d0 <etext+0x6d0>
    80004ad0:	243000ef          	jal	80005512 <panic>
    panic("virtio disk kalloc");
    80004ad4:	00003517          	auipc	a0,0x3
    80004ad8:	c1c50513          	addi	a0,a0,-996 # 800076f0 <etext+0x6f0>
    80004adc:	237000ef          	jal	80005512 <panic>

0000000080004ae0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004ae0:	7159                	addi	sp,sp,-112
    80004ae2:	f486                	sd	ra,104(sp)
    80004ae4:	f0a2                	sd	s0,96(sp)
    80004ae6:	eca6                	sd	s1,88(sp)
    80004ae8:	e8ca                	sd	s2,80(sp)
    80004aea:	e4ce                	sd	s3,72(sp)
    80004aec:	e0d2                	sd	s4,64(sp)
    80004aee:	fc56                	sd	s5,56(sp)
    80004af0:	f85a                	sd	s6,48(sp)
    80004af2:	f45e                	sd	s7,40(sp)
    80004af4:	f062                	sd	s8,32(sp)
    80004af6:	ec66                	sd	s9,24(sp)
    80004af8:	1880                	addi	s0,sp,112
    80004afa:	8a2a                	mv	s4,a0
    80004afc:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004afe:	00c52c83          	lw	s9,12(a0)
    80004b02:	001c9c9b          	slliw	s9,s9,0x1
    80004b06:	1c82                	slli	s9,s9,0x20
    80004b08:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80004b0c:	00017517          	auipc	a0,0x17
    80004b10:	c2c50513          	addi	a0,a0,-980 # 8001b738 <disk+0x128>
    80004b14:	52d000ef          	jal	80005840 <acquire>
  for(int i = 0; i < 3; i++){
    80004b18:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80004b1a:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004b1c:	00017b17          	auipc	s6,0x17
    80004b20:	af4b0b13          	addi	s6,s6,-1292 # 8001b610 <disk>
  for(int i = 0; i < 3; i++){
    80004b24:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004b26:	00017c17          	auipc	s8,0x17
    80004b2a:	c12c0c13          	addi	s8,s8,-1006 # 8001b738 <disk+0x128>
    80004b2e:	a8b9                	j	80004b8c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80004b30:	00fb0733          	add	a4,s6,a5
    80004b34:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80004b38:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004b3a:	0207c563          	bltz	a5,80004b64 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80004b3e:	2905                	addiw	s2,s2,1
    80004b40:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004b42:	05590963          	beq	s2,s5,80004b94 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80004b46:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004b48:	00017717          	auipc	a4,0x17
    80004b4c:	ac870713          	addi	a4,a4,-1336 # 8001b610 <disk>
    80004b50:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80004b52:	01874683          	lbu	a3,24(a4)
    80004b56:	fee9                	bnez	a3,80004b30 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80004b58:	2785                	addiw	a5,a5,1
    80004b5a:	0705                	addi	a4,a4,1
    80004b5c:	fe979be3          	bne	a5,s1,80004b52 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80004b60:	57fd                	li	a5,-1
    80004b62:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80004b64:	01205d63          	blez	s2,80004b7e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004b68:	f9042503          	lw	a0,-112(s0)
    80004b6c:	d07ff0ef          	jal	80004872 <free_desc>
      for(int j = 0; j < i; j++)
    80004b70:	4785                	li	a5,1
    80004b72:	0127d663          	bge	a5,s2,80004b7e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004b76:	f9442503          	lw	a0,-108(s0)
    80004b7a:	cf9ff0ef          	jal	80004872 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004b7e:	85e2                	mv	a1,s8
    80004b80:	00017517          	auipc	a0,0x17
    80004b84:	aa850513          	addi	a0,a0,-1368 # 8001b628 <disk+0x18>
    80004b88:	86ffc0ef          	jal	800013f6 <sleep>
  for(int i = 0; i < 3; i++){
    80004b8c:	f9040613          	addi	a2,s0,-112
    80004b90:	894e                	mv	s2,s3
    80004b92:	bf55                	j	80004b46 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004b94:	f9042503          	lw	a0,-112(s0)
    80004b98:	00451693          	slli	a3,a0,0x4

  if(write)
    80004b9c:	00017797          	auipc	a5,0x17
    80004ba0:	a7478793          	addi	a5,a5,-1420 # 8001b610 <disk>
    80004ba4:	00a50713          	addi	a4,a0,10
    80004ba8:	0712                	slli	a4,a4,0x4
    80004baa:	973e                	add	a4,a4,a5
    80004bac:	01703633          	snez	a2,s7
    80004bb0:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004bb2:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004bb6:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004bba:	6398                	ld	a4,0(a5)
    80004bbc:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004bbe:	0a868613          	addi	a2,a3,168
    80004bc2:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004bc4:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004bc6:	6390                	ld	a2,0(a5)
    80004bc8:	00d605b3          	add	a1,a2,a3
    80004bcc:	4741                	li	a4,16
    80004bce:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004bd0:	4805                	li	a6,1
    80004bd2:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80004bd6:	f9442703          	lw	a4,-108(s0)
    80004bda:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004bde:	0712                	slli	a4,a4,0x4
    80004be0:	963a                	add	a2,a2,a4
    80004be2:	058a0593          	addi	a1,s4,88
    80004be6:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004be8:	0007b883          	ld	a7,0(a5)
    80004bec:	9746                	add	a4,a4,a7
    80004bee:	40000613          	li	a2,1024
    80004bf2:	c710                	sw	a2,8(a4)
  if(write)
    80004bf4:	001bb613          	seqz	a2,s7
    80004bf8:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004bfc:	00166613          	ori	a2,a2,1
    80004c00:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004c04:	f9842583          	lw	a1,-104(s0)
    80004c08:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004c0c:	00250613          	addi	a2,a0,2
    80004c10:	0612                	slli	a2,a2,0x4
    80004c12:	963e                	add	a2,a2,a5
    80004c14:	577d                	li	a4,-1
    80004c16:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004c1a:	0592                	slli	a1,a1,0x4
    80004c1c:	98ae                	add	a7,a7,a1
    80004c1e:	03068713          	addi	a4,a3,48
    80004c22:	973e                	add	a4,a4,a5
    80004c24:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004c28:	6398                	ld	a4,0(a5)
    80004c2a:	972e                	add	a4,a4,a1
    80004c2c:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004c30:	4689                	li	a3,2
    80004c32:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004c36:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004c3a:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80004c3e:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004c42:	6794                	ld	a3,8(a5)
    80004c44:	0026d703          	lhu	a4,2(a3)
    80004c48:	8b1d                	andi	a4,a4,7
    80004c4a:	0706                	slli	a4,a4,0x1
    80004c4c:	96ba                	add	a3,a3,a4
    80004c4e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004c52:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004c56:	6798                	ld	a4,8(a5)
    80004c58:	00275783          	lhu	a5,2(a4)
    80004c5c:	2785                	addiw	a5,a5,1
    80004c5e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004c62:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004c66:	100017b7          	lui	a5,0x10001
    80004c6a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004c6e:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80004c72:	00017917          	auipc	s2,0x17
    80004c76:	ac690913          	addi	s2,s2,-1338 # 8001b738 <disk+0x128>
  while(b->disk == 1) {
    80004c7a:	4485                	li	s1,1
    80004c7c:	01079a63          	bne	a5,a6,80004c90 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80004c80:	85ca                	mv	a1,s2
    80004c82:	8552                	mv	a0,s4
    80004c84:	f72fc0ef          	jal	800013f6 <sleep>
  while(b->disk == 1) {
    80004c88:	004a2783          	lw	a5,4(s4)
    80004c8c:	fe978ae3          	beq	a5,s1,80004c80 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80004c90:	f9042903          	lw	s2,-112(s0)
    80004c94:	00290713          	addi	a4,s2,2
    80004c98:	0712                	slli	a4,a4,0x4
    80004c9a:	00017797          	auipc	a5,0x17
    80004c9e:	97678793          	addi	a5,a5,-1674 # 8001b610 <disk>
    80004ca2:	97ba                	add	a5,a5,a4
    80004ca4:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004ca8:	00017997          	auipc	s3,0x17
    80004cac:	96898993          	addi	s3,s3,-1688 # 8001b610 <disk>
    80004cb0:	00491713          	slli	a4,s2,0x4
    80004cb4:	0009b783          	ld	a5,0(s3)
    80004cb8:	97ba                	add	a5,a5,a4
    80004cba:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004cbe:	854a                	mv	a0,s2
    80004cc0:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004cc4:	bafff0ef          	jal	80004872 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004cc8:	8885                	andi	s1,s1,1
    80004cca:	f0fd                	bnez	s1,80004cb0 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004ccc:	00017517          	auipc	a0,0x17
    80004cd0:	a6c50513          	addi	a0,a0,-1428 # 8001b738 <disk+0x128>
    80004cd4:	405000ef          	jal	800058d8 <release>
}
    80004cd8:	70a6                	ld	ra,104(sp)
    80004cda:	7406                	ld	s0,96(sp)
    80004cdc:	64e6                	ld	s1,88(sp)
    80004cde:	6946                	ld	s2,80(sp)
    80004ce0:	69a6                	ld	s3,72(sp)
    80004ce2:	6a06                	ld	s4,64(sp)
    80004ce4:	7ae2                	ld	s5,56(sp)
    80004ce6:	7b42                	ld	s6,48(sp)
    80004ce8:	7ba2                	ld	s7,40(sp)
    80004cea:	7c02                	ld	s8,32(sp)
    80004cec:	6ce2                	ld	s9,24(sp)
    80004cee:	6165                	addi	sp,sp,112
    80004cf0:	8082                	ret

0000000080004cf2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004cf2:	1101                	addi	sp,sp,-32
    80004cf4:	ec06                	sd	ra,24(sp)
    80004cf6:	e822                	sd	s0,16(sp)
    80004cf8:	e426                	sd	s1,8(sp)
    80004cfa:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004cfc:	00017497          	auipc	s1,0x17
    80004d00:	91448493          	addi	s1,s1,-1772 # 8001b610 <disk>
    80004d04:	00017517          	auipc	a0,0x17
    80004d08:	a3450513          	addi	a0,a0,-1484 # 8001b738 <disk+0x128>
    80004d0c:	335000ef          	jal	80005840 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004d10:	100017b7          	lui	a5,0x10001
    80004d14:	53b8                	lw	a4,96(a5)
    80004d16:	8b0d                	andi	a4,a4,3
    80004d18:	100017b7          	lui	a5,0x10001
    80004d1c:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80004d1e:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004d22:	689c                	ld	a5,16(s1)
    80004d24:	0204d703          	lhu	a4,32(s1)
    80004d28:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004d2c:	04f70663          	beq	a4,a5,80004d78 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80004d30:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004d34:	6898                	ld	a4,16(s1)
    80004d36:	0204d783          	lhu	a5,32(s1)
    80004d3a:	8b9d                	andi	a5,a5,7
    80004d3c:	078e                	slli	a5,a5,0x3
    80004d3e:	97ba                	add	a5,a5,a4
    80004d40:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004d42:	00278713          	addi	a4,a5,2
    80004d46:	0712                	slli	a4,a4,0x4
    80004d48:	9726                	add	a4,a4,s1
    80004d4a:	01074703          	lbu	a4,16(a4)
    80004d4e:	e321                	bnez	a4,80004d8e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004d50:	0789                	addi	a5,a5,2
    80004d52:	0792                	slli	a5,a5,0x4
    80004d54:	97a6                	add	a5,a5,s1
    80004d56:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004d58:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004d5c:	ee6fc0ef          	jal	80001442 <wakeup>

    disk.used_idx += 1;
    80004d60:	0204d783          	lhu	a5,32(s1)
    80004d64:	2785                	addiw	a5,a5,1
    80004d66:	17c2                	slli	a5,a5,0x30
    80004d68:	93c1                	srli	a5,a5,0x30
    80004d6a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004d6e:	6898                	ld	a4,16(s1)
    80004d70:	00275703          	lhu	a4,2(a4)
    80004d74:	faf71ee3          	bne	a4,a5,80004d30 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004d78:	00017517          	auipc	a0,0x17
    80004d7c:	9c050513          	addi	a0,a0,-1600 # 8001b738 <disk+0x128>
    80004d80:	359000ef          	jal	800058d8 <release>
}
    80004d84:	60e2                	ld	ra,24(sp)
    80004d86:	6442                	ld	s0,16(sp)
    80004d88:	64a2                	ld	s1,8(sp)
    80004d8a:	6105                	addi	sp,sp,32
    80004d8c:	8082                	ret
      panic("virtio_disk_intr status");
    80004d8e:	00003517          	auipc	a0,0x3
    80004d92:	97a50513          	addi	a0,a0,-1670 # 80007708 <etext+0x708>
    80004d96:	77c000ef          	jal	80005512 <panic>

0000000080004d9a <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004d9a:	1141                	addi	sp,sp,-16
    80004d9c:	e422                	sd	s0,8(sp)
    80004d9e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004da0:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004da4:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004da8:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004dac:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004db0:	577d                	li	a4,-1
    80004db2:	177e                	slli	a4,a4,0x3f
    80004db4:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004db6:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004dba:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004dbe:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004dc2:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004dc6:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004dca:	000f4737          	lui	a4,0xf4
    80004dce:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004dd2:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004dd4:	14d79073          	csrw	stimecmp,a5
}
    80004dd8:	6422                	ld	s0,8(sp)
    80004dda:	0141                	addi	sp,sp,16
    80004ddc:	8082                	ret

0000000080004dde <start>:
{
    80004dde:	1141                	addi	sp,sp,-16
    80004de0:	e406                	sd	ra,8(sp)
    80004de2:	e022                	sd	s0,0(sp)
    80004de4:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004de6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004dea:	7779                	lui	a4,0xffffe
    80004dec:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdafaf>
    80004df0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004df2:	6705                	lui	a4,0x1
    80004df4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004df8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004dfa:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004dfe:	ffffb797          	auipc	a5,0xffffb
    80004e02:	4ea78793          	addi	a5,a5,1258 # 800002e8 <main>
    80004e06:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004e0a:	4781                	li	a5,0
    80004e0c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004e10:	67c1                	lui	a5,0x10
    80004e12:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80004e14:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004e18:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004e1c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80004e20:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80004e24:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004e28:	57fd                	li	a5,-1
    80004e2a:	83a9                	srli	a5,a5,0xa
    80004e2c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004e30:	47bd                	li	a5,15
    80004e32:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004e36:	f65ff0ef          	jal	80004d9a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004e3a:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004e3e:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80004e40:	823e                	mv	tp,a5
  asm volatile("mret");
    80004e42:	30200073          	mret
}
    80004e46:	60a2                	ld	ra,8(sp)
    80004e48:	6402                	ld	s0,0(sp)
    80004e4a:	0141                	addi	sp,sp,16
    80004e4c:	8082                	ret

0000000080004e4e <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004e4e:	715d                	addi	sp,sp,-80
    80004e50:	e486                	sd	ra,72(sp)
    80004e52:	e0a2                	sd	s0,64(sp)
    80004e54:	f84a                	sd	s2,48(sp)
    80004e56:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80004e58:	04c05263          	blez	a2,80004e9c <consolewrite+0x4e>
    80004e5c:	fc26                	sd	s1,56(sp)
    80004e5e:	f44e                	sd	s3,40(sp)
    80004e60:	f052                	sd	s4,32(sp)
    80004e62:	ec56                	sd	s5,24(sp)
    80004e64:	8a2a                	mv	s4,a0
    80004e66:	84ae                	mv	s1,a1
    80004e68:	89b2                	mv	s3,a2
    80004e6a:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80004e6c:	5afd                	li	s5,-1
    80004e6e:	4685                	li	a3,1
    80004e70:	8626                	mv	a2,s1
    80004e72:	85d2                	mv	a1,s4
    80004e74:	fbf40513          	addi	a0,s0,-65
    80004e78:	925fc0ef          	jal	8000179c <either_copyin>
    80004e7c:	03550263          	beq	a0,s5,80004ea0 <consolewrite+0x52>
      break;
    uartputc(c);
    80004e80:	fbf44503          	lbu	a0,-65(s0)
    80004e84:	035000ef          	jal	800056b8 <uartputc>
  for(i = 0; i < n; i++){
    80004e88:	2905                	addiw	s2,s2,1
    80004e8a:	0485                	addi	s1,s1,1
    80004e8c:	ff2991e3          	bne	s3,s2,80004e6e <consolewrite+0x20>
    80004e90:	894e                	mv	s2,s3
    80004e92:	74e2                	ld	s1,56(sp)
    80004e94:	79a2                	ld	s3,40(sp)
    80004e96:	7a02                	ld	s4,32(sp)
    80004e98:	6ae2                	ld	s5,24(sp)
    80004e9a:	a039                	j	80004ea8 <consolewrite+0x5a>
    80004e9c:	4901                	li	s2,0
    80004e9e:	a029                	j	80004ea8 <consolewrite+0x5a>
    80004ea0:	74e2                	ld	s1,56(sp)
    80004ea2:	79a2                	ld	s3,40(sp)
    80004ea4:	7a02                	ld	s4,32(sp)
    80004ea6:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80004ea8:	854a                	mv	a0,s2
    80004eaa:	60a6                	ld	ra,72(sp)
    80004eac:	6406                	ld	s0,64(sp)
    80004eae:	7942                	ld	s2,48(sp)
    80004eb0:	6161                	addi	sp,sp,80
    80004eb2:	8082                	ret

0000000080004eb4 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80004eb4:	711d                	addi	sp,sp,-96
    80004eb6:	ec86                	sd	ra,88(sp)
    80004eb8:	e8a2                	sd	s0,80(sp)
    80004eba:	e4a6                	sd	s1,72(sp)
    80004ebc:	e0ca                	sd	s2,64(sp)
    80004ebe:	fc4e                	sd	s3,56(sp)
    80004ec0:	f852                	sd	s4,48(sp)
    80004ec2:	f456                	sd	s5,40(sp)
    80004ec4:	f05a                	sd	s6,32(sp)
    80004ec6:	1080                	addi	s0,sp,96
    80004ec8:	8aaa                	mv	s5,a0
    80004eca:	8a2e                	mv	s4,a1
    80004ecc:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80004ece:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80004ed2:	0001f517          	auipc	a0,0x1f
    80004ed6:	87e50513          	addi	a0,a0,-1922 # 80023750 <cons>
    80004eda:	167000ef          	jal	80005840 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80004ede:	0001f497          	auipc	s1,0x1f
    80004ee2:	87248493          	addi	s1,s1,-1934 # 80023750 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80004ee6:	0001f917          	auipc	s2,0x1f
    80004eea:	90290913          	addi	s2,s2,-1790 # 800237e8 <cons+0x98>
  while(n > 0){
    80004eee:	0b305d63          	blez	s3,80004fa8 <consoleread+0xf4>
    while(cons.r == cons.w){
    80004ef2:	0984a783          	lw	a5,152(s1)
    80004ef6:	09c4a703          	lw	a4,156(s1)
    80004efa:	0af71263          	bne	a4,a5,80004f9e <consoleread+0xea>
      if(killed(myproc())){
    80004efe:	ea3fb0ef          	jal	80000da0 <myproc>
    80004f02:	f2cfc0ef          	jal	8000162e <killed>
    80004f06:	e12d                	bnez	a0,80004f68 <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    80004f08:	85a6                	mv	a1,s1
    80004f0a:	854a                	mv	a0,s2
    80004f0c:	ceafc0ef          	jal	800013f6 <sleep>
    while(cons.r == cons.w){
    80004f10:	0984a783          	lw	a5,152(s1)
    80004f14:	09c4a703          	lw	a4,156(s1)
    80004f18:	fef703e3          	beq	a4,a5,80004efe <consoleread+0x4a>
    80004f1c:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80004f1e:	0001f717          	auipc	a4,0x1f
    80004f22:	83270713          	addi	a4,a4,-1998 # 80023750 <cons>
    80004f26:	0017869b          	addiw	a3,a5,1
    80004f2a:	08d72c23          	sw	a3,152(a4)
    80004f2e:	07f7f693          	andi	a3,a5,127
    80004f32:	9736                	add	a4,a4,a3
    80004f34:	01874703          	lbu	a4,24(a4)
    80004f38:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80004f3c:	4691                	li	a3,4
    80004f3e:	04db8663          	beq	s7,a3,80004f8a <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80004f42:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80004f46:	4685                	li	a3,1
    80004f48:	faf40613          	addi	a2,s0,-81
    80004f4c:	85d2                	mv	a1,s4
    80004f4e:	8556                	mv	a0,s5
    80004f50:	803fc0ef          	jal	80001752 <either_copyout>
    80004f54:	57fd                	li	a5,-1
    80004f56:	04f50863          	beq	a0,a5,80004fa6 <consoleread+0xf2>
      break;

    dst++;
    80004f5a:	0a05                	addi	s4,s4,1
    --n;
    80004f5c:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80004f5e:	47a9                	li	a5,10
    80004f60:	04fb8d63          	beq	s7,a5,80004fba <consoleread+0x106>
    80004f64:	6be2                	ld	s7,24(sp)
    80004f66:	b761                	j	80004eee <consoleread+0x3a>
        release(&cons.lock);
    80004f68:	0001e517          	auipc	a0,0x1e
    80004f6c:	7e850513          	addi	a0,a0,2024 # 80023750 <cons>
    80004f70:	169000ef          	jal	800058d8 <release>
        return -1;
    80004f74:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80004f76:	60e6                	ld	ra,88(sp)
    80004f78:	6446                	ld	s0,80(sp)
    80004f7a:	64a6                	ld	s1,72(sp)
    80004f7c:	6906                	ld	s2,64(sp)
    80004f7e:	79e2                	ld	s3,56(sp)
    80004f80:	7a42                	ld	s4,48(sp)
    80004f82:	7aa2                	ld	s5,40(sp)
    80004f84:	7b02                	ld	s6,32(sp)
    80004f86:	6125                	addi	sp,sp,96
    80004f88:	8082                	ret
      if(n < target){
    80004f8a:	0009871b          	sext.w	a4,s3
    80004f8e:	01677a63          	bgeu	a4,s6,80004fa2 <consoleread+0xee>
        cons.r--;
    80004f92:	0001f717          	auipc	a4,0x1f
    80004f96:	84f72b23          	sw	a5,-1962(a4) # 800237e8 <cons+0x98>
    80004f9a:	6be2                	ld	s7,24(sp)
    80004f9c:	a031                	j	80004fa8 <consoleread+0xf4>
    80004f9e:	ec5e                	sd	s7,24(sp)
    80004fa0:	bfbd                	j	80004f1e <consoleread+0x6a>
    80004fa2:	6be2                	ld	s7,24(sp)
    80004fa4:	a011                	j	80004fa8 <consoleread+0xf4>
    80004fa6:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80004fa8:	0001e517          	auipc	a0,0x1e
    80004fac:	7a850513          	addi	a0,a0,1960 # 80023750 <cons>
    80004fb0:	129000ef          	jal	800058d8 <release>
  return target - n;
    80004fb4:	413b053b          	subw	a0,s6,s3
    80004fb8:	bf7d                	j	80004f76 <consoleread+0xc2>
    80004fba:	6be2                	ld	s7,24(sp)
    80004fbc:	b7f5                	j	80004fa8 <consoleread+0xf4>

0000000080004fbe <consputc>:
{
    80004fbe:	1141                	addi	sp,sp,-16
    80004fc0:	e406                	sd	ra,8(sp)
    80004fc2:	e022                	sd	s0,0(sp)
    80004fc4:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80004fc6:	10000793          	li	a5,256
    80004fca:	00f50863          	beq	a0,a5,80004fda <consputc+0x1c>
    uartputc_sync(c);
    80004fce:	604000ef          	jal	800055d2 <uartputc_sync>
}
    80004fd2:	60a2                	ld	ra,8(sp)
    80004fd4:	6402                	ld	s0,0(sp)
    80004fd6:	0141                	addi	sp,sp,16
    80004fd8:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80004fda:	4521                	li	a0,8
    80004fdc:	5f6000ef          	jal	800055d2 <uartputc_sync>
    80004fe0:	02000513          	li	a0,32
    80004fe4:	5ee000ef          	jal	800055d2 <uartputc_sync>
    80004fe8:	4521                	li	a0,8
    80004fea:	5e8000ef          	jal	800055d2 <uartputc_sync>
    80004fee:	b7d5                	j	80004fd2 <consputc+0x14>

0000000080004ff0 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80004ff0:	1101                	addi	sp,sp,-32
    80004ff2:	ec06                	sd	ra,24(sp)
    80004ff4:	e822                	sd	s0,16(sp)
    80004ff6:	e426                	sd	s1,8(sp)
    80004ff8:	1000                	addi	s0,sp,32
    80004ffa:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80004ffc:	0001e517          	auipc	a0,0x1e
    80005000:	75450513          	addi	a0,a0,1876 # 80023750 <cons>
    80005004:	03d000ef          	jal	80005840 <acquire>

  switch(c){
    80005008:	47d5                	li	a5,21
    8000500a:	08f48f63          	beq	s1,a5,800050a8 <consoleintr+0xb8>
    8000500e:	0297c563          	blt	a5,s1,80005038 <consoleintr+0x48>
    80005012:	47a1                	li	a5,8
    80005014:	0ef48463          	beq	s1,a5,800050fc <consoleintr+0x10c>
    80005018:	47c1                	li	a5,16
    8000501a:	10f49563          	bne	s1,a5,80005124 <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    8000501e:	fc8fc0ef          	jal	800017e6 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005022:	0001e517          	auipc	a0,0x1e
    80005026:	72e50513          	addi	a0,a0,1838 # 80023750 <cons>
    8000502a:	0af000ef          	jal	800058d8 <release>
}
    8000502e:	60e2                	ld	ra,24(sp)
    80005030:	6442                	ld	s0,16(sp)
    80005032:	64a2                	ld	s1,8(sp)
    80005034:	6105                	addi	sp,sp,32
    80005036:	8082                	ret
  switch(c){
    80005038:	07f00793          	li	a5,127
    8000503c:	0cf48063          	beq	s1,a5,800050fc <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005040:	0001e717          	auipc	a4,0x1e
    80005044:	71070713          	addi	a4,a4,1808 # 80023750 <cons>
    80005048:	0a072783          	lw	a5,160(a4)
    8000504c:	09872703          	lw	a4,152(a4)
    80005050:	9f99                	subw	a5,a5,a4
    80005052:	07f00713          	li	a4,127
    80005056:	fcf766e3          	bltu	a4,a5,80005022 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    8000505a:	47b5                	li	a5,13
    8000505c:	0cf48763          	beq	s1,a5,8000512a <consoleintr+0x13a>
      consputc(c);
    80005060:	8526                	mv	a0,s1
    80005062:	f5dff0ef          	jal	80004fbe <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005066:	0001e797          	auipc	a5,0x1e
    8000506a:	6ea78793          	addi	a5,a5,1770 # 80023750 <cons>
    8000506e:	0a07a683          	lw	a3,160(a5)
    80005072:	0016871b          	addiw	a4,a3,1
    80005076:	0007061b          	sext.w	a2,a4
    8000507a:	0ae7a023          	sw	a4,160(a5)
    8000507e:	07f6f693          	andi	a3,a3,127
    80005082:	97b6                	add	a5,a5,a3
    80005084:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005088:	47a9                	li	a5,10
    8000508a:	0cf48563          	beq	s1,a5,80005154 <consoleintr+0x164>
    8000508e:	4791                	li	a5,4
    80005090:	0cf48263          	beq	s1,a5,80005154 <consoleintr+0x164>
    80005094:	0001e797          	auipc	a5,0x1e
    80005098:	7547a783          	lw	a5,1876(a5) # 800237e8 <cons+0x98>
    8000509c:	9f1d                	subw	a4,a4,a5
    8000509e:	08000793          	li	a5,128
    800050a2:	f8f710e3          	bne	a4,a5,80005022 <consoleintr+0x32>
    800050a6:	a07d                	j	80005154 <consoleintr+0x164>
    800050a8:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    800050aa:	0001e717          	auipc	a4,0x1e
    800050ae:	6a670713          	addi	a4,a4,1702 # 80023750 <cons>
    800050b2:	0a072783          	lw	a5,160(a4)
    800050b6:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800050ba:	0001e497          	auipc	s1,0x1e
    800050be:	69648493          	addi	s1,s1,1686 # 80023750 <cons>
    while(cons.e != cons.w &&
    800050c2:	4929                	li	s2,10
    800050c4:	02f70863          	beq	a4,a5,800050f4 <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800050c8:	37fd                	addiw	a5,a5,-1
    800050ca:	07f7f713          	andi	a4,a5,127
    800050ce:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800050d0:	01874703          	lbu	a4,24(a4)
    800050d4:	03270263          	beq	a4,s2,800050f8 <consoleintr+0x108>
      cons.e--;
    800050d8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800050dc:	10000513          	li	a0,256
    800050e0:	edfff0ef          	jal	80004fbe <consputc>
    while(cons.e != cons.w &&
    800050e4:	0a04a783          	lw	a5,160(s1)
    800050e8:	09c4a703          	lw	a4,156(s1)
    800050ec:	fcf71ee3          	bne	a4,a5,800050c8 <consoleintr+0xd8>
    800050f0:	6902                	ld	s2,0(sp)
    800050f2:	bf05                	j	80005022 <consoleintr+0x32>
    800050f4:	6902                	ld	s2,0(sp)
    800050f6:	b735                	j	80005022 <consoleintr+0x32>
    800050f8:	6902                	ld	s2,0(sp)
    800050fa:	b725                	j	80005022 <consoleintr+0x32>
    if(cons.e != cons.w){
    800050fc:	0001e717          	auipc	a4,0x1e
    80005100:	65470713          	addi	a4,a4,1620 # 80023750 <cons>
    80005104:	0a072783          	lw	a5,160(a4)
    80005108:	09c72703          	lw	a4,156(a4)
    8000510c:	f0f70be3          	beq	a4,a5,80005022 <consoleintr+0x32>
      cons.e--;
    80005110:	37fd                	addiw	a5,a5,-1
    80005112:	0001e717          	auipc	a4,0x1e
    80005116:	6cf72f23          	sw	a5,1758(a4) # 800237f0 <cons+0xa0>
      consputc(BACKSPACE);
    8000511a:	10000513          	li	a0,256
    8000511e:	ea1ff0ef          	jal	80004fbe <consputc>
    80005122:	b701                	j	80005022 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005124:	ee048fe3          	beqz	s1,80005022 <consoleintr+0x32>
    80005128:	bf21                	j	80005040 <consoleintr+0x50>
      consputc(c);
    8000512a:	4529                	li	a0,10
    8000512c:	e93ff0ef          	jal	80004fbe <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005130:	0001e797          	auipc	a5,0x1e
    80005134:	62078793          	addi	a5,a5,1568 # 80023750 <cons>
    80005138:	0a07a703          	lw	a4,160(a5)
    8000513c:	0017069b          	addiw	a3,a4,1
    80005140:	0006861b          	sext.w	a2,a3
    80005144:	0ad7a023          	sw	a3,160(a5)
    80005148:	07f77713          	andi	a4,a4,127
    8000514c:	97ba                	add	a5,a5,a4
    8000514e:	4729                	li	a4,10
    80005150:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005154:	0001e797          	auipc	a5,0x1e
    80005158:	68c7ac23          	sw	a2,1688(a5) # 800237ec <cons+0x9c>
        wakeup(&cons.r);
    8000515c:	0001e517          	auipc	a0,0x1e
    80005160:	68c50513          	addi	a0,a0,1676 # 800237e8 <cons+0x98>
    80005164:	adefc0ef          	jal	80001442 <wakeup>
    80005168:	bd6d                	j	80005022 <consoleintr+0x32>

000000008000516a <consoleinit>:

void
consoleinit(void)
{
    8000516a:	1141                	addi	sp,sp,-16
    8000516c:	e406                	sd	ra,8(sp)
    8000516e:	e022                	sd	s0,0(sp)
    80005170:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005172:	00002597          	auipc	a1,0x2
    80005176:	5ae58593          	addi	a1,a1,1454 # 80007720 <etext+0x720>
    8000517a:	0001e517          	auipc	a0,0x1e
    8000517e:	5d650513          	addi	a0,a0,1494 # 80023750 <cons>
    80005182:	63e000ef          	jal	800057c0 <initlock>

  uartinit();
    80005186:	3f4000ef          	jal	8000557a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000518a:	00015797          	auipc	a5,0x15
    8000518e:	42e78793          	addi	a5,a5,1070 # 8001a5b8 <devsw>
    80005192:	00000717          	auipc	a4,0x0
    80005196:	d2270713          	addi	a4,a4,-734 # 80004eb4 <consoleread>
    8000519a:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000519c:	00000717          	auipc	a4,0x0
    800051a0:	cb270713          	addi	a4,a4,-846 # 80004e4e <consolewrite>
    800051a4:	ef98                	sd	a4,24(a5)
}
    800051a6:	60a2                	ld	ra,8(sp)
    800051a8:	6402                	ld	s0,0(sp)
    800051aa:	0141                	addi	sp,sp,16
    800051ac:	8082                	ret

00000000800051ae <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    800051ae:	7179                	addi	sp,sp,-48
    800051b0:	f406                	sd	ra,40(sp)
    800051b2:	f022                	sd	s0,32(sp)
    800051b4:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    800051b6:	c219                	beqz	a2,800051bc <printint+0xe>
    800051b8:	08054063          	bltz	a0,80005238 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    800051bc:	4881                	li	a7,0
    800051be:	fd040693          	addi	a3,s0,-48

  i = 0;
    800051c2:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    800051c4:	00002617          	auipc	a2,0x2
    800051c8:	71c60613          	addi	a2,a2,1820 # 800078e0 <digits>
    800051cc:	883e                	mv	a6,a5
    800051ce:	2785                	addiw	a5,a5,1
    800051d0:	02b57733          	remu	a4,a0,a1
    800051d4:	9732                	add	a4,a4,a2
    800051d6:	00074703          	lbu	a4,0(a4)
    800051da:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    800051de:	872a                	mv	a4,a0
    800051e0:	02b55533          	divu	a0,a0,a1
    800051e4:	0685                	addi	a3,a3,1
    800051e6:	feb773e3          	bgeu	a4,a1,800051cc <printint+0x1e>

  if(sign)
    800051ea:	00088a63          	beqz	a7,800051fe <printint+0x50>
    buf[i++] = '-';
    800051ee:	1781                	addi	a5,a5,-32
    800051f0:	97a2                	add	a5,a5,s0
    800051f2:	02d00713          	li	a4,45
    800051f6:	fee78823          	sb	a4,-16(a5)
    800051fa:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    800051fe:	02f05963          	blez	a5,80005230 <printint+0x82>
    80005202:	ec26                	sd	s1,24(sp)
    80005204:	e84a                	sd	s2,16(sp)
    80005206:	fd040713          	addi	a4,s0,-48
    8000520a:	00f704b3          	add	s1,a4,a5
    8000520e:	fff70913          	addi	s2,a4,-1
    80005212:	993e                	add	s2,s2,a5
    80005214:	37fd                	addiw	a5,a5,-1
    80005216:	1782                	slli	a5,a5,0x20
    80005218:	9381                	srli	a5,a5,0x20
    8000521a:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    8000521e:	fff4c503          	lbu	a0,-1(s1)
    80005222:	d9dff0ef          	jal	80004fbe <consputc>
  while(--i >= 0)
    80005226:	14fd                	addi	s1,s1,-1
    80005228:	ff249be3          	bne	s1,s2,8000521e <printint+0x70>
    8000522c:	64e2                	ld	s1,24(sp)
    8000522e:	6942                	ld	s2,16(sp)
}
    80005230:	70a2                	ld	ra,40(sp)
    80005232:	7402                	ld	s0,32(sp)
    80005234:	6145                	addi	sp,sp,48
    80005236:	8082                	ret
    x = -xx;
    80005238:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    8000523c:	4885                	li	a7,1
    x = -xx;
    8000523e:	b741                	j	800051be <printint+0x10>

0000000080005240 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80005240:	7155                	addi	sp,sp,-208
    80005242:	e506                	sd	ra,136(sp)
    80005244:	e122                	sd	s0,128(sp)
    80005246:	f0d2                	sd	s4,96(sp)
    80005248:	0900                	addi	s0,sp,144
    8000524a:	8a2a                	mv	s4,a0
    8000524c:	e40c                	sd	a1,8(s0)
    8000524e:	e810                	sd	a2,16(s0)
    80005250:	ec14                	sd	a3,24(s0)
    80005252:	f018                	sd	a4,32(s0)
    80005254:	f41c                	sd	a5,40(s0)
    80005256:	03043823          	sd	a6,48(s0)
    8000525a:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    8000525e:	0001e797          	auipc	a5,0x1e
    80005262:	5b27a783          	lw	a5,1458(a5) # 80023810 <pr+0x18>
    80005266:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    8000526a:	e3a1                	bnez	a5,800052aa <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    8000526c:	00840793          	addi	a5,s0,8
    80005270:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005274:	00054503          	lbu	a0,0(a0)
    80005278:	26050763          	beqz	a0,800054e6 <printf+0x2a6>
    8000527c:	fca6                	sd	s1,120(sp)
    8000527e:	f8ca                	sd	s2,112(sp)
    80005280:	f4ce                	sd	s3,104(sp)
    80005282:	ecd6                	sd	s5,88(sp)
    80005284:	e8da                	sd	s6,80(sp)
    80005286:	e0e2                	sd	s8,64(sp)
    80005288:	fc66                	sd	s9,56(sp)
    8000528a:	f86a                	sd	s10,48(sp)
    8000528c:	f46e                	sd	s11,40(sp)
    8000528e:	4981                	li	s3,0
    if(cx != '%'){
    80005290:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80005294:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    80005298:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000529c:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    800052a0:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    800052a4:	07000d93          	li	s11,112
    800052a8:	a815                	j	800052dc <printf+0x9c>
    acquire(&pr.lock);
    800052aa:	0001e517          	auipc	a0,0x1e
    800052ae:	54e50513          	addi	a0,a0,1358 # 800237f8 <pr>
    800052b2:	58e000ef          	jal	80005840 <acquire>
  va_start(ap, fmt);
    800052b6:	00840793          	addi	a5,s0,8
    800052ba:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800052be:	000a4503          	lbu	a0,0(s4)
    800052c2:	fd4d                	bnez	a0,8000527c <printf+0x3c>
    800052c4:	a481                	j	80005504 <printf+0x2c4>
      consputc(cx);
    800052c6:	cf9ff0ef          	jal	80004fbe <consputc>
      continue;
    800052ca:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800052cc:	0014899b          	addiw	s3,s1,1
    800052d0:	013a07b3          	add	a5,s4,s3
    800052d4:	0007c503          	lbu	a0,0(a5)
    800052d8:	1e050b63          	beqz	a0,800054ce <printf+0x28e>
    if(cx != '%'){
    800052dc:	ff5515e3          	bne	a0,s5,800052c6 <printf+0x86>
    i++;
    800052e0:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    800052e4:	009a07b3          	add	a5,s4,s1
    800052e8:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    800052ec:	1e090163          	beqz	s2,800054ce <printf+0x28e>
    800052f0:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    800052f4:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    800052f6:	c789                	beqz	a5,80005300 <printf+0xc0>
    800052f8:	009a0733          	add	a4,s4,s1
    800052fc:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80005300:	03690763          	beq	s2,s6,8000532e <printf+0xee>
    } else if(c0 == 'l' && c1 == 'd'){
    80005304:	05890163          	beq	s2,s8,80005346 <printf+0x106>
    } else if(c0 == 'u'){
    80005308:	0d990b63          	beq	s2,s9,800053de <printf+0x19e>
    } else if(c0 == 'x'){
    8000530c:	13a90163          	beq	s2,s10,8000542e <printf+0x1ee>
    } else if(c0 == 'p'){
    80005310:	13b90b63          	beq	s2,s11,80005446 <printf+0x206>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    80005314:	07300793          	li	a5,115
    80005318:	16f90a63          	beq	s2,a5,8000548c <printf+0x24c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    8000531c:	1b590463          	beq	s2,s5,800054c4 <printf+0x284>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80005320:	8556                	mv	a0,s5
    80005322:	c9dff0ef          	jal	80004fbe <consputc>
      consputc(c0);
    80005326:	854a                	mv	a0,s2
    80005328:	c97ff0ef          	jal	80004fbe <consputc>
    8000532c:	b745                	j	800052cc <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    8000532e:	f8843783          	ld	a5,-120(s0)
    80005332:	00878713          	addi	a4,a5,8
    80005336:	f8e43423          	sd	a4,-120(s0)
    8000533a:	4605                	li	a2,1
    8000533c:	45a9                	li	a1,10
    8000533e:	4388                	lw	a0,0(a5)
    80005340:	e6fff0ef          	jal	800051ae <printint>
    80005344:	b761                	j	800052cc <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    80005346:	03678663          	beq	a5,s6,80005372 <printf+0x132>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000534a:	05878263          	beq	a5,s8,8000538e <printf+0x14e>
    } else if(c0 == 'l' && c1 == 'u'){
    8000534e:	0b978463          	beq	a5,s9,800053f6 <printf+0x1b6>
    } else if(c0 == 'l' && c1 == 'x'){
    80005352:	fda797e3          	bne	a5,s10,80005320 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80005356:	f8843783          	ld	a5,-120(s0)
    8000535a:	00878713          	addi	a4,a5,8
    8000535e:	f8e43423          	sd	a4,-120(s0)
    80005362:	4601                	li	a2,0
    80005364:	45c1                	li	a1,16
    80005366:	6388                	ld	a0,0(a5)
    80005368:	e47ff0ef          	jal	800051ae <printint>
      i += 1;
    8000536c:	0029849b          	addiw	s1,s3,2
    80005370:	bfb1                	j	800052cc <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005372:	f8843783          	ld	a5,-120(s0)
    80005376:	00878713          	addi	a4,a5,8
    8000537a:	f8e43423          	sd	a4,-120(s0)
    8000537e:	4605                	li	a2,1
    80005380:	45a9                	li	a1,10
    80005382:	6388                	ld	a0,0(a5)
    80005384:	e2bff0ef          	jal	800051ae <printint>
      i += 1;
    80005388:	0029849b          	addiw	s1,s3,2
    8000538c:	b781                	j	800052cc <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000538e:	06400793          	li	a5,100
    80005392:	02f68863          	beq	a3,a5,800053c2 <printf+0x182>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80005396:	07500793          	li	a5,117
    8000539a:	06f68c63          	beq	a3,a5,80005412 <printf+0x1d2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000539e:	07800793          	li	a5,120
    800053a2:	f6f69fe3          	bne	a3,a5,80005320 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    800053a6:	f8843783          	ld	a5,-120(s0)
    800053aa:	00878713          	addi	a4,a5,8
    800053ae:	f8e43423          	sd	a4,-120(s0)
    800053b2:	4601                	li	a2,0
    800053b4:	45c1                	li	a1,16
    800053b6:	6388                	ld	a0,0(a5)
    800053b8:	df7ff0ef          	jal	800051ae <printint>
      i += 2;
    800053bc:	0039849b          	addiw	s1,s3,3
    800053c0:	b731                	j	800052cc <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    800053c2:	f8843783          	ld	a5,-120(s0)
    800053c6:	00878713          	addi	a4,a5,8
    800053ca:	f8e43423          	sd	a4,-120(s0)
    800053ce:	4605                	li	a2,1
    800053d0:	45a9                	li	a1,10
    800053d2:	6388                	ld	a0,0(a5)
    800053d4:	ddbff0ef          	jal	800051ae <printint>
      i += 2;
    800053d8:	0039849b          	addiw	s1,s3,3
    800053dc:	bdc5                	j	800052cc <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    800053de:	f8843783          	ld	a5,-120(s0)
    800053e2:	00878713          	addi	a4,a5,8
    800053e6:	f8e43423          	sd	a4,-120(s0)
    800053ea:	4601                	li	a2,0
    800053ec:	45a9                	li	a1,10
    800053ee:	4388                	lw	a0,0(a5)
    800053f0:	dbfff0ef          	jal	800051ae <printint>
    800053f4:	bde1                	j	800052cc <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800053f6:	f8843783          	ld	a5,-120(s0)
    800053fa:	00878713          	addi	a4,a5,8
    800053fe:	f8e43423          	sd	a4,-120(s0)
    80005402:	4601                	li	a2,0
    80005404:	45a9                	li	a1,10
    80005406:	6388                	ld	a0,0(a5)
    80005408:	da7ff0ef          	jal	800051ae <printint>
      i += 1;
    8000540c:	0029849b          	addiw	s1,s3,2
    80005410:	bd75                	j	800052cc <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80005412:	f8843783          	ld	a5,-120(s0)
    80005416:	00878713          	addi	a4,a5,8
    8000541a:	f8e43423          	sd	a4,-120(s0)
    8000541e:	4601                	li	a2,0
    80005420:	45a9                	li	a1,10
    80005422:	6388                	ld	a0,0(a5)
    80005424:	d8bff0ef          	jal	800051ae <printint>
      i += 2;
    80005428:	0039849b          	addiw	s1,s3,3
    8000542c:	b545                	j	800052cc <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    8000542e:	f8843783          	ld	a5,-120(s0)
    80005432:	00878713          	addi	a4,a5,8
    80005436:	f8e43423          	sd	a4,-120(s0)
    8000543a:	4601                	li	a2,0
    8000543c:	45c1                	li	a1,16
    8000543e:	4388                	lw	a0,0(a5)
    80005440:	d6fff0ef          	jal	800051ae <printint>
    80005444:	b561                	j	800052cc <printf+0x8c>
    80005446:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    80005448:	f8843783          	ld	a5,-120(s0)
    8000544c:	00878713          	addi	a4,a5,8
    80005450:	f8e43423          	sd	a4,-120(s0)
    80005454:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005458:	03000513          	li	a0,48
    8000545c:	b63ff0ef          	jal	80004fbe <consputc>
  consputc('x');
    80005460:	07800513          	li	a0,120
    80005464:	b5bff0ef          	jal	80004fbe <consputc>
    80005468:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000546a:	00002b97          	auipc	s7,0x2
    8000546e:	476b8b93          	addi	s7,s7,1142 # 800078e0 <digits>
    80005472:	03c9d793          	srli	a5,s3,0x3c
    80005476:	97de                	add	a5,a5,s7
    80005478:	0007c503          	lbu	a0,0(a5)
    8000547c:	b43ff0ef          	jal	80004fbe <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005480:	0992                	slli	s3,s3,0x4
    80005482:	397d                	addiw	s2,s2,-1
    80005484:	fe0917e3          	bnez	s2,80005472 <printf+0x232>
    80005488:	6ba6                	ld	s7,72(sp)
    8000548a:	b589                	j	800052cc <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    8000548c:	f8843783          	ld	a5,-120(s0)
    80005490:	00878713          	addi	a4,a5,8
    80005494:	f8e43423          	sd	a4,-120(s0)
    80005498:	0007b903          	ld	s2,0(a5)
    8000549c:	00090d63          	beqz	s2,800054b6 <printf+0x276>
      for(; *s; s++)
    800054a0:	00094503          	lbu	a0,0(s2)
    800054a4:	e20504e3          	beqz	a0,800052cc <printf+0x8c>
        consputc(*s);
    800054a8:	b17ff0ef          	jal	80004fbe <consputc>
      for(; *s; s++)
    800054ac:	0905                	addi	s2,s2,1
    800054ae:	00094503          	lbu	a0,0(s2)
    800054b2:	f97d                	bnez	a0,800054a8 <printf+0x268>
    800054b4:	bd21                	j	800052cc <printf+0x8c>
        s = "(null)";
    800054b6:	00002917          	auipc	s2,0x2
    800054ba:	27290913          	addi	s2,s2,626 # 80007728 <etext+0x728>
      for(; *s; s++)
    800054be:	02800513          	li	a0,40
    800054c2:	b7dd                	j	800054a8 <printf+0x268>
      consputc('%');
    800054c4:	02500513          	li	a0,37
    800054c8:	af7ff0ef          	jal	80004fbe <consputc>
    800054cc:	b501                	j	800052cc <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    800054ce:	f7843783          	ld	a5,-136(s0)
    800054d2:	e385                	bnez	a5,800054f2 <printf+0x2b2>
    800054d4:	74e6                	ld	s1,120(sp)
    800054d6:	7946                	ld	s2,112(sp)
    800054d8:	79a6                	ld	s3,104(sp)
    800054da:	6ae6                	ld	s5,88(sp)
    800054dc:	6b46                	ld	s6,80(sp)
    800054de:	6c06                	ld	s8,64(sp)
    800054e0:	7ce2                	ld	s9,56(sp)
    800054e2:	7d42                	ld	s10,48(sp)
    800054e4:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    800054e6:	4501                	li	a0,0
    800054e8:	60aa                	ld	ra,136(sp)
    800054ea:	640a                	ld	s0,128(sp)
    800054ec:	7a06                	ld	s4,96(sp)
    800054ee:	6169                	addi	sp,sp,208
    800054f0:	8082                	ret
    800054f2:	74e6                	ld	s1,120(sp)
    800054f4:	7946                	ld	s2,112(sp)
    800054f6:	79a6                	ld	s3,104(sp)
    800054f8:	6ae6                	ld	s5,88(sp)
    800054fa:	6b46                	ld	s6,80(sp)
    800054fc:	6c06                	ld	s8,64(sp)
    800054fe:	7ce2                	ld	s9,56(sp)
    80005500:	7d42                	ld	s10,48(sp)
    80005502:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    80005504:	0001e517          	auipc	a0,0x1e
    80005508:	2f450513          	addi	a0,a0,756 # 800237f8 <pr>
    8000550c:	3cc000ef          	jal	800058d8 <release>
    80005510:	bfd9                	j	800054e6 <printf+0x2a6>

0000000080005512 <panic>:

void
panic(char *s)
{
    80005512:	1101                	addi	sp,sp,-32
    80005514:	ec06                	sd	ra,24(sp)
    80005516:	e822                	sd	s0,16(sp)
    80005518:	e426                	sd	s1,8(sp)
    8000551a:	1000                	addi	s0,sp,32
    8000551c:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000551e:	0001e797          	auipc	a5,0x1e
    80005522:	2e07a923          	sw	zero,754(a5) # 80023810 <pr+0x18>
  printf("panic: ");
    80005526:	00002517          	auipc	a0,0x2
    8000552a:	20a50513          	addi	a0,a0,522 # 80007730 <etext+0x730>
    8000552e:	d13ff0ef          	jal	80005240 <printf>
  printf("%s\n", s);
    80005532:	85a6                	mv	a1,s1
    80005534:	00002517          	auipc	a0,0x2
    80005538:	20450513          	addi	a0,a0,516 # 80007738 <etext+0x738>
    8000553c:	d05ff0ef          	jal	80005240 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005540:	4785                	li	a5,1
    80005542:	00005717          	auipc	a4,0x5
    80005546:	dcf72523          	sw	a5,-566(a4) # 8000a30c <panicked>
  for(;;)
    8000554a:	a001                	j	8000554a <panic+0x38>

000000008000554c <printfinit>:
    ;
}

void
printfinit(void)
{
    8000554c:	1101                	addi	sp,sp,-32
    8000554e:	ec06                	sd	ra,24(sp)
    80005550:	e822                	sd	s0,16(sp)
    80005552:	e426                	sd	s1,8(sp)
    80005554:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005556:	0001e497          	auipc	s1,0x1e
    8000555a:	2a248493          	addi	s1,s1,674 # 800237f8 <pr>
    8000555e:	00002597          	auipc	a1,0x2
    80005562:	1e258593          	addi	a1,a1,482 # 80007740 <etext+0x740>
    80005566:	8526                	mv	a0,s1
    80005568:	258000ef          	jal	800057c0 <initlock>
  pr.locking = 1;
    8000556c:	4785                	li	a5,1
    8000556e:	cc9c                	sw	a5,24(s1)
}
    80005570:	60e2                	ld	ra,24(sp)
    80005572:	6442                	ld	s0,16(sp)
    80005574:	64a2                	ld	s1,8(sp)
    80005576:	6105                	addi	sp,sp,32
    80005578:	8082                	ret

000000008000557a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000557a:	1141                	addi	sp,sp,-16
    8000557c:	e406                	sd	ra,8(sp)
    8000557e:	e022                	sd	s0,0(sp)
    80005580:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005582:	100007b7          	lui	a5,0x10000
    80005586:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000558a:	10000737          	lui	a4,0x10000
    8000558e:	f8000693          	li	a3,-128
    80005592:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005596:	468d                	li	a3,3
    80005598:	10000637          	lui	a2,0x10000
    8000559c:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800055a0:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800055a4:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800055a8:	10000737          	lui	a4,0x10000
    800055ac:	461d                	li	a2,7
    800055ae:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800055b2:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    800055b6:	00002597          	auipc	a1,0x2
    800055ba:	19258593          	addi	a1,a1,402 # 80007748 <etext+0x748>
    800055be:	0001e517          	auipc	a0,0x1e
    800055c2:	25a50513          	addi	a0,a0,602 # 80023818 <uart_tx_lock>
    800055c6:	1fa000ef          	jal	800057c0 <initlock>
}
    800055ca:	60a2                	ld	ra,8(sp)
    800055cc:	6402                	ld	s0,0(sp)
    800055ce:	0141                	addi	sp,sp,16
    800055d0:	8082                	ret

00000000800055d2 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800055d2:	1101                	addi	sp,sp,-32
    800055d4:	ec06                	sd	ra,24(sp)
    800055d6:	e822                	sd	s0,16(sp)
    800055d8:	e426                	sd	s1,8(sp)
    800055da:	1000                	addi	s0,sp,32
    800055dc:	84aa                	mv	s1,a0
  push_off();
    800055de:	222000ef          	jal	80005800 <push_off>

  if(panicked){
    800055e2:	00005797          	auipc	a5,0x5
    800055e6:	d2a7a783          	lw	a5,-726(a5) # 8000a30c <panicked>
    800055ea:	e795                	bnez	a5,80005616 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800055ec:	10000737          	lui	a4,0x10000
    800055f0:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800055f2:	00074783          	lbu	a5,0(a4)
    800055f6:	0207f793          	andi	a5,a5,32
    800055fa:	dfe5                	beqz	a5,800055f2 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    800055fc:	0ff4f513          	zext.b	a0,s1
    80005600:	100007b7          	lui	a5,0x10000
    80005604:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005608:	27c000ef          	jal	80005884 <pop_off>
}
    8000560c:	60e2                	ld	ra,24(sp)
    8000560e:	6442                	ld	s0,16(sp)
    80005610:	64a2                	ld	s1,8(sp)
    80005612:	6105                	addi	sp,sp,32
    80005614:	8082                	ret
    for(;;)
    80005616:	a001                	j	80005616 <uartputc_sync+0x44>

0000000080005618 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005618:	00005797          	auipc	a5,0x5
    8000561c:	cf87b783          	ld	a5,-776(a5) # 8000a310 <uart_tx_r>
    80005620:	00005717          	auipc	a4,0x5
    80005624:	cf873703          	ld	a4,-776(a4) # 8000a318 <uart_tx_w>
    80005628:	08f70263          	beq	a4,a5,800056ac <uartstart+0x94>
{
    8000562c:	7139                	addi	sp,sp,-64
    8000562e:	fc06                	sd	ra,56(sp)
    80005630:	f822                	sd	s0,48(sp)
    80005632:	f426                	sd	s1,40(sp)
    80005634:	f04a                	sd	s2,32(sp)
    80005636:	ec4e                	sd	s3,24(sp)
    80005638:	e852                	sd	s4,16(sp)
    8000563a:	e456                	sd	s5,8(sp)
    8000563c:	e05a                	sd	s6,0(sp)
    8000563e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005640:	10000937          	lui	s2,0x10000
    80005644:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005646:	0001ea97          	auipc	s5,0x1e
    8000564a:	1d2a8a93          	addi	s5,s5,466 # 80023818 <uart_tx_lock>
    uart_tx_r += 1;
    8000564e:	00005497          	auipc	s1,0x5
    80005652:	cc248493          	addi	s1,s1,-830 # 8000a310 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80005656:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    8000565a:	00005997          	auipc	s3,0x5
    8000565e:	cbe98993          	addi	s3,s3,-834 # 8000a318 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005662:	00094703          	lbu	a4,0(s2)
    80005666:	02077713          	andi	a4,a4,32
    8000566a:	c71d                	beqz	a4,80005698 <uartstart+0x80>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000566c:	01f7f713          	andi	a4,a5,31
    80005670:	9756                	add	a4,a4,s5
    80005672:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80005676:	0785                	addi	a5,a5,1
    80005678:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000567a:	8526                	mv	a0,s1
    8000567c:	dc7fb0ef          	jal	80001442 <wakeup>
    WriteReg(THR, c);
    80005680:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80005684:	609c                	ld	a5,0(s1)
    80005686:	0009b703          	ld	a4,0(s3)
    8000568a:	fcf71ce3          	bne	a4,a5,80005662 <uartstart+0x4a>
      ReadReg(ISR);
    8000568e:	100007b7          	lui	a5,0x10000
    80005692:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80005694:	0007c783          	lbu	a5,0(a5)
  }
}
    80005698:	70e2                	ld	ra,56(sp)
    8000569a:	7442                	ld	s0,48(sp)
    8000569c:	74a2                	ld	s1,40(sp)
    8000569e:	7902                	ld	s2,32(sp)
    800056a0:	69e2                	ld	s3,24(sp)
    800056a2:	6a42                	ld	s4,16(sp)
    800056a4:	6aa2                	ld	s5,8(sp)
    800056a6:	6b02                	ld	s6,0(sp)
    800056a8:	6121                	addi	sp,sp,64
    800056aa:	8082                	ret
      ReadReg(ISR);
    800056ac:	100007b7          	lui	a5,0x10000
    800056b0:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    800056b2:	0007c783          	lbu	a5,0(a5)
      return;
    800056b6:	8082                	ret

00000000800056b8 <uartputc>:
{
    800056b8:	7179                	addi	sp,sp,-48
    800056ba:	f406                	sd	ra,40(sp)
    800056bc:	f022                	sd	s0,32(sp)
    800056be:	ec26                	sd	s1,24(sp)
    800056c0:	e84a                	sd	s2,16(sp)
    800056c2:	e44e                	sd	s3,8(sp)
    800056c4:	e052                	sd	s4,0(sp)
    800056c6:	1800                	addi	s0,sp,48
    800056c8:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800056ca:	0001e517          	auipc	a0,0x1e
    800056ce:	14e50513          	addi	a0,a0,334 # 80023818 <uart_tx_lock>
    800056d2:	16e000ef          	jal	80005840 <acquire>
  if(panicked){
    800056d6:	00005797          	auipc	a5,0x5
    800056da:	c367a783          	lw	a5,-970(a5) # 8000a30c <panicked>
    800056de:	efbd                	bnez	a5,8000575c <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800056e0:	00005717          	auipc	a4,0x5
    800056e4:	c3873703          	ld	a4,-968(a4) # 8000a318 <uart_tx_w>
    800056e8:	00005797          	auipc	a5,0x5
    800056ec:	c287b783          	ld	a5,-984(a5) # 8000a310 <uart_tx_r>
    800056f0:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800056f4:	0001e997          	auipc	s3,0x1e
    800056f8:	12498993          	addi	s3,s3,292 # 80023818 <uart_tx_lock>
    800056fc:	00005497          	auipc	s1,0x5
    80005700:	c1448493          	addi	s1,s1,-1004 # 8000a310 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005704:	00005917          	auipc	s2,0x5
    80005708:	c1490913          	addi	s2,s2,-1004 # 8000a318 <uart_tx_w>
    8000570c:	00e79d63          	bne	a5,a4,80005726 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80005710:	85ce                	mv	a1,s3
    80005712:	8526                	mv	a0,s1
    80005714:	ce3fb0ef          	jal	800013f6 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005718:	00093703          	ld	a4,0(s2)
    8000571c:	609c                	ld	a5,0(s1)
    8000571e:	02078793          	addi	a5,a5,32
    80005722:	fee787e3          	beq	a5,a4,80005710 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005726:	0001e497          	auipc	s1,0x1e
    8000572a:	0f248493          	addi	s1,s1,242 # 80023818 <uart_tx_lock>
    8000572e:	01f77793          	andi	a5,a4,31
    80005732:	97a6                	add	a5,a5,s1
    80005734:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80005738:	0705                	addi	a4,a4,1
    8000573a:	00005797          	auipc	a5,0x5
    8000573e:	bce7bf23          	sd	a4,-1058(a5) # 8000a318 <uart_tx_w>
  uartstart();
    80005742:	ed7ff0ef          	jal	80005618 <uartstart>
  release(&uart_tx_lock);
    80005746:	8526                	mv	a0,s1
    80005748:	190000ef          	jal	800058d8 <release>
}
    8000574c:	70a2                	ld	ra,40(sp)
    8000574e:	7402                	ld	s0,32(sp)
    80005750:	64e2                	ld	s1,24(sp)
    80005752:	6942                	ld	s2,16(sp)
    80005754:	69a2                	ld	s3,8(sp)
    80005756:	6a02                	ld	s4,0(sp)
    80005758:	6145                	addi	sp,sp,48
    8000575a:	8082                	ret
    for(;;)
    8000575c:	a001                	j	8000575c <uartputc+0xa4>

000000008000575e <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000575e:	1141                	addi	sp,sp,-16
    80005760:	e422                	sd	s0,8(sp)
    80005762:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005764:	100007b7          	lui	a5,0x10000
    80005768:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    8000576a:	0007c783          	lbu	a5,0(a5)
    8000576e:	8b85                	andi	a5,a5,1
    80005770:	cb81                	beqz	a5,80005780 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80005772:	100007b7          	lui	a5,0x10000
    80005776:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000577a:	6422                	ld	s0,8(sp)
    8000577c:	0141                	addi	sp,sp,16
    8000577e:	8082                	ret
    return -1;
    80005780:	557d                	li	a0,-1
    80005782:	bfe5                	j	8000577a <uartgetc+0x1c>

0000000080005784 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005784:	1101                	addi	sp,sp,-32
    80005786:	ec06                	sd	ra,24(sp)
    80005788:	e822                	sd	s0,16(sp)
    8000578a:	e426                	sd	s1,8(sp)
    8000578c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000578e:	54fd                	li	s1,-1
    80005790:	a019                	j	80005796 <uartintr+0x12>
      break;
    consoleintr(c);
    80005792:	85fff0ef          	jal	80004ff0 <consoleintr>
    int c = uartgetc();
    80005796:	fc9ff0ef          	jal	8000575e <uartgetc>
    if(c == -1)
    8000579a:	fe951ce3          	bne	a0,s1,80005792 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000579e:	0001e497          	auipc	s1,0x1e
    800057a2:	07a48493          	addi	s1,s1,122 # 80023818 <uart_tx_lock>
    800057a6:	8526                	mv	a0,s1
    800057a8:	098000ef          	jal	80005840 <acquire>
  uartstart();
    800057ac:	e6dff0ef          	jal	80005618 <uartstart>
  release(&uart_tx_lock);
    800057b0:	8526                	mv	a0,s1
    800057b2:	126000ef          	jal	800058d8 <release>
}
    800057b6:	60e2                	ld	ra,24(sp)
    800057b8:	6442                	ld	s0,16(sp)
    800057ba:	64a2                	ld	s1,8(sp)
    800057bc:	6105                	addi	sp,sp,32
    800057be:	8082                	ret

00000000800057c0 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800057c0:	1141                	addi	sp,sp,-16
    800057c2:	e422                	sd	s0,8(sp)
    800057c4:	0800                	addi	s0,sp,16
  lk->name = name;
    800057c6:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800057c8:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800057cc:	00053823          	sd	zero,16(a0)
}
    800057d0:	6422                	ld	s0,8(sp)
    800057d2:	0141                	addi	sp,sp,16
    800057d4:	8082                	ret

00000000800057d6 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800057d6:	411c                	lw	a5,0(a0)
    800057d8:	e399                	bnez	a5,800057de <holding+0x8>
    800057da:	4501                	li	a0,0
  return r;
}
    800057dc:	8082                	ret
{
    800057de:	1101                	addi	sp,sp,-32
    800057e0:	ec06                	sd	ra,24(sp)
    800057e2:	e822                	sd	s0,16(sp)
    800057e4:	e426                	sd	s1,8(sp)
    800057e6:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800057e8:	6904                	ld	s1,16(a0)
    800057ea:	d9afb0ef          	jal	80000d84 <mycpu>
    800057ee:	40a48533          	sub	a0,s1,a0
    800057f2:	00153513          	seqz	a0,a0
}
    800057f6:	60e2                	ld	ra,24(sp)
    800057f8:	6442                	ld	s0,16(sp)
    800057fa:	64a2                	ld	s1,8(sp)
    800057fc:	6105                	addi	sp,sp,32
    800057fe:	8082                	ret

0000000080005800 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80005800:	1101                	addi	sp,sp,-32
    80005802:	ec06                	sd	ra,24(sp)
    80005804:	e822                	sd	s0,16(sp)
    80005806:	e426                	sd	s1,8(sp)
    80005808:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000580a:	100024f3          	csrr	s1,sstatus
    8000580e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80005812:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005814:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80005818:	d6cfb0ef          	jal	80000d84 <mycpu>
    8000581c:	5d3c                	lw	a5,120(a0)
    8000581e:	cb99                	beqz	a5,80005834 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80005820:	d64fb0ef          	jal	80000d84 <mycpu>
    80005824:	5d3c                	lw	a5,120(a0)
    80005826:	2785                	addiw	a5,a5,1
    80005828:	dd3c                	sw	a5,120(a0)
}
    8000582a:	60e2                	ld	ra,24(sp)
    8000582c:	6442                	ld	s0,16(sp)
    8000582e:	64a2                	ld	s1,8(sp)
    80005830:	6105                	addi	sp,sp,32
    80005832:	8082                	ret
    mycpu()->intena = old;
    80005834:	d50fb0ef          	jal	80000d84 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80005838:	8085                	srli	s1,s1,0x1
    8000583a:	8885                	andi	s1,s1,1
    8000583c:	dd64                	sw	s1,124(a0)
    8000583e:	b7cd                	j	80005820 <push_off+0x20>

0000000080005840 <acquire>:
{
    80005840:	1101                	addi	sp,sp,-32
    80005842:	ec06                	sd	ra,24(sp)
    80005844:	e822                	sd	s0,16(sp)
    80005846:	e426                	sd	s1,8(sp)
    80005848:	1000                	addi	s0,sp,32
    8000584a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000584c:	fb5ff0ef          	jal	80005800 <push_off>
  if(holding(lk))
    80005850:	8526                	mv	a0,s1
    80005852:	f85ff0ef          	jal	800057d6 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005856:	4705                	li	a4,1
  if(holding(lk))
    80005858:	e105                	bnez	a0,80005878 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000585a:	87ba                	mv	a5,a4
    8000585c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005860:	2781                	sext.w	a5,a5
    80005862:	ffe5                	bnez	a5,8000585a <acquire+0x1a>
  __sync_synchronize();
    80005864:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80005868:	d1cfb0ef          	jal	80000d84 <mycpu>
    8000586c:	e888                	sd	a0,16(s1)
}
    8000586e:	60e2                	ld	ra,24(sp)
    80005870:	6442                	ld	s0,16(sp)
    80005872:	64a2                	ld	s1,8(sp)
    80005874:	6105                	addi	sp,sp,32
    80005876:	8082                	ret
    panic("acquire");
    80005878:	00002517          	auipc	a0,0x2
    8000587c:	ed850513          	addi	a0,a0,-296 # 80007750 <etext+0x750>
    80005880:	c93ff0ef          	jal	80005512 <panic>

0000000080005884 <pop_off>:

void
pop_off(void)
{
    80005884:	1141                	addi	sp,sp,-16
    80005886:	e406                	sd	ra,8(sp)
    80005888:	e022                	sd	s0,0(sp)
    8000588a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000588c:	cf8fb0ef          	jal	80000d84 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005890:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005894:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005896:	e78d                	bnez	a5,800058c0 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005898:	5d3c                	lw	a5,120(a0)
    8000589a:	02f05963          	blez	a5,800058cc <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    8000589e:	37fd                	addiw	a5,a5,-1
    800058a0:	0007871b          	sext.w	a4,a5
    800058a4:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800058a6:	eb09                	bnez	a4,800058b8 <pop_off+0x34>
    800058a8:	5d7c                	lw	a5,124(a0)
    800058aa:	c799                	beqz	a5,800058b8 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800058ac:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800058b0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800058b4:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800058b8:	60a2                	ld	ra,8(sp)
    800058ba:	6402                	ld	s0,0(sp)
    800058bc:	0141                	addi	sp,sp,16
    800058be:	8082                	ret
    panic("pop_off - interruptible");
    800058c0:	00002517          	auipc	a0,0x2
    800058c4:	e9850513          	addi	a0,a0,-360 # 80007758 <etext+0x758>
    800058c8:	c4bff0ef          	jal	80005512 <panic>
    panic("pop_off");
    800058cc:	00002517          	auipc	a0,0x2
    800058d0:	ea450513          	addi	a0,a0,-348 # 80007770 <etext+0x770>
    800058d4:	c3fff0ef          	jal	80005512 <panic>

00000000800058d8 <release>:
{
    800058d8:	1101                	addi	sp,sp,-32
    800058da:	ec06                	sd	ra,24(sp)
    800058dc:	e822                	sd	s0,16(sp)
    800058de:	e426                	sd	s1,8(sp)
    800058e0:	1000                	addi	s0,sp,32
    800058e2:	84aa                	mv	s1,a0
  if(!holding(lk))
    800058e4:	ef3ff0ef          	jal	800057d6 <holding>
    800058e8:	c105                	beqz	a0,80005908 <release+0x30>
  lk->cpu = 0;
    800058ea:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800058ee:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    800058f2:	0310000f          	fence	rw,w
    800058f6:	0004a023          	sw	zero,0(s1)
  pop_off();
    800058fa:	f8bff0ef          	jal	80005884 <pop_off>
}
    800058fe:	60e2                	ld	ra,24(sp)
    80005900:	6442                	ld	s0,16(sp)
    80005902:	64a2                	ld	s1,8(sp)
    80005904:	6105                	addi	sp,sp,32
    80005906:	8082                	ret
    panic("release");
    80005908:	00002517          	auipc	a0,0x2
    8000590c:	e7050513          	addi	a0,a0,-400 # 80007778 <etext+0x778>
    80005910:	c03ff0ef          	jal	80005512 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
