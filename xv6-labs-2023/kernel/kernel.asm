
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	23013103          	ld	sp,560(sp) # 8000b230 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	149050ef          	jal	8000595e <start>

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
    80000034:	8c078793          	addi	a5,a5,-1856 # 800248f0 <end>
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
    80000054:	23090913          	addi	s2,s2,560 # 8000b280 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	352080e7          	jalr	850(ra) # 800063ac <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	3f2080e7          	jalr	1010(ra) # 80006460 <release>
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
    8000008e:	da8080e7          	jalr	-600(ra) # 80005e32 <panic>

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
    800000f2:	19250513          	addi	a0,a0,402 # 8000b280 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	226080e7          	jalr	550(ra) # 8000631c <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00024517          	auipc	a0,0x24
    80000106:	7ee50513          	addi	a0,a0,2030 # 800248f0 <end>
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
    80000128:	15c48493          	addi	s1,s1,348 # 8000b280 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	27e080e7          	jalr	638(ra) # 800063ac <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	0000b517          	auipc	a0,0xb
    80000140:	14450513          	addi	a0,a0,324 # 8000b280 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	31a080e7          	jalr	794(ra) # 80006460 <release>

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
    8000016c:	11850513          	addi	a0,a0,280 # 8000b280 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	2f0080e7          	jalr	752(ra) # 80006460 <release>
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
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffda711>
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
    80000324:	bb6080e7          	jalr	-1098(ra) # 80000ed6 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000328:	0000b717          	auipc	a4,0xb
    8000032c:	f2870713          	addi	a4,a4,-216 # 8000b250 <started>
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
    80000340:	b9a080e7          	jalr	-1126(ra) # 80000ed6 <cpuid>
    80000344:	85aa                	mv	a1,a0
    80000346:	00008517          	auipc	a0,0x8
    8000034a:	cf250513          	addi	a0,a0,-782 # 80008038 <etext+0x38>
    8000034e:	00006097          	auipc	ra,0x6
    80000352:	b2e080e7          	jalr	-1234(ra) # 80005e7c <printf>
    kvminithart();    // turn on paging
    80000356:	00000097          	auipc	ra,0x0
    8000035a:	0d8080e7          	jalr	216(ra) # 8000042e <kvminithart>
    trapinithart();   // install kernel trap vector
    8000035e:	00002097          	auipc	ra,0x2
    80000362:	8f4080e7          	jalr	-1804(ra) # 80001c52 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000366:	00005097          	auipc	ra,0x5
    8000036a:	f6e080e7          	jalr	-146(ra) # 800052d4 <plicinithart>
  }

  scheduler();        
    8000036e:	00001097          	auipc	ra,0x1
    80000372:	13c080e7          	jalr	316(ra) # 800014aa <scheduler>
    consoleinit();
    80000376:	00006097          	auipc	ra,0x6
    8000037a:	9cc080e7          	jalr	-1588(ra) # 80005d42 <consoleinit>
    printfinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	d06080e7          	jalr	-762(ra) # 80006084 <printfinit>
    printf("\n");
    80000386:	00008517          	auipc	a0,0x8
    8000038a:	c9250513          	addi	a0,a0,-878 # 80008018 <etext+0x18>
    8000038e:	00006097          	auipc	ra,0x6
    80000392:	aee080e7          	jalr	-1298(ra) # 80005e7c <printf>
    printf("xv6 kernel is booting\n");
    80000396:	00008517          	auipc	a0,0x8
    8000039a:	c8a50513          	addi	a0,a0,-886 # 80008020 <etext+0x20>
    8000039e:	00006097          	auipc	ra,0x6
    800003a2:	ade080e7          	jalr	-1314(ra) # 80005e7c <printf>
    printf("\n");
    800003a6:	00008517          	auipc	a0,0x8
    800003aa:	c7250513          	addi	a0,a0,-910 # 80008018 <etext+0x18>
    800003ae:	00006097          	auipc	ra,0x6
    800003b2:	ace080e7          	jalr	-1330(ra) # 80005e7c <printf>
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
    800003d2:	a48080e7          	jalr	-1464(ra) # 80000e16 <procinit>
    trapinit();      // trap vectors
    800003d6:	00002097          	auipc	ra,0x2
    800003da:	854080e7          	jalr	-1964(ra) # 80001c2a <trapinit>
    trapinithart();  // install kernel trap vector
    800003de:	00002097          	auipc	ra,0x2
    800003e2:	874080e7          	jalr	-1932(ra) # 80001c52 <trapinithart>
    plicinit();      // set up interrupt controller
    800003e6:	00005097          	auipc	ra,0x5
    800003ea:	ed4080e7          	jalr	-300(ra) # 800052ba <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	ee6080e7          	jalr	-282(ra) # 800052d4 <plicinithart>
    binit();         // buffer cache
    800003f6:	00002097          	auipc	ra,0x2
    800003fa:	fb2080e7          	jalr	-78(ra) # 800023a8 <binit>
    iinit();         // inode table
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	668080e7          	jalr	1640(ra) # 80002a66 <iinit>
    fileinit();      // file table
    80000406:	00003097          	auipc	ra,0x3
    8000040a:	618080e7          	jalr	1560(ra) # 80003a1e <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000040e:	00005097          	auipc	ra,0x5
    80000412:	fce080e7          	jalr	-50(ra) # 800053dc <virtio_disk_init>
    userinit();      // first user process
    80000416:	00001097          	auipc	ra,0x1
    8000041a:	e74080e7          	jalr	-396(ra) # 8000128a <userinit>
    __sync_synchronize();
    8000041e:	0330000f          	fence	rw,rw
    started = 1;
    80000422:	4785                	li	a5,1
    80000424:	0000b717          	auipc	a4,0xb
    80000428:	e2f72623          	sw	a5,-468(a4) # 8000b250 <started>
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
    8000043c:	e207b783          	ld	a5,-480(a5) # 8000b258 <kernel_pagetable>
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
    80000488:	9ae080e7          	jalr	-1618(ra) # 80005e32 <panic>
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
    800004b6:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffda707>
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
    800005b2:	884080e7          	jalr	-1916(ra) # 80005e32 <panic>
    panic("mappages: size not aligned");
    800005b6:	00008517          	auipc	a0,0x8
    800005ba:	ac250513          	addi	a0,a0,-1342 # 80008078 <etext+0x78>
    800005be:	00006097          	auipc	ra,0x6
    800005c2:	874080e7          	jalr	-1932(ra) # 80005e32 <panic>
    panic("mappages: size");
    800005c6:	00008517          	auipc	a0,0x8
    800005ca:	ad250513          	addi	a0,a0,-1326 # 80008098 <etext+0x98>
    800005ce:	00006097          	auipc	ra,0x6
    800005d2:	864080e7          	jalr	-1948(ra) # 80005e32 <panic>
      panic("mappages: remap");
    800005d6:	00008517          	auipc	a0,0x8
    800005da:	ad250513          	addi	a0,a0,-1326 # 800080a8 <etext+0xa8>
    800005de:	00006097          	auipc	ra,0x6
    800005e2:	854080e7          	jalr	-1964(ra) # 80005e32 <panic>
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
    8000062e:	808080e7          	jalr	-2040(ra) # 80005e32 <panic>

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
    800006f6:	682080e7          	jalr	1666(ra) # 80000d74 <proc_mapstacks>
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
    8000071c:	b4a7b023          	sd	a0,-1216(a5) # 8000b258 <kernel_pagetable>
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
    80000770:	00005097          	auipc	ra,0x5
    80000774:	6c2080e7          	jalr	1730(ra) # 80005e32 <panic>
      panic("uvmunmap: walk");
    80000778:	00008517          	auipc	a0,0x8
    8000077c:	96050513          	addi	a0,a0,-1696 # 800080d8 <etext+0xd8>
    80000780:	00005097          	auipc	ra,0x5
    80000784:	6b2080e7          	jalr	1714(ra) # 80005e32 <panic>
      panic("uvmunmap: not mapped");
    80000788:	00008517          	auipc	a0,0x8
    8000078c:	96050513          	addi	a0,a0,-1696 # 800080e8 <etext+0xe8>
    80000790:	00005097          	auipc	ra,0x5
    80000794:	6a2080e7          	jalr	1698(ra) # 80005e32 <panic>
      panic("uvmunmap: not a leaf");
    80000798:	00008517          	auipc	a0,0x8
    8000079c:	96850513          	addi	a0,a0,-1688 # 80008100 <etext+0x100>
    800007a0:	00005097          	auipc	ra,0x5
    800007a4:	692080e7          	jalr	1682(ra) # 80005e32 <panic>
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
    80000898:	59e080e7          	jalr	1438(ra) # 80005e32 <panic>

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
    800009f0:	446080e7          	jalr	1094(ra) # 80005e32 <panic>
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
    80000ace:	368080e7          	jalr	872(ra) # 80005e32 <panic>
      panic("uvmcopy: page not present");
    80000ad2:	00007517          	auipc	a0,0x7
    80000ad6:	69650513          	addi	a0,a0,1686 # 80008168 <etext+0x168>
    80000ada:	00005097          	auipc	ra,0x5
    80000ade:	358080e7          	jalr	856(ra) # 80005e32 <panic>
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
    80000b48:	2ee080e7          	jalr	750(ra) # 80005e32 <panic>

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

0000000080000d74 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000d74:	7139                	addi	sp,sp,-64
    80000d76:	fc06                	sd	ra,56(sp)
    80000d78:	f822                	sd	s0,48(sp)
    80000d7a:	f426                	sd	s1,40(sp)
    80000d7c:	f04a                	sd	s2,32(sp)
    80000d7e:	ec4e                	sd	s3,24(sp)
    80000d80:	e852                	sd	s4,16(sp)
    80000d82:	e456                	sd	s5,8(sp)
    80000d84:	e05a                	sd	s6,0(sp)
    80000d86:	0080                	addi	s0,sp,64
    80000d88:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d8a:	0000b497          	auipc	s1,0xb
    80000d8e:	94648493          	addi	s1,s1,-1722 # 8000b6d0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d92:	8b26                	mv	s6,s1
    80000d94:	ff4df937          	lui	s2,0xff4df
    80000d98:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4ba0cd>
    80000d9c:	0936                	slli	s2,s2,0xd
    80000d9e:	6f590913          	addi	s2,s2,1781
    80000da2:	0936                	slli	s2,s2,0xd
    80000da4:	bd390913          	addi	s2,s2,-1069
    80000da8:	0932                	slli	s2,s2,0xc
    80000daa:	7a790913          	addi	s2,s2,1959
    80000dae:	010009b7          	lui	s3,0x1000
    80000db2:	19fd                	addi	s3,s3,-1 # ffffff <_entry-0x7f000001>
    80000db4:	09ba                	slli	s3,s3,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000db6:	00010a97          	auipc	s5,0x10
    80000dba:	51aa8a93          	addi	s5,s5,1306 # 800112d0 <tickslock>
    char *pa = kalloc();
    80000dbe:	fffff097          	auipc	ra,0xfffff
    80000dc2:	35c080e7          	jalr	860(ra) # 8000011a <kalloc>
    80000dc6:	862a                	mv	a2,a0
    if(pa == 0)
    80000dc8:	cd1d                	beqz	a0,80000e06 <proc_mapstacks+0x92>
    uint64 va = KSTACK((int) (p - proc));
    80000dca:	416485b3          	sub	a1,s1,s6
    80000dce:	8591                	srai	a1,a1,0x4
    80000dd0:	032585b3          	mul	a1,a1,s2
    80000dd4:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000dd8:	4719                	li	a4,6
    80000dda:	6685                	lui	a3,0x1
    80000ddc:	40b985b3          	sub	a1,s3,a1
    80000de0:	8552                	mv	a0,s4
    80000de2:	00000097          	auipc	ra,0x0
    80000de6:	820080e7          	jalr	-2016(ra) # 80000602 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dea:	17048493          	addi	s1,s1,368
    80000dee:	fd5498e3          	bne	s1,s5,80000dbe <proc_mapstacks+0x4a>
  }
}
    80000df2:	70e2                	ld	ra,56(sp)
    80000df4:	7442                	ld	s0,48(sp)
    80000df6:	74a2                	ld	s1,40(sp)
    80000df8:	7902                	ld	s2,32(sp)
    80000dfa:	69e2                	ld	s3,24(sp)
    80000dfc:	6a42                	ld	s4,16(sp)
    80000dfe:	6aa2                	ld	s5,8(sp)
    80000e00:	6b02                	ld	s6,0(sp)
    80000e02:	6121                	addi	sp,sp,64
    80000e04:	8082                	ret
      panic("kalloc");
    80000e06:	00007517          	auipc	a0,0x7
    80000e0a:	39250513          	addi	a0,a0,914 # 80008198 <etext+0x198>
    80000e0e:	00005097          	auipc	ra,0x5
    80000e12:	024080e7          	jalr	36(ra) # 80005e32 <panic>

0000000080000e16 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000e16:	7139                	addi	sp,sp,-64
    80000e18:	fc06                	sd	ra,56(sp)
    80000e1a:	f822                	sd	s0,48(sp)
    80000e1c:	f426                	sd	s1,40(sp)
    80000e1e:	f04a                	sd	s2,32(sp)
    80000e20:	ec4e                	sd	s3,24(sp)
    80000e22:	e852                	sd	s4,16(sp)
    80000e24:	e456                	sd	s5,8(sp)
    80000e26:	e05a                	sd	s6,0(sp)
    80000e28:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000e2a:	00007597          	auipc	a1,0x7
    80000e2e:	37658593          	addi	a1,a1,886 # 800081a0 <etext+0x1a0>
    80000e32:	0000a517          	auipc	a0,0xa
    80000e36:	46e50513          	addi	a0,a0,1134 # 8000b2a0 <pid_lock>
    80000e3a:	00005097          	auipc	ra,0x5
    80000e3e:	4e2080e7          	jalr	1250(ra) # 8000631c <initlock>
  initlock(&wait_lock, "wait_lock");
    80000e42:	00007597          	auipc	a1,0x7
    80000e46:	36658593          	addi	a1,a1,870 # 800081a8 <etext+0x1a8>
    80000e4a:	0000a517          	auipc	a0,0xa
    80000e4e:	46e50513          	addi	a0,a0,1134 # 8000b2b8 <wait_lock>
    80000e52:	00005097          	auipc	ra,0x5
    80000e56:	4ca080e7          	jalr	1226(ra) # 8000631c <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e5a:	0000b497          	auipc	s1,0xb
    80000e5e:	87648493          	addi	s1,s1,-1930 # 8000b6d0 <proc>
      initlock(&p->lock, "proc");
    80000e62:	00007b17          	auipc	s6,0x7
    80000e66:	356b0b13          	addi	s6,s6,854 # 800081b8 <etext+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000e6a:	8aa6                	mv	s5,s1
    80000e6c:	ff4df937          	lui	s2,0xff4df
    80000e70:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4ba0cd>
    80000e74:	0936                	slli	s2,s2,0xd
    80000e76:	6f590913          	addi	s2,s2,1781
    80000e7a:	0936                	slli	s2,s2,0xd
    80000e7c:	bd390913          	addi	s2,s2,-1069
    80000e80:	0932                	slli	s2,s2,0xc
    80000e82:	7a790913          	addi	s2,s2,1959
    80000e86:	010009b7          	lui	s3,0x1000
    80000e8a:	19fd                	addi	s3,s3,-1 # ffffff <_entry-0x7f000001>
    80000e8c:	09ba                	slli	s3,s3,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e8e:	00010a17          	auipc	s4,0x10
    80000e92:	442a0a13          	addi	s4,s4,1090 # 800112d0 <tickslock>
      initlock(&p->lock, "proc");
    80000e96:	85da                	mv	a1,s6
    80000e98:	8526                	mv	a0,s1
    80000e9a:	00005097          	auipc	ra,0x5
    80000e9e:	482080e7          	jalr	1154(ra) # 8000631c <initlock>
      p->state = UNUSED;
    80000ea2:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000ea6:	415487b3          	sub	a5,s1,s5
    80000eaa:	8791                	srai	a5,a5,0x4
    80000eac:	032787b3          	mul	a5,a5,s2
    80000eb0:	00d7979b          	slliw	a5,a5,0xd
    80000eb4:	40f987b3          	sub	a5,s3,a5
    80000eb8:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000eba:	17048493          	addi	s1,s1,368
    80000ebe:	fd449ce3          	bne	s1,s4,80000e96 <procinit+0x80>
  }
}
    80000ec2:	70e2                	ld	ra,56(sp)
    80000ec4:	7442                	ld	s0,48(sp)
    80000ec6:	74a2                	ld	s1,40(sp)
    80000ec8:	7902                	ld	s2,32(sp)
    80000eca:	69e2                	ld	s3,24(sp)
    80000ecc:	6a42                	ld	s4,16(sp)
    80000ece:	6aa2                	ld	s5,8(sp)
    80000ed0:	6b02                	ld	s6,0(sp)
    80000ed2:	6121                	addi	sp,sp,64
    80000ed4:	8082                	ret

0000000080000ed6 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000ed6:	1141                	addi	sp,sp,-16
    80000ed8:	e422                	sd	s0,8(sp)
    80000eda:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000edc:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000ede:	2501                	sext.w	a0,a0
    80000ee0:	6422                	ld	s0,8(sp)
    80000ee2:	0141                	addi	sp,sp,16
    80000ee4:	8082                	ret

0000000080000ee6 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000ee6:	1141                	addi	sp,sp,-16
    80000ee8:	e422                	sd	s0,8(sp)
    80000eea:	0800                	addi	s0,sp,16
    80000eec:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000eee:	2781                	sext.w	a5,a5
    80000ef0:	079e                	slli	a5,a5,0x7
  return c;
}
    80000ef2:	0000a517          	auipc	a0,0xa
    80000ef6:	3de50513          	addi	a0,a0,990 # 8000b2d0 <cpus>
    80000efa:	953e                	add	a0,a0,a5
    80000efc:	6422                	ld	s0,8(sp)
    80000efe:	0141                	addi	sp,sp,16
    80000f00:	8082                	ret

0000000080000f02 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000f02:	1101                	addi	sp,sp,-32
    80000f04:	ec06                	sd	ra,24(sp)
    80000f06:	e822                	sd	s0,16(sp)
    80000f08:	e426                	sd	s1,8(sp)
    80000f0a:	1000                	addi	s0,sp,32
  push_off();
    80000f0c:	00005097          	auipc	ra,0x5
    80000f10:	454080e7          	jalr	1108(ra) # 80006360 <push_off>
    80000f14:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f16:	2781                	sext.w	a5,a5
    80000f18:	079e                	slli	a5,a5,0x7
    80000f1a:	0000a717          	auipc	a4,0xa
    80000f1e:	38670713          	addi	a4,a4,902 # 8000b2a0 <pid_lock>
    80000f22:	97ba                	add	a5,a5,a4
    80000f24:	7b84                	ld	s1,48(a5)
  pop_off();
    80000f26:	00005097          	auipc	ra,0x5
    80000f2a:	4da080e7          	jalr	1242(ra) # 80006400 <pop_off>
  return p;
}
    80000f2e:	8526                	mv	a0,s1
    80000f30:	60e2                	ld	ra,24(sp)
    80000f32:	6442                	ld	s0,16(sp)
    80000f34:	64a2                	ld	s1,8(sp)
    80000f36:	6105                	addi	sp,sp,32
    80000f38:	8082                	ret

0000000080000f3a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000f3a:	1141                	addi	sp,sp,-16
    80000f3c:	e406                	sd	ra,8(sp)
    80000f3e:	e022                	sd	s0,0(sp)
    80000f40:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000f42:	00000097          	auipc	ra,0x0
    80000f46:	fc0080e7          	jalr	-64(ra) # 80000f02 <myproc>
    80000f4a:	00005097          	auipc	ra,0x5
    80000f4e:	516080e7          	jalr	1302(ra) # 80006460 <release>

  if (first) {
    80000f52:	0000a797          	auipc	a5,0xa
    80000f56:	28e7a783          	lw	a5,654(a5) # 8000b1e0 <first.1>
    80000f5a:	eb89                	bnez	a5,80000f6c <forkret+0x32>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000f5c:	00001097          	auipc	ra,0x1
    80000f60:	d0e080e7          	jalr	-754(ra) # 80001c6a <usertrapret>
}
    80000f64:	60a2                	ld	ra,8(sp)
    80000f66:	6402                	ld	s0,0(sp)
    80000f68:	0141                	addi	sp,sp,16
    80000f6a:	8082                	ret
    fsinit(ROOTDEV);
    80000f6c:	4505                	li	a0,1
    80000f6e:	00002097          	auipc	ra,0x2
    80000f72:	a78080e7          	jalr	-1416(ra) # 800029e6 <fsinit>
    first = 0;
    80000f76:	0000a797          	auipc	a5,0xa
    80000f7a:	2607a523          	sw	zero,618(a5) # 8000b1e0 <first.1>
    __sync_synchronize();
    80000f7e:	0330000f          	fence	rw,rw
    80000f82:	bfe9                	j	80000f5c <forkret+0x22>

0000000080000f84 <allocpid>:
{
    80000f84:	1101                	addi	sp,sp,-32
    80000f86:	ec06                	sd	ra,24(sp)
    80000f88:	e822                	sd	s0,16(sp)
    80000f8a:	e426                	sd	s1,8(sp)
    80000f8c:	e04a                	sd	s2,0(sp)
    80000f8e:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f90:	0000a917          	auipc	s2,0xa
    80000f94:	31090913          	addi	s2,s2,784 # 8000b2a0 <pid_lock>
    80000f98:	854a                	mv	a0,s2
    80000f9a:	00005097          	auipc	ra,0x5
    80000f9e:	412080e7          	jalr	1042(ra) # 800063ac <acquire>
  pid = nextpid;
    80000fa2:	0000a797          	auipc	a5,0xa
    80000fa6:	24278793          	addi	a5,a5,578 # 8000b1e4 <nextpid>
    80000faa:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000fac:	0014871b          	addiw	a4,s1,1
    80000fb0:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000fb2:	854a                	mv	a0,s2
    80000fb4:	00005097          	auipc	ra,0x5
    80000fb8:	4ac080e7          	jalr	1196(ra) # 80006460 <release>
}
    80000fbc:	8526                	mv	a0,s1
    80000fbe:	60e2                	ld	ra,24(sp)
    80000fc0:	6442                	ld	s0,16(sp)
    80000fc2:	64a2                	ld	s1,8(sp)
    80000fc4:	6902                	ld	s2,0(sp)
    80000fc6:	6105                	addi	sp,sp,32
    80000fc8:	8082                	ret

0000000080000fca <proc_pagetable>:
{
    80000fca:	1101                	addi	sp,sp,-32
    80000fcc:	ec06                	sd	ra,24(sp)
    80000fce:	e822                	sd	s0,16(sp)
    80000fd0:	e426                	sd	s1,8(sp)
    80000fd2:	e04a                	sd	s2,0(sp)
    80000fd4:	1000                	addi	s0,sp,32
    80000fd6:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000fd8:	00000097          	auipc	ra,0x0
    80000fdc:	824080e7          	jalr	-2012(ra) # 800007fc <uvmcreate>
    80000fe0:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000fe2:	cd39                	beqz	a0,80001040 <proc_pagetable+0x76>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000fe4:	4729                	li	a4,10
    80000fe6:	00006697          	auipc	a3,0x6
    80000fea:	01a68693          	addi	a3,a3,26 # 80007000 <_trampoline>
    80000fee:	6605                	lui	a2,0x1
    80000ff0:	040005b7          	lui	a1,0x4000
    80000ff4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ff6:	05b2                	slli	a1,a1,0xc
    80000ff8:	fffff097          	auipc	ra,0xfffff
    80000ffc:	546080e7          	jalr	1350(ra) # 8000053e <mappages>
    80001000:	04054763          	bltz	a0,8000104e <proc_pagetable+0x84>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001004:	4719                	li	a4,6
    80001006:	05893683          	ld	a3,88(s2)
    8000100a:	6605                	lui	a2,0x1
    8000100c:	020005b7          	lui	a1,0x2000
    80001010:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001012:	05b6                	slli	a1,a1,0xd
    80001014:	8526                	mv	a0,s1
    80001016:	fffff097          	auipc	ra,0xfffff
    8000101a:	528080e7          	jalr	1320(ra) # 8000053e <mappages>
    8000101e:	04054063          	bltz	a0,8000105e <proc_pagetable+0x94>
  if (mappages(pagetable, USYSCALL, PGSIZE,
    80001022:	4749                	li	a4,18
    80001024:	06093683          	ld	a3,96(s2)
    80001028:	6605                	lui	a2,0x1
    8000102a:	040005b7          	lui	a1,0x4000
    8000102e:	15f5                	addi	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    80001030:	05b2                	slli	a1,a1,0xc
    80001032:	8526                	mv	a0,s1
    80001034:	fffff097          	auipc	ra,0xfffff
    80001038:	50a080e7          	jalr	1290(ra) # 8000053e <mappages>
    8000103c:	04054463          	bltz	a0,80001084 <proc_pagetable+0xba>
}
    80001040:	8526                	mv	a0,s1
    80001042:	60e2                	ld	ra,24(sp)
    80001044:	6442                	ld	s0,16(sp)
    80001046:	64a2                	ld	s1,8(sp)
    80001048:	6902                	ld	s2,0(sp)
    8000104a:	6105                	addi	sp,sp,32
    8000104c:	8082                	ret
    uvmfree(pagetable, 0);
    8000104e:	4581                	li	a1,0
    80001050:	8526                	mv	a0,s1
    80001052:	00000097          	auipc	ra,0x0
    80001056:	9bc080e7          	jalr	-1604(ra) # 80000a0e <uvmfree>
    return 0;
    8000105a:	4481                	li	s1,0
    8000105c:	b7d5                	j	80001040 <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000105e:	4681                	li	a3,0
    80001060:	4605                	li	a2,1
    80001062:	040005b7          	lui	a1,0x4000
    80001066:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001068:	05b2                	slli	a1,a1,0xc
    8000106a:	8526                	mv	a0,s1
    8000106c:	fffff097          	auipc	ra,0xfffff
    80001070:	6bc080e7          	jalr	1724(ra) # 80000728 <uvmunmap>
    uvmfree(pagetable, 0);
    80001074:	4581                	li	a1,0
    80001076:	8526                	mv	a0,s1
    80001078:	00000097          	auipc	ra,0x0
    8000107c:	996080e7          	jalr	-1642(ra) # 80000a0e <uvmfree>
    return 0;
    80001080:	4481                	li	s1,0
    80001082:	bf7d                	j	80001040 <proc_pagetable+0x76>
        uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001084:	4681                	li	a3,0
    80001086:	4605                	li	a2,1
    80001088:	020005b7          	lui	a1,0x2000
    8000108c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000108e:	05b6                	slli	a1,a1,0xd
    80001090:	8526                	mv	a0,s1
    80001092:	fffff097          	auipc	ra,0xfffff
    80001096:	696080e7          	jalr	1686(ra) # 80000728 <uvmunmap>
        uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000109a:	4681                	li	a3,0
    8000109c:	4605                	li	a2,1
    8000109e:	040005b7          	lui	a1,0x4000
    800010a2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010a4:	05b2                	slli	a1,a1,0xc
    800010a6:	8526                	mv	a0,s1
    800010a8:	fffff097          	auipc	ra,0xfffff
    800010ac:	680080e7          	jalr	1664(ra) # 80000728 <uvmunmap>
        uvmfree(pagetable, 0);
    800010b0:	4581                	li	a1,0
    800010b2:	8526                	mv	a0,s1
    800010b4:	00000097          	auipc	ra,0x0
    800010b8:	95a080e7          	jalr	-1702(ra) # 80000a0e <uvmfree>
        return 0;
    800010bc:	4481                	li	s1,0
    800010be:	b749                	j	80001040 <proc_pagetable+0x76>

00000000800010c0 <proc_freepagetable>:
{
    800010c0:	1101                	addi	sp,sp,-32
    800010c2:	ec06                	sd	ra,24(sp)
    800010c4:	e822                	sd	s0,16(sp)
    800010c6:	e426                	sd	s1,8(sp)
    800010c8:	e04a                	sd	s2,0(sp)
    800010ca:	1000                	addi	s0,sp,32
    800010cc:	84aa                	mv	s1,a0
    800010ce:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010d0:	4681                	li	a3,0
    800010d2:	4605                	li	a2,1
    800010d4:	040005b7          	lui	a1,0x4000
    800010d8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010da:	05b2                	slli	a1,a1,0xc
    800010dc:	fffff097          	auipc	ra,0xfffff
    800010e0:	64c080e7          	jalr	1612(ra) # 80000728 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800010e4:	4681                	li	a3,0
    800010e6:	4605                	li	a2,1
    800010e8:	020005b7          	lui	a1,0x2000
    800010ec:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800010ee:	05b6                	slli	a1,a1,0xd
    800010f0:	8526                	mv	a0,s1
    800010f2:	fffff097          	auipc	ra,0xfffff
    800010f6:	636080e7          	jalr	1590(ra) # 80000728 <uvmunmap>
  uvmunmap(pagetable, USYSCALL, 1, 0);
    800010fa:	4681                	li	a3,0
    800010fc:	4605                	li	a2,1
    800010fe:	040005b7          	lui	a1,0x4000
    80001102:	15f5                	addi	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    80001104:	05b2                	slli	a1,a1,0xc
    80001106:	8526                	mv	a0,s1
    80001108:	fffff097          	auipc	ra,0xfffff
    8000110c:	620080e7          	jalr	1568(ra) # 80000728 <uvmunmap>
  uvmfree(pagetable, sz);
    80001110:	85ca                	mv	a1,s2
    80001112:	8526                	mv	a0,s1
    80001114:	00000097          	auipc	ra,0x0
    80001118:	8fa080e7          	jalr	-1798(ra) # 80000a0e <uvmfree>
}
    8000111c:	60e2                	ld	ra,24(sp)
    8000111e:	6442                	ld	s0,16(sp)
    80001120:	64a2                	ld	s1,8(sp)
    80001122:	6902                	ld	s2,0(sp)
    80001124:	6105                	addi	sp,sp,32
    80001126:	8082                	ret

0000000080001128 <freeproc>:
{
    80001128:	1101                	addi	sp,sp,-32
    8000112a:	ec06                	sd	ra,24(sp)
    8000112c:	e822                	sd	s0,16(sp)
    8000112e:	e426                	sd	s1,8(sp)
    80001130:	1000                	addi	s0,sp,32
    80001132:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001134:	6d28                	ld	a0,88(a0)
    80001136:	c509                	beqz	a0,80001140 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001138:	fffff097          	auipc	ra,0xfffff
    8000113c:	ee4080e7          	jalr	-284(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001140:	0404bc23          	sd	zero,88(s1)
  if (p->usyscall) {
    80001144:	70a8                	ld	a0,96(s1)
    80001146:	c509                	beqz	a0,80001150 <freeproc+0x28>
        kfree((void *) p->usyscall);
    80001148:	fffff097          	auipc	ra,0xfffff
    8000114c:	ed4080e7          	jalr	-300(ra) # 8000001c <kfree>
  p->usyscall = 0;
    80001150:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    80001154:	68a8                	ld	a0,80(s1)
    80001156:	c511                	beqz	a0,80001162 <freeproc+0x3a>
    proc_freepagetable(p->pagetable, p->sz);
    80001158:	64ac                	ld	a1,72(s1)
    8000115a:	00000097          	auipc	ra,0x0
    8000115e:	f66080e7          	jalr	-154(ra) # 800010c0 <proc_freepagetable>
  p->pagetable = 0;
    80001162:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001166:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000116a:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000116e:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001172:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80001176:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000117a:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000117e:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001182:	0004ac23          	sw	zero,24(s1)
}
    80001186:	60e2                	ld	ra,24(sp)
    80001188:	6442                	ld	s0,16(sp)
    8000118a:	64a2                	ld	s1,8(sp)
    8000118c:	6105                	addi	sp,sp,32
    8000118e:	8082                	ret

0000000080001190 <allocproc>:
{
    80001190:	1101                	addi	sp,sp,-32
    80001192:	ec06                	sd	ra,24(sp)
    80001194:	e822                	sd	s0,16(sp)
    80001196:	e426                	sd	s1,8(sp)
    80001198:	e04a                	sd	s2,0(sp)
    8000119a:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000119c:	0000a497          	auipc	s1,0xa
    800011a0:	53448493          	addi	s1,s1,1332 # 8000b6d0 <proc>
    800011a4:	00010917          	auipc	s2,0x10
    800011a8:	12c90913          	addi	s2,s2,300 # 800112d0 <tickslock>
    acquire(&p->lock);
    800011ac:	8526                	mv	a0,s1
    800011ae:	00005097          	auipc	ra,0x5
    800011b2:	1fe080e7          	jalr	510(ra) # 800063ac <acquire>
    if(p->state == UNUSED) {
    800011b6:	4c9c                	lw	a5,24(s1)
    800011b8:	cf81                	beqz	a5,800011d0 <allocproc+0x40>
      release(&p->lock);
    800011ba:	8526                	mv	a0,s1
    800011bc:	00005097          	auipc	ra,0x5
    800011c0:	2a4080e7          	jalr	676(ra) # 80006460 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800011c4:	17048493          	addi	s1,s1,368
    800011c8:	ff2492e3          	bne	s1,s2,800011ac <allocproc+0x1c>
  return 0;
    800011cc:	4481                	li	s1,0
    800011ce:	a09d                	j	80001234 <allocproc+0xa4>
  p->pid = allocpid();
    800011d0:	00000097          	auipc	ra,0x0
    800011d4:	db4080e7          	jalr	-588(ra) # 80000f84 <allocpid>
    800011d8:	d888                	sw	a0,48(s1)
  p->state = USED;
    800011da:	4785                	li	a5,1
    800011dc:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800011de:	fffff097          	auipc	ra,0xfffff
    800011e2:	f3c080e7          	jalr	-196(ra) # 8000011a <kalloc>
    800011e6:	892a                	mv	s2,a0
    800011e8:	eca8                	sd	a0,88(s1)
    800011ea:	cd21                	beqz	a0,80001242 <allocproc+0xb2>
  if ((p->usyscall = (struct usyscall *) kalloc()) == 0) {
    800011ec:	fffff097          	auipc	ra,0xfffff
    800011f0:	f2e080e7          	jalr	-210(ra) # 8000011a <kalloc>
    800011f4:	892a                	mv	s2,a0
    800011f6:	f0a8                	sd	a0,96(s1)
    800011f8:	c12d                	beqz	a0,8000125a <allocproc+0xca>
  p->pagetable = proc_pagetable(p);
    800011fa:	8526                	mv	a0,s1
    800011fc:	00000097          	auipc	ra,0x0
    80001200:	dce080e7          	jalr	-562(ra) # 80000fca <proc_pagetable>
    80001204:	892a                	mv	s2,a0
    80001206:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001208:	c52d                	beqz	a0,80001272 <allocproc+0xe2>
  memset(&p->context, 0, sizeof(p->context));
    8000120a:	07000613          	li	a2,112
    8000120e:	4581                	li	a1,0
    80001210:	06848513          	addi	a0,s1,104
    80001214:	fffff097          	auipc	ra,0xfffff
    80001218:	f66080e7          	jalr	-154(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    8000121c:	00000797          	auipc	a5,0x0
    80001220:	d1e78793          	addi	a5,a5,-738 # 80000f3a <forkret>
    80001224:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001226:	60bc                	ld	a5,64(s1)
    80001228:	6705                	lui	a4,0x1
    8000122a:	97ba                	add	a5,a5,a4
    8000122c:	f8bc                	sd	a5,112(s1)
  p->usyscall->pid = p->pid;
    8000122e:	70bc                	ld	a5,96(s1)
    80001230:	5898                	lw	a4,48(s1)
    80001232:	c398                	sw	a4,0(a5)
}
    80001234:	8526                	mv	a0,s1
    80001236:	60e2                	ld	ra,24(sp)
    80001238:	6442                	ld	s0,16(sp)
    8000123a:	64a2                	ld	s1,8(sp)
    8000123c:	6902                	ld	s2,0(sp)
    8000123e:	6105                	addi	sp,sp,32
    80001240:	8082                	ret
    freeproc(p);
    80001242:	8526                	mv	a0,s1
    80001244:	00000097          	auipc	ra,0x0
    80001248:	ee4080e7          	jalr	-284(ra) # 80001128 <freeproc>
    release(&p->lock);
    8000124c:	8526                	mv	a0,s1
    8000124e:	00005097          	auipc	ra,0x5
    80001252:	212080e7          	jalr	530(ra) # 80006460 <release>
    return 0;
    80001256:	84ca                	mv	s1,s2
    80001258:	bff1                	j	80001234 <allocproc+0xa4>
        freeproc(p);
    8000125a:	8526                	mv	a0,s1
    8000125c:	00000097          	auipc	ra,0x0
    80001260:	ecc080e7          	jalr	-308(ra) # 80001128 <freeproc>
        release(&p->lock);
    80001264:	8526                	mv	a0,s1
    80001266:	00005097          	auipc	ra,0x5
    8000126a:	1fa080e7          	jalr	506(ra) # 80006460 <release>
        return 0;
    8000126e:	84ca                	mv	s1,s2
    80001270:	b7d1                	j	80001234 <allocproc+0xa4>
    freeproc(p);
    80001272:	8526                	mv	a0,s1
    80001274:	00000097          	auipc	ra,0x0
    80001278:	eb4080e7          	jalr	-332(ra) # 80001128 <freeproc>
    release(&p->lock);
    8000127c:	8526                	mv	a0,s1
    8000127e:	00005097          	auipc	ra,0x5
    80001282:	1e2080e7          	jalr	482(ra) # 80006460 <release>
    return 0;
    80001286:	84ca                	mv	s1,s2
    80001288:	b775                	j	80001234 <allocproc+0xa4>

000000008000128a <userinit>:
{
    8000128a:	1101                	addi	sp,sp,-32
    8000128c:	ec06                	sd	ra,24(sp)
    8000128e:	e822                	sd	s0,16(sp)
    80001290:	e426                	sd	s1,8(sp)
    80001292:	1000                	addi	s0,sp,32
  p = allocproc();
    80001294:	00000097          	auipc	ra,0x0
    80001298:	efc080e7          	jalr	-260(ra) # 80001190 <allocproc>
    8000129c:	84aa                	mv	s1,a0
  initproc = p;
    8000129e:	0000a797          	auipc	a5,0xa
    800012a2:	fca7b123          	sd	a0,-62(a5) # 8000b260 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800012a6:	03400613          	li	a2,52
    800012aa:	0000a597          	auipc	a1,0xa
    800012ae:	f4658593          	addi	a1,a1,-186 # 8000b1f0 <initcode>
    800012b2:	6928                	ld	a0,80(a0)
    800012b4:	fffff097          	auipc	ra,0xfffff
    800012b8:	576080e7          	jalr	1398(ra) # 8000082a <uvmfirst>
  p->sz = PGSIZE;
    800012bc:	6785                	lui	a5,0x1
    800012be:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800012c0:	6cb8                	ld	a4,88(s1)
    800012c2:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800012c6:	6cb8                	ld	a4,88(s1)
    800012c8:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800012ca:	4641                	li	a2,16
    800012cc:	00007597          	auipc	a1,0x7
    800012d0:	ef458593          	addi	a1,a1,-268 # 800081c0 <etext+0x1c0>
    800012d4:	16048513          	addi	a0,s1,352
    800012d8:	fffff097          	auipc	ra,0xfffff
    800012dc:	fe4080e7          	jalr	-28(ra) # 800002bc <safestrcpy>
  p->cwd = namei("/");
    800012e0:	00007517          	auipc	a0,0x7
    800012e4:	ef050513          	addi	a0,a0,-272 # 800081d0 <etext+0x1d0>
    800012e8:	00002097          	auipc	ra,0x2
    800012ec:	150080e7          	jalr	336(ra) # 80003438 <namei>
    800012f0:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    800012f4:	478d                	li	a5,3
    800012f6:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800012f8:	8526                	mv	a0,s1
    800012fa:	00005097          	auipc	ra,0x5
    800012fe:	166080e7          	jalr	358(ra) # 80006460 <release>
}
    80001302:	60e2                	ld	ra,24(sp)
    80001304:	6442                	ld	s0,16(sp)
    80001306:	64a2                	ld	s1,8(sp)
    80001308:	6105                	addi	sp,sp,32
    8000130a:	8082                	ret

000000008000130c <growproc>:
{
    8000130c:	1101                	addi	sp,sp,-32
    8000130e:	ec06                	sd	ra,24(sp)
    80001310:	e822                	sd	s0,16(sp)
    80001312:	e426                	sd	s1,8(sp)
    80001314:	e04a                	sd	s2,0(sp)
    80001316:	1000                	addi	s0,sp,32
    80001318:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000131a:	00000097          	auipc	ra,0x0
    8000131e:	be8080e7          	jalr	-1048(ra) # 80000f02 <myproc>
    80001322:	84aa                	mv	s1,a0
  sz = p->sz;
    80001324:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001326:	01204c63          	bgtz	s2,8000133e <growproc+0x32>
  } else if(n < 0){
    8000132a:	02094663          	bltz	s2,80001356 <growproc+0x4a>
  p->sz = sz;
    8000132e:	e4ac                	sd	a1,72(s1)
  return 0;
    80001330:	4501                	li	a0,0
}
    80001332:	60e2                	ld	ra,24(sp)
    80001334:	6442                	ld	s0,16(sp)
    80001336:	64a2                	ld	s1,8(sp)
    80001338:	6902                	ld	s2,0(sp)
    8000133a:	6105                	addi	sp,sp,32
    8000133c:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    8000133e:	4691                	li	a3,4
    80001340:	00b90633          	add	a2,s2,a1
    80001344:	6928                	ld	a0,80(a0)
    80001346:	fffff097          	auipc	ra,0xfffff
    8000134a:	59e080e7          	jalr	1438(ra) # 800008e4 <uvmalloc>
    8000134e:	85aa                	mv	a1,a0
    80001350:	fd79                	bnez	a0,8000132e <growproc+0x22>
      return -1;
    80001352:	557d                	li	a0,-1
    80001354:	bff9                	j	80001332 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001356:	00b90633          	add	a2,s2,a1
    8000135a:	6928                	ld	a0,80(a0)
    8000135c:	fffff097          	auipc	ra,0xfffff
    80001360:	540080e7          	jalr	1344(ra) # 8000089c <uvmdealloc>
    80001364:	85aa                	mv	a1,a0
    80001366:	b7e1                	j	8000132e <growproc+0x22>

0000000080001368 <fork>:
{
    80001368:	7139                	addi	sp,sp,-64
    8000136a:	fc06                	sd	ra,56(sp)
    8000136c:	f822                	sd	s0,48(sp)
    8000136e:	f04a                	sd	s2,32(sp)
    80001370:	e456                	sd	s5,8(sp)
    80001372:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001374:	00000097          	auipc	ra,0x0
    80001378:	b8e080e7          	jalr	-1138(ra) # 80000f02 <myproc>
    8000137c:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000137e:	00000097          	auipc	ra,0x0
    80001382:	e12080e7          	jalr	-494(ra) # 80001190 <allocproc>
    80001386:	12050063          	beqz	a0,800014a6 <fork+0x13e>
    8000138a:	e852                	sd	s4,16(sp)
    8000138c:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000138e:	048ab603          	ld	a2,72(s5)
    80001392:	692c                	ld	a1,80(a0)
    80001394:	050ab503          	ld	a0,80(s5)
    80001398:	fffff097          	auipc	ra,0xfffff
    8000139c:	6b0080e7          	jalr	1712(ra) # 80000a48 <uvmcopy>
    800013a0:	04054a63          	bltz	a0,800013f4 <fork+0x8c>
    800013a4:	f426                	sd	s1,40(sp)
    800013a6:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    800013a8:	048ab783          	ld	a5,72(s5)
    800013ac:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800013b0:	058ab683          	ld	a3,88(s5)
    800013b4:	87b6                	mv	a5,a3
    800013b6:	058a3703          	ld	a4,88(s4)
    800013ba:	12068693          	addi	a3,a3,288
    800013be:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800013c2:	6788                	ld	a0,8(a5)
    800013c4:	6b8c                	ld	a1,16(a5)
    800013c6:	6f90                	ld	a2,24(a5)
    800013c8:	01073023          	sd	a6,0(a4)
    800013cc:	e708                	sd	a0,8(a4)
    800013ce:	eb0c                	sd	a1,16(a4)
    800013d0:	ef10                	sd	a2,24(a4)
    800013d2:	02078793          	addi	a5,a5,32
    800013d6:	02070713          	addi	a4,a4,32
    800013da:	fed792e3          	bne	a5,a3,800013be <fork+0x56>
  np->trapframe->a0 = 0;
    800013de:	058a3783          	ld	a5,88(s4)
    800013e2:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800013e6:	0d8a8493          	addi	s1,s5,216
    800013ea:	0d8a0913          	addi	s2,s4,216
    800013ee:	158a8993          	addi	s3,s5,344
    800013f2:	a015                	j	80001416 <fork+0xae>
    freeproc(np);
    800013f4:	8552                	mv	a0,s4
    800013f6:	00000097          	auipc	ra,0x0
    800013fa:	d32080e7          	jalr	-718(ra) # 80001128 <freeproc>
    release(&np->lock);
    800013fe:	8552                	mv	a0,s4
    80001400:	00005097          	auipc	ra,0x5
    80001404:	060080e7          	jalr	96(ra) # 80006460 <release>
    return -1;
    80001408:	597d                	li	s2,-1
    8000140a:	6a42                	ld	s4,16(sp)
    8000140c:	a071                	j	80001498 <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    8000140e:	04a1                	addi	s1,s1,8
    80001410:	0921                	addi	s2,s2,8
    80001412:	01348b63          	beq	s1,s3,80001428 <fork+0xc0>
    if(p->ofile[i])
    80001416:	6088                	ld	a0,0(s1)
    80001418:	d97d                	beqz	a0,8000140e <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    8000141a:	00002097          	auipc	ra,0x2
    8000141e:	696080e7          	jalr	1686(ra) # 80003ab0 <filedup>
    80001422:	00a93023          	sd	a0,0(s2)
    80001426:	b7e5                	j	8000140e <fork+0xa6>
  np->cwd = idup(p->cwd);
    80001428:	158ab503          	ld	a0,344(s5)
    8000142c:	00002097          	auipc	ra,0x2
    80001430:	800080e7          	jalr	-2048(ra) # 80002c2c <idup>
    80001434:	14aa3c23          	sd	a0,344(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001438:	4641                	li	a2,16
    8000143a:	160a8593          	addi	a1,s5,352
    8000143e:	160a0513          	addi	a0,s4,352
    80001442:	fffff097          	auipc	ra,0xfffff
    80001446:	e7a080e7          	jalr	-390(ra) # 800002bc <safestrcpy>
  pid = np->pid;
    8000144a:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    8000144e:	8552                	mv	a0,s4
    80001450:	00005097          	auipc	ra,0x5
    80001454:	010080e7          	jalr	16(ra) # 80006460 <release>
  acquire(&wait_lock);
    80001458:	0000a497          	auipc	s1,0xa
    8000145c:	e6048493          	addi	s1,s1,-416 # 8000b2b8 <wait_lock>
    80001460:	8526                	mv	a0,s1
    80001462:	00005097          	auipc	ra,0x5
    80001466:	f4a080e7          	jalr	-182(ra) # 800063ac <acquire>
  np->parent = p;
    8000146a:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000146e:	8526                	mv	a0,s1
    80001470:	00005097          	auipc	ra,0x5
    80001474:	ff0080e7          	jalr	-16(ra) # 80006460 <release>
  acquire(&np->lock);
    80001478:	8552                	mv	a0,s4
    8000147a:	00005097          	auipc	ra,0x5
    8000147e:	f32080e7          	jalr	-206(ra) # 800063ac <acquire>
  np->state = RUNNABLE;
    80001482:	478d                	li	a5,3
    80001484:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001488:	8552                	mv	a0,s4
    8000148a:	00005097          	auipc	ra,0x5
    8000148e:	fd6080e7          	jalr	-42(ra) # 80006460 <release>
  return pid;
    80001492:	74a2                	ld	s1,40(sp)
    80001494:	69e2                	ld	s3,24(sp)
    80001496:	6a42                	ld	s4,16(sp)
}
    80001498:	854a                	mv	a0,s2
    8000149a:	70e2                	ld	ra,56(sp)
    8000149c:	7442                	ld	s0,48(sp)
    8000149e:	7902                	ld	s2,32(sp)
    800014a0:	6aa2                	ld	s5,8(sp)
    800014a2:	6121                	addi	sp,sp,64
    800014a4:	8082                	ret
    return -1;
    800014a6:	597d                	li	s2,-1
    800014a8:	bfc5                	j	80001498 <fork+0x130>

00000000800014aa <scheduler>:
{
    800014aa:	7139                	addi	sp,sp,-64
    800014ac:	fc06                	sd	ra,56(sp)
    800014ae:	f822                	sd	s0,48(sp)
    800014b0:	f426                	sd	s1,40(sp)
    800014b2:	f04a                	sd	s2,32(sp)
    800014b4:	ec4e                	sd	s3,24(sp)
    800014b6:	e852                	sd	s4,16(sp)
    800014b8:	e456                	sd	s5,8(sp)
    800014ba:	e05a                	sd	s6,0(sp)
    800014bc:	0080                	addi	s0,sp,64
    800014be:	8792                	mv	a5,tp
  int id = r_tp();
    800014c0:	2781                	sext.w	a5,a5
  c->proc = 0;
    800014c2:	00779a93          	slli	s5,a5,0x7
    800014c6:	0000a717          	auipc	a4,0xa
    800014ca:	dda70713          	addi	a4,a4,-550 # 8000b2a0 <pid_lock>
    800014ce:	9756                	add	a4,a4,s5
    800014d0:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800014d4:	0000a717          	auipc	a4,0xa
    800014d8:	e0470713          	addi	a4,a4,-508 # 8000b2d8 <cpus+0x8>
    800014dc:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800014de:	498d                	li	s3,3
        p->state = RUNNING;
    800014e0:	4b11                	li	s6,4
        c->proc = p;
    800014e2:	079e                	slli	a5,a5,0x7
    800014e4:	0000aa17          	auipc	s4,0xa
    800014e8:	dbca0a13          	addi	s4,s4,-580 # 8000b2a0 <pid_lock>
    800014ec:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800014ee:	00010917          	auipc	s2,0x10
    800014f2:	de290913          	addi	s2,s2,-542 # 800112d0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014f6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800014fa:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800014fe:	10079073          	csrw	sstatus,a5
    80001502:	0000a497          	auipc	s1,0xa
    80001506:	1ce48493          	addi	s1,s1,462 # 8000b6d0 <proc>
    8000150a:	a811                	j	8000151e <scheduler+0x74>
      release(&p->lock);
    8000150c:	8526                	mv	a0,s1
    8000150e:	00005097          	auipc	ra,0x5
    80001512:	f52080e7          	jalr	-174(ra) # 80006460 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001516:	17048493          	addi	s1,s1,368
    8000151a:	fd248ee3          	beq	s1,s2,800014f6 <scheduler+0x4c>
      acquire(&p->lock);
    8000151e:	8526                	mv	a0,s1
    80001520:	00005097          	auipc	ra,0x5
    80001524:	e8c080e7          	jalr	-372(ra) # 800063ac <acquire>
      if(p->state == RUNNABLE) {
    80001528:	4c9c                	lw	a5,24(s1)
    8000152a:	ff3791e3          	bne	a5,s3,8000150c <scheduler+0x62>
        p->state = RUNNING;
    8000152e:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001532:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001536:	06848593          	addi	a1,s1,104
    8000153a:	8556                	mv	a0,s5
    8000153c:	00000097          	auipc	ra,0x0
    80001540:	684080e7          	jalr	1668(ra) # 80001bc0 <swtch>
        c->proc = 0;
    80001544:	020a3823          	sd	zero,48(s4)
    80001548:	b7d1                	j	8000150c <scheduler+0x62>

000000008000154a <sched>:
{
    8000154a:	7179                	addi	sp,sp,-48
    8000154c:	f406                	sd	ra,40(sp)
    8000154e:	f022                	sd	s0,32(sp)
    80001550:	ec26                	sd	s1,24(sp)
    80001552:	e84a                	sd	s2,16(sp)
    80001554:	e44e                	sd	s3,8(sp)
    80001556:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001558:	00000097          	auipc	ra,0x0
    8000155c:	9aa080e7          	jalr	-1622(ra) # 80000f02 <myproc>
    80001560:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001562:	00005097          	auipc	ra,0x5
    80001566:	dd0080e7          	jalr	-560(ra) # 80006332 <holding>
    8000156a:	c93d                	beqz	a0,800015e0 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000156c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000156e:	2781                	sext.w	a5,a5
    80001570:	079e                	slli	a5,a5,0x7
    80001572:	0000a717          	auipc	a4,0xa
    80001576:	d2e70713          	addi	a4,a4,-722 # 8000b2a0 <pid_lock>
    8000157a:	97ba                	add	a5,a5,a4
    8000157c:	0a87a703          	lw	a4,168(a5)
    80001580:	4785                	li	a5,1
    80001582:	06f71763          	bne	a4,a5,800015f0 <sched+0xa6>
  if(p->state == RUNNING)
    80001586:	4c98                	lw	a4,24(s1)
    80001588:	4791                	li	a5,4
    8000158a:	06f70b63          	beq	a4,a5,80001600 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000158e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001592:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001594:	efb5                	bnez	a5,80001610 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001596:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001598:	0000a917          	auipc	s2,0xa
    8000159c:	d0890913          	addi	s2,s2,-760 # 8000b2a0 <pid_lock>
    800015a0:	2781                	sext.w	a5,a5
    800015a2:	079e                	slli	a5,a5,0x7
    800015a4:	97ca                	add	a5,a5,s2
    800015a6:	0ac7a983          	lw	s3,172(a5)
    800015aa:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800015ac:	2781                	sext.w	a5,a5
    800015ae:	079e                	slli	a5,a5,0x7
    800015b0:	0000a597          	auipc	a1,0xa
    800015b4:	d2858593          	addi	a1,a1,-728 # 8000b2d8 <cpus+0x8>
    800015b8:	95be                	add	a1,a1,a5
    800015ba:	06848513          	addi	a0,s1,104
    800015be:	00000097          	auipc	ra,0x0
    800015c2:	602080e7          	jalr	1538(ra) # 80001bc0 <swtch>
    800015c6:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800015c8:	2781                	sext.w	a5,a5
    800015ca:	079e                	slli	a5,a5,0x7
    800015cc:	993e                	add	s2,s2,a5
    800015ce:	0b392623          	sw	s3,172(s2)
}
    800015d2:	70a2                	ld	ra,40(sp)
    800015d4:	7402                	ld	s0,32(sp)
    800015d6:	64e2                	ld	s1,24(sp)
    800015d8:	6942                	ld	s2,16(sp)
    800015da:	69a2                	ld	s3,8(sp)
    800015dc:	6145                	addi	sp,sp,48
    800015de:	8082                	ret
    panic("sched p->lock");
    800015e0:	00007517          	auipc	a0,0x7
    800015e4:	bf850513          	addi	a0,a0,-1032 # 800081d8 <etext+0x1d8>
    800015e8:	00005097          	auipc	ra,0x5
    800015ec:	84a080e7          	jalr	-1974(ra) # 80005e32 <panic>
    panic("sched locks");
    800015f0:	00007517          	auipc	a0,0x7
    800015f4:	bf850513          	addi	a0,a0,-1032 # 800081e8 <etext+0x1e8>
    800015f8:	00005097          	auipc	ra,0x5
    800015fc:	83a080e7          	jalr	-1990(ra) # 80005e32 <panic>
    panic("sched running");
    80001600:	00007517          	auipc	a0,0x7
    80001604:	bf850513          	addi	a0,a0,-1032 # 800081f8 <etext+0x1f8>
    80001608:	00005097          	auipc	ra,0x5
    8000160c:	82a080e7          	jalr	-2006(ra) # 80005e32 <panic>
    panic("sched interruptible");
    80001610:	00007517          	auipc	a0,0x7
    80001614:	bf850513          	addi	a0,a0,-1032 # 80008208 <etext+0x208>
    80001618:	00005097          	auipc	ra,0x5
    8000161c:	81a080e7          	jalr	-2022(ra) # 80005e32 <panic>

0000000080001620 <yield>:
{
    80001620:	1101                	addi	sp,sp,-32
    80001622:	ec06                	sd	ra,24(sp)
    80001624:	e822                	sd	s0,16(sp)
    80001626:	e426                	sd	s1,8(sp)
    80001628:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000162a:	00000097          	auipc	ra,0x0
    8000162e:	8d8080e7          	jalr	-1832(ra) # 80000f02 <myproc>
    80001632:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001634:	00005097          	auipc	ra,0x5
    80001638:	d78080e7          	jalr	-648(ra) # 800063ac <acquire>
  p->state = RUNNABLE;
    8000163c:	478d                	li	a5,3
    8000163e:	cc9c                	sw	a5,24(s1)
  sched();
    80001640:	00000097          	auipc	ra,0x0
    80001644:	f0a080e7          	jalr	-246(ra) # 8000154a <sched>
  release(&p->lock);
    80001648:	8526                	mv	a0,s1
    8000164a:	00005097          	auipc	ra,0x5
    8000164e:	e16080e7          	jalr	-490(ra) # 80006460 <release>
}
    80001652:	60e2                	ld	ra,24(sp)
    80001654:	6442                	ld	s0,16(sp)
    80001656:	64a2                	ld	s1,8(sp)
    80001658:	6105                	addi	sp,sp,32
    8000165a:	8082                	ret

000000008000165c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000165c:	7179                	addi	sp,sp,-48
    8000165e:	f406                	sd	ra,40(sp)
    80001660:	f022                	sd	s0,32(sp)
    80001662:	ec26                	sd	s1,24(sp)
    80001664:	e84a                	sd	s2,16(sp)
    80001666:	e44e                	sd	s3,8(sp)
    80001668:	1800                	addi	s0,sp,48
    8000166a:	89aa                	mv	s3,a0
    8000166c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000166e:	00000097          	auipc	ra,0x0
    80001672:	894080e7          	jalr	-1900(ra) # 80000f02 <myproc>
    80001676:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001678:	00005097          	auipc	ra,0x5
    8000167c:	d34080e7          	jalr	-716(ra) # 800063ac <acquire>
  release(lk);
    80001680:	854a                	mv	a0,s2
    80001682:	00005097          	auipc	ra,0x5
    80001686:	dde080e7          	jalr	-546(ra) # 80006460 <release>

  // Go to sleep.
  p->chan = chan;
    8000168a:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000168e:	4789                	li	a5,2
    80001690:	cc9c                	sw	a5,24(s1)

  sched();
    80001692:	00000097          	auipc	ra,0x0
    80001696:	eb8080e7          	jalr	-328(ra) # 8000154a <sched>

  // Tidy up.
  p->chan = 0;
    8000169a:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000169e:	8526                	mv	a0,s1
    800016a0:	00005097          	auipc	ra,0x5
    800016a4:	dc0080e7          	jalr	-576(ra) # 80006460 <release>
  acquire(lk);
    800016a8:	854a                	mv	a0,s2
    800016aa:	00005097          	auipc	ra,0x5
    800016ae:	d02080e7          	jalr	-766(ra) # 800063ac <acquire>
}
    800016b2:	70a2                	ld	ra,40(sp)
    800016b4:	7402                	ld	s0,32(sp)
    800016b6:	64e2                	ld	s1,24(sp)
    800016b8:	6942                	ld	s2,16(sp)
    800016ba:	69a2                	ld	s3,8(sp)
    800016bc:	6145                	addi	sp,sp,48
    800016be:	8082                	ret

00000000800016c0 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016c0:	7139                	addi	sp,sp,-64
    800016c2:	fc06                	sd	ra,56(sp)
    800016c4:	f822                	sd	s0,48(sp)
    800016c6:	f426                	sd	s1,40(sp)
    800016c8:	f04a                	sd	s2,32(sp)
    800016ca:	ec4e                	sd	s3,24(sp)
    800016cc:	e852                	sd	s4,16(sp)
    800016ce:	e456                	sd	s5,8(sp)
    800016d0:	0080                	addi	s0,sp,64
    800016d2:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016d4:	0000a497          	auipc	s1,0xa
    800016d8:	ffc48493          	addi	s1,s1,-4 # 8000b6d0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016dc:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016de:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800016e0:	00010917          	auipc	s2,0x10
    800016e4:	bf090913          	addi	s2,s2,-1040 # 800112d0 <tickslock>
    800016e8:	a811                	j	800016fc <wakeup+0x3c>
      }
      release(&p->lock);
    800016ea:	8526                	mv	a0,s1
    800016ec:	00005097          	auipc	ra,0x5
    800016f0:	d74080e7          	jalr	-652(ra) # 80006460 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800016f4:	17048493          	addi	s1,s1,368
    800016f8:	03248663          	beq	s1,s2,80001724 <wakeup+0x64>
    if(p != myproc()){
    800016fc:	00000097          	auipc	ra,0x0
    80001700:	806080e7          	jalr	-2042(ra) # 80000f02 <myproc>
    80001704:	fea488e3          	beq	s1,a0,800016f4 <wakeup+0x34>
      acquire(&p->lock);
    80001708:	8526                	mv	a0,s1
    8000170a:	00005097          	auipc	ra,0x5
    8000170e:	ca2080e7          	jalr	-862(ra) # 800063ac <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001712:	4c9c                	lw	a5,24(s1)
    80001714:	fd379be3          	bne	a5,s3,800016ea <wakeup+0x2a>
    80001718:	709c                	ld	a5,32(s1)
    8000171a:	fd4798e3          	bne	a5,s4,800016ea <wakeup+0x2a>
        p->state = RUNNABLE;
    8000171e:	0154ac23          	sw	s5,24(s1)
    80001722:	b7e1                	j	800016ea <wakeup+0x2a>
    }
  }
}
    80001724:	70e2                	ld	ra,56(sp)
    80001726:	7442                	ld	s0,48(sp)
    80001728:	74a2                	ld	s1,40(sp)
    8000172a:	7902                	ld	s2,32(sp)
    8000172c:	69e2                	ld	s3,24(sp)
    8000172e:	6a42                	ld	s4,16(sp)
    80001730:	6aa2                	ld	s5,8(sp)
    80001732:	6121                	addi	sp,sp,64
    80001734:	8082                	ret

0000000080001736 <reparent>:
{
    80001736:	7179                	addi	sp,sp,-48
    80001738:	f406                	sd	ra,40(sp)
    8000173a:	f022                	sd	s0,32(sp)
    8000173c:	ec26                	sd	s1,24(sp)
    8000173e:	e84a                	sd	s2,16(sp)
    80001740:	e44e                	sd	s3,8(sp)
    80001742:	e052                	sd	s4,0(sp)
    80001744:	1800                	addi	s0,sp,48
    80001746:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001748:	0000a497          	auipc	s1,0xa
    8000174c:	f8848493          	addi	s1,s1,-120 # 8000b6d0 <proc>
      pp->parent = initproc;
    80001750:	0000aa17          	auipc	s4,0xa
    80001754:	b10a0a13          	addi	s4,s4,-1264 # 8000b260 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001758:	00010997          	auipc	s3,0x10
    8000175c:	b7898993          	addi	s3,s3,-1160 # 800112d0 <tickslock>
    80001760:	a029                	j	8000176a <reparent+0x34>
    80001762:	17048493          	addi	s1,s1,368
    80001766:	01348d63          	beq	s1,s3,80001780 <reparent+0x4a>
    if(pp->parent == p){
    8000176a:	7c9c                	ld	a5,56(s1)
    8000176c:	ff279be3          	bne	a5,s2,80001762 <reparent+0x2c>
      pp->parent = initproc;
    80001770:	000a3503          	ld	a0,0(s4)
    80001774:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001776:	00000097          	auipc	ra,0x0
    8000177a:	f4a080e7          	jalr	-182(ra) # 800016c0 <wakeup>
    8000177e:	b7d5                	j	80001762 <reparent+0x2c>
}
    80001780:	70a2                	ld	ra,40(sp)
    80001782:	7402                	ld	s0,32(sp)
    80001784:	64e2                	ld	s1,24(sp)
    80001786:	6942                	ld	s2,16(sp)
    80001788:	69a2                	ld	s3,8(sp)
    8000178a:	6a02                	ld	s4,0(sp)
    8000178c:	6145                	addi	sp,sp,48
    8000178e:	8082                	ret

0000000080001790 <exit>:
{
    80001790:	7179                	addi	sp,sp,-48
    80001792:	f406                	sd	ra,40(sp)
    80001794:	f022                	sd	s0,32(sp)
    80001796:	ec26                	sd	s1,24(sp)
    80001798:	e84a                	sd	s2,16(sp)
    8000179a:	e44e                	sd	s3,8(sp)
    8000179c:	e052                	sd	s4,0(sp)
    8000179e:	1800                	addi	s0,sp,48
    800017a0:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017a2:	fffff097          	auipc	ra,0xfffff
    800017a6:	760080e7          	jalr	1888(ra) # 80000f02 <myproc>
    800017aa:	89aa                	mv	s3,a0
  if(p == initproc)
    800017ac:	0000a797          	auipc	a5,0xa
    800017b0:	ab47b783          	ld	a5,-1356(a5) # 8000b260 <initproc>
    800017b4:	0d850493          	addi	s1,a0,216
    800017b8:	15850913          	addi	s2,a0,344
    800017bc:	02a79363          	bne	a5,a0,800017e2 <exit+0x52>
    panic("init exiting");
    800017c0:	00007517          	auipc	a0,0x7
    800017c4:	a6050513          	addi	a0,a0,-1440 # 80008220 <etext+0x220>
    800017c8:	00004097          	auipc	ra,0x4
    800017cc:	66a080e7          	jalr	1642(ra) # 80005e32 <panic>
      fileclose(f);
    800017d0:	00002097          	auipc	ra,0x2
    800017d4:	332080e7          	jalr	818(ra) # 80003b02 <fileclose>
      p->ofile[fd] = 0;
    800017d8:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017dc:	04a1                	addi	s1,s1,8
    800017de:	01248563          	beq	s1,s2,800017e8 <exit+0x58>
    if(p->ofile[fd]){
    800017e2:	6088                	ld	a0,0(s1)
    800017e4:	f575                	bnez	a0,800017d0 <exit+0x40>
    800017e6:	bfdd                	j	800017dc <exit+0x4c>
  begin_op();
    800017e8:	00002097          	auipc	ra,0x2
    800017ec:	e50080e7          	jalr	-432(ra) # 80003638 <begin_op>
  iput(p->cwd);
    800017f0:	1589b503          	ld	a0,344(s3)
    800017f4:	00001097          	auipc	ra,0x1
    800017f8:	634080e7          	jalr	1588(ra) # 80002e28 <iput>
  end_op();
    800017fc:	00002097          	auipc	ra,0x2
    80001800:	eb6080e7          	jalr	-330(ra) # 800036b2 <end_op>
  p->cwd = 0;
    80001804:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    80001808:	0000a497          	auipc	s1,0xa
    8000180c:	ab048493          	addi	s1,s1,-1360 # 8000b2b8 <wait_lock>
    80001810:	8526                	mv	a0,s1
    80001812:	00005097          	auipc	ra,0x5
    80001816:	b9a080e7          	jalr	-1126(ra) # 800063ac <acquire>
  reparent(p);
    8000181a:	854e                	mv	a0,s3
    8000181c:	00000097          	auipc	ra,0x0
    80001820:	f1a080e7          	jalr	-230(ra) # 80001736 <reparent>
  wakeup(p->parent);
    80001824:	0389b503          	ld	a0,56(s3)
    80001828:	00000097          	auipc	ra,0x0
    8000182c:	e98080e7          	jalr	-360(ra) # 800016c0 <wakeup>
  acquire(&p->lock);
    80001830:	854e                	mv	a0,s3
    80001832:	00005097          	auipc	ra,0x5
    80001836:	b7a080e7          	jalr	-1158(ra) # 800063ac <acquire>
  p->xstate = status;
    8000183a:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000183e:	4795                	li	a5,5
    80001840:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001844:	8526                	mv	a0,s1
    80001846:	00005097          	auipc	ra,0x5
    8000184a:	c1a080e7          	jalr	-998(ra) # 80006460 <release>
  sched();
    8000184e:	00000097          	auipc	ra,0x0
    80001852:	cfc080e7          	jalr	-772(ra) # 8000154a <sched>
  panic("zombie exit");
    80001856:	00007517          	auipc	a0,0x7
    8000185a:	9da50513          	addi	a0,a0,-1574 # 80008230 <etext+0x230>
    8000185e:	00004097          	auipc	ra,0x4
    80001862:	5d4080e7          	jalr	1492(ra) # 80005e32 <panic>

0000000080001866 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001866:	7179                	addi	sp,sp,-48
    80001868:	f406                	sd	ra,40(sp)
    8000186a:	f022                	sd	s0,32(sp)
    8000186c:	ec26                	sd	s1,24(sp)
    8000186e:	e84a                	sd	s2,16(sp)
    80001870:	e44e                	sd	s3,8(sp)
    80001872:	1800                	addi	s0,sp,48
    80001874:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001876:	0000a497          	auipc	s1,0xa
    8000187a:	e5a48493          	addi	s1,s1,-422 # 8000b6d0 <proc>
    8000187e:	00010997          	auipc	s3,0x10
    80001882:	a5298993          	addi	s3,s3,-1454 # 800112d0 <tickslock>
    acquire(&p->lock);
    80001886:	8526                	mv	a0,s1
    80001888:	00005097          	auipc	ra,0x5
    8000188c:	b24080e7          	jalr	-1244(ra) # 800063ac <acquire>
    if(p->pid == pid){
    80001890:	589c                	lw	a5,48(s1)
    80001892:	01278d63          	beq	a5,s2,800018ac <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001896:	8526                	mv	a0,s1
    80001898:	00005097          	auipc	ra,0x5
    8000189c:	bc8080e7          	jalr	-1080(ra) # 80006460 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018a0:	17048493          	addi	s1,s1,368
    800018a4:	ff3491e3          	bne	s1,s3,80001886 <kill+0x20>
  }
  return -1;
    800018a8:	557d                	li	a0,-1
    800018aa:	a829                	j	800018c4 <kill+0x5e>
      p->killed = 1;
    800018ac:	4785                	li	a5,1
    800018ae:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800018b0:	4c98                	lw	a4,24(s1)
    800018b2:	4789                	li	a5,2
    800018b4:	00f70f63          	beq	a4,a5,800018d2 <kill+0x6c>
      release(&p->lock);
    800018b8:	8526                	mv	a0,s1
    800018ba:	00005097          	auipc	ra,0x5
    800018be:	ba6080e7          	jalr	-1114(ra) # 80006460 <release>
      return 0;
    800018c2:	4501                	li	a0,0
}
    800018c4:	70a2                	ld	ra,40(sp)
    800018c6:	7402                	ld	s0,32(sp)
    800018c8:	64e2                	ld	s1,24(sp)
    800018ca:	6942                	ld	s2,16(sp)
    800018cc:	69a2                	ld	s3,8(sp)
    800018ce:	6145                	addi	sp,sp,48
    800018d0:	8082                	ret
        p->state = RUNNABLE;
    800018d2:	478d                	li	a5,3
    800018d4:	cc9c                	sw	a5,24(s1)
    800018d6:	b7cd                	j	800018b8 <kill+0x52>

00000000800018d8 <setkilled>:

void
setkilled(struct proc *p)
{
    800018d8:	1101                	addi	sp,sp,-32
    800018da:	ec06                	sd	ra,24(sp)
    800018dc:	e822                	sd	s0,16(sp)
    800018de:	e426                	sd	s1,8(sp)
    800018e0:	1000                	addi	s0,sp,32
    800018e2:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800018e4:	00005097          	auipc	ra,0x5
    800018e8:	ac8080e7          	jalr	-1336(ra) # 800063ac <acquire>
  p->killed = 1;
    800018ec:	4785                	li	a5,1
    800018ee:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800018f0:	8526                	mv	a0,s1
    800018f2:	00005097          	auipc	ra,0x5
    800018f6:	b6e080e7          	jalr	-1170(ra) # 80006460 <release>
}
    800018fa:	60e2                	ld	ra,24(sp)
    800018fc:	6442                	ld	s0,16(sp)
    800018fe:	64a2                	ld	s1,8(sp)
    80001900:	6105                	addi	sp,sp,32
    80001902:	8082                	ret

0000000080001904 <killed>:

int
killed(struct proc *p)
{
    80001904:	1101                	addi	sp,sp,-32
    80001906:	ec06                	sd	ra,24(sp)
    80001908:	e822                	sd	s0,16(sp)
    8000190a:	e426                	sd	s1,8(sp)
    8000190c:	e04a                	sd	s2,0(sp)
    8000190e:	1000                	addi	s0,sp,32
    80001910:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001912:	00005097          	auipc	ra,0x5
    80001916:	a9a080e7          	jalr	-1382(ra) # 800063ac <acquire>
  k = p->killed;
    8000191a:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000191e:	8526                	mv	a0,s1
    80001920:	00005097          	auipc	ra,0x5
    80001924:	b40080e7          	jalr	-1216(ra) # 80006460 <release>
  return k;
}
    80001928:	854a                	mv	a0,s2
    8000192a:	60e2                	ld	ra,24(sp)
    8000192c:	6442                	ld	s0,16(sp)
    8000192e:	64a2                	ld	s1,8(sp)
    80001930:	6902                	ld	s2,0(sp)
    80001932:	6105                	addi	sp,sp,32
    80001934:	8082                	ret

0000000080001936 <wait>:
{
    80001936:	715d                	addi	sp,sp,-80
    80001938:	e486                	sd	ra,72(sp)
    8000193a:	e0a2                	sd	s0,64(sp)
    8000193c:	fc26                	sd	s1,56(sp)
    8000193e:	f84a                	sd	s2,48(sp)
    80001940:	f44e                	sd	s3,40(sp)
    80001942:	f052                	sd	s4,32(sp)
    80001944:	ec56                	sd	s5,24(sp)
    80001946:	e85a                	sd	s6,16(sp)
    80001948:	e45e                	sd	s7,8(sp)
    8000194a:	e062                	sd	s8,0(sp)
    8000194c:	0880                	addi	s0,sp,80
    8000194e:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001950:	fffff097          	auipc	ra,0xfffff
    80001954:	5b2080e7          	jalr	1458(ra) # 80000f02 <myproc>
    80001958:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000195a:	0000a517          	auipc	a0,0xa
    8000195e:	95e50513          	addi	a0,a0,-1698 # 8000b2b8 <wait_lock>
    80001962:	00005097          	auipc	ra,0x5
    80001966:	a4a080e7          	jalr	-1462(ra) # 800063ac <acquire>
    havekids = 0;
    8000196a:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    8000196c:	4a15                	li	s4,5
        havekids = 1;
    8000196e:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001970:	00010997          	auipc	s3,0x10
    80001974:	96098993          	addi	s3,s3,-1696 # 800112d0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001978:	0000ac17          	auipc	s8,0xa
    8000197c:	940c0c13          	addi	s8,s8,-1728 # 8000b2b8 <wait_lock>
    80001980:	a0d1                	j	80001a44 <wait+0x10e>
          pid = pp->pid;
    80001982:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001986:	000b0e63          	beqz	s6,800019a2 <wait+0x6c>
    8000198a:	4691                	li	a3,4
    8000198c:	02c48613          	addi	a2,s1,44
    80001990:	85da                	mv	a1,s6
    80001992:	05093503          	ld	a0,80(s2)
    80001996:	fffff097          	auipc	ra,0xfffff
    8000199a:	1b6080e7          	jalr	438(ra) # 80000b4c <copyout>
    8000199e:	04054163          	bltz	a0,800019e0 <wait+0xaa>
          freeproc(pp);
    800019a2:	8526                	mv	a0,s1
    800019a4:	fffff097          	auipc	ra,0xfffff
    800019a8:	784080e7          	jalr	1924(ra) # 80001128 <freeproc>
          release(&pp->lock);
    800019ac:	8526                	mv	a0,s1
    800019ae:	00005097          	auipc	ra,0x5
    800019b2:	ab2080e7          	jalr	-1358(ra) # 80006460 <release>
          release(&wait_lock);
    800019b6:	0000a517          	auipc	a0,0xa
    800019ba:	90250513          	addi	a0,a0,-1790 # 8000b2b8 <wait_lock>
    800019be:	00005097          	auipc	ra,0x5
    800019c2:	aa2080e7          	jalr	-1374(ra) # 80006460 <release>
}
    800019c6:	854e                	mv	a0,s3
    800019c8:	60a6                	ld	ra,72(sp)
    800019ca:	6406                	ld	s0,64(sp)
    800019cc:	74e2                	ld	s1,56(sp)
    800019ce:	7942                	ld	s2,48(sp)
    800019d0:	79a2                	ld	s3,40(sp)
    800019d2:	7a02                	ld	s4,32(sp)
    800019d4:	6ae2                	ld	s5,24(sp)
    800019d6:	6b42                	ld	s6,16(sp)
    800019d8:	6ba2                	ld	s7,8(sp)
    800019da:	6c02                	ld	s8,0(sp)
    800019dc:	6161                	addi	sp,sp,80
    800019de:	8082                	ret
            release(&pp->lock);
    800019e0:	8526                	mv	a0,s1
    800019e2:	00005097          	auipc	ra,0x5
    800019e6:	a7e080e7          	jalr	-1410(ra) # 80006460 <release>
            release(&wait_lock);
    800019ea:	0000a517          	auipc	a0,0xa
    800019ee:	8ce50513          	addi	a0,a0,-1842 # 8000b2b8 <wait_lock>
    800019f2:	00005097          	auipc	ra,0x5
    800019f6:	a6e080e7          	jalr	-1426(ra) # 80006460 <release>
            return -1;
    800019fa:	59fd                	li	s3,-1
    800019fc:	b7e9                	j	800019c6 <wait+0x90>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800019fe:	17048493          	addi	s1,s1,368
    80001a02:	03348463          	beq	s1,s3,80001a2a <wait+0xf4>
      if(pp->parent == p){
    80001a06:	7c9c                	ld	a5,56(s1)
    80001a08:	ff279be3          	bne	a5,s2,800019fe <wait+0xc8>
        acquire(&pp->lock);
    80001a0c:	8526                	mv	a0,s1
    80001a0e:	00005097          	auipc	ra,0x5
    80001a12:	99e080e7          	jalr	-1634(ra) # 800063ac <acquire>
        if(pp->state == ZOMBIE){
    80001a16:	4c9c                	lw	a5,24(s1)
    80001a18:	f74785e3          	beq	a5,s4,80001982 <wait+0x4c>
        release(&pp->lock);
    80001a1c:	8526                	mv	a0,s1
    80001a1e:	00005097          	auipc	ra,0x5
    80001a22:	a42080e7          	jalr	-1470(ra) # 80006460 <release>
        havekids = 1;
    80001a26:	8756                	mv	a4,s5
    80001a28:	bfd9                	j	800019fe <wait+0xc8>
    if(!havekids || killed(p)){
    80001a2a:	c31d                	beqz	a4,80001a50 <wait+0x11a>
    80001a2c:	854a                	mv	a0,s2
    80001a2e:	00000097          	auipc	ra,0x0
    80001a32:	ed6080e7          	jalr	-298(ra) # 80001904 <killed>
    80001a36:	ed09                	bnez	a0,80001a50 <wait+0x11a>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001a38:	85e2                	mv	a1,s8
    80001a3a:	854a                	mv	a0,s2
    80001a3c:	00000097          	auipc	ra,0x0
    80001a40:	c20080e7          	jalr	-992(ra) # 8000165c <sleep>
    havekids = 0;
    80001a44:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001a46:	0000a497          	auipc	s1,0xa
    80001a4a:	c8a48493          	addi	s1,s1,-886 # 8000b6d0 <proc>
    80001a4e:	bf65                	j	80001a06 <wait+0xd0>
      release(&wait_lock);
    80001a50:	0000a517          	auipc	a0,0xa
    80001a54:	86850513          	addi	a0,a0,-1944 # 8000b2b8 <wait_lock>
    80001a58:	00005097          	auipc	ra,0x5
    80001a5c:	a08080e7          	jalr	-1528(ra) # 80006460 <release>
      return -1;
    80001a60:	59fd                	li	s3,-1
    80001a62:	b795                	j	800019c6 <wait+0x90>

0000000080001a64 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a64:	7179                	addi	sp,sp,-48
    80001a66:	f406                	sd	ra,40(sp)
    80001a68:	f022                	sd	s0,32(sp)
    80001a6a:	ec26                	sd	s1,24(sp)
    80001a6c:	e84a                	sd	s2,16(sp)
    80001a6e:	e44e                	sd	s3,8(sp)
    80001a70:	e052                	sd	s4,0(sp)
    80001a72:	1800                	addi	s0,sp,48
    80001a74:	84aa                	mv	s1,a0
    80001a76:	892e                	mv	s2,a1
    80001a78:	89b2                	mv	s3,a2
    80001a7a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a7c:	fffff097          	auipc	ra,0xfffff
    80001a80:	486080e7          	jalr	1158(ra) # 80000f02 <myproc>
  if(user_dst){
    80001a84:	c08d                	beqz	s1,80001aa6 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a86:	86d2                	mv	a3,s4
    80001a88:	864e                	mv	a2,s3
    80001a8a:	85ca                	mv	a1,s2
    80001a8c:	6928                	ld	a0,80(a0)
    80001a8e:	fffff097          	auipc	ra,0xfffff
    80001a92:	0be080e7          	jalr	190(ra) # 80000b4c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001a96:	70a2                	ld	ra,40(sp)
    80001a98:	7402                	ld	s0,32(sp)
    80001a9a:	64e2                	ld	s1,24(sp)
    80001a9c:	6942                	ld	s2,16(sp)
    80001a9e:	69a2                	ld	s3,8(sp)
    80001aa0:	6a02                	ld	s4,0(sp)
    80001aa2:	6145                	addi	sp,sp,48
    80001aa4:	8082                	ret
    memmove((char *)dst, src, len);
    80001aa6:	000a061b          	sext.w	a2,s4
    80001aaa:	85ce                	mv	a1,s3
    80001aac:	854a                	mv	a0,s2
    80001aae:	ffffe097          	auipc	ra,0xffffe
    80001ab2:	728080e7          	jalr	1832(ra) # 800001d6 <memmove>
    return 0;
    80001ab6:	8526                	mv	a0,s1
    80001ab8:	bff9                	j	80001a96 <either_copyout+0x32>

0000000080001aba <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001aba:	7179                	addi	sp,sp,-48
    80001abc:	f406                	sd	ra,40(sp)
    80001abe:	f022                	sd	s0,32(sp)
    80001ac0:	ec26                	sd	s1,24(sp)
    80001ac2:	e84a                	sd	s2,16(sp)
    80001ac4:	e44e                	sd	s3,8(sp)
    80001ac6:	e052                	sd	s4,0(sp)
    80001ac8:	1800                	addi	s0,sp,48
    80001aca:	892a                	mv	s2,a0
    80001acc:	84ae                	mv	s1,a1
    80001ace:	89b2                	mv	s3,a2
    80001ad0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001ad2:	fffff097          	auipc	ra,0xfffff
    80001ad6:	430080e7          	jalr	1072(ra) # 80000f02 <myproc>
  if(user_src){
    80001ada:	c08d                	beqz	s1,80001afc <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001adc:	86d2                	mv	a3,s4
    80001ade:	864e                	mv	a2,s3
    80001ae0:	85ca                	mv	a1,s2
    80001ae2:	6928                	ld	a0,80(a0)
    80001ae4:	fffff097          	auipc	ra,0xfffff
    80001ae8:	146080e7          	jalr	326(ra) # 80000c2a <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001aec:	70a2                	ld	ra,40(sp)
    80001aee:	7402                	ld	s0,32(sp)
    80001af0:	64e2                	ld	s1,24(sp)
    80001af2:	6942                	ld	s2,16(sp)
    80001af4:	69a2                	ld	s3,8(sp)
    80001af6:	6a02                	ld	s4,0(sp)
    80001af8:	6145                	addi	sp,sp,48
    80001afa:	8082                	ret
    memmove(dst, (char*)src, len);
    80001afc:	000a061b          	sext.w	a2,s4
    80001b00:	85ce                	mv	a1,s3
    80001b02:	854a                	mv	a0,s2
    80001b04:	ffffe097          	auipc	ra,0xffffe
    80001b08:	6d2080e7          	jalr	1746(ra) # 800001d6 <memmove>
    return 0;
    80001b0c:	8526                	mv	a0,s1
    80001b0e:	bff9                	j	80001aec <either_copyin+0x32>

0000000080001b10 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001b10:	715d                	addi	sp,sp,-80
    80001b12:	e486                	sd	ra,72(sp)
    80001b14:	e0a2                	sd	s0,64(sp)
    80001b16:	fc26                	sd	s1,56(sp)
    80001b18:	f84a                	sd	s2,48(sp)
    80001b1a:	f44e                	sd	s3,40(sp)
    80001b1c:	f052                	sd	s4,32(sp)
    80001b1e:	ec56                	sd	s5,24(sp)
    80001b20:	e85a                	sd	s6,16(sp)
    80001b22:	e45e                	sd	s7,8(sp)
    80001b24:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b26:	00006517          	auipc	a0,0x6
    80001b2a:	4f250513          	addi	a0,a0,1266 # 80008018 <etext+0x18>
    80001b2e:	00004097          	auipc	ra,0x4
    80001b32:	34e080e7          	jalr	846(ra) # 80005e7c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b36:	0000a497          	auipc	s1,0xa
    80001b3a:	cfa48493          	addi	s1,s1,-774 # 8000b830 <proc+0x160>
    80001b3e:	00010917          	auipc	s2,0x10
    80001b42:	8f290913          	addi	s2,s2,-1806 # 80011430 <bcache+0x148>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b46:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001b48:	00006997          	auipc	s3,0x6
    80001b4c:	6f898993          	addi	s3,s3,1784 # 80008240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    80001b50:	00006a97          	auipc	s5,0x6
    80001b54:	6f8a8a93          	addi	s5,s5,1784 # 80008248 <etext+0x248>
    printf("\n");
    80001b58:	00006a17          	auipc	s4,0x6
    80001b5c:	4c0a0a13          	addi	s4,s4,1216 # 80008018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b60:	00007b97          	auipc	s7,0x7
    80001b64:	c10b8b93          	addi	s7,s7,-1008 # 80008770 <states.0>
    80001b68:	a00d                	j	80001b8a <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b6a:	ed06a583          	lw	a1,-304(a3)
    80001b6e:	8556                	mv	a0,s5
    80001b70:	00004097          	auipc	ra,0x4
    80001b74:	30c080e7          	jalr	780(ra) # 80005e7c <printf>
    printf("\n");
    80001b78:	8552                	mv	a0,s4
    80001b7a:	00004097          	auipc	ra,0x4
    80001b7e:	302080e7          	jalr	770(ra) # 80005e7c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b82:	17048493          	addi	s1,s1,368
    80001b86:	03248263          	beq	s1,s2,80001baa <procdump+0x9a>
    if(p->state == UNUSED)
    80001b8a:	86a6                	mv	a3,s1
    80001b8c:	eb84a783          	lw	a5,-328(s1)
    80001b90:	dbed                	beqz	a5,80001b82 <procdump+0x72>
      state = "???";
    80001b92:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b94:	fcfb6be3          	bltu	s6,a5,80001b6a <procdump+0x5a>
    80001b98:	02079713          	slli	a4,a5,0x20
    80001b9c:	01d75793          	srli	a5,a4,0x1d
    80001ba0:	97de                	add	a5,a5,s7
    80001ba2:	6390                	ld	a2,0(a5)
    80001ba4:	f279                	bnez	a2,80001b6a <procdump+0x5a>
      state = "???";
    80001ba6:	864e                	mv	a2,s3
    80001ba8:	b7c9                	j	80001b6a <procdump+0x5a>
  }
}
    80001baa:	60a6                	ld	ra,72(sp)
    80001bac:	6406                	ld	s0,64(sp)
    80001bae:	74e2                	ld	s1,56(sp)
    80001bb0:	7942                	ld	s2,48(sp)
    80001bb2:	79a2                	ld	s3,40(sp)
    80001bb4:	7a02                	ld	s4,32(sp)
    80001bb6:	6ae2                	ld	s5,24(sp)
    80001bb8:	6b42                	ld	s6,16(sp)
    80001bba:	6ba2                	ld	s7,8(sp)
    80001bbc:	6161                	addi	sp,sp,80
    80001bbe:	8082                	ret

0000000080001bc0 <swtch>:
    80001bc0:	00153023          	sd	ra,0(a0)
    80001bc4:	00253423          	sd	sp,8(a0)
    80001bc8:	e900                	sd	s0,16(a0)
    80001bca:	ed04                	sd	s1,24(a0)
    80001bcc:	03253023          	sd	s2,32(a0)
    80001bd0:	03353423          	sd	s3,40(a0)
    80001bd4:	03453823          	sd	s4,48(a0)
    80001bd8:	03553c23          	sd	s5,56(a0)
    80001bdc:	05653023          	sd	s6,64(a0)
    80001be0:	05753423          	sd	s7,72(a0)
    80001be4:	05853823          	sd	s8,80(a0)
    80001be8:	05953c23          	sd	s9,88(a0)
    80001bec:	07a53023          	sd	s10,96(a0)
    80001bf0:	07b53423          	sd	s11,104(a0)
    80001bf4:	0005b083          	ld	ra,0(a1)
    80001bf8:	0085b103          	ld	sp,8(a1)
    80001bfc:	6980                	ld	s0,16(a1)
    80001bfe:	6d84                	ld	s1,24(a1)
    80001c00:	0205b903          	ld	s2,32(a1)
    80001c04:	0285b983          	ld	s3,40(a1)
    80001c08:	0305ba03          	ld	s4,48(a1)
    80001c0c:	0385ba83          	ld	s5,56(a1)
    80001c10:	0405bb03          	ld	s6,64(a1)
    80001c14:	0485bb83          	ld	s7,72(a1)
    80001c18:	0505bc03          	ld	s8,80(a1)
    80001c1c:	0585bc83          	ld	s9,88(a1)
    80001c20:	0605bd03          	ld	s10,96(a1)
    80001c24:	0685bd83          	ld	s11,104(a1)
    80001c28:	8082                	ret

0000000080001c2a <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c2a:	1141                	addi	sp,sp,-16
    80001c2c:	e406                	sd	ra,8(sp)
    80001c2e:	e022                	sd	s0,0(sp)
    80001c30:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c32:	00006597          	auipc	a1,0x6
    80001c36:	65658593          	addi	a1,a1,1622 # 80008288 <etext+0x288>
    80001c3a:	0000f517          	auipc	a0,0xf
    80001c3e:	69650513          	addi	a0,a0,1686 # 800112d0 <tickslock>
    80001c42:	00004097          	auipc	ra,0x4
    80001c46:	6da080e7          	jalr	1754(ra) # 8000631c <initlock>
}
    80001c4a:	60a2                	ld	ra,8(sp)
    80001c4c:	6402                	ld	s0,0(sp)
    80001c4e:	0141                	addi	sp,sp,16
    80001c50:	8082                	ret

0000000080001c52 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001c52:	1141                	addi	sp,sp,-16
    80001c54:	e422                	sd	s0,8(sp)
    80001c56:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c58:	00003797          	auipc	a5,0x3
    80001c5c:	5a878793          	addi	a5,a5,1448 # 80005200 <kernelvec>
    80001c60:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001c64:	6422                	ld	s0,8(sp)
    80001c66:	0141                	addi	sp,sp,16
    80001c68:	8082                	ret

0000000080001c6a <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001c6a:	1141                	addi	sp,sp,-16
    80001c6c:	e406                	sd	ra,8(sp)
    80001c6e:	e022                	sd	s0,0(sp)
    80001c70:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001c72:	fffff097          	auipc	ra,0xfffff
    80001c76:	290080e7          	jalr	656(ra) # 80000f02 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c7a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001c7e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c80:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001c84:	00005697          	auipc	a3,0x5
    80001c88:	37c68693          	addi	a3,a3,892 # 80007000 <_trampoline>
    80001c8c:	00005717          	auipc	a4,0x5
    80001c90:	37470713          	addi	a4,a4,884 # 80007000 <_trampoline>
    80001c94:	8f15                	sub	a4,a4,a3
    80001c96:	040007b7          	lui	a5,0x4000
    80001c9a:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001c9c:	07b2                	slli	a5,a5,0xc
    80001c9e:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ca0:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001ca4:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001ca6:	18002673          	csrr	a2,satp
    80001caa:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001cac:	6d30                	ld	a2,88(a0)
    80001cae:	6138                	ld	a4,64(a0)
    80001cb0:	6585                	lui	a1,0x1
    80001cb2:	972e                	add	a4,a4,a1
    80001cb4:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001cb6:	6d38                	ld	a4,88(a0)
    80001cb8:	00000617          	auipc	a2,0x0
    80001cbc:	13860613          	addi	a2,a2,312 # 80001df0 <usertrap>
    80001cc0:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001cc2:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001cc4:	8612                	mv	a2,tp
    80001cc6:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cc8:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001ccc:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001cd0:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cd4:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001cd8:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001cda:	6f18                	ld	a4,24(a4)
    80001cdc:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001ce0:	6928                	ld	a0,80(a0)
    80001ce2:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001ce4:	00005717          	auipc	a4,0x5
    80001ce8:	3b870713          	addi	a4,a4,952 # 8000709c <userret>
    80001cec:	8f15                	sub	a4,a4,a3
    80001cee:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001cf0:	577d                	li	a4,-1
    80001cf2:	177e                	slli	a4,a4,0x3f
    80001cf4:	8d59                	or	a0,a0,a4
    80001cf6:	9782                	jalr	a5
}
    80001cf8:	60a2                	ld	ra,8(sp)
    80001cfa:	6402                	ld	s0,0(sp)
    80001cfc:	0141                	addi	sp,sp,16
    80001cfe:	8082                	ret

0000000080001d00 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001d00:	1101                	addi	sp,sp,-32
    80001d02:	ec06                	sd	ra,24(sp)
    80001d04:	e822                	sd	s0,16(sp)
    80001d06:	e426                	sd	s1,8(sp)
    80001d08:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001d0a:	0000f497          	auipc	s1,0xf
    80001d0e:	5c648493          	addi	s1,s1,1478 # 800112d0 <tickslock>
    80001d12:	8526                	mv	a0,s1
    80001d14:	00004097          	auipc	ra,0x4
    80001d18:	698080e7          	jalr	1688(ra) # 800063ac <acquire>
  ticks++;
    80001d1c:	00009517          	auipc	a0,0x9
    80001d20:	54c50513          	addi	a0,a0,1356 # 8000b268 <ticks>
    80001d24:	411c                	lw	a5,0(a0)
    80001d26:	2785                	addiw	a5,a5,1
    80001d28:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d2a:	00000097          	auipc	ra,0x0
    80001d2e:	996080e7          	jalr	-1642(ra) # 800016c0 <wakeup>
  release(&tickslock);
    80001d32:	8526                	mv	a0,s1
    80001d34:	00004097          	auipc	ra,0x4
    80001d38:	72c080e7          	jalr	1836(ra) # 80006460 <release>
}
    80001d3c:	60e2                	ld	ra,24(sp)
    80001d3e:	6442                	ld	s0,16(sp)
    80001d40:	64a2                	ld	s1,8(sp)
    80001d42:	6105                	addi	sp,sp,32
    80001d44:	8082                	ret

0000000080001d46 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d46:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001d4a:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001d4c:	0a07d163          	bgez	a5,80001dee <devintr+0xa8>
{
    80001d50:	1101                	addi	sp,sp,-32
    80001d52:	ec06                	sd	ra,24(sp)
    80001d54:	e822                	sd	s0,16(sp)
    80001d56:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001d58:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001d5c:	46a5                	li	a3,9
    80001d5e:	00d70c63          	beq	a4,a3,80001d76 <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80001d62:	577d                	li	a4,-1
    80001d64:	177e                	slli	a4,a4,0x3f
    80001d66:	0705                	addi	a4,a4,1
    return 0;
    80001d68:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001d6a:	06e78163          	beq	a5,a4,80001dcc <devintr+0x86>
  }
}
    80001d6e:	60e2                	ld	ra,24(sp)
    80001d70:	6442                	ld	s0,16(sp)
    80001d72:	6105                	addi	sp,sp,32
    80001d74:	8082                	ret
    80001d76:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001d78:	00003097          	auipc	ra,0x3
    80001d7c:	594080e7          	jalr	1428(ra) # 8000530c <plic_claim>
    80001d80:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001d82:	47a9                	li	a5,10
    80001d84:	00f50963          	beq	a0,a5,80001d96 <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80001d88:	4785                	li	a5,1
    80001d8a:	00f50b63          	beq	a0,a5,80001da0 <devintr+0x5a>
    return 1;
    80001d8e:	4505                	li	a0,1
    } else if(irq){
    80001d90:	ec89                	bnez	s1,80001daa <devintr+0x64>
    80001d92:	64a2                	ld	s1,8(sp)
    80001d94:	bfe9                	j	80001d6e <devintr+0x28>
      uartintr();
    80001d96:	00004097          	auipc	ra,0x4
    80001d9a:	536080e7          	jalr	1334(ra) # 800062cc <uartintr>
    if(irq)
    80001d9e:	a839                	j	80001dbc <devintr+0x76>
      virtio_disk_intr();
    80001da0:	00004097          	auipc	ra,0x4
    80001da4:	a96080e7          	jalr	-1386(ra) # 80005836 <virtio_disk_intr>
    if(irq)
    80001da8:	a811                	j	80001dbc <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001daa:	85a6                	mv	a1,s1
    80001dac:	00006517          	auipc	a0,0x6
    80001db0:	4e450513          	addi	a0,a0,1252 # 80008290 <etext+0x290>
    80001db4:	00004097          	auipc	ra,0x4
    80001db8:	0c8080e7          	jalr	200(ra) # 80005e7c <printf>
      plic_complete(irq);
    80001dbc:	8526                	mv	a0,s1
    80001dbe:	00003097          	auipc	ra,0x3
    80001dc2:	572080e7          	jalr	1394(ra) # 80005330 <plic_complete>
    return 1;
    80001dc6:	4505                	li	a0,1
    80001dc8:	64a2                	ld	s1,8(sp)
    80001dca:	b755                	j	80001d6e <devintr+0x28>
    if(cpuid() == 0){
    80001dcc:	fffff097          	auipc	ra,0xfffff
    80001dd0:	10a080e7          	jalr	266(ra) # 80000ed6 <cpuid>
    80001dd4:	c901                	beqz	a0,80001de4 <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001dd6:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001dda:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001ddc:	14479073          	csrw	sip,a5
    return 2;
    80001de0:	4509                	li	a0,2
    80001de2:	b771                	j	80001d6e <devintr+0x28>
      clockintr();
    80001de4:	00000097          	auipc	ra,0x0
    80001de8:	f1c080e7          	jalr	-228(ra) # 80001d00 <clockintr>
    80001dec:	b7ed                	j	80001dd6 <devintr+0x90>
}
    80001dee:	8082                	ret

0000000080001df0 <usertrap>:
{
    80001df0:	1101                	addi	sp,sp,-32
    80001df2:	ec06                	sd	ra,24(sp)
    80001df4:	e822                	sd	s0,16(sp)
    80001df6:	e426                	sd	s1,8(sp)
    80001df8:	e04a                	sd	s2,0(sp)
    80001dfa:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dfc:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001e00:	1007f793          	andi	a5,a5,256
    80001e04:	e3b1                	bnez	a5,80001e48 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e06:	00003797          	auipc	a5,0x3
    80001e0a:	3fa78793          	addi	a5,a5,1018 # 80005200 <kernelvec>
    80001e0e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e12:	fffff097          	auipc	ra,0xfffff
    80001e16:	0f0080e7          	jalr	240(ra) # 80000f02 <myproc>
    80001e1a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e1c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e1e:	14102773          	csrr	a4,sepc
    80001e22:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e24:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e28:	47a1                	li	a5,8
    80001e2a:	02f70763          	beq	a4,a5,80001e58 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001e2e:	00000097          	auipc	ra,0x0
    80001e32:	f18080e7          	jalr	-232(ra) # 80001d46 <devintr>
    80001e36:	892a                	mv	s2,a0
    80001e38:	c151                	beqz	a0,80001ebc <usertrap+0xcc>
  if(killed(p))
    80001e3a:	8526                	mv	a0,s1
    80001e3c:	00000097          	auipc	ra,0x0
    80001e40:	ac8080e7          	jalr	-1336(ra) # 80001904 <killed>
    80001e44:	c929                	beqz	a0,80001e96 <usertrap+0xa6>
    80001e46:	a099                	j	80001e8c <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001e48:	00006517          	auipc	a0,0x6
    80001e4c:	46850513          	addi	a0,a0,1128 # 800082b0 <etext+0x2b0>
    80001e50:	00004097          	auipc	ra,0x4
    80001e54:	fe2080e7          	jalr	-30(ra) # 80005e32 <panic>
    if(killed(p))
    80001e58:	00000097          	auipc	ra,0x0
    80001e5c:	aac080e7          	jalr	-1364(ra) # 80001904 <killed>
    80001e60:	e921                	bnez	a0,80001eb0 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001e62:	6cb8                	ld	a4,88(s1)
    80001e64:	6f1c                	ld	a5,24(a4)
    80001e66:	0791                	addi	a5,a5,4
    80001e68:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e6a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e6e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e72:	10079073          	csrw	sstatus,a5
    syscall();
    80001e76:	00000097          	auipc	ra,0x0
    80001e7a:	2d4080e7          	jalr	724(ra) # 8000214a <syscall>
  if(killed(p))
    80001e7e:	8526                	mv	a0,s1
    80001e80:	00000097          	auipc	ra,0x0
    80001e84:	a84080e7          	jalr	-1404(ra) # 80001904 <killed>
    80001e88:	c911                	beqz	a0,80001e9c <usertrap+0xac>
    80001e8a:	4901                	li	s2,0
    exit(-1);
    80001e8c:	557d                	li	a0,-1
    80001e8e:	00000097          	auipc	ra,0x0
    80001e92:	902080e7          	jalr	-1790(ra) # 80001790 <exit>
  if(which_dev == 2)
    80001e96:	4789                	li	a5,2
    80001e98:	04f90f63          	beq	s2,a5,80001ef6 <usertrap+0x106>
  usertrapret();
    80001e9c:	00000097          	auipc	ra,0x0
    80001ea0:	dce080e7          	jalr	-562(ra) # 80001c6a <usertrapret>
}
    80001ea4:	60e2                	ld	ra,24(sp)
    80001ea6:	6442                	ld	s0,16(sp)
    80001ea8:	64a2                	ld	s1,8(sp)
    80001eaa:	6902                	ld	s2,0(sp)
    80001eac:	6105                	addi	sp,sp,32
    80001eae:	8082                	ret
      exit(-1);
    80001eb0:	557d                	li	a0,-1
    80001eb2:	00000097          	auipc	ra,0x0
    80001eb6:	8de080e7          	jalr	-1826(ra) # 80001790 <exit>
    80001eba:	b765                	j	80001e62 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ebc:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001ec0:	5890                	lw	a2,48(s1)
    80001ec2:	00006517          	auipc	a0,0x6
    80001ec6:	40e50513          	addi	a0,a0,1038 # 800082d0 <etext+0x2d0>
    80001eca:	00004097          	auipc	ra,0x4
    80001ece:	fb2080e7          	jalr	-78(ra) # 80005e7c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ed2:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ed6:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001eda:	00006517          	auipc	a0,0x6
    80001ede:	42650513          	addi	a0,a0,1062 # 80008300 <etext+0x300>
    80001ee2:	00004097          	auipc	ra,0x4
    80001ee6:	f9a080e7          	jalr	-102(ra) # 80005e7c <printf>
    setkilled(p);
    80001eea:	8526                	mv	a0,s1
    80001eec:	00000097          	auipc	ra,0x0
    80001ef0:	9ec080e7          	jalr	-1556(ra) # 800018d8 <setkilled>
    80001ef4:	b769                	j	80001e7e <usertrap+0x8e>
    yield();
    80001ef6:	fffff097          	auipc	ra,0xfffff
    80001efa:	72a080e7          	jalr	1834(ra) # 80001620 <yield>
    80001efe:	bf79                	j	80001e9c <usertrap+0xac>

0000000080001f00 <kerneltrap>:
{
    80001f00:	7179                	addi	sp,sp,-48
    80001f02:	f406                	sd	ra,40(sp)
    80001f04:	f022                	sd	s0,32(sp)
    80001f06:	ec26                	sd	s1,24(sp)
    80001f08:	e84a                	sd	s2,16(sp)
    80001f0a:	e44e                	sd	s3,8(sp)
    80001f0c:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f0e:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f12:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f16:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001f1a:	1004f793          	andi	a5,s1,256
    80001f1e:	cb85                	beqz	a5,80001f4e <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f20:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f24:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001f26:	ef85                	bnez	a5,80001f5e <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001f28:	00000097          	auipc	ra,0x0
    80001f2c:	e1e080e7          	jalr	-482(ra) # 80001d46 <devintr>
    80001f30:	cd1d                	beqz	a0,80001f6e <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f32:	4789                	li	a5,2
    80001f34:	06f50a63          	beq	a0,a5,80001fa8 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f38:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f3c:	10049073          	csrw	sstatus,s1
}
    80001f40:	70a2                	ld	ra,40(sp)
    80001f42:	7402                	ld	s0,32(sp)
    80001f44:	64e2                	ld	s1,24(sp)
    80001f46:	6942                	ld	s2,16(sp)
    80001f48:	69a2                	ld	s3,8(sp)
    80001f4a:	6145                	addi	sp,sp,48
    80001f4c:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f4e:	00006517          	auipc	a0,0x6
    80001f52:	3d250513          	addi	a0,a0,978 # 80008320 <etext+0x320>
    80001f56:	00004097          	auipc	ra,0x4
    80001f5a:	edc080e7          	jalr	-292(ra) # 80005e32 <panic>
    panic("kerneltrap: interrupts enabled");
    80001f5e:	00006517          	auipc	a0,0x6
    80001f62:	3ea50513          	addi	a0,a0,1002 # 80008348 <etext+0x348>
    80001f66:	00004097          	auipc	ra,0x4
    80001f6a:	ecc080e7          	jalr	-308(ra) # 80005e32 <panic>
    printf("scause %p\n", scause);
    80001f6e:	85ce                	mv	a1,s3
    80001f70:	00006517          	auipc	a0,0x6
    80001f74:	3f850513          	addi	a0,a0,1016 # 80008368 <etext+0x368>
    80001f78:	00004097          	auipc	ra,0x4
    80001f7c:	f04080e7          	jalr	-252(ra) # 80005e7c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f80:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f84:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f88:	00006517          	auipc	a0,0x6
    80001f8c:	3f050513          	addi	a0,a0,1008 # 80008378 <etext+0x378>
    80001f90:	00004097          	auipc	ra,0x4
    80001f94:	eec080e7          	jalr	-276(ra) # 80005e7c <printf>
    panic("kerneltrap");
    80001f98:	00006517          	auipc	a0,0x6
    80001f9c:	3f850513          	addi	a0,a0,1016 # 80008390 <etext+0x390>
    80001fa0:	00004097          	auipc	ra,0x4
    80001fa4:	e92080e7          	jalr	-366(ra) # 80005e32 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001fa8:	fffff097          	auipc	ra,0xfffff
    80001fac:	f5a080e7          	jalr	-166(ra) # 80000f02 <myproc>
    80001fb0:	d541                	beqz	a0,80001f38 <kerneltrap+0x38>
    80001fb2:	fffff097          	auipc	ra,0xfffff
    80001fb6:	f50080e7          	jalr	-176(ra) # 80000f02 <myproc>
    80001fba:	4d18                	lw	a4,24(a0)
    80001fbc:	4791                	li	a5,4
    80001fbe:	f6f71de3          	bne	a4,a5,80001f38 <kerneltrap+0x38>
    yield();
    80001fc2:	fffff097          	auipc	ra,0xfffff
    80001fc6:	65e080e7          	jalr	1630(ra) # 80001620 <yield>
    80001fca:	b7bd                	j	80001f38 <kerneltrap+0x38>

0000000080001fcc <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001fcc:	1101                	addi	sp,sp,-32
    80001fce:	ec06                	sd	ra,24(sp)
    80001fd0:	e822                	sd	s0,16(sp)
    80001fd2:	e426                	sd	s1,8(sp)
    80001fd4:	1000                	addi	s0,sp,32
    80001fd6:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001fd8:	fffff097          	auipc	ra,0xfffff
    80001fdc:	f2a080e7          	jalr	-214(ra) # 80000f02 <myproc>
  switch (n) {
    80001fe0:	4795                	li	a5,5
    80001fe2:	0497e163          	bltu	a5,s1,80002024 <argraw+0x58>
    80001fe6:	048a                	slli	s1,s1,0x2
    80001fe8:	00006717          	auipc	a4,0x6
    80001fec:	7b870713          	addi	a4,a4,1976 # 800087a0 <states.0+0x30>
    80001ff0:	94ba                	add	s1,s1,a4
    80001ff2:	409c                	lw	a5,0(s1)
    80001ff4:	97ba                	add	a5,a5,a4
    80001ff6:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001ff8:	6d3c                	ld	a5,88(a0)
    80001ffa:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001ffc:	60e2                	ld	ra,24(sp)
    80001ffe:	6442                	ld	s0,16(sp)
    80002000:	64a2                	ld	s1,8(sp)
    80002002:	6105                	addi	sp,sp,32
    80002004:	8082                	ret
    return p->trapframe->a1;
    80002006:	6d3c                	ld	a5,88(a0)
    80002008:	7fa8                	ld	a0,120(a5)
    8000200a:	bfcd                	j	80001ffc <argraw+0x30>
    return p->trapframe->a2;
    8000200c:	6d3c                	ld	a5,88(a0)
    8000200e:	63c8                	ld	a0,128(a5)
    80002010:	b7f5                	j	80001ffc <argraw+0x30>
    return p->trapframe->a3;
    80002012:	6d3c                	ld	a5,88(a0)
    80002014:	67c8                	ld	a0,136(a5)
    80002016:	b7dd                	j	80001ffc <argraw+0x30>
    return p->trapframe->a4;
    80002018:	6d3c                	ld	a5,88(a0)
    8000201a:	6bc8                	ld	a0,144(a5)
    8000201c:	b7c5                	j	80001ffc <argraw+0x30>
    return p->trapframe->a5;
    8000201e:	6d3c                	ld	a5,88(a0)
    80002020:	6fc8                	ld	a0,152(a5)
    80002022:	bfe9                	j	80001ffc <argraw+0x30>
  panic("argraw");
    80002024:	00006517          	auipc	a0,0x6
    80002028:	37c50513          	addi	a0,a0,892 # 800083a0 <etext+0x3a0>
    8000202c:	00004097          	auipc	ra,0x4
    80002030:	e06080e7          	jalr	-506(ra) # 80005e32 <panic>

0000000080002034 <fetchaddr>:
{
    80002034:	1101                	addi	sp,sp,-32
    80002036:	ec06                	sd	ra,24(sp)
    80002038:	e822                	sd	s0,16(sp)
    8000203a:	e426                	sd	s1,8(sp)
    8000203c:	e04a                	sd	s2,0(sp)
    8000203e:	1000                	addi	s0,sp,32
    80002040:	84aa                	mv	s1,a0
    80002042:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002044:	fffff097          	auipc	ra,0xfffff
    80002048:	ebe080e7          	jalr	-322(ra) # 80000f02 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    8000204c:	653c                	ld	a5,72(a0)
    8000204e:	02f4f863          	bgeu	s1,a5,8000207e <fetchaddr+0x4a>
    80002052:	00848713          	addi	a4,s1,8
    80002056:	02e7e663          	bltu	a5,a4,80002082 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000205a:	46a1                	li	a3,8
    8000205c:	8626                	mv	a2,s1
    8000205e:	85ca                	mv	a1,s2
    80002060:	6928                	ld	a0,80(a0)
    80002062:	fffff097          	auipc	ra,0xfffff
    80002066:	bc8080e7          	jalr	-1080(ra) # 80000c2a <copyin>
    8000206a:	00a03533          	snez	a0,a0
    8000206e:	40a00533          	neg	a0,a0
}
    80002072:	60e2                	ld	ra,24(sp)
    80002074:	6442                	ld	s0,16(sp)
    80002076:	64a2                	ld	s1,8(sp)
    80002078:	6902                	ld	s2,0(sp)
    8000207a:	6105                	addi	sp,sp,32
    8000207c:	8082                	ret
    return -1;
    8000207e:	557d                	li	a0,-1
    80002080:	bfcd                	j	80002072 <fetchaddr+0x3e>
    80002082:	557d                	li	a0,-1
    80002084:	b7fd                	j	80002072 <fetchaddr+0x3e>

0000000080002086 <fetchstr>:
{
    80002086:	7179                	addi	sp,sp,-48
    80002088:	f406                	sd	ra,40(sp)
    8000208a:	f022                	sd	s0,32(sp)
    8000208c:	ec26                	sd	s1,24(sp)
    8000208e:	e84a                	sd	s2,16(sp)
    80002090:	e44e                	sd	s3,8(sp)
    80002092:	1800                	addi	s0,sp,48
    80002094:	892a                	mv	s2,a0
    80002096:	84ae                	mv	s1,a1
    80002098:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000209a:	fffff097          	auipc	ra,0xfffff
    8000209e:	e68080e7          	jalr	-408(ra) # 80000f02 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    800020a2:	86ce                	mv	a3,s3
    800020a4:	864a                	mv	a2,s2
    800020a6:	85a6                	mv	a1,s1
    800020a8:	6928                	ld	a0,80(a0)
    800020aa:	fffff097          	auipc	ra,0xfffff
    800020ae:	c0e080e7          	jalr	-1010(ra) # 80000cb8 <copyinstr>
    800020b2:	00054e63          	bltz	a0,800020ce <fetchstr+0x48>
  return strlen(buf);
    800020b6:	8526                	mv	a0,s1
    800020b8:	ffffe097          	auipc	ra,0xffffe
    800020bc:	236080e7          	jalr	566(ra) # 800002ee <strlen>
}
    800020c0:	70a2                	ld	ra,40(sp)
    800020c2:	7402                	ld	s0,32(sp)
    800020c4:	64e2                	ld	s1,24(sp)
    800020c6:	6942                	ld	s2,16(sp)
    800020c8:	69a2                	ld	s3,8(sp)
    800020ca:	6145                	addi	sp,sp,48
    800020cc:	8082                	ret
    return -1;
    800020ce:	557d                	li	a0,-1
    800020d0:	bfc5                	j	800020c0 <fetchstr+0x3a>

00000000800020d2 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800020d2:	1101                	addi	sp,sp,-32
    800020d4:	ec06                	sd	ra,24(sp)
    800020d6:	e822                	sd	s0,16(sp)
    800020d8:	e426                	sd	s1,8(sp)
    800020da:	1000                	addi	s0,sp,32
    800020dc:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020de:	00000097          	auipc	ra,0x0
    800020e2:	eee080e7          	jalr	-274(ra) # 80001fcc <argraw>
    800020e6:	c088                	sw	a0,0(s1)
}
    800020e8:	60e2                	ld	ra,24(sp)
    800020ea:	6442                	ld	s0,16(sp)
    800020ec:	64a2                	ld	s1,8(sp)
    800020ee:	6105                	addi	sp,sp,32
    800020f0:	8082                	ret

00000000800020f2 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800020f2:	1101                	addi	sp,sp,-32
    800020f4:	ec06                	sd	ra,24(sp)
    800020f6:	e822                	sd	s0,16(sp)
    800020f8:	e426                	sd	s1,8(sp)
    800020fa:	1000                	addi	s0,sp,32
    800020fc:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020fe:	00000097          	auipc	ra,0x0
    80002102:	ece080e7          	jalr	-306(ra) # 80001fcc <argraw>
    80002106:	e088                	sd	a0,0(s1)
}
    80002108:	60e2                	ld	ra,24(sp)
    8000210a:	6442                	ld	s0,16(sp)
    8000210c:	64a2                	ld	s1,8(sp)
    8000210e:	6105                	addi	sp,sp,32
    80002110:	8082                	ret

0000000080002112 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002112:	7179                	addi	sp,sp,-48
    80002114:	f406                	sd	ra,40(sp)
    80002116:	f022                	sd	s0,32(sp)
    80002118:	ec26                	sd	s1,24(sp)
    8000211a:	e84a                	sd	s2,16(sp)
    8000211c:	1800                	addi	s0,sp,48
    8000211e:	84ae                	mv	s1,a1
    80002120:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002122:	fd840593          	addi	a1,s0,-40
    80002126:	00000097          	auipc	ra,0x0
    8000212a:	fcc080e7          	jalr	-52(ra) # 800020f2 <argaddr>
  return fetchstr(addr, buf, max);
    8000212e:	864a                	mv	a2,s2
    80002130:	85a6                	mv	a1,s1
    80002132:	fd843503          	ld	a0,-40(s0)
    80002136:	00000097          	auipc	ra,0x0
    8000213a:	f50080e7          	jalr	-176(ra) # 80002086 <fetchstr>
}
    8000213e:	70a2                	ld	ra,40(sp)
    80002140:	7402                	ld	s0,32(sp)
    80002142:	64e2                	ld	s1,24(sp)
    80002144:	6942                	ld	s2,16(sp)
    80002146:	6145                	addi	sp,sp,48
    80002148:	8082                	ret

000000008000214a <syscall>:



void
syscall(void)
{
    8000214a:	1101                	addi	sp,sp,-32
    8000214c:	ec06                	sd	ra,24(sp)
    8000214e:	e822                	sd	s0,16(sp)
    80002150:	e426                	sd	s1,8(sp)
    80002152:	e04a                	sd	s2,0(sp)
    80002154:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002156:	fffff097          	auipc	ra,0xfffff
    8000215a:	dac080e7          	jalr	-596(ra) # 80000f02 <myproc>
    8000215e:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002160:	05853903          	ld	s2,88(a0)
    80002164:	0a893783          	ld	a5,168(s2)
    80002168:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000216c:	37fd                	addiw	a5,a5,-1
    8000216e:	4775                	li	a4,29
    80002170:	00f76f63          	bltu	a4,a5,8000218e <syscall+0x44>
    80002174:	00369713          	slli	a4,a3,0x3
    80002178:	00006797          	auipc	a5,0x6
    8000217c:	64078793          	addi	a5,a5,1600 # 800087b8 <syscalls>
    80002180:	97ba                	add	a5,a5,a4
    80002182:	639c                	ld	a5,0(a5)
    80002184:	c789                	beqz	a5,8000218e <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002186:	9782                	jalr	a5
    80002188:	06a93823          	sd	a0,112(s2)
    8000218c:	a839                	j	800021aa <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000218e:	16048613          	addi	a2,s1,352
    80002192:	588c                	lw	a1,48(s1)
    80002194:	00006517          	auipc	a0,0x6
    80002198:	21450513          	addi	a0,a0,532 # 800083a8 <etext+0x3a8>
    8000219c:	00004097          	auipc	ra,0x4
    800021a0:	ce0080e7          	jalr	-800(ra) # 80005e7c <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800021a4:	6cbc                	ld	a5,88(s1)
    800021a6:	577d                	li	a4,-1
    800021a8:	fbb8                	sd	a4,112(a5)
  }
}
    800021aa:	60e2                	ld	ra,24(sp)
    800021ac:	6442                	ld	s0,16(sp)
    800021ae:	64a2                	ld	s1,8(sp)
    800021b0:	6902                	ld	s2,0(sp)
    800021b2:	6105                	addi	sp,sp,32
    800021b4:	8082                	ret

00000000800021b6 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800021b6:	1101                	addi	sp,sp,-32
    800021b8:	ec06                	sd	ra,24(sp)
    800021ba:	e822                	sd	s0,16(sp)
    800021bc:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800021be:	fec40593          	addi	a1,s0,-20
    800021c2:	4501                	li	a0,0
    800021c4:	00000097          	auipc	ra,0x0
    800021c8:	f0e080e7          	jalr	-242(ra) # 800020d2 <argint>
  exit(n);
    800021cc:	fec42503          	lw	a0,-20(s0)
    800021d0:	fffff097          	auipc	ra,0xfffff
    800021d4:	5c0080e7          	jalr	1472(ra) # 80001790 <exit>
  return 0;  // not reached
}
    800021d8:	4501                	li	a0,0
    800021da:	60e2                	ld	ra,24(sp)
    800021dc:	6442                	ld	s0,16(sp)
    800021de:	6105                	addi	sp,sp,32
    800021e0:	8082                	ret

00000000800021e2 <sys_getpid>:

uint64
sys_getpid(void)
{
    800021e2:	1141                	addi	sp,sp,-16
    800021e4:	e406                	sd	ra,8(sp)
    800021e6:	e022                	sd	s0,0(sp)
    800021e8:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800021ea:	fffff097          	auipc	ra,0xfffff
    800021ee:	d18080e7          	jalr	-744(ra) # 80000f02 <myproc>
}
    800021f2:	5908                	lw	a0,48(a0)
    800021f4:	60a2                	ld	ra,8(sp)
    800021f6:	6402                	ld	s0,0(sp)
    800021f8:	0141                	addi	sp,sp,16
    800021fa:	8082                	ret

00000000800021fc <sys_fork>:

uint64
sys_fork(void)
{
    800021fc:	1141                	addi	sp,sp,-16
    800021fe:	e406                	sd	ra,8(sp)
    80002200:	e022                	sd	s0,0(sp)
    80002202:	0800                	addi	s0,sp,16
  return fork();
    80002204:	fffff097          	auipc	ra,0xfffff
    80002208:	164080e7          	jalr	356(ra) # 80001368 <fork>
}
    8000220c:	60a2                	ld	ra,8(sp)
    8000220e:	6402                	ld	s0,0(sp)
    80002210:	0141                	addi	sp,sp,16
    80002212:	8082                	ret

0000000080002214 <sys_wait>:

uint64
sys_wait(void)
{
    80002214:	1101                	addi	sp,sp,-32
    80002216:	ec06                	sd	ra,24(sp)
    80002218:	e822                	sd	s0,16(sp)
    8000221a:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000221c:	fe840593          	addi	a1,s0,-24
    80002220:	4501                	li	a0,0
    80002222:	00000097          	auipc	ra,0x0
    80002226:	ed0080e7          	jalr	-304(ra) # 800020f2 <argaddr>
  return wait(p);
    8000222a:	fe843503          	ld	a0,-24(s0)
    8000222e:	fffff097          	auipc	ra,0xfffff
    80002232:	708080e7          	jalr	1800(ra) # 80001936 <wait>
}
    80002236:	60e2                	ld	ra,24(sp)
    80002238:	6442                	ld	s0,16(sp)
    8000223a:	6105                	addi	sp,sp,32
    8000223c:	8082                	ret

000000008000223e <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000223e:	7179                	addi	sp,sp,-48
    80002240:	f406                	sd	ra,40(sp)
    80002242:	f022                	sd	s0,32(sp)
    80002244:	ec26                	sd	s1,24(sp)
    80002246:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002248:	fdc40593          	addi	a1,s0,-36
    8000224c:	4501                	li	a0,0
    8000224e:	00000097          	auipc	ra,0x0
    80002252:	e84080e7          	jalr	-380(ra) # 800020d2 <argint>
  addr = myproc()->sz;
    80002256:	fffff097          	auipc	ra,0xfffff
    8000225a:	cac080e7          	jalr	-852(ra) # 80000f02 <myproc>
    8000225e:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002260:	fdc42503          	lw	a0,-36(s0)
    80002264:	fffff097          	auipc	ra,0xfffff
    80002268:	0a8080e7          	jalr	168(ra) # 8000130c <growproc>
    8000226c:	00054863          	bltz	a0,8000227c <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002270:	8526                	mv	a0,s1
    80002272:	70a2                	ld	ra,40(sp)
    80002274:	7402                	ld	s0,32(sp)
    80002276:	64e2                	ld	s1,24(sp)
    80002278:	6145                	addi	sp,sp,48
    8000227a:	8082                	ret
    return -1;
    8000227c:	54fd                	li	s1,-1
    8000227e:	bfcd                	j	80002270 <sys_sbrk+0x32>

0000000080002280 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002280:	7139                	addi	sp,sp,-64
    80002282:	fc06                	sd	ra,56(sp)
    80002284:	f822                	sd	s0,48(sp)
    80002286:	f04a                	sd	s2,32(sp)
    80002288:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  argint(0, &n);
    8000228a:	fcc40593          	addi	a1,s0,-52
    8000228e:	4501                	li	a0,0
    80002290:	00000097          	auipc	ra,0x0
    80002294:	e42080e7          	jalr	-446(ra) # 800020d2 <argint>
  acquire(&tickslock);
    80002298:	0000f517          	auipc	a0,0xf
    8000229c:	03850513          	addi	a0,a0,56 # 800112d0 <tickslock>
    800022a0:	00004097          	auipc	ra,0x4
    800022a4:	10c080e7          	jalr	268(ra) # 800063ac <acquire>
  ticks0 = ticks;
    800022a8:	00009917          	auipc	s2,0x9
    800022ac:	fc092903          	lw	s2,-64(s2) # 8000b268 <ticks>
  while(ticks - ticks0 < n){
    800022b0:	fcc42783          	lw	a5,-52(s0)
    800022b4:	c3b9                	beqz	a5,800022fa <sys_sleep+0x7a>
    800022b6:	f426                	sd	s1,40(sp)
    800022b8:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800022ba:	0000f997          	auipc	s3,0xf
    800022be:	01698993          	addi	s3,s3,22 # 800112d0 <tickslock>
    800022c2:	00009497          	auipc	s1,0x9
    800022c6:	fa648493          	addi	s1,s1,-90 # 8000b268 <ticks>
    if(killed(myproc())){
    800022ca:	fffff097          	auipc	ra,0xfffff
    800022ce:	c38080e7          	jalr	-968(ra) # 80000f02 <myproc>
    800022d2:	fffff097          	auipc	ra,0xfffff
    800022d6:	632080e7          	jalr	1586(ra) # 80001904 <killed>
    800022da:	ed15                	bnez	a0,80002316 <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    800022dc:	85ce                	mv	a1,s3
    800022de:	8526                	mv	a0,s1
    800022e0:	fffff097          	auipc	ra,0xfffff
    800022e4:	37c080e7          	jalr	892(ra) # 8000165c <sleep>
  while(ticks - ticks0 < n){
    800022e8:	409c                	lw	a5,0(s1)
    800022ea:	412787bb          	subw	a5,a5,s2
    800022ee:	fcc42703          	lw	a4,-52(s0)
    800022f2:	fce7ece3          	bltu	a5,a4,800022ca <sys_sleep+0x4a>
    800022f6:	74a2                	ld	s1,40(sp)
    800022f8:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    800022fa:	0000f517          	auipc	a0,0xf
    800022fe:	fd650513          	addi	a0,a0,-42 # 800112d0 <tickslock>
    80002302:	00004097          	auipc	ra,0x4
    80002306:	15e080e7          	jalr	350(ra) # 80006460 <release>
  return 0;
    8000230a:	4501                	li	a0,0
}
    8000230c:	70e2                	ld	ra,56(sp)
    8000230e:	7442                	ld	s0,48(sp)
    80002310:	7902                	ld	s2,32(sp)
    80002312:	6121                	addi	sp,sp,64
    80002314:	8082                	ret
      release(&tickslock);
    80002316:	0000f517          	auipc	a0,0xf
    8000231a:	fba50513          	addi	a0,a0,-70 # 800112d0 <tickslock>
    8000231e:	00004097          	auipc	ra,0x4
    80002322:	142080e7          	jalr	322(ra) # 80006460 <release>
      return -1;
    80002326:	557d                	li	a0,-1
    80002328:	74a2                	ld	s1,40(sp)
    8000232a:	69e2                	ld	s3,24(sp)
    8000232c:	b7c5                	j	8000230c <sys_sleep+0x8c>

000000008000232e <sys_pgaccess>:


#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
    8000232e:	1141                	addi	sp,sp,-16
    80002330:	e422                	sd	s0,8(sp)
    80002332:	0800                	addi	s0,sp,16
  // lab pgtbl: your code here.
  return 0;
}
    80002334:	4501                	li	a0,0
    80002336:	6422                	ld	s0,8(sp)
    80002338:	0141                	addi	sp,sp,16
    8000233a:	8082                	ret

000000008000233c <sys_kill>:
#endif

uint64
sys_kill(void)
{
    8000233c:	1101                	addi	sp,sp,-32
    8000233e:	ec06                	sd	ra,24(sp)
    80002340:	e822                	sd	s0,16(sp)
    80002342:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002344:	fec40593          	addi	a1,s0,-20
    80002348:	4501                	li	a0,0
    8000234a:	00000097          	auipc	ra,0x0
    8000234e:	d88080e7          	jalr	-632(ra) # 800020d2 <argint>
  return kill(pid);
    80002352:	fec42503          	lw	a0,-20(s0)
    80002356:	fffff097          	auipc	ra,0xfffff
    8000235a:	510080e7          	jalr	1296(ra) # 80001866 <kill>
}
    8000235e:	60e2                	ld	ra,24(sp)
    80002360:	6442                	ld	s0,16(sp)
    80002362:	6105                	addi	sp,sp,32
    80002364:	8082                	ret

0000000080002366 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002366:	1101                	addi	sp,sp,-32
    80002368:	ec06                	sd	ra,24(sp)
    8000236a:	e822                	sd	s0,16(sp)
    8000236c:	e426                	sd	s1,8(sp)
    8000236e:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002370:	0000f517          	auipc	a0,0xf
    80002374:	f6050513          	addi	a0,a0,-160 # 800112d0 <tickslock>
    80002378:	00004097          	auipc	ra,0x4
    8000237c:	034080e7          	jalr	52(ra) # 800063ac <acquire>
  xticks = ticks;
    80002380:	00009497          	auipc	s1,0x9
    80002384:	ee84a483          	lw	s1,-280(s1) # 8000b268 <ticks>
  release(&tickslock);
    80002388:	0000f517          	auipc	a0,0xf
    8000238c:	f4850513          	addi	a0,a0,-184 # 800112d0 <tickslock>
    80002390:	00004097          	auipc	ra,0x4
    80002394:	0d0080e7          	jalr	208(ra) # 80006460 <release>
  return xticks;
}
    80002398:	02049513          	slli	a0,s1,0x20
    8000239c:	9101                	srli	a0,a0,0x20
    8000239e:	60e2                	ld	ra,24(sp)
    800023a0:	6442                	ld	s0,16(sp)
    800023a2:	64a2                	ld	s1,8(sp)
    800023a4:	6105                	addi	sp,sp,32
    800023a6:	8082                	ret

00000000800023a8 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800023a8:	7179                	addi	sp,sp,-48
    800023aa:	f406                	sd	ra,40(sp)
    800023ac:	f022                	sd	s0,32(sp)
    800023ae:	ec26                	sd	s1,24(sp)
    800023b0:	e84a                	sd	s2,16(sp)
    800023b2:	e44e                	sd	s3,8(sp)
    800023b4:	e052                	sd	s4,0(sp)
    800023b6:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800023b8:	00006597          	auipc	a1,0x6
    800023bc:	01058593          	addi	a1,a1,16 # 800083c8 <etext+0x3c8>
    800023c0:	0000f517          	auipc	a0,0xf
    800023c4:	f2850513          	addi	a0,a0,-216 # 800112e8 <bcache>
    800023c8:	00004097          	auipc	ra,0x4
    800023cc:	f54080e7          	jalr	-172(ra) # 8000631c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800023d0:	00017797          	auipc	a5,0x17
    800023d4:	f1878793          	addi	a5,a5,-232 # 800192e8 <bcache+0x8000>
    800023d8:	00017717          	auipc	a4,0x17
    800023dc:	17870713          	addi	a4,a4,376 # 80019550 <bcache+0x8268>
    800023e0:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800023e4:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023e8:	0000f497          	auipc	s1,0xf
    800023ec:	f1848493          	addi	s1,s1,-232 # 80011300 <bcache+0x18>
    b->next = bcache.head.next;
    800023f0:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800023f2:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800023f4:	00006a17          	auipc	s4,0x6
    800023f8:	fdca0a13          	addi	s4,s4,-36 # 800083d0 <etext+0x3d0>
    b->next = bcache.head.next;
    800023fc:	2b893783          	ld	a5,696(s2)
    80002400:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002402:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002406:	85d2                	mv	a1,s4
    80002408:	01048513          	addi	a0,s1,16
    8000240c:	00001097          	auipc	ra,0x1
    80002410:	4e8080e7          	jalr	1256(ra) # 800038f4 <initsleeplock>
    bcache.head.next->prev = b;
    80002414:	2b893783          	ld	a5,696(s2)
    80002418:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000241a:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000241e:	45848493          	addi	s1,s1,1112
    80002422:	fd349de3          	bne	s1,s3,800023fc <binit+0x54>
  }
}
    80002426:	70a2                	ld	ra,40(sp)
    80002428:	7402                	ld	s0,32(sp)
    8000242a:	64e2                	ld	s1,24(sp)
    8000242c:	6942                	ld	s2,16(sp)
    8000242e:	69a2                	ld	s3,8(sp)
    80002430:	6a02                	ld	s4,0(sp)
    80002432:	6145                	addi	sp,sp,48
    80002434:	8082                	ret

0000000080002436 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002436:	7179                	addi	sp,sp,-48
    80002438:	f406                	sd	ra,40(sp)
    8000243a:	f022                	sd	s0,32(sp)
    8000243c:	ec26                	sd	s1,24(sp)
    8000243e:	e84a                	sd	s2,16(sp)
    80002440:	e44e                	sd	s3,8(sp)
    80002442:	1800                	addi	s0,sp,48
    80002444:	892a                	mv	s2,a0
    80002446:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002448:	0000f517          	auipc	a0,0xf
    8000244c:	ea050513          	addi	a0,a0,-352 # 800112e8 <bcache>
    80002450:	00004097          	auipc	ra,0x4
    80002454:	f5c080e7          	jalr	-164(ra) # 800063ac <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002458:	00017497          	auipc	s1,0x17
    8000245c:	1484b483          	ld	s1,328(s1) # 800195a0 <bcache+0x82b8>
    80002460:	00017797          	auipc	a5,0x17
    80002464:	0f078793          	addi	a5,a5,240 # 80019550 <bcache+0x8268>
    80002468:	02f48f63          	beq	s1,a5,800024a6 <bread+0x70>
    8000246c:	873e                	mv	a4,a5
    8000246e:	a021                	j	80002476 <bread+0x40>
    80002470:	68a4                	ld	s1,80(s1)
    80002472:	02e48a63          	beq	s1,a4,800024a6 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002476:	449c                	lw	a5,8(s1)
    80002478:	ff279ce3          	bne	a5,s2,80002470 <bread+0x3a>
    8000247c:	44dc                	lw	a5,12(s1)
    8000247e:	ff3799e3          	bne	a5,s3,80002470 <bread+0x3a>
      b->refcnt++;
    80002482:	40bc                	lw	a5,64(s1)
    80002484:	2785                	addiw	a5,a5,1
    80002486:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002488:	0000f517          	auipc	a0,0xf
    8000248c:	e6050513          	addi	a0,a0,-416 # 800112e8 <bcache>
    80002490:	00004097          	auipc	ra,0x4
    80002494:	fd0080e7          	jalr	-48(ra) # 80006460 <release>
      acquiresleep(&b->lock);
    80002498:	01048513          	addi	a0,s1,16
    8000249c:	00001097          	auipc	ra,0x1
    800024a0:	492080e7          	jalr	1170(ra) # 8000392e <acquiresleep>
      return b;
    800024a4:	a8b9                	j	80002502 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024a6:	00017497          	auipc	s1,0x17
    800024aa:	0f24b483          	ld	s1,242(s1) # 80019598 <bcache+0x82b0>
    800024ae:	00017797          	auipc	a5,0x17
    800024b2:	0a278793          	addi	a5,a5,162 # 80019550 <bcache+0x8268>
    800024b6:	00f48863          	beq	s1,a5,800024c6 <bread+0x90>
    800024ba:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800024bc:	40bc                	lw	a5,64(s1)
    800024be:	cf81                	beqz	a5,800024d6 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024c0:	64a4                	ld	s1,72(s1)
    800024c2:	fee49de3          	bne	s1,a4,800024bc <bread+0x86>
  panic("bget: no buffers");
    800024c6:	00006517          	auipc	a0,0x6
    800024ca:	f1250513          	addi	a0,a0,-238 # 800083d8 <etext+0x3d8>
    800024ce:	00004097          	auipc	ra,0x4
    800024d2:	964080e7          	jalr	-1692(ra) # 80005e32 <panic>
      b->dev = dev;
    800024d6:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800024da:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800024de:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800024e2:	4785                	li	a5,1
    800024e4:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024e6:	0000f517          	auipc	a0,0xf
    800024ea:	e0250513          	addi	a0,a0,-510 # 800112e8 <bcache>
    800024ee:	00004097          	auipc	ra,0x4
    800024f2:	f72080e7          	jalr	-142(ra) # 80006460 <release>
      acquiresleep(&b->lock);
    800024f6:	01048513          	addi	a0,s1,16
    800024fa:	00001097          	auipc	ra,0x1
    800024fe:	434080e7          	jalr	1076(ra) # 8000392e <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002502:	409c                	lw	a5,0(s1)
    80002504:	cb89                	beqz	a5,80002516 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002506:	8526                	mv	a0,s1
    80002508:	70a2                	ld	ra,40(sp)
    8000250a:	7402                	ld	s0,32(sp)
    8000250c:	64e2                	ld	s1,24(sp)
    8000250e:	6942                	ld	s2,16(sp)
    80002510:	69a2                	ld	s3,8(sp)
    80002512:	6145                	addi	sp,sp,48
    80002514:	8082                	ret
    virtio_disk_rw(b, 0);
    80002516:	4581                	li	a1,0
    80002518:	8526                	mv	a0,s1
    8000251a:	00003097          	auipc	ra,0x3
    8000251e:	0ee080e7          	jalr	238(ra) # 80005608 <virtio_disk_rw>
    b->valid = 1;
    80002522:	4785                	li	a5,1
    80002524:	c09c                	sw	a5,0(s1)
  return b;
    80002526:	b7c5                	j	80002506 <bread+0xd0>

0000000080002528 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002528:	1101                	addi	sp,sp,-32
    8000252a:	ec06                	sd	ra,24(sp)
    8000252c:	e822                	sd	s0,16(sp)
    8000252e:	e426                	sd	s1,8(sp)
    80002530:	1000                	addi	s0,sp,32
    80002532:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002534:	0541                	addi	a0,a0,16
    80002536:	00001097          	auipc	ra,0x1
    8000253a:	492080e7          	jalr	1170(ra) # 800039c8 <holdingsleep>
    8000253e:	cd01                	beqz	a0,80002556 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002540:	4585                	li	a1,1
    80002542:	8526                	mv	a0,s1
    80002544:	00003097          	auipc	ra,0x3
    80002548:	0c4080e7          	jalr	196(ra) # 80005608 <virtio_disk_rw>
}
    8000254c:	60e2                	ld	ra,24(sp)
    8000254e:	6442                	ld	s0,16(sp)
    80002550:	64a2                	ld	s1,8(sp)
    80002552:	6105                	addi	sp,sp,32
    80002554:	8082                	ret
    panic("bwrite");
    80002556:	00006517          	auipc	a0,0x6
    8000255a:	e9a50513          	addi	a0,a0,-358 # 800083f0 <etext+0x3f0>
    8000255e:	00004097          	auipc	ra,0x4
    80002562:	8d4080e7          	jalr	-1836(ra) # 80005e32 <panic>

0000000080002566 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002566:	1101                	addi	sp,sp,-32
    80002568:	ec06                	sd	ra,24(sp)
    8000256a:	e822                	sd	s0,16(sp)
    8000256c:	e426                	sd	s1,8(sp)
    8000256e:	e04a                	sd	s2,0(sp)
    80002570:	1000                	addi	s0,sp,32
    80002572:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002574:	01050913          	addi	s2,a0,16
    80002578:	854a                	mv	a0,s2
    8000257a:	00001097          	auipc	ra,0x1
    8000257e:	44e080e7          	jalr	1102(ra) # 800039c8 <holdingsleep>
    80002582:	c925                	beqz	a0,800025f2 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    80002584:	854a                	mv	a0,s2
    80002586:	00001097          	auipc	ra,0x1
    8000258a:	3fe080e7          	jalr	1022(ra) # 80003984 <releasesleep>

  acquire(&bcache.lock);
    8000258e:	0000f517          	auipc	a0,0xf
    80002592:	d5a50513          	addi	a0,a0,-678 # 800112e8 <bcache>
    80002596:	00004097          	auipc	ra,0x4
    8000259a:	e16080e7          	jalr	-490(ra) # 800063ac <acquire>
  b->refcnt--;
    8000259e:	40bc                	lw	a5,64(s1)
    800025a0:	37fd                	addiw	a5,a5,-1
    800025a2:	0007871b          	sext.w	a4,a5
    800025a6:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800025a8:	e71d                	bnez	a4,800025d6 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800025aa:	68b8                	ld	a4,80(s1)
    800025ac:	64bc                	ld	a5,72(s1)
    800025ae:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800025b0:	68b8                	ld	a4,80(s1)
    800025b2:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800025b4:	00017797          	auipc	a5,0x17
    800025b8:	d3478793          	addi	a5,a5,-716 # 800192e8 <bcache+0x8000>
    800025bc:	2b87b703          	ld	a4,696(a5)
    800025c0:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800025c2:	00017717          	auipc	a4,0x17
    800025c6:	f8e70713          	addi	a4,a4,-114 # 80019550 <bcache+0x8268>
    800025ca:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800025cc:	2b87b703          	ld	a4,696(a5)
    800025d0:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800025d2:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800025d6:	0000f517          	auipc	a0,0xf
    800025da:	d1250513          	addi	a0,a0,-750 # 800112e8 <bcache>
    800025de:	00004097          	auipc	ra,0x4
    800025e2:	e82080e7          	jalr	-382(ra) # 80006460 <release>
}
    800025e6:	60e2                	ld	ra,24(sp)
    800025e8:	6442                	ld	s0,16(sp)
    800025ea:	64a2                	ld	s1,8(sp)
    800025ec:	6902                	ld	s2,0(sp)
    800025ee:	6105                	addi	sp,sp,32
    800025f0:	8082                	ret
    panic("brelse");
    800025f2:	00006517          	auipc	a0,0x6
    800025f6:	e0650513          	addi	a0,a0,-506 # 800083f8 <etext+0x3f8>
    800025fa:	00004097          	auipc	ra,0x4
    800025fe:	838080e7          	jalr	-1992(ra) # 80005e32 <panic>

0000000080002602 <bpin>:

void
bpin(struct buf *b) {
    80002602:	1101                	addi	sp,sp,-32
    80002604:	ec06                	sd	ra,24(sp)
    80002606:	e822                	sd	s0,16(sp)
    80002608:	e426                	sd	s1,8(sp)
    8000260a:	1000                	addi	s0,sp,32
    8000260c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000260e:	0000f517          	auipc	a0,0xf
    80002612:	cda50513          	addi	a0,a0,-806 # 800112e8 <bcache>
    80002616:	00004097          	auipc	ra,0x4
    8000261a:	d96080e7          	jalr	-618(ra) # 800063ac <acquire>
  b->refcnt++;
    8000261e:	40bc                	lw	a5,64(s1)
    80002620:	2785                	addiw	a5,a5,1
    80002622:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002624:	0000f517          	auipc	a0,0xf
    80002628:	cc450513          	addi	a0,a0,-828 # 800112e8 <bcache>
    8000262c:	00004097          	auipc	ra,0x4
    80002630:	e34080e7          	jalr	-460(ra) # 80006460 <release>
}
    80002634:	60e2                	ld	ra,24(sp)
    80002636:	6442                	ld	s0,16(sp)
    80002638:	64a2                	ld	s1,8(sp)
    8000263a:	6105                	addi	sp,sp,32
    8000263c:	8082                	ret

000000008000263e <bunpin>:

void
bunpin(struct buf *b) {
    8000263e:	1101                	addi	sp,sp,-32
    80002640:	ec06                	sd	ra,24(sp)
    80002642:	e822                	sd	s0,16(sp)
    80002644:	e426                	sd	s1,8(sp)
    80002646:	1000                	addi	s0,sp,32
    80002648:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000264a:	0000f517          	auipc	a0,0xf
    8000264e:	c9e50513          	addi	a0,a0,-866 # 800112e8 <bcache>
    80002652:	00004097          	auipc	ra,0x4
    80002656:	d5a080e7          	jalr	-678(ra) # 800063ac <acquire>
  b->refcnt--;
    8000265a:	40bc                	lw	a5,64(s1)
    8000265c:	37fd                	addiw	a5,a5,-1
    8000265e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002660:	0000f517          	auipc	a0,0xf
    80002664:	c8850513          	addi	a0,a0,-888 # 800112e8 <bcache>
    80002668:	00004097          	auipc	ra,0x4
    8000266c:	df8080e7          	jalr	-520(ra) # 80006460 <release>
}
    80002670:	60e2                	ld	ra,24(sp)
    80002672:	6442                	ld	s0,16(sp)
    80002674:	64a2                	ld	s1,8(sp)
    80002676:	6105                	addi	sp,sp,32
    80002678:	8082                	ret

000000008000267a <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000267a:	1101                	addi	sp,sp,-32
    8000267c:	ec06                	sd	ra,24(sp)
    8000267e:	e822                	sd	s0,16(sp)
    80002680:	e426                	sd	s1,8(sp)
    80002682:	e04a                	sd	s2,0(sp)
    80002684:	1000                	addi	s0,sp,32
    80002686:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002688:	00d5d59b          	srliw	a1,a1,0xd
    8000268c:	00017797          	auipc	a5,0x17
    80002690:	3387a783          	lw	a5,824(a5) # 800199c4 <sb+0x1c>
    80002694:	9dbd                	addw	a1,a1,a5
    80002696:	00000097          	auipc	ra,0x0
    8000269a:	da0080e7          	jalr	-608(ra) # 80002436 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000269e:	0074f713          	andi	a4,s1,7
    800026a2:	4785                	li	a5,1
    800026a4:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800026a8:	14ce                	slli	s1,s1,0x33
    800026aa:	90d9                	srli	s1,s1,0x36
    800026ac:	00950733          	add	a4,a0,s1
    800026b0:	05874703          	lbu	a4,88(a4)
    800026b4:	00e7f6b3          	and	a3,a5,a4
    800026b8:	c69d                	beqz	a3,800026e6 <bfree+0x6c>
    800026ba:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800026bc:	94aa                	add	s1,s1,a0
    800026be:	fff7c793          	not	a5,a5
    800026c2:	8f7d                	and	a4,a4,a5
    800026c4:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800026c8:	00001097          	auipc	ra,0x1
    800026cc:	148080e7          	jalr	328(ra) # 80003810 <log_write>
  brelse(bp);
    800026d0:	854a                	mv	a0,s2
    800026d2:	00000097          	auipc	ra,0x0
    800026d6:	e94080e7          	jalr	-364(ra) # 80002566 <brelse>
}
    800026da:	60e2                	ld	ra,24(sp)
    800026dc:	6442                	ld	s0,16(sp)
    800026de:	64a2                	ld	s1,8(sp)
    800026e0:	6902                	ld	s2,0(sp)
    800026e2:	6105                	addi	sp,sp,32
    800026e4:	8082                	ret
    panic("freeing free block");
    800026e6:	00006517          	auipc	a0,0x6
    800026ea:	d1a50513          	addi	a0,a0,-742 # 80008400 <etext+0x400>
    800026ee:	00003097          	auipc	ra,0x3
    800026f2:	744080e7          	jalr	1860(ra) # 80005e32 <panic>

00000000800026f6 <balloc>:
{
    800026f6:	711d                	addi	sp,sp,-96
    800026f8:	ec86                	sd	ra,88(sp)
    800026fa:	e8a2                	sd	s0,80(sp)
    800026fc:	e4a6                	sd	s1,72(sp)
    800026fe:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002700:	00017797          	auipc	a5,0x17
    80002704:	2ac7a783          	lw	a5,684(a5) # 800199ac <sb+0x4>
    80002708:	10078f63          	beqz	a5,80002826 <balloc+0x130>
    8000270c:	e0ca                	sd	s2,64(sp)
    8000270e:	fc4e                	sd	s3,56(sp)
    80002710:	f852                	sd	s4,48(sp)
    80002712:	f456                	sd	s5,40(sp)
    80002714:	f05a                	sd	s6,32(sp)
    80002716:	ec5e                	sd	s7,24(sp)
    80002718:	e862                	sd	s8,16(sp)
    8000271a:	e466                	sd	s9,8(sp)
    8000271c:	8baa                	mv	s7,a0
    8000271e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002720:	00017b17          	auipc	s6,0x17
    80002724:	288b0b13          	addi	s6,s6,648 # 800199a8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002728:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000272a:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000272c:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000272e:	6c89                	lui	s9,0x2
    80002730:	a061                	j	800027b8 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002732:	97ca                	add	a5,a5,s2
    80002734:	8e55                	or	a2,a2,a3
    80002736:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000273a:	854a                	mv	a0,s2
    8000273c:	00001097          	auipc	ra,0x1
    80002740:	0d4080e7          	jalr	212(ra) # 80003810 <log_write>
        brelse(bp);
    80002744:	854a                	mv	a0,s2
    80002746:	00000097          	auipc	ra,0x0
    8000274a:	e20080e7          	jalr	-480(ra) # 80002566 <brelse>
  bp = bread(dev, bno);
    8000274e:	85a6                	mv	a1,s1
    80002750:	855e                	mv	a0,s7
    80002752:	00000097          	auipc	ra,0x0
    80002756:	ce4080e7          	jalr	-796(ra) # 80002436 <bread>
    8000275a:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000275c:	40000613          	li	a2,1024
    80002760:	4581                	li	a1,0
    80002762:	05850513          	addi	a0,a0,88
    80002766:	ffffe097          	auipc	ra,0xffffe
    8000276a:	a14080e7          	jalr	-1516(ra) # 8000017a <memset>
  log_write(bp);
    8000276e:	854a                	mv	a0,s2
    80002770:	00001097          	auipc	ra,0x1
    80002774:	0a0080e7          	jalr	160(ra) # 80003810 <log_write>
  brelse(bp);
    80002778:	854a                	mv	a0,s2
    8000277a:	00000097          	auipc	ra,0x0
    8000277e:	dec080e7          	jalr	-532(ra) # 80002566 <brelse>
}
    80002782:	6906                	ld	s2,64(sp)
    80002784:	79e2                	ld	s3,56(sp)
    80002786:	7a42                	ld	s4,48(sp)
    80002788:	7aa2                	ld	s5,40(sp)
    8000278a:	7b02                	ld	s6,32(sp)
    8000278c:	6be2                	ld	s7,24(sp)
    8000278e:	6c42                	ld	s8,16(sp)
    80002790:	6ca2                	ld	s9,8(sp)
}
    80002792:	8526                	mv	a0,s1
    80002794:	60e6                	ld	ra,88(sp)
    80002796:	6446                	ld	s0,80(sp)
    80002798:	64a6                	ld	s1,72(sp)
    8000279a:	6125                	addi	sp,sp,96
    8000279c:	8082                	ret
    brelse(bp);
    8000279e:	854a                	mv	a0,s2
    800027a0:	00000097          	auipc	ra,0x0
    800027a4:	dc6080e7          	jalr	-570(ra) # 80002566 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800027a8:	015c87bb          	addw	a5,s9,s5
    800027ac:	00078a9b          	sext.w	s5,a5
    800027b0:	004b2703          	lw	a4,4(s6)
    800027b4:	06eaf163          	bgeu	s5,a4,80002816 <balloc+0x120>
    bp = bread(dev, BBLOCK(b, sb));
    800027b8:	41fad79b          	sraiw	a5,s5,0x1f
    800027bc:	0137d79b          	srliw	a5,a5,0x13
    800027c0:	015787bb          	addw	a5,a5,s5
    800027c4:	40d7d79b          	sraiw	a5,a5,0xd
    800027c8:	01cb2583          	lw	a1,28(s6)
    800027cc:	9dbd                	addw	a1,a1,a5
    800027ce:	855e                	mv	a0,s7
    800027d0:	00000097          	auipc	ra,0x0
    800027d4:	c66080e7          	jalr	-922(ra) # 80002436 <bread>
    800027d8:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027da:	004b2503          	lw	a0,4(s6)
    800027de:	000a849b          	sext.w	s1,s5
    800027e2:	8762                	mv	a4,s8
    800027e4:	faa4fde3          	bgeu	s1,a0,8000279e <balloc+0xa8>
      m = 1 << (bi % 8);
    800027e8:	00777693          	andi	a3,a4,7
    800027ec:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800027f0:	41f7579b          	sraiw	a5,a4,0x1f
    800027f4:	01d7d79b          	srliw	a5,a5,0x1d
    800027f8:	9fb9                	addw	a5,a5,a4
    800027fa:	4037d79b          	sraiw	a5,a5,0x3
    800027fe:	00f90633          	add	a2,s2,a5
    80002802:	05864603          	lbu	a2,88(a2)
    80002806:	00c6f5b3          	and	a1,a3,a2
    8000280a:	d585                	beqz	a1,80002732 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000280c:	2705                	addiw	a4,a4,1
    8000280e:	2485                	addiw	s1,s1,1
    80002810:	fd471ae3          	bne	a4,s4,800027e4 <balloc+0xee>
    80002814:	b769                	j	8000279e <balloc+0xa8>
    80002816:	6906                	ld	s2,64(sp)
    80002818:	79e2                	ld	s3,56(sp)
    8000281a:	7a42                	ld	s4,48(sp)
    8000281c:	7aa2                	ld	s5,40(sp)
    8000281e:	7b02                	ld	s6,32(sp)
    80002820:	6be2                	ld	s7,24(sp)
    80002822:	6c42                	ld	s8,16(sp)
    80002824:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80002826:	00006517          	auipc	a0,0x6
    8000282a:	bf250513          	addi	a0,a0,-1038 # 80008418 <etext+0x418>
    8000282e:	00003097          	auipc	ra,0x3
    80002832:	64e080e7          	jalr	1614(ra) # 80005e7c <printf>
  return 0;
    80002836:	4481                	li	s1,0
    80002838:	bfa9                	j	80002792 <balloc+0x9c>

000000008000283a <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000283a:	7179                	addi	sp,sp,-48
    8000283c:	f406                	sd	ra,40(sp)
    8000283e:	f022                	sd	s0,32(sp)
    80002840:	ec26                	sd	s1,24(sp)
    80002842:	e84a                	sd	s2,16(sp)
    80002844:	e44e                	sd	s3,8(sp)
    80002846:	1800                	addi	s0,sp,48
    80002848:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000284a:	47ad                	li	a5,11
    8000284c:	02b7e863          	bltu	a5,a1,8000287c <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    80002850:	02059793          	slli	a5,a1,0x20
    80002854:	01e7d593          	srli	a1,a5,0x1e
    80002858:	00b504b3          	add	s1,a0,a1
    8000285c:	0504a903          	lw	s2,80(s1)
    80002860:	08091263          	bnez	s2,800028e4 <bmap+0xaa>
      addr = balloc(ip->dev);
    80002864:	4108                	lw	a0,0(a0)
    80002866:	00000097          	auipc	ra,0x0
    8000286a:	e90080e7          	jalr	-368(ra) # 800026f6 <balloc>
    8000286e:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002872:	06090963          	beqz	s2,800028e4 <bmap+0xaa>
        return 0;
      ip->addrs[bn] = addr;
    80002876:	0524a823          	sw	s2,80(s1)
    8000287a:	a0ad                	j	800028e4 <bmap+0xaa>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000287c:	ff45849b          	addiw	s1,a1,-12
    80002880:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002884:	0ff00793          	li	a5,255
    80002888:	08e7e863          	bltu	a5,a4,80002918 <bmap+0xde>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000288c:	08052903          	lw	s2,128(a0)
    80002890:	00091f63          	bnez	s2,800028ae <bmap+0x74>
      addr = balloc(ip->dev);
    80002894:	4108                	lw	a0,0(a0)
    80002896:	00000097          	auipc	ra,0x0
    8000289a:	e60080e7          	jalr	-416(ra) # 800026f6 <balloc>
    8000289e:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800028a2:	04090163          	beqz	s2,800028e4 <bmap+0xaa>
    800028a6:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800028a8:	0929a023          	sw	s2,128(s3)
    800028ac:	a011                	j	800028b0 <bmap+0x76>
    800028ae:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800028b0:	85ca                	mv	a1,s2
    800028b2:	0009a503          	lw	a0,0(s3)
    800028b6:	00000097          	auipc	ra,0x0
    800028ba:	b80080e7          	jalr	-1152(ra) # 80002436 <bread>
    800028be:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800028c0:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800028c4:	02049713          	slli	a4,s1,0x20
    800028c8:	01e75593          	srli	a1,a4,0x1e
    800028cc:	00b784b3          	add	s1,a5,a1
    800028d0:	0004a903          	lw	s2,0(s1)
    800028d4:	02090063          	beqz	s2,800028f4 <bmap+0xba>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800028d8:	8552                	mv	a0,s4
    800028da:	00000097          	auipc	ra,0x0
    800028de:	c8c080e7          	jalr	-884(ra) # 80002566 <brelse>
    return addr;
    800028e2:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800028e4:	854a                	mv	a0,s2
    800028e6:	70a2                	ld	ra,40(sp)
    800028e8:	7402                	ld	s0,32(sp)
    800028ea:	64e2                	ld	s1,24(sp)
    800028ec:	6942                	ld	s2,16(sp)
    800028ee:	69a2                	ld	s3,8(sp)
    800028f0:	6145                	addi	sp,sp,48
    800028f2:	8082                	ret
      addr = balloc(ip->dev);
    800028f4:	0009a503          	lw	a0,0(s3)
    800028f8:	00000097          	auipc	ra,0x0
    800028fc:	dfe080e7          	jalr	-514(ra) # 800026f6 <balloc>
    80002900:	0005091b          	sext.w	s2,a0
      if(addr){
    80002904:	fc090ae3          	beqz	s2,800028d8 <bmap+0x9e>
        a[bn] = addr;
    80002908:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000290c:	8552                	mv	a0,s4
    8000290e:	00001097          	auipc	ra,0x1
    80002912:	f02080e7          	jalr	-254(ra) # 80003810 <log_write>
    80002916:	b7c9                	j	800028d8 <bmap+0x9e>
    80002918:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    8000291a:	00006517          	auipc	a0,0x6
    8000291e:	b1650513          	addi	a0,a0,-1258 # 80008430 <etext+0x430>
    80002922:	00003097          	auipc	ra,0x3
    80002926:	510080e7          	jalr	1296(ra) # 80005e32 <panic>

000000008000292a <iget>:
{
    8000292a:	7179                	addi	sp,sp,-48
    8000292c:	f406                	sd	ra,40(sp)
    8000292e:	f022                	sd	s0,32(sp)
    80002930:	ec26                	sd	s1,24(sp)
    80002932:	e84a                	sd	s2,16(sp)
    80002934:	e44e                	sd	s3,8(sp)
    80002936:	e052                	sd	s4,0(sp)
    80002938:	1800                	addi	s0,sp,48
    8000293a:	89aa                	mv	s3,a0
    8000293c:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000293e:	00017517          	auipc	a0,0x17
    80002942:	08a50513          	addi	a0,a0,138 # 800199c8 <itable>
    80002946:	00004097          	auipc	ra,0x4
    8000294a:	a66080e7          	jalr	-1434(ra) # 800063ac <acquire>
  empty = 0;
    8000294e:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002950:	00017497          	auipc	s1,0x17
    80002954:	09048493          	addi	s1,s1,144 # 800199e0 <itable+0x18>
    80002958:	00019697          	auipc	a3,0x19
    8000295c:	b1868693          	addi	a3,a3,-1256 # 8001b470 <log>
    80002960:	a039                	j	8000296e <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002962:	02090b63          	beqz	s2,80002998 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002966:	08848493          	addi	s1,s1,136
    8000296a:	02d48a63          	beq	s1,a3,8000299e <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000296e:	449c                	lw	a5,8(s1)
    80002970:	fef059e3          	blez	a5,80002962 <iget+0x38>
    80002974:	4098                	lw	a4,0(s1)
    80002976:	ff3716e3          	bne	a4,s3,80002962 <iget+0x38>
    8000297a:	40d8                	lw	a4,4(s1)
    8000297c:	ff4713e3          	bne	a4,s4,80002962 <iget+0x38>
      ip->ref++;
    80002980:	2785                	addiw	a5,a5,1
    80002982:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002984:	00017517          	auipc	a0,0x17
    80002988:	04450513          	addi	a0,a0,68 # 800199c8 <itable>
    8000298c:	00004097          	auipc	ra,0x4
    80002990:	ad4080e7          	jalr	-1324(ra) # 80006460 <release>
      return ip;
    80002994:	8926                	mv	s2,s1
    80002996:	a03d                	j	800029c4 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002998:	f7f9                	bnez	a5,80002966 <iget+0x3c>
      empty = ip;
    8000299a:	8926                	mv	s2,s1
    8000299c:	b7e9                	j	80002966 <iget+0x3c>
  if(empty == 0)
    8000299e:	02090c63          	beqz	s2,800029d6 <iget+0xac>
  ip->dev = dev;
    800029a2:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800029a6:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800029aa:	4785                	li	a5,1
    800029ac:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800029b0:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800029b4:	00017517          	auipc	a0,0x17
    800029b8:	01450513          	addi	a0,a0,20 # 800199c8 <itable>
    800029bc:	00004097          	auipc	ra,0x4
    800029c0:	aa4080e7          	jalr	-1372(ra) # 80006460 <release>
}
    800029c4:	854a                	mv	a0,s2
    800029c6:	70a2                	ld	ra,40(sp)
    800029c8:	7402                	ld	s0,32(sp)
    800029ca:	64e2                	ld	s1,24(sp)
    800029cc:	6942                	ld	s2,16(sp)
    800029ce:	69a2                	ld	s3,8(sp)
    800029d0:	6a02                	ld	s4,0(sp)
    800029d2:	6145                	addi	sp,sp,48
    800029d4:	8082                	ret
    panic("iget: no inodes");
    800029d6:	00006517          	auipc	a0,0x6
    800029da:	a7250513          	addi	a0,a0,-1422 # 80008448 <etext+0x448>
    800029de:	00003097          	auipc	ra,0x3
    800029e2:	454080e7          	jalr	1108(ra) # 80005e32 <panic>

00000000800029e6 <fsinit>:
fsinit(int dev) {
    800029e6:	7179                	addi	sp,sp,-48
    800029e8:	f406                	sd	ra,40(sp)
    800029ea:	f022                	sd	s0,32(sp)
    800029ec:	ec26                	sd	s1,24(sp)
    800029ee:	e84a                	sd	s2,16(sp)
    800029f0:	e44e                	sd	s3,8(sp)
    800029f2:	1800                	addi	s0,sp,48
    800029f4:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800029f6:	4585                	li	a1,1
    800029f8:	00000097          	auipc	ra,0x0
    800029fc:	a3e080e7          	jalr	-1474(ra) # 80002436 <bread>
    80002a00:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a02:	00017997          	auipc	s3,0x17
    80002a06:	fa698993          	addi	s3,s3,-90 # 800199a8 <sb>
    80002a0a:	02000613          	li	a2,32
    80002a0e:	05850593          	addi	a1,a0,88
    80002a12:	854e                	mv	a0,s3
    80002a14:	ffffd097          	auipc	ra,0xffffd
    80002a18:	7c2080e7          	jalr	1986(ra) # 800001d6 <memmove>
  brelse(bp);
    80002a1c:	8526                	mv	a0,s1
    80002a1e:	00000097          	auipc	ra,0x0
    80002a22:	b48080e7          	jalr	-1208(ra) # 80002566 <brelse>
  if(sb.magic != FSMAGIC)
    80002a26:	0009a703          	lw	a4,0(s3)
    80002a2a:	102037b7          	lui	a5,0x10203
    80002a2e:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a32:	02f71263          	bne	a4,a5,80002a56 <fsinit+0x70>
  initlog(dev, &sb);
    80002a36:	00017597          	auipc	a1,0x17
    80002a3a:	f7258593          	addi	a1,a1,-142 # 800199a8 <sb>
    80002a3e:	854a                	mv	a0,s2
    80002a40:	00001097          	auipc	ra,0x1
    80002a44:	b60080e7          	jalr	-1184(ra) # 800035a0 <initlog>
}
    80002a48:	70a2                	ld	ra,40(sp)
    80002a4a:	7402                	ld	s0,32(sp)
    80002a4c:	64e2                	ld	s1,24(sp)
    80002a4e:	6942                	ld	s2,16(sp)
    80002a50:	69a2                	ld	s3,8(sp)
    80002a52:	6145                	addi	sp,sp,48
    80002a54:	8082                	ret
    panic("invalid file system");
    80002a56:	00006517          	auipc	a0,0x6
    80002a5a:	a0250513          	addi	a0,a0,-1534 # 80008458 <etext+0x458>
    80002a5e:	00003097          	auipc	ra,0x3
    80002a62:	3d4080e7          	jalr	980(ra) # 80005e32 <panic>

0000000080002a66 <iinit>:
{
    80002a66:	7179                	addi	sp,sp,-48
    80002a68:	f406                	sd	ra,40(sp)
    80002a6a:	f022                	sd	s0,32(sp)
    80002a6c:	ec26                	sd	s1,24(sp)
    80002a6e:	e84a                	sd	s2,16(sp)
    80002a70:	e44e                	sd	s3,8(sp)
    80002a72:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a74:	00006597          	auipc	a1,0x6
    80002a78:	9fc58593          	addi	a1,a1,-1540 # 80008470 <etext+0x470>
    80002a7c:	00017517          	auipc	a0,0x17
    80002a80:	f4c50513          	addi	a0,a0,-180 # 800199c8 <itable>
    80002a84:	00004097          	auipc	ra,0x4
    80002a88:	898080e7          	jalr	-1896(ra) # 8000631c <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a8c:	00017497          	auipc	s1,0x17
    80002a90:	f6448493          	addi	s1,s1,-156 # 800199f0 <itable+0x28>
    80002a94:	00019997          	auipc	s3,0x19
    80002a98:	9ec98993          	addi	s3,s3,-1556 # 8001b480 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a9c:	00006917          	auipc	s2,0x6
    80002aa0:	9dc90913          	addi	s2,s2,-1572 # 80008478 <etext+0x478>
    80002aa4:	85ca                	mv	a1,s2
    80002aa6:	8526                	mv	a0,s1
    80002aa8:	00001097          	auipc	ra,0x1
    80002aac:	e4c080e7          	jalr	-436(ra) # 800038f4 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002ab0:	08848493          	addi	s1,s1,136
    80002ab4:	ff3498e3          	bne	s1,s3,80002aa4 <iinit+0x3e>
}
    80002ab8:	70a2                	ld	ra,40(sp)
    80002aba:	7402                	ld	s0,32(sp)
    80002abc:	64e2                	ld	s1,24(sp)
    80002abe:	6942                	ld	s2,16(sp)
    80002ac0:	69a2                	ld	s3,8(sp)
    80002ac2:	6145                	addi	sp,sp,48
    80002ac4:	8082                	ret

0000000080002ac6 <ialloc>:
{
    80002ac6:	7139                	addi	sp,sp,-64
    80002ac8:	fc06                	sd	ra,56(sp)
    80002aca:	f822                	sd	s0,48(sp)
    80002acc:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ace:	00017717          	auipc	a4,0x17
    80002ad2:	ee672703          	lw	a4,-282(a4) # 800199b4 <sb+0xc>
    80002ad6:	4785                	li	a5,1
    80002ad8:	06e7f463          	bgeu	a5,a4,80002b40 <ialloc+0x7a>
    80002adc:	f426                	sd	s1,40(sp)
    80002ade:	f04a                	sd	s2,32(sp)
    80002ae0:	ec4e                	sd	s3,24(sp)
    80002ae2:	e852                	sd	s4,16(sp)
    80002ae4:	e456                	sd	s5,8(sp)
    80002ae6:	e05a                	sd	s6,0(sp)
    80002ae8:	8aaa                	mv	s5,a0
    80002aea:	8b2e                	mv	s6,a1
    80002aec:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002aee:	00017a17          	auipc	s4,0x17
    80002af2:	ebaa0a13          	addi	s4,s4,-326 # 800199a8 <sb>
    80002af6:	00495593          	srli	a1,s2,0x4
    80002afa:	018a2783          	lw	a5,24(s4)
    80002afe:	9dbd                	addw	a1,a1,a5
    80002b00:	8556                	mv	a0,s5
    80002b02:	00000097          	auipc	ra,0x0
    80002b06:	934080e7          	jalr	-1740(ra) # 80002436 <bread>
    80002b0a:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002b0c:	05850993          	addi	s3,a0,88
    80002b10:	00f97793          	andi	a5,s2,15
    80002b14:	079a                	slli	a5,a5,0x6
    80002b16:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002b18:	00099783          	lh	a5,0(s3)
    80002b1c:	cf9d                	beqz	a5,80002b5a <ialloc+0x94>
    brelse(bp);
    80002b1e:	00000097          	auipc	ra,0x0
    80002b22:	a48080e7          	jalr	-1464(ra) # 80002566 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b26:	0905                	addi	s2,s2,1
    80002b28:	00ca2703          	lw	a4,12(s4)
    80002b2c:	0009079b          	sext.w	a5,s2
    80002b30:	fce7e3e3          	bltu	a5,a4,80002af6 <ialloc+0x30>
    80002b34:	74a2                	ld	s1,40(sp)
    80002b36:	7902                	ld	s2,32(sp)
    80002b38:	69e2                	ld	s3,24(sp)
    80002b3a:	6a42                	ld	s4,16(sp)
    80002b3c:	6aa2                	ld	s5,8(sp)
    80002b3e:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002b40:	00006517          	auipc	a0,0x6
    80002b44:	94050513          	addi	a0,a0,-1728 # 80008480 <etext+0x480>
    80002b48:	00003097          	auipc	ra,0x3
    80002b4c:	334080e7          	jalr	820(ra) # 80005e7c <printf>
  return 0;
    80002b50:	4501                	li	a0,0
}
    80002b52:	70e2                	ld	ra,56(sp)
    80002b54:	7442                	ld	s0,48(sp)
    80002b56:	6121                	addi	sp,sp,64
    80002b58:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002b5a:	04000613          	li	a2,64
    80002b5e:	4581                	li	a1,0
    80002b60:	854e                	mv	a0,s3
    80002b62:	ffffd097          	auipc	ra,0xffffd
    80002b66:	618080e7          	jalr	1560(ra) # 8000017a <memset>
      dip->type = type;
    80002b6a:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002b6e:	8526                	mv	a0,s1
    80002b70:	00001097          	auipc	ra,0x1
    80002b74:	ca0080e7          	jalr	-864(ra) # 80003810 <log_write>
      brelse(bp);
    80002b78:	8526                	mv	a0,s1
    80002b7a:	00000097          	auipc	ra,0x0
    80002b7e:	9ec080e7          	jalr	-1556(ra) # 80002566 <brelse>
      return iget(dev, inum);
    80002b82:	0009059b          	sext.w	a1,s2
    80002b86:	8556                	mv	a0,s5
    80002b88:	00000097          	auipc	ra,0x0
    80002b8c:	da2080e7          	jalr	-606(ra) # 8000292a <iget>
    80002b90:	74a2                	ld	s1,40(sp)
    80002b92:	7902                	ld	s2,32(sp)
    80002b94:	69e2                	ld	s3,24(sp)
    80002b96:	6a42                	ld	s4,16(sp)
    80002b98:	6aa2                	ld	s5,8(sp)
    80002b9a:	6b02                	ld	s6,0(sp)
    80002b9c:	bf5d                	j	80002b52 <ialloc+0x8c>

0000000080002b9e <iupdate>:
{
    80002b9e:	1101                	addi	sp,sp,-32
    80002ba0:	ec06                	sd	ra,24(sp)
    80002ba2:	e822                	sd	s0,16(sp)
    80002ba4:	e426                	sd	s1,8(sp)
    80002ba6:	e04a                	sd	s2,0(sp)
    80002ba8:	1000                	addi	s0,sp,32
    80002baa:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bac:	415c                	lw	a5,4(a0)
    80002bae:	0047d79b          	srliw	a5,a5,0x4
    80002bb2:	00017597          	auipc	a1,0x17
    80002bb6:	e0e5a583          	lw	a1,-498(a1) # 800199c0 <sb+0x18>
    80002bba:	9dbd                	addw	a1,a1,a5
    80002bbc:	4108                	lw	a0,0(a0)
    80002bbe:	00000097          	auipc	ra,0x0
    80002bc2:	878080e7          	jalr	-1928(ra) # 80002436 <bread>
    80002bc6:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002bc8:	05850793          	addi	a5,a0,88
    80002bcc:	40d8                	lw	a4,4(s1)
    80002bce:	8b3d                	andi	a4,a4,15
    80002bd0:	071a                	slli	a4,a4,0x6
    80002bd2:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002bd4:	04449703          	lh	a4,68(s1)
    80002bd8:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002bdc:	04649703          	lh	a4,70(s1)
    80002be0:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002be4:	04849703          	lh	a4,72(s1)
    80002be8:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002bec:	04a49703          	lh	a4,74(s1)
    80002bf0:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002bf4:	44f8                	lw	a4,76(s1)
    80002bf6:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002bf8:	03400613          	li	a2,52
    80002bfc:	05048593          	addi	a1,s1,80
    80002c00:	00c78513          	addi	a0,a5,12
    80002c04:	ffffd097          	auipc	ra,0xffffd
    80002c08:	5d2080e7          	jalr	1490(ra) # 800001d6 <memmove>
  log_write(bp);
    80002c0c:	854a                	mv	a0,s2
    80002c0e:	00001097          	auipc	ra,0x1
    80002c12:	c02080e7          	jalr	-1022(ra) # 80003810 <log_write>
  brelse(bp);
    80002c16:	854a                	mv	a0,s2
    80002c18:	00000097          	auipc	ra,0x0
    80002c1c:	94e080e7          	jalr	-1714(ra) # 80002566 <brelse>
}
    80002c20:	60e2                	ld	ra,24(sp)
    80002c22:	6442                	ld	s0,16(sp)
    80002c24:	64a2                	ld	s1,8(sp)
    80002c26:	6902                	ld	s2,0(sp)
    80002c28:	6105                	addi	sp,sp,32
    80002c2a:	8082                	ret

0000000080002c2c <idup>:
{
    80002c2c:	1101                	addi	sp,sp,-32
    80002c2e:	ec06                	sd	ra,24(sp)
    80002c30:	e822                	sd	s0,16(sp)
    80002c32:	e426                	sd	s1,8(sp)
    80002c34:	1000                	addi	s0,sp,32
    80002c36:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c38:	00017517          	auipc	a0,0x17
    80002c3c:	d9050513          	addi	a0,a0,-624 # 800199c8 <itable>
    80002c40:	00003097          	auipc	ra,0x3
    80002c44:	76c080e7          	jalr	1900(ra) # 800063ac <acquire>
  ip->ref++;
    80002c48:	449c                	lw	a5,8(s1)
    80002c4a:	2785                	addiw	a5,a5,1
    80002c4c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c4e:	00017517          	auipc	a0,0x17
    80002c52:	d7a50513          	addi	a0,a0,-646 # 800199c8 <itable>
    80002c56:	00004097          	auipc	ra,0x4
    80002c5a:	80a080e7          	jalr	-2038(ra) # 80006460 <release>
}
    80002c5e:	8526                	mv	a0,s1
    80002c60:	60e2                	ld	ra,24(sp)
    80002c62:	6442                	ld	s0,16(sp)
    80002c64:	64a2                	ld	s1,8(sp)
    80002c66:	6105                	addi	sp,sp,32
    80002c68:	8082                	ret

0000000080002c6a <ilock>:
{
    80002c6a:	1101                	addi	sp,sp,-32
    80002c6c:	ec06                	sd	ra,24(sp)
    80002c6e:	e822                	sd	s0,16(sp)
    80002c70:	e426                	sd	s1,8(sp)
    80002c72:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c74:	c10d                	beqz	a0,80002c96 <ilock+0x2c>
    80002c76:	84aa                	mv	s1,a0
    80002c78:	451c                	lw	a5,8(a0)
    80002c7a:	00f05e63          	blez	a5,80002c96 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002c7e:	0541                	addi	a0,a0,16
    80002c80:	00001097          	auipc	ra,0x1
    80002c84:	cae080e7          	jalr	-850(ra) # 8000392e <acquiresleep>
  if(ip->valid == 0){
    80002c88:	40bc                	lw	a5,64(s1)
    80002c8a:	cf99                	beqz	a5,80002ca8 <ilock+0x3e>
}
    80002c8c:	60e2                	ld	ra,24(sp)
    80002c8e:	6442                	ld	s0,16(sp)
    80002c90:	64a2                	ld	s1,8(sp)
    80002c92:	6105                	addi	sp,sp,32
    80002c94:	8082                	ret
    80002c96:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002c98:	00006517          	auipc	a0,0x6
    80002c9c:	80050513          	addi	a0,a0,-2048 # 80008498 <etext+0x498>
    80002ca0:	00003097          	auipc	ra,0x3
    80002ca4:	192080e7          	jalr	402(ra) # 80005e32 <panic>
    80002ca8:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002caa:	40dc                	lw	a5,4(s1)
    80002cac:	0047d79b          	srliw	a5,a5,0x4
    80002cb0:	00017597          	auipc	a1,0x17
    80002cb4:	d105a583          	lw	a1,-752(a1) # 800199c0 <sb+0x18>
    80002cb8:	9dbd                	addw	a1,a1,a5
    80002cba:	4088                	lw	a0,0(s1)
    80002cbc:	fffff097          	auipc	ra,0xfffff
    80002cc0:	77a080e7          	jalr	1914(ra) # 80002436 <bread>
    80002cc4:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002cc6:	05850593          	addi	a1,a0,88
    80002cca:	40dc                	lw	a5,4(s1)
    80002ccc:	8bbd                	andi	a5,a5,15
    80002cce:	079a                	slli	a5,a5,0x6
    80002cd0:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002cd2:	00059783          	lh	a5,0(a1)
    80002cd6:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002cda:	00259783          	lh	a5,2(a1)
    80002cde:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002ce2:	00459783          	lh	a5,4(a1)
    80002ce6:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002cea:	00659783          	lh	a5,6(a1)
    80002cee:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002cf2:	459c                	lw	a5,8(a1)
    80002cf4:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002cf6:	03400613          	li	a2,52
    80002cfa:	05b1                	addi	a1,a1,12
    80002cfc:	05048513          	addi	a0,s1,80
    80002d00:	ffffd097          	auipc	ra,0xffffd
    80002d04:	4d6080e7          	jalr	1238(ra) # 800001d6 <memmove>
    brelse(bp);
    80002d08:	854a                	mv	a0,s2
    80002d0a:	00000097          	auipc	ra,0x0
    80002d0e:	85c080e7          	jalr	-1956(ra) # 80002566 <brelse>
    ip->valid = 1;
    80002d12:	4785                	li	a5,1
    80002d14:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002d16:	04449783          	lh	a5,68(s1)
    80002d1a:	c399                	beqz	a5,80002d20 <ilock+0xb6>
    80002d1c:	6902                	ld	s2,0(sp)
    80002d1e:	b7bd                	j	80002c8c <ilock+0x22>
      panic("ilock: no type");
    80002d20:	00005517          	auipc	a0,0x5
    80002d24:	78050513          	addi	a0,a0,1920 # 800084a0 <etext+0x4a0>
    80002d28:	00003097          	auipc	ra,0x3
    80002d2c:	10a080e7          	jalr	266(ra) # 80005e32 <panic>

0000000080002d30 <iunlock>:
{
    80002d30:	1101                	addi	sp,sp,-32
    80002d32:	ec06                	sd	ra,24(sp)
    80002d34:	e822                	sd	s0,16(sp)
    80002d36:	e426                	sd	s1,8(sp)
    80002d38:	e04a                	sd	s2,0(sp)
    80002d3a:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002d3c:	c905                	beqz	a0,80002d6c <iunlock+0x3c>
    80002d3e:	84aa                	mv	s1,a0
    80002d40:	01050913          	addi	s2,a0,16
    80002d44:	854a                	mv	a0,s2
    80002d46:	00001097          	auipc	ra,0x1
    80002d4a:	c82080e7          	jalr	-894(ra) # 800039c8 <holdingsleep>
    80002d4e:	cd19                	beqz	a0,80002d6c <iunlock+0x3c>
    80002d50:	449c                	lw	a5,8(s1)
    80002d52:	00f05d63          	blez	a5,80002d6c <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002d56:	854a                	mv	a0,s2
    80002d58:	00001097          	auipc	ra,0x1
    80002d5c:	c2c080e7          	jalr	-980(ra) # 80003984 <releasesleep>
}
    80002d60:	60e2                	ld	ra,24(sp)
    80002d62:	6442                	ld	s0,16(sp)
    80002d64:	64a2                	ld	s1,8(sp)
    80002d66:	6902                	ld	s2,0(sp)
    80002d68:	6105                	addi	sp,sp,32
    80002d6a:	8082                	ret
    panic("iunlock");
    80002d6c:	00005517          	auipc	a0,0x5
    80002d70:	74450513          	addi	a0,a0,1860 # 800084b0 <etext+0x4b0>
    80002d74:	00003097          	auipc	ra,0x3
    80002d78:	0be080e7          	jalr	190(ra) # 80005e32 <panic>

0000000080002d7c <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d7c:	7179                	addi	sp,sp,-48
    80002d7e:	f406                	sd	ra,40(sp)
    80002d80:	f022                	sd	s0,32(sp)
    80002d82:	ec26                	sd	s1,24(sp)
    80002d84:	e84a                	sd	s2,16(sp)
    80002d86:	e44e                	sd	s3,8(sp)
    80002d88:	1800                	addi	s0,sp,48
    80002d8a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d8c:	05050493          	addi	s1,a0,80
    80002d90:	08050913          	addi	s2,a0,128
    80002d94:	a021                	j	80002d9c <itrunc+0x20>
    80002d96:	0491                	addi	s1,s1,4
    80002d98:	01248d63          	beq	s1,s2,80002db2 <itrunc+0x36>
    if(ip->addrs[i]){
    80002d9c:	408c                	lw	a1,0(s1)
    80002d9e:	dde5                	beqz	a1,80002d96 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002da0:	0009a503          	lw	a0,0(s3)
    80002da4:	00000097          	auipc	ra,0x0
    80002da8:	8d6080e7          	jalr	-1834(ra) # 8000267a <bfree>
      ip->addrs[i] = 0;
    80002dac:	0004a023          	sw	zero,0(s1)
    80002db0:	b7dd                	j	80002d96 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002db2:	0809a583          	lw	a1,128(s3)
    80002db6:	ed99                	bnez	a1,80002dd4 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002db8:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002dbc:	854e                	mv	a0,s3
    80002dbe:	00000097          	auipc	ra,0x0
    80002dc2:	de0080e7          	jalr	-544(ra) # 80002b9e <iupdate>
}
    80002dc6:	70a2                	ld	ra,40(sp)
    80002dc8:	7402                	ld	s0,32(sp)
    80002dca:	64e2                	ld	s1,24(sp)
    80002dcc:	6942                	ld	s2,16(sp)
    80002dce:	69a2                	ld	s3,8(sp)
    80002dd0:	6145                	addi	sp,sp,48
    80002dd2:	8082                	ret
    80002dd4:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002dd6:	0009a503          	lw	a0,0(s3)
    80002dda:	fffff097          	auipc	ra,0xfffff
    80002dde:	65c080e7          	jalr	1628(ra) # 80002436 <bread>
    80002de2:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002de4:	05850493          	addi	s1,a0,88
    80002de8:	45850913          	addi	s2,a0,1112
    80002dec:	a021                	j	80002df4 <itrunc+0x78>
    80002dee:	0491                	addi	s1,s1,4
    80002df0:	01248b63          	beq	s1,s2,80002e06 <itrunc+0x8a>
      if(a[j])
    80002df4:	408c                	lw	a1,0(s1)
    80002df6:	dde5                	beqz	a1,80002dee <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002df8:	0009a503          	lw	a0,0(s3)
    80002dfc:	00000097          	auipc	ra,0x0
    80002e00:	87e080e7          	jalr	-1922(ra) # 8000267a <bfree>
    80002e04:	b7ed                	j	80002dee <itrunc+0x72>
    brelse(bp);
    80002e06:	8552                	mv	a0,s4
    80002e08:	fffff097          	auipc	ra,0xfffff
    80002e0c:	75e080e7          	jalr	1886(ra) # 80002566 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e10:	0809a583          	lw	a1,128(s3)
    80002e14:	0009a503          	lw	a0,0(s3)
    80002e18:	00000097          	auipc	ra,0x0
    80002e1c:	862080e7          	jalr	-1950(ra) # 8000267a <bfree>
    ip->addrs[NDIRECT] = 0;
    80002e20:	0809a023          	sw	zero,128(s3)
    80002e24:	6a02                	ld	s4,0(sp)
    80002e26:	bf49                	j	80002db8 <itrunc+0x3c>

0000000080002e28 <iput>:
{
    80002e28:	1101                	addi	sp,sp,-32
    80002e2a:	ec06                	sd	ra,24(sp)
    80002e2c:	e822                	sd	s0,16(sp)
    80002e2e:	e426                	sd	s1,8(sp)
    80002e30:	1000                	addi	s0,sp,32
    80002e32:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e34:	00017517          	auipc	a0,0x17
    80002e38:	b9450513          	addi	a0,a0,-1132 # 800199c8 <itable>
    80002e3c:	00003097          	auipc	ra,0x3
    80002e40:	570080e7          	jalr	1392(ra) # 800063ac <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e44:	4498                	lw	a4,8(s1)
    80002e46:	4785                	li	a5,1
    80002e48:	02f70263          	beq	a4,a5,80002e6c <iput+0x44>
  ip->ref--;
    80002e4c:	449c                	lw	a5,8(s1)
    80002e4e:	37fd                	addiw	a5,a5,-1
    80002e50:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e52:	00017517          	auipc	a0,0x17
    80002e56:	b7650513          	addi	a0,a0,-1162 # 800199c8 <itable>
    80002e5a:	00003097          	auipc	ra,0x3
    80002e5e:	606080e7          	jalr	1542(ra) # 80006460 <release>
}
    80002e62:	60e2                	ld	ra,24(sp)
    80002e64:	6442                	ld	s0,16(sp)
    80002e66:	64a2                	ld	s1,8(sp)
    80002e68:	6105                	addi	sp,sp,32
    80002e6a:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e6c:	40bc                	lw	a5,64(s1)
    80002e6e:	dff9                	beqz	a5,80002e4c <iput+0x24>
    80002e70:	04a49783          	lh	a5,74(s1)
    80002e74:	ffe1                	bnez	a5,80002e4c <iput+0x24>
    80002e76:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002e78:	01048913          	addi	s2,s1,16
    80002e7c:	854a                	mv	a0,s2
    80002e7e:	00001097          	auipc	ra,0x1
    80002e82:	ab0080e7          	jalr	-1360(ra) # 8000392e <acquiresleep>
    release(&itable.lock);
    80002e86:	00017517          	auipc	a0,0x17
    80002e8a:	b4250513          	addi	a0,a0,-1214 # 800199c8 <itable>
    80002e8e:	00003097          	auipc	ra,0x3
    80002e92:	5d2080e7          	jalr	1490(ra) # 80006460 <release>
    itrunc(ip);
    80002e96:	8526                	mv	a0,s1
    80002e98:	00000097          	auipc	ra,0x0
    80002e9c:	ee4080e7          	jalr	-284(ra) # 80002d7c <itrunc>
    ip->type = 0;
    80002ea0:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002ea4:	8526                	mv	a0,s1
    80002ea6:	00000097          	auipc	ra,0x0
    80002eaa:	cf8080e7          	jalr	-776(ra) # 80002b9e <iupdate>
    ip->valid = 0;
    80002eae:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002eb2:	854a                	mv	a0,s2
    80002eb4:	00001097          	auipc	ra,0x1
    80002eb8:	ad0080e7          	jalr	-1328(ra) # 80003984 <releasesleep>
    acquire(&itable.lock);
    80002ebc:	00017517          	auipc	a0,0x17
    80002ec0:	b0c50513          	addi	a0,a0,-1268 # 800199c8 <itable>
    80002ec4:	00003097          	auipc	ra,0x3
    80002ec8:	4e8080e7          	jalr	1256(ra) # 800063ac <acquire>
    80002ecc:	6902                	ld	s2,0(sp)
    80002ece:	bfbd                	j	80002e4c <iput+0x24>

0000000080002ed0 <iunlockput>:
{
    80002ed0:	1101                	addi	sp,sp,-32
    80002ed2:	ec06                	sd	ra,24(sp)
    80002ed4:	e822                	sd	s0,16(sp)
    80002ed6:	e426                	sd	s1,8(sp)
    80002ed8:	1000                	addi	s0,sp,32
    80002eda:	84aa                	mv	s1,a0
  iunlock(ip);
    80002edc:	00000097          	auipc	ra,0x0
    80002ee0:	e54080e7          	jalr	-428(ra) # 80002d30 <iunlock>
  iput(ip);
    80002ee4:	8526                	mv	a0,s1
    80002ee6:	00000097          	auipc	ra,0x0
    80002eea:	f42080e7          	jalr	-190(ra) # 80002e28 <iput>
}
    80002eee:	60e2                	ld	ra,24(sp)
    80002ef0:	6442                	ld	s0,16(sp)
    80002ef2:	64a2                	ld	s1,8(sp)
    80002ef4:	6105                	addi	sp,sp,32
    80002ef6:	8082                	ret

0000000080002ef8 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002ef8:	1141                	addi	sp,sp,-16
    80002efa:	e422                	sd	s0,8(sp)
    80002efc:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002efe:	411c                	lw	a5,0(a0)
    80002f00:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f02:	415c                	lw	a5,4(a0)
    80002f04:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002f06:	04451783          	lh	a5,68(a0)
    80002f0a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002f0e:	04a51783          	lh	a5,74(a0)
    80002f12:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002f16:	04c56783          	lwu	a5,76(a0)
    80002f1a:	e99c                	sd	a5,16(a1)
}
    80002f1c:	6422                	ld	s0,8(sp)
    80002f1e:	0141                	addi	sp,sp,16
    80002f20:	8082                	ret

0000000080002f22 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f22:	457c                	lw	a5,76(a0)
    80002f24:	10d7e563          	bltu	a5,a3,8000302e <readi+0x10c>
{
    80002f28:	7159                	addi	sp,sp,-112
    80002f2a:	f486                	sd	ra,104(sp)
    80002f2c:	f0a2                	sd	s0,96(sp)
    80002f2e:	eca6                	sd	s1,88(sp)
    80002f30:	e0d2                	sd	s4,64(sp)
    80002f32:	fc56                	sd	s5,56(sp)
    80002f34:	f85a                	sd	s6,48(sp)
    80002f36:	f45e                	sd	s7,40(sp)
    80002f38:	1880                	addi	s0,sp,112
    80002f3a:	8b2a                	mv	s6,a0
    80002f3c:	8bae                	mv	s7,a1
    80002f3e:	8a32                	mv	s4,a2
    80002f40:	84b6                	mv	s1,a3
    80002f42:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002f44:	9f35                	addw	a4,a4,a3
    return 0;
    80002f46:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002f48:	0cd76a63          	bltu	a4,a3,8000301c <readi+0xfa>
    80002f4c:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002f4e:	00e7f463          	bgeu	a5,a4,80002f56 <readi+0x34>
    n = ip->size - off;
    80002f52:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f56:	0a0a8963          	beqz	s5,80003008 <readi+0xe6>
    80002f5a:	e8ca                	sd	s2,80(sp)
    80002f5c:	f062                	sd	s8,32(sp)
    80002f5e:	ec66                	sd	s9,24(sp)
    80002f60:	e86a                	sd	s10,16(sp)
    80002f62:	e46e                	sd	s11,8(sp)
    80002f64:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f66:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f6a:	5c7d                	li	s8,-1
    80002f6c:	a82d                	j	80002fa6 <readi+0x84>
    80002f6e:	020d1d93          	slli	s11,s10,0x20
    80002f72:	020ddd93          	srli	s11,s11,0x20
    80002f76:	05890613          	addi	a2,s2,88
    80002f7a:	86ee                	mv	a3,s11
    80002f7c:	963a                	add	a2,a2,a4
    80002f7e:	85d2                	mv	a1,s4
    80002f80:	855e                	mv	a0,s7
    80002f82:	fffff097          	auipc	ra,0xfffff
    80002f86:	ae2080e7          	jalr	-1310(ra) # 80001a64 <either_copyout>
    80002f8a:	05850d63          	beq	a0,s8,80002fe4 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f8e:	854a                	mv	a0,s2
    80002f90:	fffff097          	auipc	ra,0xfffff
    80002f94:	5d6080e7          	jalr	1494(ra) # 80002566 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f98:	013d09bb          	addw	s3,s10,s3
    80002f9c:	009d04bb          	addw	s1,s10,s1
    80002fa0:	9a6e                	add	s4,s4,s11
    80002fa2:	0559fd63          	bgeu	s3,s5,80002ffc <readi+0xda>
    uint addr = bmap(ip, off/BSIZE);
    80002fa6:	00a4d59b          	srliw	a1,s1,0xa
    80002faa:	855a                	mv	a0,s6
    80002fac:	00000097          	auipc	ra,0x0
    80002fb0:	88e080e7          	jalr	-1906(ra) # 8000283a <bmap>
    80002fb4:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002fb8:	c9b1                	beqz	a1,8000300c <readi+0xea>
    bp = bread(ip->dev, addr);
    80002fba:	000b2503          	lw	a0,0(s6)
    80002fbe:	fffff097          	auipc	ra,0xfffff
    80002fc2:	478080e7          	jalr	1144(ra) # 80002436 <bread>
    80002fc6:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fc8:	3ff4f713          	andi	a4,s1,1023
    80002fcc:	40ec87bb          	subw	a5,s9,a4
    80002fd0:	413a86bb          	subw	a3,s5,s3
    80002fd4:	8d3e                	mv	s10,a5
    80002fd6:	2781                	sext.w	a5,a5
    80002fd8:	0006861b          	sext.w	a2,a3
    80002fdc:	f8f679e3          	bgeu	a2,a5,80002f6e <readi+0x4c>
    80002fe0:	8d36                	mv	s10,a3
    80002fe2:	b771                	j	80002f6e <readi+0x4c>
      brelse(bp);
    80002fe4:	854a                	mv	a0,s2
    80002fe6:	fffff097          	auipc	ra,0xfffff
    80002fea:	580080e7          	jalr	1408(ra) # 80002566 <brelse>
      tot = -1;
    80002fee:	59fd                	li	s3,-1
      break;
    80002ff0:	6946                	ld	s2,80(sp)
    80002ff2:	7c02                	ld	s8,32(sp)
    80002ff4:	6ce2                	ld	s9,24(sp)
    80002ff6:	6d42                	ld	s10,16(sp)
    80002ff8:	6da2                	ld	s11,8(sp)
    80002ffa:	a831                	j	80003016 <readi+0xf4>
    80002ffc:	6946                	ld	s2,80(sp)
    80002ffe:	7c02                	ld	s8,32(sp)
    80003000:	6ce2                	ld	s9,24(sp)
    80003002:	6d42                	ld	s10,16(sp)
    80003004:	6da2                	ld	s11,8(sp)
    80003006:	a801                	j	80003016 <readi+0xf4>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003008:	89d6                	mv	s3,s5
    8000300a:	a031                	j	80003016 <readi+0xf4>
    8000300c:	6946                	ld	s2,80(sp)
    8000300e:	7c02                	ld	s8,32(sp)
    80003010:	6ce2                	ld	s9,24(sp)
    80003012:	6d42                	ld	s10,16(sp)
    80003014:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003016:	0009851b          	sext.w	a0,s3
    8000301a:	69a6                	ld	s3,72(sp)
}
    8000301c:	70a6                	ld	ra,104(sp)
    8000301e:	7406                	ld	s0,96(sp)
    80003020:	64e6                	ld	s1,88(sp)
    80003022:	6a06                	ld	s4,64(sp)
    80003024:	7ae2                	ld	s5,56(sp)
    80003026:	7b42                	ld	s6,48(sp)
    80003028:	7ba2                	ld	s7,40(sp)
    8000302a:	6165                	addi	sp,sp,112
    8000302c:	8082                	ret
    return 0;
    8000302e:	4501                	li	a0,0
}
    80003030:	8082                	ret

0000000080003032 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003032:	457c                	lw	a5,76(a0)
    80003034:	10d7ee63          	bltu	a5,a3,80003150 <writei+0x11e>
{
    80003038:	7159                	addi	sp,sp,-112
    8000303a:	f486                	sd	ra,104(sp)
    8000303c:	f0a2                	sd	s0,96(sp)
    8000303e:	e8ca                	sd	s2,80(sp)
    80003040:	e0d2                	sd	s4,64(sp)
    80003042:	fc56                	sd	s5,56(sp)
    80003044:	f85a                	sd	s6,48(sp)
    80003046:	f45e                	sd	s7,40(sp)
    80003048:	1880                	addi	s0,sp,112
    8000304a:	8aaa                	mv	s5,a0
    8000304c:	8bae                	mv	s7,a1
    8000304e:	8a32                	mv	s4,a2
    80003050:	8936                	mv	s2,a3
    80003052:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003054:	00e687bb          	addw	a5,a3,a4
    80003058:	0ed7ee63          	bltu	a5,a3,80003154 <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000305c:	00043737          	lui	a4,0x43
    80003060:	0ef76c63          	bltu	a4,a5,80003158 <writei+0x126>
    80003064:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003066:	0c0b0d63          	beqz	s6,80003140 <writei+0x10e>
    8000306a:	eca6                	sd	s1,88(sp)
    8000306c:	f062                	sd	s8,32(sp)
    8000306e:	ec66                	sd	s9,24(sp)
    80003070:	e86a                	sd	s10,16(sp)
    80003072:	e46e                	sd	s11,8(sp)
    80003074:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003076:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000307a:	5c7d                	li	s8,-1
    8000307c:	a091                	j	800030c0 <writei+0x8e>
    8000307e:	020d1d93          	slli	s11,s10,0x20
    80003082:	020ddd93          	srli	s11,s11,0x20
    80003086:	05848513          	addi	a0,s1,88
    8000308a:	86ee                	mv	a3,s11
    8000308c:	8652                	mv	a2,s4
    8000308e:	85de                	mv	a1,s7
    80003090:	953a                	add	a0,a0,a4
    80003092:	fffff097          	auipc	ra,0xfffff
    80003096:	a28080e7          	jalr	-1496(ra) # 80001aba <either_copyin>
    8000309a:	07850263          	beq	a0,s8,800030fe <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000309e:	8526                	mv	a0,s1
    800030a0:	00000097          	auipc	ra,0x0
    800030a4:	770080e7          	jalr	1904(ra) # 80003810 <log_write>
    brelse(bp);
    800030a8:	8526                	mv	a0,s1
    800030aa:	fffff097          	auipc	ra,0xfffff
    800030ae:	4bc080e7          	jalr	1212(ra) # 80002566 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030b2:	013d09bb          	addw	s3,s10,s3
    800030b6:	012d093b          	addw	s2,s10,s2
    800030ba:	9a6e                	add	s4,s4,s11
    800030bc:	0569f663          	bgeu	s3,s6,80003108 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    800030c0:	00a9559b          	srliw	a1,s2,0xa
    800030c4:	8556                	mv	a0,s5
    800030c6:	fffff097          	auipc	ra,0xfffff
    800030ca:	774080e7          	jalr	1908(ra) # 8000283a <bmap>
    800030ce:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800030d2:	c99d                	beqz	a1,80003108 <writei+0xd6>
    bp = bread(ip->dev, addr);
    800030d4:	000aa503          	lw	a0,0(s5)
    800030d8:	fffff097          	auipc	ra,0xfffff
    800030dc:	35e080e7          	jalr	862(ra) # 80002436 <bread>
    800030e0:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030e2:	3ff97713          	andi	a4,s2,1023
    800030e6:	40ec87bb          	subw	a5,s9,a4
    800030ea:	413b06bb          	subw	a3,s6,s3
    800030ee:	8d3e                	mv	s10,a5
    800030f0:	2781                	sext.w	a5,a5
    800030f2:	0006861b          	sext.w	a2,a3
    800030f6:	f8f674e3          	bgeu	a2,a5,8000307e <writei+0x4c>
    800030fa:	8d36                	mv	s10,a3
    800030fc:	b749                	j	8000307e <writei+0x4c>
      brelse(bp);
    800030fe:	8526                	mv	a0,s1
    80003100:	fffff097          	auipc	ra,0xfffff
    80003104:	466080e7          	jalr	1126(ra) # 80002566 <brelse>
  }

  if(off > ip->size)
    80003108:	04caa783          	lw	a5,76(s5)
    8000310c:	0327fc63          	bgeu	a5,s2,80003144 <writei+0x112>
    ip->size = off;
    80003110:	052aa623          	sw	s2,76(s5)
    80003114:	64e6                	ld	s1,88(sp)
    80003116:	7c02                	ld	s8,32(sp)
    80003118:	6ce2                	ld	s9,24(sp)
    8000311a:	6d42                	ld	s10,16(sp)
    8000311c:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000311e:	8556                	mv	a0,s5
    80003120:	00000097          	auipc	ra,0x0
    80003124:	a7e080e7          	jalr	-1410(ra) # 80002b9e <iupdate>

  return tot;
    80003128:	0009851b          	sext.w	a0,s3
    8000312c:	69a6                	ld	s3,72(sp)
}
    8000312e:	70a6                	ld	ra,104(sp)
    80003130:	7406                	ld	s0,96(sp)
    80003132:	6946                	ld	s2,80(sp)
    80003134:	6a06                	ld	s4,64(sp)
    80003136:	7ae2                	ld	s5,56(sp)
    80003138:	7b42                	ld	s6,48(sp)
    8000313a:	7ba2                	ld	s7,40(sp)
    8000313c:	6165                	addi	sp,sp,112
    8000313e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003140:	89da                	mv	s3,s6
    80003142:	bff1                	j	8000311e <writei+0xec>
    80003144:	64e6                	ld	s1,88(sp)
    80003146:	7c02                	ld	s8,32(sp)
    80003148:	6ce2                	ld	s9,24(sp)
    8000314a:	6d42                	ld	s10,16(sp)
    8000314c:	6da2                	ld	s11,8(sp)
    8000314e:	bfc1                	j	8000311e <writei+0xec>
    return -1;
    80003150:	557d                	li	a0,-1
}
    80003152:	8082                	ret
    return -1;
    80003154:	557d                	li	a0,-1
    80003156:	bfe1                	j	8000312e <writei+0xfc>
    return -1;
    80003158:	557d                	li	a0,-1
    8000315a:	bfd1                	j	8000312e <writei+0xfc>

000000008000315c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000315c:	1141                	addi	sp,sp,-16
    8000315e:	e406                	sd	ra,8(sp)
    80003160:	e022                	sd	s0,0(sp)
    80003162:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003164:	4639                	li	a2,14
    80003166:	ffffd097          	auipc	ra,0xffffd
    8000316a:	0e4080e7          	jalr	228(ra) # 8000024a <strncmp>
}
    8000316e:	60a2                	ld	ra,8(sp)
    80003170:	6402                	ld	s0,0(sp)
    80003172:	0141                	addi	sp,sp,16
    80003174:	8082                	ret

0000000080003176 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003176:	7139                	addi	sp,sp,-64
    80003178:	fc06                	sd	ra,56(sp)
    8000317a:	f822                	sd	s0,48(sp)
    8000317c:	f426                	sd	s1,40(sp)
    8000317e:	f04a                	sd	s2,32(sp)
    80003180:	ec4e                	sd	s3,24(sp)
    80003182:	e852                	sd	s4,16(sp)
    80003184:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003186:	04451703          	lh	a4,68(a0)
    8000318a:	4785                	li	a5,1
    8000318c:	00f71a63          	bne	a4,a5,800031a0 <dirlookup+0x2a>
    80003190:	892a                	mv	s2,a0
    80003192:	89ae                	mv	s3,a1
    80003194:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003196:	457c                	lw	a5,76(a0)
    80003198:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000319a:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000319c:	e79d                	bnez	a5,800031ca <dirlookup+0x54>
    8000319e:	a8a5                	j	80003216 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800031a0:	00005517          	auipc	a0,0x5
    800031a4:	31850513          	addi	a0,a0,792 # 800084b8 <etext+0x4b8>
    800031a8:	00003097          	auipc	ra,0x3
    800031ac:	c8a080e7          	jalr	-886(ra) # 80005e32 <panic>
      panic("dirlookup read");
    800031b0:	00005517          	auipc	a0,0x5
    800031b4:	32050513          	addi	a0,a0,800 # 800084d0 <etext+0x4d0>
    800031b8:	00003097          	auipc	ra,0x3
    800031bc:	c7a080e7          	jalr	-902(ra) # 80005e32 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031c0:	24c1                	addiw	s1,s1,16
    800031c2:	04c92783          	lw	a5,76(s2)
    800031c6:	04f4f763          	bgeu	s1,a5,80003214 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031ca:	4741                	li	a4,16
    800031cc:	86a6                	mv	a3,s1
    800031ce:	fc040613          	addi	a2,s0,-64
    800031d2:	4581                	li	a1,0
    800031d4:	854a                	mv	a0,s2
    800031d6:	00000097          	auipc	ra,0x0
    800031da:	d4c080e7          	jalr	-692(ra) # 80002f22 <readi>
    800031de:	47c1                	li	a5,16
    800031e0:	fcf518e3          	bne	a0,a5,800031b0 <dirlookup+0x3a>
    if(de.inum == 0)
    800031e4:	fc045783          	lhu	a5,-64(s0)
    800031e8:	dfe1                	beqz	a5,800031c0 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800031ea:	fc240593          	addi	a1,s0,-62
    800031ee:	854e                	mv	a0,s3
    800031f0:	00000097          	auipc	ra,0x0
    800031f4:	f6c080e7          	jalr	-148(ra) # 8000315c <namecmp>
    800031f8:	f561                	bnez	a0,800031c0 <dirlookup+0x4a>
      if(poff)
    800031fa:	000a0463          	beqz	s4,80003202 <dirlookup+0x8c>
        *poff = off;
    800031fe:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003202:	fc045583          	lhu	a1,-64(s0)
    80003206:	00092503          	lw	a0,0(s2)
    8000320a:	fffff097          	auipc	ra,0xfffff
    8000320e:	720080e7          	jalr	1824(ra) # 8000292a <iget>
    80003212:	a011                	j	80003216 <dirlookup+0xa0>
  return 0;
    80003214:	4501                	li	a0,0
}
    80003216:	70e2                	ld	ra,56(sp)
    80003218:	7442                	ld	s0,48(sp)
    8000321a:	74a2                	ld	s1,40(sp)
    8000321c:	7902                	ld	s2,32(sp)
    8000321e:	69e2                	ld	s3,24(sp)
    80003220:	6a42                	ld	s4,16(sp)
    80003222:	6121                	addi	sp,sp,64
    80003224:	8082                	ret

0000000080003226 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003226:	711d                	addi	sp,sp,-96
    80003228:	ec86                	sd	ra,88(sp)
    8000322a:	e8a2                	sd	s0,80(sp)
    8000322c:	e4a6                	sd	s1,72(sp)
    8000322e:	e0ca                	sd	s2,64(sp)
    80003230:	fc4e                	sd	s3,56(sp)
    80003232:	f852                	sd	s4,48(sp)
    80003234:	f456                	sd	s5,40(sp)
    80003236:	f05a                	sd	s6,32(sp)
    80003238:	ec5e                	sd	s7,24(sp)
    8000323a:	e862                	sd	s8,16(sp)
    8000323c:	e466                	sd	s9,8(sp)
    8000323e:	1080                	addi	s0,sp,96
    80003240:	84aa                	mv	s1,a0
    80003242:	8b2e                	mv	s6,a1
    80003244:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003246:	00054703          	lbu	a4,0(a0)
    8000324a:	02f00793          	li	a5,47
    8000324e:	02f70263          	beq	a4,a5,80003272 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003252:	ffffe097          	auipc	ra,0xffffe
    80003256:	cb0080e7          	jalr	-848(ra) # 80000f02 <myproc>
    8000325a:	15853503          	ld	a0,344(a0)
    8000325e:	00000097          	auipc	ra,0x0
    80003262:	9ce080e7          	jalr	-1586(ra) # 80002c2c <idup>
    80003266:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003268:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000326c:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000326e:	4b85                	li	s7,1
    80003270:	a875                	j	8000332c <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003272:	4585                	li	a1,1
    80003274:	4505                	li	a0,1
    80003276:	fffff097          	auipc	ra,0xfffff
    8000327a:	6b4080e7          	jalr	1716(ra) # 8000292a <iget>
    8000327e:	8a2a                	mv	s4,a0
    80003280:	b7e5                	j	80003268 <namex+0x42>
      iunlockput(ip);
    80003282:	8552                	mv	a0,s4
    80003284:	00000097          	auipc	ra,0x0
    80003288:	c4c080e7          	jalr	-948(ra) # 80002ed0 <iunlockput>
      return 0;
    8000328c:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000328e:	8552                	mv	a0,s4
    80003290:	60e6                	ld	ra,88(sp)
    80003292:	6446                	ld	s0,80(sp)
    80003294:	64a6                	ld	s1,72(sp)
    80003296:	6906                	ld	s2,64(sp)
    80003298:	79e2                	ld	s3,56(sp)
    8000329a:	7a42                	ld	s4,48(sp)
    8000329c:	7aa2                	ld	s5,40(sp)
    8000329e:	7b02                	ld	s6,32(sp)
    800032a0:	6be2                	ld	s7,24(sp)
    800032a2:	6c42                	ld	s8,16(sp)
    800032a4:	6ca2                	ld	s9,8(sp)
    800032a6:	6125                	addi	sp,sp,96
    800032a8:	8082                	ret
      iunlock(ip);
    800032aa:	8552                	mv	a0,s4
    800032ac:	00000097          	auipc	ra,0x0
    800032b0:	a84080e7          	jalr	-1404(ra) # 80002d30 <iunlock>
      return ip;
    800032b4:	bfe9                	j	8000328e <namex+0x68>
      iunlockput(ip);
    800032b6:	8552                	mv	a0,s4
    800032b8:	00000097          	auipc	ra,0x0
    800032bc:	c18080e7          	jalr	-1000(ra) # 80002ed0 <iunlockput>
      return 0;
    800032c0:	8a4e                	mv	s4,s3
    800032c2:	b7f1                	j	8000328e <namex+0x68>
  len = path - s;
    800032c4:	40998633          	sub	a2,s3,s1
    800032c8:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800032cc:	099c5863          	bge	s8,s9,8000335c <namex+0x136>
    memmove(name, s, DIRSIZ);
    800032d0:	4639                	li	a2,14
    800032d2:	85a6                	mv	a1,s1
    800032d4:	8556                	mv	a0,s5
    800032d6:	ffffd097          	auipc	ra,0xffffd
    800032da:	f00080e7          	jalr	-256(ra) # 800001d6 <memmove>
    800032de:	84ce                	mv	s1,s3
  while(*path == '/')
    800032e0:	0004c783          	lbu	a5,0(s1)
    800032e4:	01279763          	bne	a5,s2,800032f2 <namex+0xcc>
    path++;
    800032e8:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032ea:	0004c783          	lbu	a5,0(s1)
    800032ee:	ff278de3          	beq	a5,s2,800032e8 <namex+0xc2>
    ilock(ip);
    800032f2:	8552                	mv	a0,s4
    800032f4:	00000097          	auipc	ra,0x0
    800032f8:	976080e7          	jalr	-1674(ra) # 80002c6a <ilock>
    if(ip->type != T_DIR){
    800032fc:	044a1783          	lh	a5,68(s4)
    80003300:	f97791e3          	bne	a5,s7,80003282 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80003304:	000b0563          	beqz	s6,8000330e <namex+0xe8>
    80003308:	0004c783          	lbu	a5,0(s1)
    8000330c:	dfd9                	beqz	a5,800032aa <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000330e:	4601                	li	a2,0
    80003310:	85d6                	mv	a1,s5
    80003312:	8552                	mv	a0,s4
    80003314:	00000097          	auipc	ra,0x0
    80003318:	e62080e7          	jalr	-414(ra) # 80003176 <dirlookup>
    8000331c:	89aa                	mv	s3,a0
    8000331e:	dd41                	beqz	a0,800032b6 <namex+0x90>
    iunlockput(ip);
    80003320:	8552                	mv	a0,s4
    80003322:	00000097          	auipc	ra,0x0
    80003326:	bae080e7          	jalr	-1106(ra) # 80002ed0 <iunlockput>
    ip = next;
    8000332a:	8a4e                	mv	s4,s3
  while(*path == '/')
    8000332c:	0004c783          	lbu	a5,0(s1)
    80003330:	01279763          	bne	a5,s2,8000333e <namex+0x118>
    path++;
    80003334:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003336:	0004c783          	lbu	a5,0(s1)
    8000333a:	ff278de3          	beq	a5,s2,80003334 <namex+0x10e>
  if(*path == 0)
    8000333e:	cb9d                	beqz	a5,80003374 <namex+0x14e>
  while(*path != '/' && *path != 0)
    80003340:	0004c783          	lbu	a5,0(s1)
    80003344:	89a6                	mv	s3,s1
  len = path - s;
    80003346:	4c81                	li	s9,0
    80003348:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    8000334a:	01278963          	beq	a5,s2,8000335c <namex+0x136>
    8000334e:	dbbd                	beqz	a5,800032c4 <namex+0x9e>
    path++;
    80003350:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003352:	0009c783          	lbu	a5,0(s3)
    80003356:	ff279ce3          	bne	a5,s2,8000334e <namex+0x128>
    8000335a:	b7ad                	j	800032c4 <namex+0x9e>
    memmove(name, s, len);
    8000335c:	2601                	sext.w	a2,a2
    8000335e:	85a6                	mv	a1,s1
    80003360:	8556                	mv	a0,s5
    80003362:	ffffd097          	auipc	ra,0xffffd
    80003366:	e74080e7          	jalr	-396(ra) # 800001d6 <memmove>
    name[len] = 0;
    8000336a:	9cd6                	add	s9,s9,s5
    8000336c:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003370:	84ce                	mv	s1,s3
    80003372:	b7bd                	j	800032e0 <namex+0xba>
  if(nameiparent){
    80003374:	f00b0de3          	beqz	s6,8000328e <namex+0x68>
    iput(ip);
    80003378:	8552                	mv	a0,s4
    8000337a:	00000097          	auipc	ra,0x0
    8000337e:	aae080e7          	jalr	-1362(ra) # 80002e28 <iput>
    return 0;
    80003382:	4a01                	li	s4,0
    80003384:	b729                	j	8000328e <namex+0x68>

0000000080003386 <dirlink>:
{
    80003386:	7139                	addi	sp,sp,-64
    80003388:	fc06                	sd	ra,56(sp)
    8000338a:	f822                	sd	s0,48(sp)
    8000338c:	f04a                	sd	s2,32(sp)
    8000338e:	ec4e                	sd	s3,24(sp)
    80003390:	e852                	sd	s4,16(sp)
    80003392:	0080                	addi	s0,sp,64
    80003394:	892a                	mv	s2,a0
    80003396:	8a2e                	mv	s4,a1
    80003398:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000339a:	4601                	li	a2,0
    8000339c:	00000097          	auipc	ra,0x0
    800033a0:	dda080e7          	jalr	-550(ra) # 80003176 <dirlookup>
    800033a4:	ed25                	bnez	a0,8000341c <dirlink+0x96>
    800033a6:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033a8:	04c92483          	lw	s1,76(s2)
    800033ac:	c49d                	beqz	s1,800033da <dirlink+0x54>
    800033ae:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033b0:	4741                	li	a4,16
    800033b2:	86a6                	mv	a3,s1
    800033b4:	fc040613          	addi	a2,s0,-64
    800033b8:	4581                	li	a1,0
    800033ba:	854a                	mv	a0,s2
    800033bc:	00000097          	auipc	ra,0x0
    800033c0:	b66080e7          	jalr	-1178(ra) # 80002f22 <readi>
    800033c4:	47c1                	li	a5,16
    800033c6:	06f51163          	bne	a0,a5,80003428 <dirlink+0xa2>
    if(de.inum == 0)
    800033ca:	fc045783          	lhu	a5,-64(s0)
    800033ce:	c791                	beqz	a5,800033da <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033d0:	24c1                	addiw	s1,s1,16
    800033d2:	04c92783          	lw	a5,76(s2)
    800033d6:	fcf4ede3          	bltu	s1,a5,800033b0 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800033da:	4639                	li	a2,14
    800033dc:	85d2                	mv	a1,s4
    800033de:	fc240513          	addi	a0,s0,-62
    800033e2:	ffffd097          	auipc	ra,0xffffd
    800033e6:	e9e080e7          	jalr	-354(ra) # 80000280 <strncpy>
  de.inum = inum;
    800033ea:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033ee:	4741                	li	a4,16
    800033f0:	86a6                	mv	a3,s1
    800033f2:	fc040613          	addi	a2,s0,-64
    800033f6:	4581                	li	a1,0
    800033f8:	854a                	mv	a0,s2
    800033fa:	00000097          	auipc	ra,0x0
    800033fe:	c38080e7          	jalr	-968(ra) # 80003032 <writei>
    80003402:	1541                	addi	a0,a0,-16
    80003404:	00a03533          	snez	a0,a0
    80003408:	40a00533          	neg	a0,a0
    8000340c:	74a2                	ld	s1,40(sp)
}
    8000340e:	70e2                	ld	ra,56(sp)
    80003410:	7442                	ld	s0,48(sp)
    80003412:	7902                	ld	s2,32(sp)
    80003414:	69e2                	ld	s3,24(sp)
    80003416:	6a42                	ld	s4,16(sp)
    80003418:	6121                	addi	sp,sp,64
    8000341a:	8082                	ret
    iput(ip);
    8000341c:	00000097          	auipc	ra,0x0
    80003420:	a0c080e7          	jalr	-1524(ra) # 80002e28 <iput>
    return -1;
    80003424:	557d                	li	a0,-1
    80003426:	b7e5                	j	8000340e <dirlink+0x88>
      panic("dirlink read");
    80003428:	00005517          	auipc	a0,0x5
    8000342c:	0b850513          	addi	a0,a0,184 # 800084e0 <etext+0x4e0>
    80003430:	00003097          	auipc	ra,0x3
    80003434:	a02080e7          	jalr	-1534(ra) # 80005e32 <panic>

0000000080003438 <namei>:

struct inode*
namei(char *path)
{
    80003438:	1101                	addi	sp,sp,-32
    8000343a:	ec06                	sd	ra,24(sp)
    8000343c:	e822                	sd	s0,16(sp)
    8000343e:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003440:	fe040613          	addi	a2,s0,-32
    80003444:	4581                	li	a1,0
    80003446:	00000097          	auipc	ra,0x0
    8000344a:	de0080e7          	jalr	-544(ra) # 80003226 <namex>
}
    8000344e:	60e2                	ld	ra,24(sp)
    80003450:	6442                	ld	s0,16(sp)
    80003452:	6105                	addi	sp,sp,32
    80003454:	8082                	ret

0000000080003456 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003456:	1141                	addi	sp,sp,-16
    80003458:	e406                	sd	ra,8(sp)
    8000345a:	e022                	sd	s0,0(sp)
    8000345c:	0800                	addi	s0,sp,16
    8000345e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003460:	4585                	li	a1,1
    80003462:	00000097          	auipc	ra,0x0
    80003466:	dc4080e7          	jalr	-572(ra) # 80003226 <namex>
}
    8000346a:	60a2                	ld	ra,8(sp)
    8000346c:	6402                	ld	s0,0(sp)
    8000346e:	0141                	addi	sp,sp,16
    80003470:	8082                	ret

0000000080003472 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003472:	1101                	addi	sp,sp,-32
    80003474:	ec06                	sd	ra,24(sp)
    80003476:	e822                	sd	s0,16(sp)
    80003478:	e426                	sd	s1,8(sp)
    8000347a:	e04a                	sd	s2,0(sp)
    8000347c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000347e:	00018917          	auipc	s2,0x18
    80003482:	ff290913          	addi	s2,s2,-14 # 8001b470 <log>
    80003486:	01892583          	lw	a1,24(s2)
    8000348a:	02892503          	lw	a0,40(s2)
    8000348e:	fffff097          	auipc	ra,0xfffff
    80003492:	fa8080e7          	jalr	-88(ra) # 80002436 <bread>
    80003496:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003498:	02c92603          	lw	a2,44(s2)
    8000349c:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000349e:	00c05f63          	blez	a2,800034bc <write_head+0x4a>
    800034a2:	00018717          	auipc	a4,0x18
    800034a6:	ffe70713          	addi	a4,a4,-2 # 8001b4a0 <log+0x30>
    800034aa:	87aa                	mv	a5,a0
    800034ac:	060a                	slli	a2,a2,0x2
    800034ae:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800034b0:	4314                	lw	a3,0(a4)
    800034b2:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800034b4:	0711                	addi	a4,a4,4
    800034b6:	0791                	addi	a5,a5,4
    800034b8:	fec79ce3          	bne	a5,a2,800034b0 <write_head+0x3e>
  }
  bwrite(buf);
    800034bc:	8526                	mv	a0,s1
    800034be:	fffff097          	auipc	ra,0xfffff
    800034c2:	06a080e7          	jalr	106(ra) # 80002528 <bwrite>
  brelse(buf);
    800034c6:	8526                	mv	a0,s1
    800034c8:	fffff097          	auipc	ra,0xfffff
    800034cc:	09e080e7          	jalr	158(ra) # 80002566 <brelse>
}
    800034d0:	60e2                	ld	ra,24(sp)
    800034d2:	6442                	ld	s0,16(sp)
    800034d4:	64a2                	ld	s1,8(sp)
    800034d6:	6902                	ld	s2,0(sp)
    800034d8:	6105                	addi	sp,sp,32
    800034da:	8082                	ret

00000000800034dc <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800034dc:	00018797          	auipc	a5,0x18
    800034e0:	fc07a783          	lw	a5,-64(a5) # 8001b49c <log+0x2c>
    800034e4:	0af05d63          	blez	a5,8000359e <install_trans+0xc2>
{
    800034e8:	7139                	addi	sp,sp,-64
    800034ea:	fc06                	sd	ra,56(sp)
    800034ec:	f822                	sd	s0,48(sp)
    800034ee:	f426                	sd	s1,40(sp)
    800034f0:	f04a                	sd	s2,32(sp)
    800034f2:	ec4e                	sd	s3,24(sp)
    800034f4:	e852                	sd	s4,16(sp)
    800034f6:	e456                	sd	s5,8(sp)
    800034f8:	e05a                	sd	s6,0(sp)
    800034fa:	0080                	addi	s0,sp,64
    800034fc:	8b2a                	mv	s6,a0
    800034fe:	00018a97          	auipc	s5,0x18
    80003502:	fa2a8a93          	addi	s5,s5,-94 # 8001b4a0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003506:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003508:	00018997          	auipc	s3,0x18
    8000350c:	f6898993          	addi	s3,s3,-152 # 8001b470 <log>
    80003510:	a00d                	j	80003532 <install_trans+0x56>
    brelse(lbuf);
    80003512:	854a                	mv	a0,s2
    80003514:	fffff097          	auipc	ra,0xfffff
    80003518:	052080e7          	jalr	82(ra) # 80002566 <brelse>
    brelse(dbuf);
    8000351c:	8526                	mv	a0,s1
    8000351e:	fffff097          	auipc	ra,0xfffff
    80003522:	048080e7          	jalr	72(ra) # 80002566 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003526:	2a05                	addiw	s4,s4,1
    80003528:	0a91                	addi	s5,s5,4
    8000352a:	02c9a783          	lw	a5,44(s3)
    8000352e:	04fa5e63          	bge	s4,a5,8000358a <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003532:	0189a583          	lw	a1,24(s3)
    80003536:	014585bb          	addw	a1,a1,s4
    8000353a:	2585                	addiw	a1,a1,1
    8000353c:	0289a503          	lw	a0,40(s3)
    80003540:	fffff097          	auipc	ra,0xfffff
    80003544:	ef6080e7          	jalr	-266(ra) # 80002436 <bread>
    80003548:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000354a:	000aa583          	lw	a1,0(s5)
    8000354e:	0289a503          	lw	a0,40(s3)
    80003552:	fffff097          	auipc	ra,0xfffff
    80003556:	ee4080e7          	jalr	-284(ra) # 80002436 <bread>
    8000355a:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000355c:	40000613          	li	a2,1024
    80003560:	05890593          	addi	a1,s2,88
    80003564:	05850513          	addi	a0,a0,88
    80003568:	ffffd097          	auipc	ra,0xffffd
    8000356c:	c6e080e7          	jalr	-914(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003570:	8526                	mv	a0,s1
    80003572:	fffff097          	auipc	ra,0xfffff
    80003576:	fb6080e7          	jalr	-74(ra) # 80002528 <bwrite>
    if(recovering == 0)
    8000357a:	f80b1ce3          	bnez	s6,80003512 <install_trans+0x36>
      bunpin(dbuf);
    8000357e:	8526                	mv	a0,s1
    80003580:	fffff097          	auipc	ra,0xfffff
    80003584:	0be080e7          	jalr	190(ra) # 8000263e <bunpin>
    80003588:	b769                	j	80003512 <install_trans+0x36>
}
    8000358a:	70e2                	ld	ra,56(sp)
    8000358c:	7442                	ld	s0,48(sp)
    8000358e:	74a2                	ld	s1,40(sp)
    80003590:	7902                	ld	s2,32(sp)
    80003592:	69e2                	ld	s3,24(sp)
    80003594:	6a42                	ld	s4,16(sp)
    80003596:	6aa2                	ld	s5,8(sp)
    80003598:	6b02                	ld	s6,0(sp)
    8000359a:	6121                	addi	sp,sp,64
    8000359c:	8082                	ret
    8000359e:	8082                	ret

00000000800035a0 <initlog>:
{
    800035a0:	7179                	addi	sp,sp,-48
    800035a2:	f406                	sd	ra,40(sp)
    800035a4:	f022                	sd	s0,32(sp)
    800035a6:	ec26                	sd	s1,24(sp)
    800035a8:	e84a                	sd	s2,16(sp)
    800035aa:	e44e                	sd	s3,8(sp)
    800035ac:	1800                	addi	s0,sp,48
    800035ae:	892a                	mv	s2,a0
    800035b0:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800035b2:	00018497          	auipc	s1,0x18
    800035b6:	ebe48493          	addi	s1,s1,-322 # 8001b470 <log>
    800035ba:	00005597          	auipc	a1,0x5
    800035be:	f3658593          	addi	a1,a1,-202 # 800084f0 <etext+0x4f0>
    800035c2:	8526                	mv	a0,s1
    800035c4:	00003097          	auipc	ra,0x3
    800035c8:	d58080e7          	jalr	-680(ra) # 8000631c <initlock>
  log.start = sb->logstart;
    800035cc:	0149a583          	lw	a1,20(s3)
    800035d0:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800035d2:	0109a783          	lw	a5,16(s3)
    800035d6:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800035d8:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800035dc:	854a                	mv	a0,s2
    800035de:	fffff097          	auipc	ra,0xfffff
    800035e2:	e58080e7          	jalr	-424(ra) # 80002436 <bread>
  log.lh.n = lh->n;
    800035e6:	4d30                	lw	a2,88(a0)
    800035e8:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800035ea:	00c05f63          	blez	a2,80003608 <initlog+0x68>
    800035ee:	87aa                	mv	a5,a0
    800035f0:	00018717          	auipc	a4,0x18
    800035f4:	eb070713          	addi	a4,a4,-336 # 8001b4a0 <log+0x30>
    800035f8:	060a                	slli	a2,a2,0x2
    800035fa:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800035fc:	4ff4                	lw	a3,92(a5)
    800035fe:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003600:	0791                	addi	a5,a5,4
    80003602:	0711                	addi	a4,a4,4
    80003604:	fec79ce3          	bne	a5,a2,800035fc <initlog+0x5c>
  brelse(buf);
    80003608:	fffff097          	auipc	ra,0xfffff
    8000360c:	f5e080e7          	jalr	-162(ra) # 80002566 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003610:	4505                	li	a0,1
    80003612:	00000097          	auipc	ra,0x0
    80003616:	eca080e7          	jalr	-310(ra) # 800034dc <install_trans>
  log.lh.n = 0;
    8000361a:	00018797          	auipc	a5,0x18
    8000361e:	e807a123          	sw	zero,-382(a5) # 8001b49c <log+0x2c>
  write_head(); // clear the log
    80003622:	00000097          	auipc	ra,0x0
    80003626:	e50080e7          	jalr	-432(ra) # 80003472 <write_head>
}
    8000362a:	70a2                	ld	ra,40(sp)
    8000362c:	7402                	ld	s0,32(sp)
    8000362e:	64e2                	ld	s1,24(sp)
    80003630:	6942                	ld	s2,16(sp)
    80003632:	69a2                	ld	s3,8(sp)
    80003634:	6145                	addi	sp,sp,48
    80003636:	8082                	ret

0000000080003638 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003638:	1101                	addi	sp,sp,-32
    8000363a:	ec06                	sd	ra,24(sp)
    8000363c:	e822                	sd	s0,16(sp)
    8000363e:	e426                	sd	s1,8(sp)
    80003640:	e04a                	sd	s2,0(sp)
    80003642:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003644:	00018517          	auipc	a0,0x18
    80003648:	e2c50513          	addi	a0,a0,-468 # 8001b470 <log>
    8000364c:	00003097          	auipc	ra,0x3
    80003650:	d60080e7          	jalr	-672(ra) # 800063ac <acquire>
  while(1){
    if(log.committing){
    80003654:	00018497          	auipc	s1,0x18
    80003658:	e1c48493          	addi	s1,s1,-484 # 8001b470 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000365c:	4979                	li	s2,30
    8000365e:	a039                	j	8000366c <begin_op+0x34>
      sleep(&log, &log.lock);
    80003660:	85a6                	mv	a1,s1
    80003662:	8526                	mv	a0,s1
    80003664:	ffffe097          	auipc	ra,0xffffe
    80003668:	ff8080e7          	jalr	-8(ra) # 8000165c <sleep>
    if(log.committing){
    8000366c:	50dc                	lw	a5,36(s1)
    8000366e:	fbed                	bnez	a5,80003660 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003670:	5098                	lw	a4,32(s1)
    80003672:	2705                	addiw	a4,a4,1
    80003674:	0027179b          	slliw	a5,a4,0x2
    80003678:	9fb9                	addw	a5,a5,a4
    8000367a:	0017979b          	slliw	a5,a5,0x1
    8000367e:	54d4                	lw	a3,44(s1)
    80003680:	9fb5                	addw	a5,a5,a3
    80003682:	00f95963          	bge	s2,a5,80003694 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003686:	85a6                	mv	a1,s1
    80003688:	8526                	mv	a0,s1
    8000368a:	ffffe097          	auipc	ra,0xffffe
    8000368e:	fd2080e7          	jalr	-46(ra) # 8000165c <sleep>
    80003692:	bfe9                	j	8000366c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003694:	00018517          	auipc	a0,0x18
    80003698:	ddc50513          	addi	a0,a0,-548 # 8001b470 <log>
    8000369c:	d118                	sw	a4,32(a0)
      release(&log.lock);
    8000369e:	00003097          	auipc	ra,0x3
    800036a2:	dc2080e7          	jalr	-574(ra) # 80006460 <release>
      break;
    }
  }
}
    800036a6:	60e2                	ld	ra,24(sp)
    800036a8:	6442                	ld	s0,16(sp)
    800036aa:	64a2                	ld	s1,8(sp)
    800036ac:	6902                	ld	s2,0(sp)
    800036ae:	6105                	addi	sp,sp,32
    800036b0:	8082                	ret

00000000800036b2 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800036b2:	7139                	addi	sp,sp,-64
    800036b4:	fc06                	sd	ra,56(sp)
    800036b6:	f822                	sd	s0,48(sp)
    800036b8:	f426                	sd	s1,40(sp)
    800036ba:	f04a                	sd	s2,32(sp)
    800036bc:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800036be:	00018497          	auipc	s1,0x18
    800036c2:	db248493          	addi	s1,s1,-590 # 8001b470 <log>
    800036c6:	8526                	mv	a0,s1
    800036c8:	00003097          	auipc	ra,0x3
    800036cc:	ce4080e7          	jalr	-796(ra) # 800063ac <acquire>
  log.outstanding -= 1;
    800036d0:	509c                	lw	a5,32(s1)
    800036d2:	37fd                	addiw	a5,a5,-1
    800036d4:	0007891b          	sext.w	s2,a5
    800036d8:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800036da:	50dc                	lw	a5,36(s1)
    800036dc:	e7b9                	bnez	a5,8000372a <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    800036de:	06091163          	bnez	s2,80003740 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800036e2:	00018497          	auipc	s1,0x18
    800036e6:	d8e48493          	addi	s1,s1,-626 # 8001b470 <log>
    800036ea:	4785                	li	a5,1
    800036ec:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800036ee:	8526                	mv	a0,s1
    800036f0:	00003097          	auipc	ra,0x3
    800036f4:	d70080e7          	jalr	-656(ra) # 80006460 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800036f8:	54dc                	lw	a5,44(s1)
    800036fa:	06f04763          	bgtz	a5,80003768 <end_op+0xb6>
    acquire(&log.lock);
    800036fe:	00018497          	auipc	s1,0x18
    80003702:	d7248493          	addi	s1,s1,-654 # 8001b470 <log>
    80003706:	8526                	mv	a0,s1
    80003708:	00003097          	auipc	ra,0x3
    8000370c:	ca4080e7          	jalr	-860(ra) # 800063ac <acquire>
    log.committing = 0;
    80003710:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003714:	8526                	mv	a0,s1
    80003716:	ffffe097          	auipc	ra,0xffffe
    8000371a:	faa080e7          	jalr	-86(ra) # 800016c0 <wakeup>
    release(&log.lock);
    8000371e:	8526                	mv	a0,s1
    80003720:	00003097          	auipc	ra,0x3
    80003724:	d40080e7          	jalr	-704(ra) # 80006460 <release>
}
    80003728:	a815                	j	8000375c <end_op+0xaa>
    8000372a:	ec4e                	sd	s3,24(sp)
    8000372c:	e852                	sd	s4,16(sp)
    8000372e:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003730:	00005517          	auipc	a0,0x5
    80003734:	dc850513          	addi	a0,a0,-568 # 800084f8 <etext+0x4f8>
    80003738:	00002097          	auipc	ra,0x2
    8000373c:	6fa080e7          	jalr	1786(ra) # 80005e32 <panic>
    wakeup(&log);
    80003740:	00018497          	auipc	s1,0x18
    80003744:	d3048493          	addi	s1,s1,-720 # 8001b470 <log>
    80003748:	8526                	mv	a0,s1
    8000374a:	ffffe097          	auipc	ra,0xffffe
    8000374e:	f76080e7          	jalr	-138(ra) # 800016c0 <wakeup>
  release(&log.lock);
    80003752:	8526                	mv	a0,s1
    80003754:	00003097          	auipc	ra,0x3
    80003758:	d0c080e7          	jalr	-756(ra) # 80006460 <release>
}
    8000375c:	70e2                	ld	ra,56(sp)
    8000375e:	7442                	ld	s0,48(sp)
    80003760:	74a2                	ld	s1,40(sp)
    80003762:	7902                	ld	s2,32(sp)
    80003764:	6121                	addi	sp,sp,64
    80003766:	8082                	ret
    80003768:	ec4e                	sd	s3,24(sp)
    8000376a:	e852                	sd	s4,16(sp)
    8000376c:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    8000376e:	00018a97          	auipc	s5,0x18
    80003772:	d32a8a93          	addi	s5,s5,-718 # 8001b4a0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003776:	00018a17          	auipc	s4,0x18
    8000377a:	cfaa0a13          	addi	s4,s4,-774 # 8001b470 <log>
    8000377e:	018a2583          	lw	a1,24(s4)
    80003782:	012585bb          	addw	a1,a1,s2
    80003786:	2585                	addiw	a1,a1,1
    80003788:	028a2503          	lw	a0,40(s4)
    8000378c:	fffff097          	auipc	ra,0xfffff
    80003790:	caa080e7          	jalr	-854(ra) # 80002436 <bread>
    80003794:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003796:	000aa583          	lw	a1,0(s5)
    8000379a:	028a2503          	lw	a0,40(s4)
    8000379e:	fffff097          	auipc	ra,0xfffff
    800037a2:	c98080e7          	jalr	-872(ra) # 80002436 <bread>
    800037a6:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800037a8:	40000613          	li	a2,1024
    800037ac:	05850593          	addi	a1,a0,88
    800037b0:	05848513          	addi	a0,s1,88
    800037b4:	ffffd097          	auipc	ra,0xffffd
    800037b8:	a22080e7          	jalr	-1502(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    800037bc:	8526                	mv	a0,s1
    800037be:	fffff097          	auipc	ra,0xfffff
    800037c2:	d6a080e7          	jalr	-662(ra) # 80002528 <bwrite>
    brelse(from);
    800037c6:	854e                	mv	a0,s3
    800037c8:	fffff097          	auipc	ra,0xfffff
    800037cc:	d9e080e7          	jalr	-610(ra) # 80002566 <brelse>
    brelse(to);
    800037d0:	8526                	mv	a0,s1
    800037d2:	fffff097          	auipc	ra,0xfffff
    800037d6:	d94080e7          	jalr	-620(ra) # 80002566 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037da:	2905                	addiw	s2,s2,1
    800037dc:	0a91                	addi	s5,s5,4
    800037de:	02ca2783          	lw	a5,44(s4)
    800037e2:	f8f94ee3          	blt	s2,a5,8000377e <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800037e6:	00000097          	auipc	ra,0x0
    800037ea:	c8c080e7          	jalr	-884(ra) # 80003472 <write_head>
    install_trans(0); // Now install writes to home locations
    800037ee:	4501                	li	a0,0
    800037f0:	00000097          	auipc	ra,0x0
    800037f4:	cec080e7          	jalr	-788(ra) # 800034dc <install_trans>
    log.lh.n = 0;
    800037f8:	00018797          	auipc	a5,0x18
    800037fc:	ca07a223          	sw	zero,-860(a5) # 8001b49c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003800:	00000097          	auipc	ra,0x0
    80003804:	c72080e7          	jalr	-910(ra) # 80003472 <write_head>
    80003808:	69e2                	ld	s3,24(sp)
    8000380a:	6a42                	ld	s4,16(sp)
    8000380c:	6aa2                	ld	s5,8(sp)
    8000380e:	bdc5                	j	800036fe <end_op+0x4c>

0000000080003810 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003810:	1101                	addi	sp,sp,-32
    80003812:	ec06                	sd	ra,24(sp)
    80003814:	e822                	sd	s0,16(sp)
    80003816:	e426                	sd	s1,8(sp)
    80003818:	e04a                	sd	s2,0(sp)
    8000381a:	1000                	addi	s0,sp,32
    8000381c:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000381e:	00018917          	auipc	s2,0x18
    80003822:	c5290913          	addi	s2,s2,-942 # 8001b470 <log>
    80003826:	854a                	mv	a0,s2
    80003828:	00003097          	auipc	ra,0x3
    8000382c:	b84080e7          	jalr	-1148(ra) # 800063ac <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003830:	02c92603          	lw	a2,44(s2)
    80003834:	47f5                	li	a5,29
    80003836:	06c7c563          	blt	a5,a2,800038a0 <log_write+0x90>
    8000383a:	00018797          	auipc	a5,0x18
    8000383e:	c527a783          	lw	a5,-942(a5) # 8001b48c <log+0x1c>
    80003842:	37fd                	addiw	a5,a5,-1
    80003844:	04f65e63          	bge	a2,a5,800038a0 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003848:	00018797          	auipc	a5,0x18
    8000384c:	c487a783          	lw	a5,-952(a5) # 8001b490 <log+0x20>
    80003850:	06f05063          	blez	a5,800038b0 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003854:	4781                	li	a5,0
    80003856:	06c05563          	blez	a2,800038c0 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000385a:	44cc                	lw	a1,12(s1)
    8000385c:	00018717          	auipc	a4,0x18
    80003860:	c4470713          	addi	a4,a4,-956 # 8001b4a0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003864:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003866:	4314                	lw	a3,0(a4)
    80003868:	04b68c63          	beq	a3,a1,800038c0 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000386c:	2785                	addiw	a5,a5,1
    8000386e:	0711                	addi	a4,a4,4
    80003870:	fef61be3          	bne	a2,a5,80003866 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003874:	0621                	addi	a2,a2,8
    80003876:	060a                	slli	a2,a2,0x2
    80003878:	00018797          	auipc	a5,0x18
    8000387c:	bf878793          	addi	a5,a5,-1032 # 8001b470 <log>
    80003880:	97b2                	add	a5,a5,a2
    80003882:	44d8                	lw	a4,12(s1)
    80003884:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003886:	8526                	mv	a0,s1
    80003888:	fffff097          	auipc	ra,0xfffff
    8000388c:	d7a080e7          	jalr	-646(ra) # 80002602 <bpin>
    log.lh.n++;
    80003890:	00018717          	auipc	a4,0x18
    80003894:	be070713          	addi	a4,a4,-1056 # 8001b470 <log>
    80003898:	575c                	lw	a5,44(a4)
    8000389a:	2785                	addiw	a5,a5,1
    8000389c:	d75c                	sw	a5,44(a4)
    8000389e:	a82d                	j	800038d8 <log_write+0xc8>
    panic("too big a transaction");
    800038a0:	00005517          	auipc	a0,0x5
    800038a4:	c6850513          	addi	a0,a0,-920 # 80008508 <etext+0x508>
    800038a8:	00002097          	auipc	ra,0x2
    800038ac:	58a080e7          	jalr	1418(ra) # 80005e32 <panic>
    panic("log_write outside of trans");
    800038b0:	00005517          	auipc	a0,0x5
    800038b4:	c7050513          	addi	a0,a0,-912 # 80008520 <etext+0x520>
    800038b8:	00002097          	auipc	ra,0x2
    800038bc:	57a080e7          	jalr	1402(ra) # 80005e32 <panic>
  log.lh.block[i] = b->blockno;
    800038c0:	00878693          	addi	a3,a5,8
    800038c4:	068a                	slli	a3,a3,0x2
    800038c6:	00018717          	auipc	a4,0x18
    800038ca:	baa70713          	addi	a4,a4,-1110 # 8001b470 <log>
    800038ce:	9736                	add	a4,a4,a3
    800038d0:	44d4                	lw	a3,12(s1)
    800038d2:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800038d4:	faf609e3          	beq	a2,a5,80003886 <log_write+0x76>
  }
  release(&log.lock);
    800038d8:	00018517          	auipc	a0,0x18
    800038dc:	b9850513          	addi	a0,a0,-1128 # 8001b470 <log>
    800038e0:	00003097          	auipc	ra,0x3
    800038e4:	b80080e7          	jalr	-1152(ra) # 80006460 <release>
}
    800038e8:	60e2                	ld	ra,24(sp)
    800038ea:	6442                	ld	s0,16(sp)
    800038ec:	64a2                	ld	s1,8(sp)
    800038ee:	6902                	ld	s2,0(sp)
    800038f0:	6105                	addi	sp,sp,32
    800038f2:	8082                	ret

00000000800038f4 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800038f4:	1101                	addi	sp,sp,-32
    800038f6:	ec06                	sd	ra,24(sp)
    800038f8:	e822                	sd	s0,16(sp)
    800038fa:	e426                	sd	s1,8(sp)
    800038fc:	e04a                	sd	s2,0(sp)
    800038fe:	1000                	addi	s0,sp,32
    80003900:	84aa                	mv	s1,a0
    80003902:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003904:	00005597          	auipc	a1,0x5
    80003908:	c3c58593          	addi	a1,a1,-964 # 80008540 <etext+0x540>
    8000390c:	0521                	addi	a0,a0,8
    8000390e:	00003097          	auipc	ra,0x3
    80003912:	a0e080e7          	jalr	-1522(ra) # 8000631c <initlock>
  lk->name = name;
    80003916:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000391a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000391e:	0204a423          	sw	zero,40(s1)
}
    80003922:	60e2                	ld	ra,24(sp)
    80003924:	6442                	ld	s0,16(sp)
    80003926:	64a2                	ld	s1,8(sp)
    80003928:	6902                	ld	s2,0(sp)
    8000392a:	6105                	addi	sp,sp,32
    8000392c:	8082                	ret

000000008000392e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000392e:	1101                	addi	sp,sp,-32
    80003930:	ec06                	sd	ra,24(sp)
    80003932:	e822                	sd	s0,16(sp)
    80003934:	e426                	sd	s1,8(sp)
    80003936:	e04a                	sd	s2,0(sp)
    80003938:	1000                	addi	s0,sp,32
    8000393a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000393c:	00850913          	addi	s2,a0,8
    80003940:	854a                	mv	a0,s2
    80003942:	00003097          	auipc	ra,0x3
    80003946:	a6a080e7          	jalr	-1430(ra) # 800063ac <acquire>
  while (lk->locked) {
    8000394a:	409c                	lw	a5,0(s1)
    8000394c:	cb89                	beqz	a5,8000395e <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000394e:	85ca                	mv	a1,s2
    80003950:	8526                	mv	a0,s1
    80003952:	ffffe097          	auipc	ra,0xffffe
    80003956:	d0a080e7          	jalr	-758(ra) # 8000165c <sleep>
  while (lk->locked) {
    8000395a:	409c                	lw	a5,0(s1)
    8000395c:	fbed                	bnez	a5,8000394e <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000395e:	4785                	li	a5,1
    80003960:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003962:	ffffd097          	auipc	ra,0xffffd
    80003966:	5a0080e7          	jalr	1440(ra) # 80000f02 <myproc>
    8000396a:	591c                	lw	a5,48(a0)
    8000396c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000396e:	854a                	mv	a0,s2
    80003970:	00003097          	auipc	ra,0x3
    80003974:	af0080e7          	jalr	-1296(ra) # 80006460 <release>
}
    80003978:	60e2                	ld	ra,24(sp)
    8000397a:	6442                	ld	s0,16(sp)
    8000397c:	64a2                	ld	s1,8(sp)
    8000397e:	6902                	ld	s2,0(sp)
    80003980:	6105                	addi	sp,sp,32
    80003982:	8082                	ret

0000000080003984 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003984:	1101                	addi	sp,sp,-32
    80003986:	ec06                	sd	ra,24(sp)
    80003988:	e822                	sd	s0,16(sp)
    8000398a:	e426                	sd	s1,8(sp)
    8000398c:	e04a                	sd	s2,0(sp)
    8000398e:	1000                	addi	s0,sp,32
    80003990:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003992:	00850913          	addi	s2,a0,8
    80003996:	854a                	mv	a0,s2
    80003998:	00003097          	auipc	ra,0x3
    8000399c:	a14080e7          	jalr	-1516(ra) # 800063ac <acquire>
  lk->locked = 0;
    800039a0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039a4:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800039a8:	8526                	mv	a0,s1
    800039aa:	ffffe097          	auipc	ra,0xffffe
    800039ae:	d16080e7          	jalr	-746(ra) # 800016c0 <wakeup>
  release(&lk->lk);
    800039b2:	854a                	mv	a0,s2
    800039b4:	00003097          	auipc	ra,0x3
    800039b8:	aac080e7          	jalr	-1364(ra) # 80006460 <release>
}
    800039bc:	60e2                	ld	ra,24(sp)
    800039be:	6442                	ld	s0,16(sp)
    800039c0:	64a2                	ld	s1,8(sp)
    800039c2:	6902                	ld	s2,0(sp)
    800039c4:	6105                	addi	sp,sp,32
    800039c6:	8082                	ret

00000000800039c8 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800039c8:	7179                	addi	sp,sp,-48
    800039ca:	f406                	sd	ra,40(sp)
    800039cc:	f022                	sd	s0,32(sp)
    800039ce:	ec26                	sd	s1,24(sp)
    800039d0:	e84a                	sd	s2,16(sp)
    800039d2:	1800                	addi	s0,sp,48
    800039d4:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800039d6:	00850913          	addi	s2,a0,8
    800039da:	854a                	mv	a0,s2
    800039dc:	00003097          	auipc	ra,0x3
    800039e0:	9d0080e7          	jalr	-1584(ra) # 800063ac <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800039e4:	409c                	lw	a5,0(s1)
    800039e6:	ef91                	bnez	a5,80003a02 <holdingsleep+0x3a>
    800039e8:	4481                	li	s1,0
  release(&lk->lk);
    800039ea:	854a                	mv	a0,s2
    800039ec:	00003097          	auipc	ra,0x3
    800039f0:	a74080e7          	jalr	-1420(ra) # 80006460 <release>
  return r;
}
    800039f4:	8526                	mv	a0,s1
    800039f6:	70a2                	ld	ra,40(sp)
    800039f8:	7402                	ld	s0,32(sp)
    800039fa:	64e2                	ld	s1,24(sp)
    800039fc:	6942                	ld	s2,16(sp)
    800039fe:	6145                	addi	sp,sp,48
    80003a00:	8082                	ret
    80003a02:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a04:	0284a983          	lw	s3,40(s1)
    80003a08:	ffffd097          	auipc	ra,0xffffd
    80003a0c:	4fa080e7          	jalr	1274(ra) # 80000f02 <myproc>
    80003a10:	5904                	lw	s1,48(a0)
    80003a12:	413484b3          	sub	s1,s1,s3
    80003a16:	0014b493          	seqz	s1,s1
    80003a1a:	69a2                	ld	s3,8(sp)
    80003a1c:	b7f9                	j	800039ea <holdingsleep+0x22>

0000000080003a1e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003a1e:	1141                	addi	sp,sp,-16
    80003a20:	e406                	sd	ra,8(sp)
    80003a22:	e022                	sd	s0,0(sp)
    80003a24:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003a26:	00005597          	auipc	a1,0x5
    80003a2a:	b2a58593          	addi	a1,a1,-1238 # 80008550 <etext+0x550>
    80003a2e:	00018517          	auipc	a0,0x18
    80003a32:	b8a50513          	addi	a0,a0,-1142 # 8001b5b8 <ftable>
    80003a36:	00003097          	auipc	ra,0x3
    80003a3a:	8e6080e7          	jalr	-1818(ra) # 8000631c <initlock>
}
    80003a3e:	60a2                	ld	ra,8(sp)
    80003a40:	6402                	ld	s0,0(sp)
    80003a42:	0141                	addi	sp,sp,16
    80003a44:	8082                	ret

0000000080003a46 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a46:	1101                	addi	sp,sp,-32
    80003a48:	ec06                	sd	ra,24(sp)
    80003a4a:	e822                	sd	s0,16(sp)
    80003a4c:	e426                	sd	s1,8(sp)
    80003a4e:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a50:	00018517          	auipc	a0,0x18
    80003a54:	b6850513          	addi	a0,a0,-1176 # 8001b5b8 <ftable>
    80003a58:	00003097          	auipc	ra,0x3
    80003a5c:	954080e7          	jalr	-1708(ra) # 800063ac <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a60:	00018497          	auipc	s1,0x18
    80003a64:	b7048493          	addi	s1,s1,-1168 # 8001b5d0 <ftable+0x18>
    80003a68:	00019717          	auipc	a4,0x19
    80003a6c:	b0870713          	addi	a4,a4,-1272 # 8001c570 <disk>
    if(f->ref == 0){
    80003a70:	40dc                	lw	a5,4(s1)
    80003a72:	cf99                	beqz	a5,80003a90 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a74:	02848493          	addi	s1,s1,40
    80003a78:	fee49ce3          	bne	s1,a4,80003a70 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a7c:	00018517          	auipc	a0,0x18
    80003a80:	b3c50513          	addi	a0,a0,-1220 # 8001b5b8 <ftable>
    80003a84:	00003097          	auipc	ra,0x3
    80003a88:	9dc080e7          	jalr	-1572(ra) # 80006460 <release>
  return 0;
    80003a8c:	4481                	li	s1,0
    80003a8e:	a819                	j	80003aa4 <filealloc+0x5e>
      f->ref = 1;
    80003a90:	4785                	li	a5,1
    80003a92:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a94:	00018517          	auipc	a0,0x18
    80003a98:	b2450513          	addi	a0,a0,-1244 # 8001b5b8 <ftable>
    80003a9c:	00003097          	auipc	ra,0x3
    80003aa0:	9c4080e7          	jalr	-1596(ra) # 80006460 <release>
}
    80003aa4:	8526                	mv	a0,s1
    80003aa6:	60e2                	ld	ra,24(sp)
    80003aa8:	6442                	ld	s0,16(sp)
    80003aaa:	64a2                	ld	s1,8(sp)
    80003aac:	6105                	addi	sp,sp,32
    80003aae:	8082                	ret

0000000080003ab0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003ab0:	1101                	addi	sp,sp,-32
    80003ab2:	ec06                	sd	ra,24(sp)
    80003ab4:	e822                	sd	s0,16(sp)
    80003ab6:	e426                	sd	s1,8(sp)
    80003ab8:	1000                	addi	s0,sp,32
    80003aba:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003abc:	00018517          	auipc	a0,0x18
    80003ac0:	afc50513          	addi	a0,a0,-1284 # 8001b5b8 <ftable>
    80003ac4:	00003097          	auipc	ra,0x3
    80003ac8:	8e8080e7          	jalr	-1816(ra) # 800063ac <acquire>
  if(f->ref < 1)
    80003acc:	40dc                	lw	a5,4(s1)
    80003ace:	02f05263          	blez	a5,80003af2 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003ad2:	2785                	addiw	a5,a5,1
    80003ad4:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003ad6:	00018517          	auipc	a0,0x18
    80003ada:	ae250513          	addi	a0,a0,-1310 # 8001b5b8 <ftable>
    80003ade:	00003097          	auipc	ra,0x3
    80003ae2:	982080e7          	jalr	-1662(ra) # 80006460 <release>
  return f;
}
    80003ae6:	8526                	mv	a0,s1
    80003ae8:	60e2                	ld	ra,24(sp)
    80003aea:	6442                	ld	s0,16(sp)
    80003aec:	64a2                	ld	s1,8(sp)
    80003aee:	6105                	addi	sp,sp,32
    80003af0:	8082                	ret
    panic("filedup");
    80003af2:	00005517          	auipc	a0,0x5
    80003af6:	a6650513          	addi	a0,a0,-1434 # 80008558 <etext+0x558>
    80003afa:	00002097          	auipc	ra,0x2
    80003afe:	338080e7          	jalr	824(ra) # 80005e32 <panic>

0000000080003b02 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003b02:	7139                	addi	sp,sp,-64
    80003b04:	fc06                	sd	ra,56(sp)
    80003b06:	f822                	sd	s0,48(sp)
    80003b08:	f426                	sd	s1,40(sp)
    80003b0a:	0080                	addi	s0,sp,64
    80003b0c:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003b0e:	00018517          	auipc	a0,0x18
    80003b12:	aaa50513          	addi	a0,a0,-1366 # 8001b5b8 <ftable>
    80003b16:	00003097          	auipc	ra,0x3
    80003b1a:	896080e7          	jalr	-1898(ra) # 800063ac <acquire>
  if(f->ref < 1)
    80003b1e:	40dc                	lw	a5,4(s1)
    80003b20:	04f05c63          	blez	a5,80003b78 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80003b24:	37fd                	addiw	a5,a5,-1
    80003b26:	0007871b          	sext.w	a4,a5
    80003b2a:	c0dc                	sw	a5,4(s1)
    80003b2c:	06e04263          	bgtz	a4,80003b90 <fileclose+0x8e>
    80003b30:	f04a                	sd	s2,32(sp)
    80003b32:	ec4e                	sd	s3,24(sp)
    80003b34:	e852                	sd	s4,16(sp)
    80003b36:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003b38:	0004a903          	lw	s2,0(s1)
    80003b3c:	0094ca83          	lbu	s5,9(s1)
    80003b40:	0104ba03          	ld	s4,16(s1)
    80003b44:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003b48:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b4c:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b50:	00018517          	auipc	a0,0x18
    80003b54:	a6850513          	addi	a0,a0,-1432 # 8001b5b8 <ftable>
    80003b58:	00003097          	auipc	ra,0x3
    80003b5c:	908080e7          	jalr	-1784(ra) # 80006460 <release>

  if(ff.type == FD_PIPE){
    80003b60:	4785                	li	a5,1
    80003b62:	04f90463          	beq	s2,a5,80003baa <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003b66:	3979                	addiw	s2,s2,-2
    80003b68:	4785                	li	a5,1
    80003b6a:	0527fb63          	bgeu	a5,s2,80003bc0 <fileclose+0xbe>
    80003b6e:	7902                	ld	s2,32(sp)
    80003b70:	69e2                	ld	s3,24(sp)
    80003b72:	6a42                	ld	s4,16(sp)
    80003b74:	6aa2                	ld	s5,8(sp)
    80003b76:	a02d                	j	80003ba0 <fileclose+0x9e>
    80003b78:	f04a                	sd	s2,32(sp)
    80003b7a:	ec4e                	sd	s3,24(sp)
    80003b7c:	e852                	sd	s4,16(sp)
    80003b7e:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003b80:	00005517          	auipc	a0,0x5
    80003b84:	9e050513          	addi	a0,a0,-1568 # 80008560 <etext+0x560>
    80003b88:	00002097          	auipc	ra,0x2
    80003b8c:	2aa080e7          	jalr	682(ra) # 80005e32 <panic>
    release(&ftable.lock);
    80003b90:	00018517          	auipc	a0,0x18
    80003b94:	a2850513          	addi	a0,a0,-1496 # 8001b5b8 <ftable>
    80003b98:	00003097          	auipc	ra,0x3
    80003b9c:	8c8080e7          	jalr	-1848(ra) # 80006460 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003ba0:	70e2                	ld	ra,56(sp)
    80003ba2:	7442                	ld	s0,48(sp)
    80003ba4:	74a2                	ld	s1,40(sp)
    80003ba6:	6121                	addi	sp,sp,64
    80003ba8:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003baa:	85d6                	mv	a1,s5
    80003bac:	8552                	mv	a0,s4
    80003bae:	00000097          	auipc	ra,0x0
    80003bb2:	3a2080e7          	jalr	930(ra) # 80003f50 <pipeclose>
    80003bb6:	7902                	ld	s2,32(sp)
    80003bb8:	69e2                	ld	s3,24(sp)
    80003bba:	6a42                	ld	s4,16(sp)
    80003bbc:	6aa2                	ld	s5,8(sp)
    80003bbe:	b7cd                	j	80003ba0 <fileclose+0x9e>
    begin_op();
    80003bc0:	00000097          	auipc	ra,0x0
    80003bc4:	a78080e7          	jalr	-1416(ra) # 80003638 <begin_op>
    iput(ff.ip);
    80003bc8:	854e                	mv	a0,s3
    80003bca:	fffff097          	auipc	ra,0xfffff
    80003bce:	25e080e7          	jalr	606(ra) # 80002e28 <iput>
    end_op();
    80003bd2:	00000097          	auipc	ra,0x0
    80003bd6:	ae0080e7          	jalr	-1312(ra) # 800036b2 <end_op>
    80003bda:	7902                	ld	s2,32(sp)
    80003bdc:	69e2                	ld	s3,24(sp)
    80003bde:	6a42                	ld	s4,16(sp)
    80003be0:	6aa2                	ld	s5,8(sp)
    80003be2:	bf7d                	j	80003ba0 <fileclose+0x9e>

0000000080003be4 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003be4:	715d                	addi	sp,sp,-80
    80003be6:	e486                	sd	ra,72(sp)
    80003be8:	e0a2                	sd	s0,64(sp)
    80003bea:	fc26                	sd	s1,56(sp)
    80003bec:	f44e                	sd	s3,40(sp)
    80003bee:	0880                	addi	s0,sp,80
    80003bf0:	84aa                	mv	s1,a0
    80003bf2:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003bf4:	ffffd097          	auipc	ra,0xffffd
    80003bf8:	30e080e7          	jalr	782(ra) # 80000f02 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003bfc:	409c                	lw	a5,0(s1)
    80003bfe:	37f9                	addiw	a5,a5,-2
    80003c00:	4705                	li	a4,1
    80003c02:	04f76863          	bltu	a4,a5,80003c52 <filestat+0x6e>
    80003c06:	f84a                	sd	s2,48(sp)
    80003c08:	892a                	mv	s2,a0
    ilock(f->ip);
    80003c0a:	6c88                	ld	a0,24(s1)
    80003c0c:	fffff097          	auipc	ra,0xfffff
    80003c10:	05e080e7          	jalr	94(ra) # 80002c6a <ilock>
    stati(f->ip, &st);
    80003c14:	fb840593          	addi	a1,s0,-72
    80003c18:	6c88                	ld	a0,24(s1)
    80003c1a:	fffff097          	auipc	ra,0xfffff
    80003c1e:	2de080e7          	jalr	734(ra) # 80002ef8 <stati>
    iunlock(f->ip);
    80003c22:	6c88                	ld	a0,24(s1)
    80003c24:	fffff097          	auipc	ra,0xfffff
    80003c28:	10c080e7          	jalr	268(ra) # 80002d30 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003c2c:	46e1                	li	a3,24
    80003c2e:	fb840613          	addi	a2,s0,-72
    80003c32:	85ce                	mv	a1,s3
    80003c34:	05093503          	ld	a0,80(s2)
    80003c38:	ffffd097          	auipc	ra,0xffffd
    80003c3c:	f14080e7          	jalr	-236(ra) # 80000b4c <copyout>
    80003c40:	41f5551b          	sraiw	a0,a0,0x1f
    80003c44:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003c46:	60a6                	ld	ra,72(sp)
    80003c48:	6406                	ld	s0,64(sp)
    80003c4a:	74e2                	ld	s1,56(sp)
    80003c4c:	79a2                	ld	s3,40(sp)
    80003c4e:	6161                	addi	sp,sp,80
    80003c50:	8082                	ret
  return -1;
    80003c52:	557d                	li	a0,-1
    80003c54:	bfcd                	j	80003c46 <filestat+0x62>

0000000080003c56 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c56:	7179                	addi	sp,sp,-48
    80003c58:	f406                	sd	ra,40(sp)
    80003c5a:	f022                	sd	s0,32(sp)
    80003c5c:	e84a                	sd	s2,16(sp)
    80003c5e:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c60:	00854783          	lbu	a5,8(a0)
    80003c64:	cbc5                	beqz	a5,80003d14 <fileread+0xbe>
    80003c66:	ec26                	sd	s1,24(sp)
    80003c68:	e44e                	sd	s3,8(sp)
    80003c6a:	84aa                	mv	s1,a0
    80003c6c:	89ae                	mv	s3,a1
    80003c6e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c70:	411c                	lw	a5,0(a0)
    80003c72:	4705                	li	a4,1
    80003c74:	04e78963          	beq	a5,a4,80003cc6 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c78:	470d                	li	a4,3
    80003c7a:	04e78f63          	beq	a5,a4,80003cd8 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c7e:	4709                	li	a4,2
    80003c80:	08e79263          	bne	a5,a4,80003d04 <fileread+0xae>
    ilock(f->ip);
    80003c84:	6d08                	ld	a0,24(a0)
    80003c86:	fffff097          	auipc	ra,0xfffff
    80003c8a:	fe4080e7          	jalr	-28(ra) # 80002c6a <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c8e:	874a                	mv	a4,s2
    80003c90:	5094                	lw	a3,32(s1)
    80003c92:	864e                	mv	a2,s3
    80003c94:	4585                	li	a1,1
    80003c96:	6c88                	ld	a0,24(s1)
    80003c98:	fffff097          	auipc	ra,0xfffff
    80003c9c:	28a080e7          	jalr	650(ra) # 80002f22 <readi>
    80003ca0:	892a                	mv	s2,a0
    80003ca2:	00a05563          	blez	a0,80003cac <fileread+0x56>
      f->off += r;
    80003ca6:	509c                	lw	a5,32(s1)
    80003ca8:	9fa9                	addw	a5,a5,a0
    80003caa:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003cac:	6c88                	ld	a0,24(s1)
    80003cae:	fffff097          	auipc	ra,0xfffff
    80003cb2:	082080e7          	jalr	130(ra) # 80002d30 <iunlock>
    80003cb6:	64e2                	ld	s1,24(sp)
    80003cb8:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003cba:	854a                	mv	a0,s2
    80003cbc:	70a2                	ld	ra,40(sp)
    80003cbe:	7402                	ld	s0,32(sp)
    80003cc0:	6942                	ld	s2,16(sp)
    80003cc2:	6145                	addi	sp,sp,48
    80003cc4:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003cc6:	6908                	ld	a0,16(a0)
    80003cc8:	00000097          	auipc	ra,0x0
    80003ccc:	400080e7          	jalr	1024(ra) # 800040c8 <piperead>
    80003cd0:	892a                	mv	s2,a0
    80003cd2:	64e2                	ld	s1,24(sp)
    80003cd4:	69a2                	ld	s3,8(sp)
    80003cd6:	b7d5                	j	80003cba <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003cd8:	02451783          	lh	a5,36(a0)
    80003cdc:	03079693          	slli	a3,a5,0x30
    80003ce0:	92c1                	srli	a3,a3,0x30
    80003ce2:	4725                	li	a4,9
    80003ce4:	02d76a63          	bltu	a4,a3,80003d18 <fileread+0xc2>
    80003ce8:	0792                	slli	a5,a5,0x4
    80003cea:	00018717          	auipc	a4,0x18
    80003cee:	82e70713          	addi	a4,a4,-2002 # 8001b518 <devsw>
    80003cf2:	97ba                	add	a5,a5,a4
    80003cf4:	639c                	ld	a5,0(a5)
    80003cf6:	c78d                	beqz	a5,80003d20 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003cf8:	4505                	li	a0,1
    80003cfa:	9782                	jalr	a5
    80003cfc:	892a                	mv	s2,a0
    80003cfe:	64e2                	ld	s1,24(sp)
    80003d00:	69a2                	ld	s3,8(sp)
    80003d02:	bf65                	j	80003cba <fileread+0x64>
    panic("fileread");
    80003d04:	00005517          	auipc	a0,0x5
    80003d08:	86c50513          	addi	a0,a0,-1940 # 80008570 <etext+0x570>
    80003d0c:	00002097          	auipc	ra,0x2
    80003d10:	126080e7          	jalr	294(ra) # 80005e32 <panic>
    return -1;
    80003d14:	597d                	li	s2,-1
    80003d16:	b755                	j	80003cba <fileread+0x64>
      return -1;
    80003d18:	597d                	li	s2,-1
    80003d1a:	64e2                	ld	s1,24(sp)
    80003d1c:	69a2                	ld	s3,8(sp)
    80003d1e:	bf71                	j	80003cba <fileread+0x64>
    80003d20:	597d                	li	s2,-1
    80003d22:	64e2                	ld	s1,24(sp)
    80003d24:	69a2                	ld	s3,8(sp)
    80003d26:	bf51                	j	80003cba <fileread+0x64>

0000000080003d28 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003d28:	00954783          	lbu	a5,9(a0)
    80003d2c:	12078963          	beqz	a5,80003e5e <filewrite+0x136>
{
    80003d30:	715d                	addi	sp,sp,-80
    80003d32:	e486                	sd	ra,72(sp)
    80003d34:	e0a2                	sd	s0,64(sp)
    80003d36:	f84a                	sd	s2,48(sp)
    80003d38:	f052                	sd	s4,32(sp)
    80003d3a:	e85a                	sd	s6,16(sp)
    80003d3c:	0880                	addi	s0,sp,80
    80003d3e:	892a                	mv	s2,a0
    80003d40:	8b2e                	mv	s6,a1
    80003d42:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d44:	411c                	lw	a5,0(a0)
    80003d46:	4705                	li	a4,1
    80003d48:	02e78763          	beq	a5,a4,80003d76 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d4c:	470d                	li	a4,3
    80003d4e:	02e78a63          	beq	a5,a4,80003d82 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d52:	4709                	li	a4,2
    80003d54:	0ee79863          	bne	a5,a4,80003e44 <filewrite+0x11c>
    80003d58:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d5a:	0cc05463          	blez	a2,80003e22 <filewrite+0xfa>
    80003d5e:	fc26                	sd	s1,56(sp)
    80003d60:	ec56                	sd	s5,24(sp)
    80003d62:	e45e                	sd	s7,8(sp)
    80003d64:	e062                	sd	s8,0(sp)
    int i = 0;
    80003d66:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003d68:	6b85                	lui	s7,0x1
    80003d6a:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003d6e:	6c05                	lui	s8,0x1
    80003d70:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003d74:	a851                	j	80003e08 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003d76:	6908                	ld	a0,16(a0)
    80003d78:	00000097          	auipc	ra,0x0
    80003d7c:	248080e7          	jalr	584(ra) # 80003fc0 <pipewrite>
    80003d80:	a85d                	j	80003e36 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d82:	02451783          	lh	a5,36(a0)
    80003d86:	03079693          	slli	a3,a5,0x30
    80003d8a:	92c1                	srli	a3,a3,0x30
    80003d8c:	4725                	li	a4,9
    80003d8e:	0cd76a63          	bltu	a4,a3,80003e62 <filewrite+0x13a>
    80003d92:	0792                	slli	a5,a5,0x4
    80003d94:	00017717          	auipc	a4,0x17
    80003d98:	78470713          	addi	a4,a4,1924 # 8001b518 <devsw>
    80003d9c:	97ba                	add	a5,a5,a4
    80003d9e:	679c                	ld	a5,8(a5)
    80003da0:	c3f9                	beqz	a5,80003e66 <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80003da2:	4505                	li	a0,1
    80003da4:	9782                	jalr	a5
    80003da6:	a841                	j	80003e36 <filewrite+0x10e>
      if(n1 > max)
    80003da8:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003dac:	00000097          	auipc	ra,0x0
    80003db0:	88c080e7          	jalr	-1908(ra) # 80003638 <begin_op>
      ilock(f->ip);
    80003db4:	01893503          	ld	a0,24(s2)
    80003db8:	fffff097          	auipc	ra,0xfffff
    80003dbc:	eb2080e7          	jalr	-334(ra) # 80002c6a <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003dc0:	8756                	mv	a4,s5
    80003dc2:	02092683          	lw	a3,32(s2)
    80003dc6:	01698633          	add	a2,s3,s6
    80003dca:	4585                	li	a1,1
    80003dcc:	01893503          	ld	a0,24(s2)
    80003dd0:	fffff097          	auipc	ra,0xfffff
    80003dd4:	262080e7          	jalr	610(ra) # 80003032 <writei>
    80003dd8:	84aa                	mv	s1,a0
    80003dda:	00a05763          	blez	a0,80003de8 <filewrite+0xc0>
        f->off += r;
    80003dde:	02092783          	lw	a5,32(s2)
    80003de2:	9fa9                	addw	a5,a5,a0
    80003de4:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003de8:	01893503          	ld	a0,24(s2)
    80003dec:	fffff097          	auipc	ra,0xfffff
    80003df0:	f44080e7          	jalr	-188(ra) # 80002d30 <iunlock>
      end_op();
    80003df4:	00000097          	auipc	ra,0x0
    80003df8:	8be080e7          	jalr	-1858(ra) # 800036b2 <end_op>

      if(r != n1){
    80003dfc:	029a9563          	bne	s5,s1,80003e26 <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80003e00:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003e04:	0149da63          	bge	s3,s4,80003e18 <filewrite+0xf0>
      int n1 = n - i;
    80003e08:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003e0c:	0004879b          	sext.w	a5,s1
    80003e10:	f8fbdce3          	bge	s7,a5,80003da8 <filewrite+0x80>
    80003e14:	84e2                	mv	s1,s8
    80003e16:	bf49                	j	80003da8 <filewrite+0x80>
    80003e18:	74e2                	ld	s1,56(sp)
    80003e1a:	6ae2                	ld	s5,24(sp)
    80003e1c:	6ba2                	ld	s7,8(sp)
    80003e1e:	6c02                	ld	s8,0(sp)
    80003e20:	a039                	j	80003e2e <filewrite+0x106>
    int i = 0;
    80003e22:	4981                	li	s3,0
    80003e24:	a029                	j	80003e2e <filewrite+0x106>
    80003e26:	74e2                	ld	s1,56(sp)
    80003e28:	6ae2                	ld	s5,24(sp)
    80003e2a:	6ba2                	ld	s7,8(sp)
    80003e2c:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003e2e:	033a1e63          	bne	s4,s3,80003e6a <filewrite+0x142>
    80003e32:	8552                	mv	a0,s4
    80003e34:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003e36:	60a6                	ld	ra,72(sp)
    80003e38:	6406                	ld	s0,64(sp)
    80003e3a:	7942                	ld	s2,48(sp)
    80003e3c:	7a02                	ld	s4,32(sp)
    80003e3e:	6b42                	ld	s6,16(sp)
    80003e40:	6161                	addi	sp,sp,80
    80003e42:	8082                	ret
    80003e44:	fc26                	sd	s1,56(sp)
    80003e46:	f44e                	sd	s3,40(sp)
    80003e48:	ec56                	sd	s5,24(sp)
    80003e4a:	e45e                	sd	s7,8(sp)
    80003e4c:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003e4e:	00004517          	auipc	a0,0x4
    80003e52:	73250513          	addi	a0,a0,1842 # 80008580 <etext+0x580>
    80003e56:	00002097          	auipc	ra,0x2
    80003e5a:	fdc080e7          	jalr	-36(ra) # 80005e32 <panic>
    return -1;
    80003e5e:	557d                	li	a0,-1
}
    80003e60:	8082                	ret
      return -1;
    80003e62:	557d                	li	a0,-1
    80003e64:	bfc9                	j	80003e36 <filewrite+0x10e>
    80003e66:	557d                	li	a0,-1
    80003e68:	b7f9                	j	80003e36 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80003e6a:	557d                	li	a0,-1
    80003e6c:	79a2                	ld	s3,40(sp)
    80003e6e:	b7e1                	j	80003e36 <filewrite+0x10e>

0000000080003e70 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e70:	7179                	addi	sp,sp,-48
    80003e72:	f406                	sd	ra,40(sp)
    80003e74:	f022                	sd	s0,32(sp)
    80003e76:	ec26                	sd	s1,24(sp)
    80003e78:	e052                	sd	s4,0(sp)
    80003e7a:	1800                	addi	s0,sp,48
    80003e7c:	84aa                	mv	s1,a0
    80003e7e:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e80:	0005b023          	sd	zero,0(a1)
    80003e84:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e88:	00000097          	auipc	ra,0x0
    80003e8c:	bbe080e7          	jalr	-1090(ra) # 80003a46 <filealloc>
    80003e90:	e088                	sd	a0,0(s1)
    80003e92:	cd49                	beqz	a0,80003f2c <pipealloc+0xbc>
    80003e94:	00000097          	auipc	ra,0x0
    80003e98:	bb2080e7          	jalr	-1102(ra) # 80003a46 <filealloc>
    80003e9c:	00aa3023          	sd	a0,0(s4)
    80003ea0:	c141                	beqz	a0,80003f20 <pipealloc+0xb0>
    80003ea2:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003ea4:	ffffc097          	auipc	ra,0xffffc
    80003ea8:	276080e7          	jalr	630(ra) # 8000011a <kalloc>
    80003eac:	892a                	mv	s2,a0
    80003eae:	c13d                	beqz	a0,80003f14 <pipealloc+0xa4>
    80003eb0:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003eb2:	4985                	li	s3,1
    80003eb4:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003eb8:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003ebc:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003ec0:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003ec4:	00004597          	auipc	a1,0x4
    80003ec8:	6cc58593          	addi	a1,a1,1740 # 80008590 <etext+0x590>
    80003ecc:	00002097          	auipc	ra,0x2
    80003ed0:	450080e7          	jalr	1104(ra) # 8000631c <initlock>
  (*f0)->type = FD_PIPE;
    80003ed4:	609c                	ld	a5,0(s1)
    80003ed6:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003eda:	609c                	ld	a5,0(s1)
    80003edc:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003ee0:	609c                	ld	a5,0(s1)
    80003ee2:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003ee6:	609c                	ld	a5,0(s1)
    80003ee8:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003eec:	000a3783          	ld	a5,0(s4)
    80003ef0:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003ef4:	000a3783          	ld	a5,0(s4)
    80003ef8:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003efc:	000a3783          	ld	a5,0(s4)
    80003f00:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f04:	000a3783          	ld	a5,0(s4)
    80003f08:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f0c:	4501                	li	a0,0
    80003f0e:	6942                	ld	s2,16(sp)
    80003f10:	69a2                	ld	s3,8(sp)
    80003f12:	a03d                	j	80003f40 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003f14:	6088                	ld	a0,0(s1)
    80003f16:	c119                	beqz	a0,80003f1c <pipealloc+0xac>
    80003f18:	6942                	ld	s2,16(sp)
    80003f1a:	a029                	j	80003f24 <pipealloc+0xb4>
    80003f1c:	6942                	ld	s2,16(sp)
    80003f1e:	a039                	j	80003f2c <pipealloc+0xbc>
    80003f20:	6088                	ld	a0,0(s1)
    80003f22:	c50d                	beqz	a0,80003f4c <pipealloc+0xdc>
    fileclose(*f0);
    80003f24:	00000097          	auipc	ra,0x0
    80003f28:	bde080e7          	jalr	-1058(ra) # 80003b02 <fileclose>
  if(*f1)
    80003f2c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003f30:	557d                	li	a0,-1
  if(*f1)
    80003f32:	c799                	beqz	a5,80003f40 <pipealloc+0xd0>
    fileclose(*f1);
    80003f34:	853e                	mv	a0,a5
    80003f36:	00000097          	auipc	ra,0x0
    80003f3a:	bcc080e7          	jalr	-1076(ra) # 80003b02 <fileclose>
  return -1;
    80003f3e:	557d                	li	a0,-1
}
    80003f40:	70a2                	ld	ra,40(sp)
    80003f42:	7402                	ld	s0,32(sp)
    80003f44:	64e2                	ld	s1,24(sp)
    80003f46:	6a02                	ld	s4,0(sp)
    80003f48:	6145                	addi	sp,sp,48
    80003f4a:	8082                	ret
  return -1;
    80003f4c:	557d                	li	a0,-1
    80003f4e:	bfcd                	j	80003f40 <pipealloc+0xd0>

0000000080003f50 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f50:	1101                	addi	sp,sp,-32
    80003f52:	ec06                	sd	ra,24(sp)
    80003f54:	e822                	sd	s0,16(sp)
    80003f56:	e426                	sd	s1,8(sp)
    80003f58:	e04a                	sd	s2,0(sp)
    80003f5a:	1000                	addi	s0,sp,32
    80003f5c:	84aa                	mv	s1,a0
    80003f5e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f60:	00002097          	auipc	ra,0x2
    80003f64:	44c080e7          	jalr	1100(ra) # 800063ac <acquire>
  if(writable){
    80003f68:	02090d63          	beqz	s2,80003fa2 <pipeclose+0x52>
    pi->writeopen = 0;
    80003f6c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f70:	21848513          	addi	a0,s1,536
    80003f74:	ffffd097          	auipc	ra,0xffffd
    80003f78:	74c080e7          	jalr	1868(ra) # 800016c0 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f7c:	2204b783          	ld	a5,544(s1)
    80003f80:	eb95                	bnez	a5,80003fb4 <pipeclose+0x64>
    release(&pi->lock);
    80003f82:	8526                	mv	a0,s1
    80003f84:	00002097          	auipc	ra,0x2
    80003f88:	4dc080e7          	jalr	1244(ra) # 80006460 <release>
    kfree((char*)pi);
    80003f8c:	8526                	mv	a0,s1
    80003f8e:	ffffc097          	auipc	ra,0xffffc
    80003f92:	08e080e7          	jalr	142(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f96:	60e2                	ld	ra,24(sp)
    80003f98:	6442                	ld	s0,16(sp)
    80003f9a:	64a2                	ld	s1,8(sp)
    80003f9c:	6902                	ld	s2,0(sp)
    80003f9e:	6105                	addi	sp,sp,32
    80003fa0:	8082                	ret
    pi->readopen = 0;
    80003fa2:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003fa6:	21c48513          	addi	a0,s1,540
    80003faa:	ffffd097          	auipc	ra,0xffffd
    80003fae:	716080e7          	jalr	1814(ra) # 800016c0 <wakeup>
    80003fb2:	b7e9                	j	80003f7c <pipeclose+0x2c>
    release(&pi->lock);
    80003fb4:	8526                	mv	a0,s1
    80003fb6:	00002097          	auipc	ra,0x2
    80003fba:	4aa080e7          	jalr	1194(ra) # 80006460 <release>
}
    80003fbe:	bfe1                	j	80003f96 <pipeclose+0x46>

0000000080003fc0 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003fc0:	711d                	addi	sp,sp,-96
    80003fc2:	ec86                	sd	ra,88(sp)
    80003fc4:	e8a2                	sd	s0,80(sp)
    80003fc6:	e4a6                	sd	s1,72(sp)
    80003fc8:	e0ca                	sd	s2,64(sp)
    80003fca:	fc4e                	sd	s3,56(sp)
    80003fcc:	f852                	sd	s4,48(sp)
    80003fce:	f456                	sd	s5,40(sp)
    80003fd0:	1080                	addi	s0,sp,96
    80003fd2:	84aa                	mv	s1,a0
    80003fd4:	8aae                	mv	s5,a1
    80003fd6:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003fd8:	ffffd097          	auipc	ra,0xffffd
    80003fdc:	f2a080e7          	jalr	-214(ra) # 80000f02 <myproc>
    80003fe0:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003fe2:	8526                	mv	a0,s1
    80003fe4:	00002097          	auipc	ra,0x2
    80003fe8:	3c8080e7          	jalr	968(ra) # 800063ac <acquire>
  while(i < n){
    80003fec:	0d405863          	blez	s4,800040bc <pipewrite+0xfc>
    80003ff0:	f05a                	sd	s6,32(sp)
    80003ff2:	ec5e                	sd	s7,24(sp)
    80003ff4:	e862                	sd	s8,16(sp)
  int i = 0;
    80003ff6:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003ff8:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003ffa:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003ffe:	21c48b93          	addi	s7,s1,540
    80004002:	a089                	j	80004044 <pipewrite+0x84>
      release(&pi->lock);
    80004004:	8526                	mv	a0,s1
    80004006:	00002097          	auipc	ra,0x2
    8000400a:	45a080e7          	jalr	1114(ra) # 80006460 <release>
      return -1;
    8000400e:	597d                	li	s2,-1
    80004010:	7b02                	ld	s6,32(sp)
    80004012:	6be2                	ld	s7,24(sp)
    80004014:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004016:	854a                	mv	a0,s2
    80004018:	60e6                	ld	ra,88(sp)
    8000401a:	6446                	ld	s0,80(sp)
    8000401c:	64a6                	ld	s1,72(sp)
    8000401e:	6906                	ld	s2,64(sp)
    80004020:	79e2                	ld	s3,56(sp)
    80004022:	7a42                	ld	s4,48(sp)
    80004024:	7aa2                	ld	s5,40(sp)
    80004026:	6125                	addi	sp,sp,96
    80004028:	8082                	ret
      wakeup(&pi->nread);
    8000402a:	8562                	mv	a0,s8
    8000402c:	ffffd097          	auipc	ra,0xffffd
    80004030:	694080e7          	jalr	1684(ra) # 800016c0 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004034:	85a6                	mv	a1,s1
    80004036:	855e                	mv	a0,s7
    80004038:	ffffd097          	auipc	ra,0xffffd
    8000403c:	624080e7          	jalr	1572(ra) # 8000165c <sleep>
  while(i < n){
    80004040:	05495f63          	bge	s2,s4,8000409e <pipewrite+0xde>
    if(pi->readopen == 0 || killed(pr)){
    80004044:	2204a783          	lw	a5,544(s1)
    80004048:	dfd5                	beqz	a5,80004004 <pipewrite+0x44>
    8000404a:	854e                	mv	a0,s3
    8000404c:	ffffe097          	auipc	ra,0xffffe
    80004050:	8b8080e7          	jalr	-1864(ra) # 80001904 <killed>
    80004054:	f945                	bnez	a0,80004004 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004056:	2184a783          	lw	a5,536(s1)
    8000405a:	21c4a703          	lw	a4,540(s1)
    8000405e:	2007879b          	addiw	a5,a5,512
    80004062:	fcf704e3          	beq	a4,a5,8000402a <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004066:	4685                	li	a3,1
    80004068:	01590633          	add	a2,s2,s5
    8000406c:	faf40593          	addi	a1,s0,-81
    80004070:	0509b503          	ld	a0,80(s3)
    80004074:	ffffd097          	auipc	ra,0xffffd
    80004078:	bb6080e7          	jalr	-1098(ra) # 80000c2a <copyin>
    8000407c:	05650263          	beq	a0,s6,800040c0 <pipewrite+0x100>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004080:	21c4a783          	lw	a5,540(s1)
    80004084:	0017871b          	addiw	a4,a5,1
    80004088:	20e4ae23          	sw	a4,540(s1)
    8000408c:	1ff7f793          	andi	a5,a5,511
    80004090:	97a6                	add	a5,a5,s1
    80004092:	faf44703          	lbu	a4,-81(s0)
    80004096:	00e78c23          	sb	a4,24(a5)
      i++;
    8000409a:	2905                	addiw	s2,s2,1
    8000409c:	b755                	j	80004040 <pipewrite+0x80>
    8000409e:	7b02                	ld	s6,32(sp)
    800040a0:	6be2                	ld	s7,24(sp)
    800040a2:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    800040a4:	21848513          	addi	a0,s1,536
    800040a8:	ffffd097          	auipc	ra,0xffffd
    800040ac:	618080e7          	jalr	1560(ra) # 800016c0 <wakeup>
  release(&pi->lock);
    800040b0:	8526                	mv	a0,s1
    800040b2:	00002097          	auipc	ra,0x2
    800040b6:	3ae080e7          	jalr	942(ra) # 80006460 <release>
  return i;
    800040ba:	bfb1                	j	80004016 <pipewrite+0x56>
  int i = 0;
    800040bc:	4901                	li	s2,0
    800040be:	b7dd                	j	800040a4 <pipewrite+0xe4>
    800040c0:	7b02                	ld	s6,32(sp)
    800040c2:	6be2                	ld	s7,24(sp)
    800040c4:	6c42                	ld	s8,16(sp)
    800040c6:	bff9                	j	800040a4 <pipewrite+0xe4>

00000000800040c8 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800040c8:	715d                	addi	sp,sp,-80
    800040ca:	e486                	sd	ra,72(sp)
    800040cc:	e0a2                	sd	s0,64(sp)
    800040ce:	fc26                	sd	s1,56(sp)
    800040d0:	f84a                	sd	s2,48(sp)
    800040d2:	f44e                	sd	s3,40(sp)
    800040d4:	f052                	sd	s4,32(sp)
    800040d6:	ec56                	sd	s5,24(sp)
    800040d8:	0880                	addi	s0,sp,80
    800040da:	84aa                	mv	s1,a0
    800040dc:	892e                	mv	s2,a1
    800040de:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800040e0:	ffffd097          	auipc	ra,0xffffd
    800040e4:	e22080e7          	jalr	-478(ra) # 80000f02 <myproc>
    800040e8:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800040ea:	8526                	mv	a0,s1
    800040ec:	00002097          	auipc	ra,0x2
    800040f0:	2c0080e7          	jalr	704(ra) # 800063ac <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040f4:	2184a703          	lw	a4,536(s1)
    800040f8:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040fc:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004100:	02f71963          	bne	a4,a5,80004132 <piperead+0x6a>
    80004104:	2244a783          	lw	a5,548(s1)
    80004108:	cf95                	beqz	a5,80004144 <piperead+0x7c>
    if(killed(pr)){
    8000410a:	8552                	mv	a0,s4
    8000410c:	ffffd097          	auipc	ra,0xffffd
    80004110:	7f8080e7          	jalr	2040(ra) # 80001904 <killed>
    80004114:	e10d                	bnez	a0,80004136 <piperead+0x6e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004116:	85a6                	mv	a1,s1
    80004118:	854e                	mv	a0,s3
    8000411a:	ffffd097          	auipc	ra,0xffffd
    8000411e:	542080e7          	jalr	1346(ra) # 8000165c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004122:	2184a703          	lw	a4,536(s1)
    80004126:	21c4a783          	lw	a5,540(s1)
    8000412a:	fcf70de3          	beq	a4,a5,80004104 <piperead+0x3c>
    8000412e:	e85a                	sd	s6,16(sp)
    80004130:	a819                	j	80004146 <piperead+0x7e>
    80004132:	e85a                	sd	s6,16(sp)
    80004134:	a809                	j	80004146 <piperead+0x7e>
      release(&pi->lock);
    80004136:	8526                	mv	a0,s1
    80004138:	00002097          	auipc	ra,0x2
    8000413c:	328080e7          	jalr	808(ra) # 80006460 <release>
      return -1;
    80004140:	59fd                	li	s3,-1
    80004142:	a0a5                	j	800041aa <piperead+0xe2>
    80004144:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004146:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004148:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000414a:	05505463          	blez	s5,80004192 <piperead+0xca>
    if(pi->nread == pi->nwrite)
    8000414e:	2184a783          	lw	a5,536(s1)
    80004152:	21c4a703          	lw	a4,540(s1)
    80004156:	02f70e63          	beq	a4,a5,80004192 <piperead+0xca>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000415a:	0017871b          	addiw	a4,a5,1
    8000415e:	20e4ac23          	sw	a4,536(s1)
    80004162:	1ff7f793          	andi	a5,a5,511
    80004166:	97a6                	add	a5,a5,s1
    80004168:	0187c783          	lbu	a5,24(a5)
    8000416c:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004170:	4685                	li	a3,1
    80004172:	fbf40613          	addi	a2,s0,-65
    80004176:	85ca                	mv	a1,s2
    80004178:	050a3503          	ld	a0,80(s4)
    8000417c:	ffffd097          	auipc	ra,0xffffd
    80004180:	9d0080e7          	jalr	-1584(ra) # 80000b4c <copyout>
    80004184:	01650763          	beq	a0,s6,80004192 <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004188:	2985                	addiw	s3,s3,1
    8000418a:	0905                	addi	s2,s2,1
    8000418c:	fd3a91e3          	bne	s5,s3,8000414e <piperead+0x86>
    80004190:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004192:	21c48513          	addi	a0,s1,540
    80004196:	ffffd097          	auipc	ra,0xffffd
    8000419a:	52a080e7          	jalr	1322(ra) # 800016c0 <wakeup>
  release(&pi->lock);
    8000419e:	8526                	mv	a0,s1
    800041a0:	00002097          	auipc	ra,0x2
    800041a4:	2c0080e7          	jalr	704(ra) # 80006460 <release>
    800041a8:	6b42                	ld	s6,16(sp)
  return i;
}
    800041aa:	854e                	mv	a0,s3
    800041ac:	60a6                	ld	ra,72(sp)
    800041ae:	6406                	ld	s0,64(sp)
    800041b0:	74e2                	ld	s1,56(sp)
    800041b2:	7942                	ld	s2,48(sp)
    800041b4:	79a2                	ld	s3,40(sp)
    800041b6:	7a02                	ld	s4,32(sp)
    800041b8:	6ae2                	ld	s5,24(sp)
    800041ba:	6161                	addi	sp,sp,80
    800041bc:	8082                	ret

00000000800041be <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800041be:	1141                	addi	sp,sp,-16
    800041c0:	e422                	sd	s0,8(sp)
    800041c2:	0800                	addi	s0,sp,16
    800041c4:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800041c6:	8905                	andi	a0,a0,1
    800041c8:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800041ca:	8b89                	andi	a5,a5,2
    800041cc:	c399                	beqz	a5,800041d2 <flags2perm+0x14>
      perm |= PTE_W;
    800041ce:	00456513          	ori	a0,a0,4
    return perm;
}
    800041d2:	6422                	ld	s0,8(sp)
    800041d4:	0141                	addi	sp,sp,16
    800041d6:	8082                	ret

00000000800041d8 <exec>:

int
exec(char *path, char **argv)
{
    800041d8:	df010113          	addi	sp,sp,-528
    800041dc:	20113423          	sd	ra,520(sp)
    800041e0:	20813023          	sd	s0,512(sp)
    800041e4:	ffa6                	sd	s1,504(sp)
    800041e6:	fbca                	sd	s2,496(sp)
    800041e8:	0c00                	addi	s0,sp,528
    800041ea:	892a                	mv	s2,a0
    800041ec:	dea43c23          	sd	a0,-520(s0)
    800041f0:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800041f4:	ffffd097          	auipc	ra,0xffffd
    800041f8:	d0e080e7          	jalr	-754(ra) # 80000f02 <myproc>
    800041fc:	84aa                	mv	s1,a0

  begin_op();
    800041fe:	fffff097          	auipc	ra,0xfffff
    80004202:	43a080e7          	jalr	1082(ra) # 80003638 <begin_op>

  if((ip = namei(path)) == 0){
    80004206:	854a                	mv	a0,s2
    80004208:	fffff097          	auipc	ra,0xfffff
    8000420c:	230080e7          	jalr	560(ra) # 80003438 <namei>
    80004210:	c135                	beqz	a0,80004274 <exec+0x9c>
    80004212:	f3d2                	sd	s4,480(sp)
    80004214:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004216:	fffff097          	auipc	ra,0xfffff
    8000421a:	a54080e7          	jalr	-1452(ra) # 80002c6a <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000421e:	04000713          	li	a4,64
    80004222:	4681                	li	a3,0
    80004224:	e5040613          	addi	a2,s0,-432
    80004228:	4581                	li	a1,0
    8000422a:	8552                	mv	a0,s4
    8000422c:	fffff097          	auipc	ra,0xfffff
    80004230:	cf6080e7          	jalr	-778(ra) # 80002f22 <readi>
    80004234:	04000793          	li	a5,64
    80004238:	00f51a63          	bne	a0,a5,8000424c <exec+0x74>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000423c:	e5042703          	lw	a4,-432(s0)
    80004240:	464c47b7          	lui	a5,0x464c4
    80004244:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004248:	02f70c63          	beq	a4,a5,80004280 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000424c:	8552                	mv	a0,s4
    8000424e:	fffff097          	auipc	ra,0xfffff
    80004252:	c82080e7          	jalr	-894(ra) # 80002ed0 <iunlockput>
    end_op();
    80004256:	fffff097          	auipc	ra,0xfffff
    8000425a:	45c080e7          	jalr	1116(ra) # 800036b2 <end_op>
  }
  return -1;
    8000425e:	557d                	li	a0,-1
    80004260:	7a1e                	ld	s4,480(sp)
}
    80004262:	20813083          	ld	ra,520(sp)
    80004266:	20013403          	ld	s0,512(sp)
    8000426a:	74fe                	ld	s1,504(sp)
    8000426c:	795e                	ld	s2,496(sp)
    8000426e:	21010113          	addi	sp,sp,528
    80004272:	8082                	ret
    end_op();
    80004274:	fffff097          	auipc	ra,0xfffff
    80004278:	43e080e7          	jalr	1086(ra) # 800036b2 <end_op>
    return -1;
    8000427c:	557d                	li	a0,-1
    8000427e:	b7d5                	j	80004262 <exec+0x8a>
    80004280:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004282:	8526                	mv	a0,s1
    80004284:	ffffd097          	auipc	ra,0xffffd
    80004288:	d46080e7          	jalr	-698(ra) # 80000fca <proc_pagetable>
    8000428c:	8b2a                	mv	s6,a0
    8000428e:	30050f63          	beqz	a0,800045ac <exec+0x3d4>
    80004292:	f7ce                	sd	s3,488(sp)
    80004294:	efd6                	sd	s5,472(sp)
    80004296:	e7de                	sd	s7,456(sp)
    80004298:	e3e2                	sd	s8,448(sp)
    8000429a:	ff66                	sd	s9,440(sp)
    8000429c:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000429e:	e7042d03          	lw	s10,-400(s0)
    800042a2:	e8845783          	lhu	a5,-376(s0)
    800042a6:	14078d63          	beqz	a5,80004400 <exec+0x228>
    800042aa:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042ac:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042ae:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    800042b0:	6c85                	lui	s9,0x1
    800042b2:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800042b6:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800042ba:	6a85                	lui	s5,0x1
    800042bc:	a0b5                	j	80004328 <exec+0x150>
      panic("loadseg: address should exist");
    800042be:	00004517          	auipc	a0,0x4
    800042c2:	2da50513          	addi	a0,a0,730 # 80008598 <etext+0x598>
    800042c6:	00002097          	auipc	ra,0x2
    800042ca:	b6c080e7          	jalr	-1172(ra) # 80005e32 <panic>
    if(sz - i < PGSIZE)
    800042ce:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800042d0:	8726                	mv	a4,s1
    800042d2:	012c06bb          	addw	a3,s8,s2
    800042d6:	4581                	li	a1,0
    800042d8:	8552                	mv	a0,s4
    800042da:	fffff097          	auipc	ra,0xfffff
    800042de:	c48080e7          	jalr	-952(ra) # 80002f22 <readi>
    800042e2:	2501                	sext.w	a0,a0
    800042e4:	28a49863          	bne	s1,a0,80004574 <exec+0x39c>
  for(i = 0; i < sz; i += PGSIZE){
    800042e8:	012a893b          	addw	s2,s5,s2
    800042ec:	03397563          	bgeu	s2,s3,80004316 <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    800042f0:	02091593          	slli	a1,s2,0x20
    800042f4:	9181                	srli	a1,a1,0x20
    800042f6:	95de                	add	a1,a1,s7
    800042f8:	855a                	mv	a0,s6
    800042fa:	ffffc097          	auipc	ra,0xffffc
    800042fe:	202080e7          	jalr	514(ra) # 800004fc <walkaddr>
    80004302:	862a                	mv	a2,a0
    if(pa == 0)
    80004304:	dd4d                	beqz	a0,800042be <exec+0xe6>
    if(sz - i < PGSIZE)
    80004306:	412984bb          	subw	s1,s3,s2
    8000430a:	0004879b          	sext.w	a5,s1
    8000430e:	fcfcf0e3          	bgeu	s9,a5,800042ce <exec+0xf6>
    80004312:	84d6                	mv	s1,s5
    80004314:	bf6d                	j	800042ce <exec+0xf6>
    sz = sz1;
    80004316:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000431a:	2d85                	addiw	s11,s11,1
    8000431c:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    80004320:	e8845783          	lhu	a5,-376(s0)
    80004324:	08fdd663          	bge	s11,a5,800043b0 <exec+0x1d8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004328:	2d01                	sext.w	s10,s10
    8000432a:	03800713          	li	a4,56
    8000432e:	86ea                	mv	a3,s10
    80004330:	e1840613          	addi	a2,s0,-488
    80004334:	4581                	li	a1,0
    80004336:	8552                	mv	a0,s4
    80004338:	fffff097          	auipc	ra,0xfffff
    8000433c:	bea080e7          	jalr	-1046(ra) # 80002f22 <readi>
    80004340:	03800793          	li	a5,56
    80004344:	20f51063          	bne	a0,a5,80004544 <exec+0x36c>
    if(ph.type != ELF_PROG_LOAD)
    80004348:	e1842783          	lw	a5,-488(s0)
    8000434c:	4705                	li	a4,1
    8000434e:	fce796e3          	bne	a5,a4,8000431a <exec+0x142>
    if(ph.memsz < ph.filesz)
    80004352:	e4043483          	ld	s1,-448(s0)
    80004356:	e3843783          	ld	a5,-456(s0)
    8000435a:	1ef4e963          	bltu	s1,a5,8000454c <exec+0x374>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000435e:	e2843783          	ld	a5,-472(s0)
    80004362:	94be                	add	s1,s1,a5
    80004364:	1ef4e863          	bltu	s1,a5,80004554 <exec+0x37c>
    if(ph.vaddr % PGSIZE != 0)
    80004368:	df043703          	ld	a4,-528(s0)
    8000436c:	8ff9                	and	a5,a5,a4
    8000436e:	1e079763          	bnez	a5,8000455c <exec+0x384>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004372:	e1c42503          	lw	a0,-484(s0)
    80004376:	00000097          	auipc	ra,0x0
    8000437a:	e48080e7          	jalr	-440(ra) # 800041be <flags2perm>
    8000437e:	86aa                	mv	a3,a0
    80004380:	8626                	mv	a2,s1
    80004382:	85ca                	mv	a1,s2
    80004384:	855a                	mv	a0,s6
    80004386:	ffffc097          	auipc	ra,0xffffc
    8000438a:	55e080e7          	jalr	1374(ra) # 800008e4 <uvmalloc>
    8000438e:	e0a43423          	sd	a0,-504(s0)
    80004392:	1c050963          	beqz	a0,80004564 <exec+0x38c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004396:	e2843b83          	ld	s7,-472(s0)
    8000439a:	e2042c03          	lw	s8,-480(s0)
    8000439e:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800043a2:	00098463          	beqz	s3,800043aa <exec+0x1d2>
    800043a6:	4901                	li	s2,0
    800043a8:	b7a1                	j	800042f0 <exec+0x118>
    sz = sz1;
    800043aa:	e0843903          	ld	s2,-504(s0)
    800043ae:	b7b5                	j	8000431a <exec+0x142>
    800043b0:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    800043b2:	8552                	mv	a0,s4
    800043b4:	fffff097          	auipc	ra,0xfffff
    800043b8:	b1c080e7          	jalr	-1252(ra) # 80002ed0 <iunlockput>
  end_op();
    800043bc:	fffff097          	auipc	ra,0xfffff
    800043c0:	2f6080e7          	jalr	758(ra) # 800036b2 <end_op>
  p = myproc();
    800043c4:	ffffd097          	auipc	ra,0xffffd
    800043c8:	b3e080e7          	jalr	-1218(ra) # 80000f02 <myproc>
    800043cc:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800043ce:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    800043d2:	6985                	lui	s3,0x1
    800043d4:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800043d6:	99ca                	add	s3,s3,s2
    800043d8:	77fd                	lui	a5,0xfffff
    800043da:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800043de:	4691                	li	a3,4
    800043e0:	6609                	lui	a2,0x2
    800043e2:	964e                	add	a2,a2,s3
    800043e4:	85ce                	mv	a1,s3
    800043e6:	855a                	mv	a0,s6
    800043e8:	ffffc097          	auipc	ra,0xffffc
    800043ec:	4fc080e7          	jalr	1276(ra) # 800008e4 <uvmalloc>
    800043f0:	892a                	mv	s2,a0
    800043f2:	e0a43423          	sd	a0,-504(s0)
    800043f6:	e519                	bnez	a0,80004404 <exec+0x22c>
  if(pagetable)
    800043f8:	e1343423          	sd	s3,-504(s0)
    800043fc:	4a01                	li	s4,0
    800043fe:	aaa5                	j	80004576 <exec+0x39e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004400:	4901                	li	s2,0
    80004402:	bf45                	j	800043b2 <exec+0x1da>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004404:	75f9                	lui	a1,0xffffe
    80004406:	95aa                	add	a1,a1,a0
    80004408:	855a                	mv	a0,s6
    8000440a:	ffffc097          	auipc	ra,0xffffc
    8000440e:	710080e7          	jalr	1808(ra) # 80000b1a <uvmclear>
  stackbase = sp - PGSIZE;
    80004412:	7bfd                	lui	s7,0xfffff
    80004414:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004416:	e0043783          	ld	a5,-512(s0)
    8000441a:	6388                	ld	a0,0(a5)
    8000441c:	c52d                	beqz	a0,80004486 <exec+0x2ae>
    8000441e:	e9040993          	addi	s3,s0,-368
    80004422:	f9040c13          	addi	s8,s0,-112
    80004426:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004428:	ffffc097          	auipc	ra,0xffffc
    8000442c:	ec6080e7          	jalr	-314(ra) # 800002ee <strlen>
    80004430:	0015079b          	addiw	a5,a0,1
    80004434:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004438:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000443c:	13796863          	bltu	s2,s7,8000456c <exec+0x394>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004440:	e0043d03          	ld	s10,-512(s0)
    80004444:	000d3a03          	ld	s4,0(s10)
    80004448:	8552                	mv	a0,s4
    8000444a:	ffffc097          	auipc	ra,0xffffc
    8000444e:	ea4080e7          	jalr	-348(ra) # 800002ee <strlen>
    80004452:	0015069b          	addiw	a3,a0,1
    80004456:	8652                	mv	a2,s4
    80004458:	85ca                	mv	a1,s2
    8000445a:	855a                	mv	a0,s6
    8000445c:	ffffc097          	auipc	ra,0xffffc
    80004460:	6f0080e7          	jalr	1776(ra) # 80000b4c <copyout>
    80004464:	10054663          	bltz	a0,80004570 <exec+0x398>
    ustack[argc] = sp;
    80004468:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000446c:	0485                	addi	s1,s1,1
    8000446e:	008d0793          	addi	a5,s10,8
    80004472:	e0f43023          	sd	a5,-512(s0)
    80004476:	008d3503          	ld	a0,8(s10)
    8000447a:	c909                	beqz	a0,8000448c <exec+0x2b4>
    if(argc >= MAXARG)
    8000447c:	09a1                	addi	s3,s3,8
    8000447e:	fb8995e3          	bne	s3,s8,80004428 <exec+0x250>
  ip = 0;
    80004482:	4a01                	li	s4,0
    80004484:	a8cd                	j	80004576 <exec+0x39e>
  sp = sz;
    80004486:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    8000448a:	4481                	li	s1,0
  ustack[argc] = 0;
    8000448c:	00349793          	slli	a5,s1,0x3
    80004490:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffda6a0>
    80004494:	97a2                	add	a5,a5,s0
    80004496:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000449a:	00148693          	addi	a3,s1,1
    8000449e:	068e                	slli	a3,a3,0x3
    800044a0:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800044a4:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    800044a8:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    800044ac:	f57966e3          	bltu	s2,s7,800043f8 <exec+0x220>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800044b0:	e9040613          	addi	a2,s0,-368
    800044b4:	85ca                	mv	a1,s2
    800044b6:	855a                	mv	a0,s6
    800044b8:	ffffc097          	auipc	ra,0xffffc
    800044bc:	694080e7          	jalr	1684(ra) # 80000b4c <copyout>
    800044c0:	0e054863          	bltz	a0,800045b0 <exec+0x3d8>
  p->trapframe->a1 = sp;
    800044c4:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    800044c8:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800044cc:	df843783          	ld	a5,-520(s0)
    800044d0:	0007c703          	lbu	a4,0(a5)
    800044d4:	cf11                	beqz	a4,800044f0 <exec+0x318>
    800044d6:	0785                	addi	a5,a5,1
    if(*s == '/')
    800044d8:	02f00693          	li	a3,47
    800044dc:	a039                	j	800044ea <exec+0x312>
      last = s+1;
    800044de:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800044e2:	0785                	addi	a5,a5,1
    800044e4:	fff7c703          	lbu	a4,-1(a5)
    800044e8:	c701                	beqz	a4,800044f0 <exec+0x318>
    if(*s == '/')
    800044ea:	fed71ce3          	bne	a4,a3,800044e2 <exec+0x30a>
    800044ee:	bfc5                	j	800044de <exec+0x306>
  safestrcpy(p->name, last, sizeof(p->name));
    800044f0:	4641                	li	a2,16
    800044f2:	df843583          	ld	a1,-520(s0)
    800044f6:	160a8513          	addi	a0,s5,352
    800044fa:	ffffc097          	auipc	ra,0xffffc
    800044fe:	dc2080e7          	jalr	-574(ra) # 800002bc <safestrcpy>
  oldpagetable = p->pagetable;
    80004502:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004506:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    8000450a:	e0843783          	ld	a5,-504(s0)
    8000450e:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004512:	058ab783          	ld	a5,88(s5)
    80004516:	e6843703          	ld	a4,-408(s0)
    8000451a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000451c:	058ab783          	ld	a5,88(s5)
    80004520:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004524:	85e6                	mv	a1,s9
    80004526:	ffffd097          	auipc	ra,0xffffd
    8000452a:	b9a080e7          	jalr	-1126(ra) # 800010c0 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000452e:	0004851b          	sext.w	a0,s1
    80004532:	79be                	ld	s3,488(sp)
    80004534:	7a1e                	ld	s4,480(sp)
    80004536:	6afe                	ld	s5,472(sp)
    80004538:	6b5e                	ld	s6,464(sp)
    8000453a:	6bbe                	ld	s7,456(sp)
    8000453c:	6c1e                	ld	s8,448(sp)
    8000453e:	7cfa                	ld	s9,440(sp)
    80004540:	7d5a                	ld	s10,432(sp)
    80004542:	b305                	j	80004262 <exec+0x8a>
    80004544:	e1243423          	sd	s2,-504(s0)
    80004548:	7dba                	ld	s11,424(sp)
    8000454a:	a035                	j	80004576 <exec+0x39e>
    8000454c:	e1243423          	sd	s2,-504(s0)
    80004550:	7dba                	ld	s11,424(sp)
    80004552:	a015                	j	80004576 <exec+0x39e>
    80004554:	e1243423          	sd	s2,-504(s0)
    80004558:	7dba                	ld	s11,424(sp)
    8000455a:	a831                	j	80004576 <exec+0x39e>
    8000455c:	e1243423          	sd	s2,-504(s0)
    80004560:	7dba                	ld	s11,424(sp)
    80004562:	a811                	j	80004576 <exec+0x39e>
    80004564:	e1243423          	sd	s2,-504(s0)
    80004568:	7dba                	ld	s11,424(sp)
    8000456a:	a031                	j	80004576 <exec+0x39e>
  ip = 0;
    8000456c:	4a01                	li	s4,0
    8000456e:	a021                	j	80004576 <exec+0x39e>
    80004570:	4a01                	li	s4,0
  if(pagetable)
    80004572:	a011                	j	80004576 <exec+0x39e>
    80004574:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004576:	e0843583          	ld	a1,-504(s0)
    8000457a:	855a                	mv	a0,s6
    8000457c:	ffffd097          	auipc	ra,0xffffd
    80004580:	b44080e7          	jalr	-1212(ra) # 800010c0 <proc_freepagetable>
  return -1;
    80004584:	557d                	li	a0,-1
  if(ip){
    80004586:	000a1b63          	bnez	s4,8000459c <exec+0x3c4>
    8000458a:	79be                	ld	s3,488(sp)
    8000458c:	7a1e                	ld	s4,480(sp)
    8000458e:	6afe                	ld	s5,472(sp)
    80004590:	6b5e                	ld	s6,464(sp)
    80004592:	6bbe                	ld	s7,456(sp)
    80004594:	6c1e                	ld	s8,448(sp)
    80004596:	7cfa                	ld	s9,440(sp)
    80004598:	7d5a                	ld	s10,432(sp)
    8000459a:	b1e1                	j	80004262 <exec+0x8a>
    8000459c:	79be                	ld	s3,488(sp)
    8000459e:	6afe                	ld	s5,472(sp)
    800045a0:	6b5e                	ld	s6,464(sp)
    800045a2:	6bbe                	ld	s7,456(sp)
    800045a4:	6c1e                	ld	s8,448(sp)
    800045a6:	7cfa                	ld	s9,440(sp)
    800045a8:	7d5a                	ld	s10,432(sp)
    800045aa:	b14d                	j	8000424c <exec+0x74>
    800045ac:	6b5e                	ld	s6,464(sp)
    800045ae:	b979                	j	8000424c <exec+0x74>
  sz = sz1;
    800045b0:	e0843983          	ld	s3,-504(s0)
    800045b4:	b591                	j	800043f8 <exec+0x220>

00000000800045b6 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800045b6:	7179                	addi	sp,sp,-48
    800045b8:	f406                	sd	ra,40(sp)
    800045ba:	f022                	sd	s0,32(sp)
    800045bc:	ec26                	sd	s1,24(sp)
    800045be:	e84a                	sd	s2,16(sp)
    800045c0:	1800                	addi	s0,sp,48
    800045c2:	892e                	mv	s2,a1
    800045c4:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800045c6:	fdc40593          	addi	a1,s0,-36
    800045ca:	ffffe097          	auipc	ra,0xffffe
    800045ce:	b08080e7          	jalr	-1272(ra) # 800020d2 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800045d2:	fdc42703          	lw	a4,-36(s0)
    800045d6:	47bd                	li	a5,15
    800045d8:	02e7eb63          	bltu	a5,a4,8000460e <argfd+0x58>
    800045dc:	ffffd097          	auipc	ra,0xffffd
    800045e0:	926080e7          	jalr	-1754(ra) # 80000f02 <myproc>
    800045e4:	fdc42703          	lw	a4,-36(s0)
    800045e8:	01a70793          	addi	a5,a4,26
    800045ec:	078e                	slli	a5,a5,0x3
    800045ee:	953e                	add	a0,a0,a5
    800045f0:	651c                	ld	a5,8(a0)
    800045f2:	c385                	beqz	a5,80004612 <argfd+0x5c>
    return -1;
  if(pfd)
    800045f4:	00090463          	beqz	s2,800045fc <argfd+0x46>
    *pfd = fd;
    800045f8:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800045fc:	4501                	li	a0,0
  if(pf)
    800045fe:	c091                	beqz	s1,80004602 <argfd+0x4c>
    *pf = f;
    80004600:	e09c                	sd	a5,0(s1)
}
    80004602:	70a2                	ld	ra,40(sp)
    80004604:	7402                	ld	s0,32(sp)
    80004606:	64e2                	ld	s1,24(sp)
    80004608:	6942                	ld	s2,16(sp)
    8000460a:	6145                	addi	sp,sp,48
    8000460c:	8082                	ret
    return -1;
    8000460e:	557d                	li	a0,-1
    80004610:	bfcd                	j	80004602 <argfd+0x4c>
    80004612:	557d                	li	a0,-1
    80004614:	b7fd                	j	80004602 <argfd+0x4c>

0000000080004616 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004616:	1101                	addi	sp,sp,-32
    80004618:	ec06                	sd	ra,24(sp)
    8000461a:	e822                	sd	s0,16(sp)
    8000461c:	e426                	sd	s1,8(sp)
    8000461e:	1000                	addi	s0,sp,32
    80004620:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004622:	ffffd097          	auipc	ra,0xffffd
    80004626:	8e0080e7          	jalr	-1824(ra) # 80000f02 <myproc>
    8000462a:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000462c:	0d850793          	addi	a5,a0,216
    80004630:	4501                	li	a0,0
    80004632:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004634:	6398                	ld	a4,0(a5)
    80004636:	cb19                	beqz	a4,8000464c <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004638:	2505                	addiw	a0,a0,1
    8000463a:	07a1                	addi	a5,a5,8
    8000463c:	fed51ce3          	bne	a0,a3,80004634 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004640:	557d                	li	a0,-1
}
    80004642:	60e2                	ld	ra,24(sp)
    80004644:	6442                	ld	s0,16(sp)
    80004646:	64a2                	ld	s1,8(sp)
    80004648:	6105                	addi	sp,sp,32
    8000464a:	8082                	ret
      p->ofile[fd] = f;
    8000464c:	01a50793          	addi	a5,a0,26
    80004650:	078e                	slli	a5,a5,0x3
    80004652:	963e                	add	a2,a2,a5
    80004654:	e604                	sd	s1,8(a2)
      return fd;
    80004656:	b7f5                	j	80004642 <fdalloc+0x2c>

0000000080004658 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004658:	715d                	addi	sp,sp,-80
    8000465a:	e486                	sd	ra,72(sp)
    8000465c:	e0a2                	sd	s0,64(sp)
    8000465e:	fc26                	sd	s1,56(sp)
    80004660:	f84a                	sd	s2,48(sp)
    80004662:	f44e                	sd	s3,40(sp)
    80004664:	ec56                	sd	s5,24(sp)
    80004666:	e85a                	sd	s6,16(sp)
    80004668:	0880                	addi	s0,sp,80
    8000466a:	8b2e                	mv	s6,a1
    8000466c:	89b2                	mv	s3,a2
    8000466e:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004670:	fb040593          	addi	a1,s0,-80
    80004674:	fffff097          	auipc	ra,0xfffff
    80004678:	de2080e7          	jalr	-542(ra) # 80003456 <nameiparent>
    8000467c:	84aa                	mv	s1,a0
    8000467e:	14050e63          	beqz	a0,800047da <create+0x182>
    return 0;

  ilock(dp);
    80004682:	ffffe097          	auipc	ra,0xffffe
    80004686:	5e8080e7          	jalr	1512(ra) # 80002c6a <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000468a:	4601                	li	a2,0
    8000468c:	fb040593          	addi	a1,s0,-80
    80004690:	8526                	mv	a0,s1
    80004692:	fffff097          	auipc	ra,0xfffff
    80004696:	ae4080e7          	jalr	-1308(ra) # 80003176 <dirlookup>
    8000469a:	8aaa                	mv	s5,a0
    8000469c:	c539                	beqz	a0,800046ea <create+0x92>
    iunlockput(dp);
    8000469e:	8526                	mv	a0,s1
    800046a0:	fffff097          	auipc	ra,0xfffff
    800046a4:	830080e7          	jalr	-2000(ra) # 80002ed0 <iunlockput>
    ilock(ip);
    800046a8:	8556                	mv	a0,s5
    800046aa:	ffffe097          	auipc	ra,0xffffe
    800046ae:	5c0080e7          	jalr	1472(ra) # 80002c6a <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800046b2:	4789                	li	a5,2
    800046b4:	02fb1463          	bne	s6,a5,800046dc <create+0x84>
    800046b8:	044ad783          	lhu	a5,68(s5)
    800046bc:	37f9                	addiw	a5,a5,-2
    800046be:	17c2                	slli	a5,a5,0x30
    800046c0:	93c1                	srli	a5,a5,0x30
    800046c2:	4705                	li	a4,1
    800046c4:	00f76c63          	bltu	a4,a5,800046dc <create+0x84>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800046c8:	8556                	mv	a0,s5
    800046ca:	60a6                	ld	ra,72(sp)
    800046cc:	6406                	ld	s0,64(sp)
    800046ce:	74e2                	ld	s1,56(sp)
    800046d0:	7942                	ld	s2,48(sp)
    800046d2:	79a2                	ld	s3,40(sp)
    800046d4:	6ae2                	ld	s5,24(sp)
    800046d6:	6b42                	ld	s6,16(sp)
    800046d8:	6161                	addi	sp,sp,80
    800046da:	8082                	ret
    iunlockput(ip);
    800046dc:	8556                	mv	a0,s5
    800046de:	ffffe097          	auipc	ra,0xffffe
    800046e2:	7f2080e7          	jalr	2034(ra) # 80002ed0 <iunlockput>
    return 0;
    800046e6:	4a81                	li	s5,0
    800046e8:	b7c5                	j	800046c8 <create+0x70>
    800046ea:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    800046ec:	85da                	mv	a1,s6
    800046ee:	4088                	lw	a0,0(s1)
    800046f0:	ffffe097          	auipc	ra,0xffffe
    800046f4:	3d6080e7          	jalr	982(ra) # 80002ac6 <ialloc>
    800046f8:	8a2a                	mv	s4,a0
    800046fa:	c531                	beqz	a0,80004746 <create+0xee>
  ilock(ip);
    800046fc:	ffffe097          	auipc	ra,0xffffe
    80004700:	56e080e7          	jalr	1390(ra) # 80002c6a <ilock>
  ip->major = major;
    80004704:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004708:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000470c:	4905                	li	s2,1
    8000470e:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004712:	8552                	mv	a0,s4
    80004714:	ffffe097          	auipc	ra,0xffffe
    80004718:	48a080e7          	jalr	1162(ra) # 80002b9e <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000471c:	032b0d63          	beq	s6,s2,80004756 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80004720:	004a2603          	lw	a2,4(s4)
    80004724:	fb040593          	addi	a1,s0,-80
    80004728:	8526                	mv	a0,s1
    8000472a:	fffff097          	auipc	ra,0xfffff
    8000472e:	c5c080e7          	jalr	-932(ra) # 80003386 <dirlink>
    80004732:	08054163          	bltz	a0,800047b4 <create+0x15c>
  iunlockput(dp);
    80004736:	8526                	mv	a0,s1
    80004738:	ffffe097          	auipc	ra,0xffffe
    8000473c:	798080e7          	jalr	1944(ra) # 80002ed0 <iunlockput>
  return ip;
    80004740:	8ad2                	mv	s5,s4
    80004742:	7a02                	ld	s4,32(sp)
    80004744:	b751                	j	800046c8 <create+0x70>
    iunlockput(dp);
    80004746:	8526                	mv	a0,s1
    80004748:	ffffe097          	auipc	ra,0xffffe
    8000474c:	788080e7          	jalr	1928(ra) # 80002ed0 <iunlockput>
    return 0;
    80004750:	8ad2                	mv	s5,s4
    80004752:	7a02                	ld	s4,32(sp)
    80004754:	bf95                	j	800046c8 <create+0x70>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004756:	004a2603          	lw	a2,4(s4)
    8000475a:	00004597          	auipc	a1,0x4
    8000475e:	e5e58593          	addi	a1,a1,-418 # 800085b8 <etext+0x5b8>
    80004762:	8552                	mv	a0,s4
    80004764:	fffff097          	auipc	ra,0xfffff
    80004768:	c22080e7          	jalr	-990(ra) # 80003386 <dirlink>
    8000476c:	04054463          	bltz	a0,800047b4 <create+0x15c>
    80004770:	40d0                	lw	a2,4(s1)
    80004772:	00004597          	auipc	a1,0x4
    80004776:	e4e58593          	addi	a1,a1,-434 # 800085c0 <etext+0x5c0>
    8000477a:	8552                	mv	a0,s4
    8000477c:	fffff097          	auipc	ra,0xfffff
    80004780:	c0a080e7          	jalr	-1014(ra) # 80003386 <dirlink>
    80004784:	02054863          	bltz	a0,800047b4 <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004788:	004a2603          	lw	a2,4(s4)
    8000478c:	fb040593          	addi	a1,s0,-80
    80004790:	8526                	mv	a0,s1
    80004792:	fffff097          	auipc	ra,0xfffff
    80004796:	bf4080e7          	jalr	-1036(ra) # 80003386 <dirlink>
    8000479a:	00054d63          	bltz	a0,800047b4 <create+0x15c>
    dp->nlink++;  // for ".."
    8000479e:	04a4d783          	lhu	a5,74(s1)
    800047a2:	2785                	addiw	a5,a5,1
    800047a4:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800047a8:	8526                	mv	a0,s1
    800047aa:	ffffe097          	auipc	ra,0xffffe
    800047ae:	3f4080e7          	jalr	1012(ra) # 80002b9e <iupdate>
    800047b2:	b751                	j	80004736 <create+0xde>
  ip->nlink = 0;
    800047b4:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800047b8:	8552                	mv	a0,s4
    800047ba:	ffffe097          	auipc	ra,0xffffe
    800047be:	3e4080e7          	jalr	996(ra) # 80002b9e <iupdate>
  iunlockput(ip);
    800047c2:	8552                	mv	a0,s4
    800047c4:	ffffe097          	auipc	ra,0xffffe
    800047c8:	70c080e7          	jalr	1804(ra) # 80002ed0 <iunlockput>
  iunlockput(dp);
    800047cc:	8526                	mv	a0,s1
    800047ce:	ffffe097          	auipc	ra,0xffffe
    800047d2:	702080e7          	jalr	1794(ra) # 80002ed0 <iunlockput>
  return 0;
    800047d6:	7a02                	ld	s4,32(sp)
    800047d8:	bdc5                	j	800046c8 <create+0x70>
    return 0;
    800047da:	8aaa                	mv	s5,a0
    800047dc:	b5f5                	j	800046c8 <create+0x70>

00000000800047de <sys_dup>:
{
    800047de:	7179                	addi	sp,sp,-48
    800047e0:	f406                	sd	ra,40(sp)
    800047e2:	f022                	sd	s0,32(sp)
    800047e4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800047e6:	fd840613          	addi	a2,s0,-40
    800047ea:	4581                	li	a1,0
    800047ec:	4501                	li	a0,0
    800047ee:	00000097          	auipc	ra,0x0
    800047f2:	dc8080e7          	jalr	-568(ra) # 800045b6 <argfd>
    return -1;
    800047f6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800047f8:	02054763          	bltz	a0,80004826 <sys_dup+0x48>
    800047fc:	ec26                	sd	s1,24(sp)
    800047fe:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004800:	fd843903          	ld	s2,-40(s0)
    80004804:	854a                	mv	a0,s2
    80004806:	00000097          	auipc	ra,0x0
    8000480a:	e10080e7          	jalr	-496(ra) # 80004616 <fdalloc>
    8000480e:	84aa                	mv	s1,a0
    return -1;
    80004810:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004812:	00054f63          	bltz	a0,80004830 <sys_dup+0x52>
  filedup(f);
    80004816:	854a                	mv	a0,s2
    80004818:	fffff097          	auipc	ra,0xfffff
    8000481c:	298080e7          	jalr	664(ra) # 80003ab0 <filedup>
  return fd;
    80004820:	87a6                	mv	a5,s1
    80004822:	64e2                	ld	s1,24(sp)
    80004824:	6942                	ld	s2,16(sp)
}
    80004826:	853e                	mv	a0,a5
    80004828:	70a2                	ld	ra,40(sp)
    8000482a:	7402                	ld	s0,32(sp)
    8000482c:	6145                	addi	sp,sp,48
    8000482e:	8082                	ret
    80004830:	64e2                	ld	s1,24(sp)
    80004832:	6942                	ld	s2,16(sp)
    80004834:	bfcd                	j	80004826 <sys_dup+0x48>

0000000080004836 <sys_read>:
{
    80004836:	7179                	addi	sp,sp,-48
    80004838:	f406                	sd	ra,40(sp)
    8000483a:	f022                	sd	s0,32(sp)
    8000483c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000483e:	fd840593          	addi	a1,s0,-40
    80004842:	4505                	li	a0,1
    80004844:	ffffe097          	auipc	ra,0xffffe
    80004848:	8ae080e7          	jalr	-1874(ra) # 800020f2 <argaddr>
  argint(2, &n);
    8000484c:	fe440593          	addi	a1,s0,-28
    80004850:	4509                	li	a0,2
    80004852:	ffffe097          	auipc	ra,0xffffe
    80004856:	880080e7          	jalr	-1920(ra) # 800020d2 <argint>
  if(argfd(0, 0, &f) < 0)
    8000485a:	fe840613          	addi	a2,s0,-24
    8000485e:	4581                	li	a1,0
    80004860:	4501                	li	a0,0
    80004862:	00000097          	auipc	ra,0x0
    80004866:	d54080e7          	jalr	-684(ra) # 800045b6 <argfd>
    8000486a:	87aa                	mv	a5,a0
    return -1;
    8000486c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000486e:	0007cc63          	bltz	a5,80004886 <sys_read+0x50>
  return fileread(f, p, n);
    80004872:	fe442603          	lw	a2,-28(s0)
    80004876:	fd843583          	ld	a1,-40(s0)
    8000487a:	fe843503          	ld	a0,-24(s0)
    8000487e:	fffff097          	auipc	ra,0xfffff
    80004882:	3d8080e7          	jalr	984(ra) # 80003c56 <fileread>
}
    80004886:	70a2                	ld	ra,40(sp)
    80004888:	7402                	ld	s0,32(sp)
    8000488a:	6145                	addi	sp,sp,48
    8000488c:	8082                	ret

000000008000488e <sys_write>:
{
    8000488e:	7179                	addi	sp,sp,-48
    80004890:	f406                	sd	ra,40(sp)
    80004892:	f022                	sd	s0,32(sp)
    80004894:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004896:	fd840593          	addi	a1,s0,-40
    8000489a:	4505                	li	a0,1
    8000489c:	ffffe097          	auipc	ra,0xffffe
    800048a0:	856080e7          	jalr	-1962(ra) # 800020f2 <argaddr>
  argint(2, &n);
    800048a4:	fe440593          	addi	a1,s0,-28
    800048a8:	4509                	li	a0,2
    800048aa:	ffffe097          	auipc	ra,0xffffe
    800048ae:	828080e7          	jalr	-2008(ra) # 800020d2 <argint>
  if(argfd(0, 0, &f) < 0)
    800048b2:	fe840613          	addi	a2,s0,-24
    800048b6:	4581                	li	a1,0
    800048b8:	4501                	li	a0,0
    800048ba:	00000097          	auipc	ra,0x0
    800048be:	cfc080e7          	jalr	-772(ra) # 800045b6 <argfd>
    800048c2:	87aa                	mv	a5,a0
    return -1;
    800048c4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800048c6:	0007cc63          	bltz	a5,800048de <sys_write+0x50>
  return filewrite(f, p, n);
    800048ca:	fe442603          	lw	a2,-28(s0)
    800048ce:	fd843583          	ld	a1,-40(s0)
    800048d2:	fe843503          	ld	a0,-24(s0)
    800048d6:	fffff097          	auipc	ra,0xfffff
    800048da:	452080e7          	jalr	1106(ra) # 80003d28 <filewrite>
}
    800048de:	70a2                	ld	ra,40(sp)
    800048e0:	7402                	ld	s0,32(sp)
    800048e2:	6145                	addi	sp,sp,48
    800048e4:	8082                	ret

00000000800048e6 <sys_close>:
{
    800048e6:	1101                	addi	sp,sp,-32
    800048e8:	ec06                	sd	ra,24(sp)
    800048ea:	e822                	sd	s0,16(sp)
    800048ec:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800048ee:	fe040613          	addi	a2,s0,-32
    800048f2:	fec40593          	addi	a1,s0,-20
    800048f6:	4501                	li	a0,0
    800048f8:	00000097          	auipc	ra,0x0
    800048fc:	cbe080e7          	jalr	-834(ra) # 800045b6 <argfd>
    return -1;
    80004900:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004902:	02054463          	bltz	a0,8000492a <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004906:	ffffc097          	auipc	ra,0xffffc
    8000490a:	5fc080e7          	jalr	1532(ra) # 80000f02 <myproc>
    8000490e:	fec42783          	lw	a5,-20(s0)
    80004912:	07e9                	addi	a5,a5,26
    80004914:	078e                	slli	a5,a5,0x3
    80004916:	953e                	add	a0,a0,a5
    80004918:	00053423          	sd	zero,8(a0)
  fileclose(f);
    8000491c:	fe043503          	ld	a0,-32(s0)
    80004920:	fffff097          	auipc	ra,0xfffff
    80004924:	1e2080e7          	jalr	482(ra) # 80003b02 <fileclose>
  return 0;
    80004928:	4781                	li	a5,0
}
    8000492a:	853e                	mv	a0,a5
    8000492c:	60e2                	ld	ra,24(sp)
    8000492e:	6442                	ld	s0,16(sp)
    80004930:	6105                	addi	sp,sp,32
    80004932:	8082                	ret

0000000080004934 <sys_fstat>:
{
    80004934:	1101                	addi	sp,sp,-32
    80004936:	ec06                	sd	ra,24(sp)
    80004938:	e822                	sd	s0,16(sp)
    8000493a:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000493c:	fe040593          	addi	a1,s0,-32
    80004940:	4505                	li	a0,1
    80004942:	ffffd097          	auipc	ra,0xffffd
    80004946:	7b0080e7          	jalr	1968(ra) # 800020f2 <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000494a:	fe840613          	addi	a2,s0,-24
    8000494e:	4581                	li	a1,0
    80004950:	4501                	li	a0,0
    80004952:	00000097          	auipc	ra,0x0
    80004956:	c64080e7          	jalr	-924(ra) # 800045b6 <argfd>
    8000495a:	87aa                	mv	a5,a0
    return -1;
    8000495c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000495e:	0007ca63          	bltz	a5,80004972 <sys_fstat+0x3e>
  return filestat(f, st);
    80004962:	fe043583          	ld	a1,-32(s0)
    80004966:	fe843503          	ld	a0,-24(s0)
    8000496a:	fffff097          	auipc	ra,0xfffff
    8000496e:	27a080e7          	jalr	634(ra) # 80003be4 <filestat>
}
    80004972:	60e2                	ld	ra,24(sp)
    80004974:	6442                	ld	s0,16(sp)
    80004976:	6105                	addi	sp,sp,32
    80004978:	8082                	ret

000000008000497a <sys_link>:
{
    8000497a:	7169                	addi	sp,sp,-304
    8000497c:	f606                	sd	ra,296(sp)
    8000497e:	f222                	sd	s0,288(sp)
    80004980:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004982:	08000613          	li	a2,128
    80004986:	ed040593          	addi	a1,s0,-304
    8000498a:	4501                	li	a0,0
    8000498c:	ffffd097          	auipc	ra,0xffffd
    80004990:	786080e7          	jalr	1926(ra) # 80002112 <argstr>
    return -1;
    80004994:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004996:	12054663          	bltz	a0,80004ac2 <sys_link+0x148>
    8000499a:	08000613          	li	a2,128
    8000499e:	f5040593          	addi	a1,s0,-176
    800049a2:	4505                	li	a0,1
    800049a4:	ffffd097          	auipc	ra,0xffffd
    800049a8:	76e080e7          	jalr	1902(ra) # 80002112 <argstr>
    return -1;
    800049ac:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049ae:	10054a63          	bltz	a0,80004ac2 <sys_link+0x148>
    800049b2:	ee26                	sd	s1,280(sp)
  begin_op();
    800049b4:	fffff097          	auipc	ra,0xfffff
    800049b8:	c84080e7          	jalr	-892(ra) # 80003638 <begin_op>
  if((ip = namei(old)) == 0){
    800049bc:	ed040513          	addi	a0,s0,-304
    800049c0:	fffff097          	auipc	ra,0xfffff
    800049c4:	a78080e7          	jalr	-1416(ra) # 80003438 <namei>
    800049c8:	84aa                	mv	s1,a0
    800049ca:	c949                	beqz	a0,80004a5c <sys_link+0xe2>
  ilock(ip);
    800049cc:	ffffe097          	auipc	ra,0xffffe
    800049d0:	29e080e7          	jalr	670(ra) # 80002c6a <ilock>
  if(ip->type == T_DIR){
    800049d4:	04449703          	lh	a4,68(s1)
    800049d8:	4785                	li	a5,1
    800049da:	08f70863          	beq	a4,a5,80004a6a <sys_link+0xf0>
    800049de:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800049e0:	04a4d783          	lhu	a5,74(s1)
    800049e4:	2785                	addiw	a5,a5,1
    800049e6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049ea:	8526                	mv	a0,s1
    800049ec:	ffffe097          	auipc	ra,0xffffe
    800049f0:	1b2080e7          	jalr	434(ra) # 80002b9e <iupdate>
  iunlock(ip);
    800049f4:	8526                	mv	a0,s1
    800049f6:	ffffe097          	auipc	ra,0xffffe
    800049fa:	33a080e7          	jalr	826(ra) # 80002d30 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800049fe:	fd040593          	addi	a1,s0,-48
    80004a02:	f5040513          	addi	a0,s0,-176
    80004a06:	fffff097          	auipc	ra,0xfffff
    80004a0a:	a50080e7          	jalr	-1456(ra) # 80003456 <nameiparent>
    80004a0e:	892a                	mv	s2,a0
    80004a10:	cd35                	beqz	a0,80004a8c <sys_link+0x112>
  ilock(dp);
    80004a12:	ffffe097          	auipc	ra,0xffffe
    80004a16:	258080e7          	jalr	600(ra) # 80002c6a <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a1a:	00092703          	lw	a4,0(s2)
    80004a1e:	409c                	lw	a5,0(s1)
    80004a20:	06f71163          	bne	a4,a5,80004a82 <sys_link+0x108>
    80004a24:	40d0                	lw	a2,4(s1)
    80004a26:	fd040593          	addi	a1,s0,-48
    80004a2a:	854a                	mv	a0,s2
    80004a2c:	fffff097          	auipc	ra,0xfffff
    80004a30:	95a080e7          	jalr	-1702(ra) # 80003386 <dirlink>
    80004a34:	04054763          	bltz	a0,80004a82 <sys_link+0x108>
  iunlockput(dp);
    80004a38:	854a                	mv	a0,s2
    80004a3a:	ffffe097          	auipc	ra,0xffffe
    80004a3e:	496080e7          	jalr	1174(ra) # 80002ed0 <iunlockput>
  iput(ip);
    80004a42:	8526                	mv	a0,s1
    80004a44:	ffffe097          	auipc	ra,0xffffe
    80004a48:	3e4080e7          	jalr	996(ra) # 80002e28 <iput>
  end_op();
    80004a4c:	fffff097          	auipc	ra,0xfffff
    80004a50:	c66080e7          	jalr	-922(ra) # 800036b2 <end_op>
  return 0;
    80004a54:	4781                	li	a5,0
    80004a56:	64f2                	ld	s1,280(sp)
    80004a58:	6952                	ld	s2,272(sp)
    80004a5a:	a0a5                	j	80004ac2 <sys_link+0x148>
    end_op();
    80004a5c:	fffff097          	auipc	ra,0xfffff
    80004a60:	c56080e7          	jalr	-938(ra) # 800036b2 <end_op>
    return -1;
    80004a64:	57fd                	li	a5,-1
    80004a66:	64f2                	ld	s1,280(sp)
    80004a68:	a8a9                	j	80004ac2 <sys_link+0x148>
    iunlockput(ip);
    80004a6a:	8526                	mv	a0,s1
    80004a6c:	ffffe097          	auipc	ra,0xffffe
    80004a70:	464080e7          	jalr	1124(ra) # 80002ed0 <iunlockput>
    end_op();
    80004a74:	fffff097          	auipc	ra,0xfffff
    80004a78:	c3e080e7          	jalr	-962(ra) # 800036b2 <end_op>
    return -1;
    80004a7c:	57fd                	li	a5,-1
    80004a7e:	64f2                	ld	s1,280(sp)
    80004a80:	a089                	j	80004ac2 <sys_link+0x148>
    iunlockput(dp);
    80004a82:	854a                	mv	a0,s2
    80004a84:	ffffe097          	auipc	ra,0xffffe
    80004a88:	44c080e7          	jalr	1100(ra) # 80002ed0 <iunlockput>
  ilock(ip);
    80004a8c:	8526                	mv	a0,s1
    80004a8e:	ffffe097          	auipc	ra,0xffffe
    80004a92:	1dc080e7          	jalr	476(ra) # 80002c6a <ilock>
  ip->nlink--;
    80004a96:	04a4d783          	lhu	a5,74(s1)
    80004a9a:	37fd                	addiw	a5,a5,-1
    80004a9c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004aa0:	8526                	mv	a0,s1
    80004aa2:	ffffe097          	auipc	ra,0xffffe
    80004aa6:	0fc080e7          	jalr	252(ra) # 80002b9e <iupdate>
  iunlockput(ip);
    80004aaa:	8526                	mv	a0,s1
    80004aac:	ffffe097          	auipc	ra,0xffffe
    80004ab0:	424080e7          	jalr	1060(ra) # 80002ed0 <iunlockput>
  end_op();
    80004ab4:	fffff097          	auipc	ra,0xfffff
    80004ab8:	bfe080e7          	jalr	-1026(ra) # 800036b2 <end_op>
  return -1;
    80004abc:	57fd                	li	a5,-1
    80004abe:	64f2                	ld	s1,280(sp)
    80004ac0:	6952                	ld	s2,272(sp)
}
    80004ac2:	853e                	mv	a0,a5
    80004ac4:	70b2                	ld	ra,296(sp)
    80004ac6:	7412                	ld	s0,288(sp)
    80004ac8:	6155                	addi	sp,sp,304
    80004aca:	8082                	ret

0000000080004acc <sys_unlink>:
{
    80004acc:	7151                	addi	sp,sp,-240
    80004ace:	f586                	sd	ra,232(sp)
    80004ad0:	f1a2                	sd	s0,224(sp)
    80004ad2:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004ad4:	08000613          	li	a2,128
    80004ad8:	f3040593          	addi	a1,s0,-208
    80004adc:	4501                	li	a0,0
    80004ade:	ffffd097          	auipc	ra,0xffffd
    80004ae2:	634080e7          	jalr	1588(ra) # 80002112 <argstr>
    80004ae6:	1a054a63          	bltz	a0,80004c9a <sys_unlink+0x1ce>
    80004aea:	eda6                	sd	s1,216(sp)
  begin_op();
    80004aec:	fffff097          	auipc	ra,0xfffff
    80004af0:	b4c080e7          	jalr	-1204(ra) # 80003638 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004af4:	fb040593          	addi	a1,s0,-80
    80004af8:	f3040513          	addi	a0,s0,-208
    80004afc:	fffff097          	auipc	ra,0xfffff
    80004b00:	95a080e7          	jalr	-1702(ra) # 80003456 <nameiparent>
    80004b04:	84aa                	mv	s1,a0
    80004b06:	cd71                	beqz	a0,80004be2 <sys_unlink+0x116>
  ilock(dp);
    80004b08:	ffffe097          	auipc	ra,0xffffe
    80004b0c:	162080e7          	jalr	354(ra) # 80002c6a <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004b10:	00004597          	auipc	a1,0x4
    80004b14:	aa858593          	addi	a1,a1,-1368 # 800085b8 <etext+0x5b8>
    80004b18:	fb040513          	addi	a0,s0,-80
    80004b1c:	ffffe097          	auipc	ra,0xffffe
    80004b20:	640080e7          	jalr	1600(ra) # 8000315c <namecmp>
    80004b24:	14050c63          	beqz	a0,80004c7c <sys_unlink+0x1b0>
    80004b28:	00004597          	auipc	a1,0x4
    80004b2c:	a9858593          	addi	a1,a1,-1384 # 800085c0 <etext+0x5c0>
    80004b30:	fb040513          	addi	a0,s0,-80
    80004b34:	ffffe097          	auipc	ra,0xffffe
    80004b38:	628080e7          	jalr	1576(ra) # 8000315c <namecmp>
    80004b3c:	14050063          	beqz	a0,80004c7c <sys_unlink+0x1b0>
    80004b40:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b42:	f2c40613          	addi	a2,s0,-212
    80004b46:	fb040593          	addi	a1,s0,-80
    80004b4a:	8526                	mv	a0,s1
    80004b4c:	ffffe097          	auipc	ra,0xffffe
    80004b50:	62a080e7          	jalr	1578(ra) # 80003176 <dirlookup>
    80004b54:	892a                	mv	s2,a0
    80004b56:	12050263          	beqz	a0,80004c7a <sys_unlink+0x1ae>
  ilock(ip);
    80004b5a:	ffffe097          	auipc	ra,0xffffe
    80004b5e:	110080e7          	jalr	272(ra) # 80002c6a <ilock>
  if(ip->nlink < 1)
    80004b62:	04a91783          	lh	a5,74(s2)
    80004b66:	08f05563          	blez	a5,80004bf0 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b6a:	04491703          	lh	a4,68(s2)
    80004b6e:	4785                	li	a5,1
    80004b70:	08f70963          	beq	a4,a5,80004c02 <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004b74:	4641                	li	a2,16
    80004b76:	4581                	li	a1,0
    80004b78:	fc040513          	addi	a0,s0,-64
    80004b7c:	ffffb097          	auipc	ra,0xffffb
    80004b80:	5fe080e7          	jalr	1534(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b84:	4741                	li	a4,16
    80004b86:	f2c42683          	lw	a3,-212(s0)
    80004b8a:	fc040613          	addi	a2,s0,-64
    80004b8e:	4581                	li	a1,0
    80004b90:	8526                	mv	a0,s1
    80004b92:	ffffe097          	auipc	ra,0xffffe
    80004b96:	4a0080e7          	jalr	1184(ra) # 80003032 <writei>
    80004b9a:	47c1                	li	a5,16
    80004b9c:	0af51b63          	bne	a0,a5,80004c52 <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80004ba0:	04491703          	lh	a4,68(s2)
    80004ba4:	4785                	li	a5,1
    80004ba6:	0af70f63          	beq	a4,a5,80004c64 <sys_unlink+0x198>
  iunlockput(dp);
    80004baa:	8526                	mv	a0,s1
    80004bac:	ffffe097          	auipc	ra,0xffffe
    80004bb0:	324080e7          	jalr	804(ra) # 80002ed0 <iunlockput>
  ip->nlink--;
    80004bb4:	04a95783          	lhu	a5,74(s2)
    80004bb8:	37fd                	addiw	a5,a5,-1
    80004bba:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004bbe:	854a                	mv	a0,s2
    80004bc0:	ffffe097          	auipc	ra,0xffffe
    80004bc4:	fde080e7          	jalr	-34(ra) # 80002b9e <iupdate>
  iunlockput(ip);
    80004bc8:	854a                	mv	a0,s2
    80004bca:	ffffe097          	auipc	ra,0xffffe
    80004bce:	306080e7          	jalr	774(ra) # 80002ed0 <iunlockput>
  end_op();
    80004bd2:	fffff097          	auipc	ra,0xfffff
    80004bd6:	ae0080e7          	jalr	-1312(ra) # 800036b2 <end_op>
  return 0;
    80004bda:	4501                	li	a0,0
    80004bdc:	64ee                	ld	s1,216(sp)
    80004bde:	694e                	ld	s2,208(sp)
    80004be0:	a84d                	j	80004c92 <sys_unlink+0x1c6>
    end_op();
    80004be2:	fffff097          	auipc	ra,0xfffff
    80004be6:	ad0080e7          	jalr	-1328(ra) # 800036b2 <end_op>
    return -1;
    80004bea:	557d                	li	a0,-1
    80004bec:	64ee                	ld	s1,216(sp)
    80004bee:	a055                	j	80004c92 <sys_unlink+0x1c6>
    80004bf0:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004bf2:	00004517          	auipc	a0,0x4
    80004bf6:	9d650513          	addi	a0,a0,-1578 # 800085c8 <etext+0x5c8>
    80004bfa:	00001097          	auipc	ra,0x1
    80004bfe:	238080e7          	jalr	568(ra) # 80005e32 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c02:	04c92703          	lw	a4,76(s2)
    80004c06:	02000793          	li	a5,32
    80004c0a:	f6e7f5e3          	bgeu	a5,a4,80004b74 <sys_unlink+0xa8>
    80004c0e:	e5ce                	sd	s3,200(sp)
    80004c10:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c14:	4741                	li	a4,16
    80004c16:	86ce                	mv	a3,s3
    80004c18:	f1840613          	addi	a2,s0,-232
    80004c1c:	4581                	li	a1,0
    80004c1e:	854a                	mv	a0,s2
    80004c20:	ffffe097          	auipc	ra,0xffffe
    80004c24:	302080e7          	jalr	770(ra) # 80002f22 <readi>
    80004c28:	47c1                	li	a5,16
    80004c2a:	00f51c63          	bne	a0,a5,80004c42 <sys_unlink+0x176>
    if(de.inum != 0)
    80004c2e:	f1845783          	lhu	a5,-232(s0)
    80004c32:	e7b5                	bnez	a5,80004c9e <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c34:	29c1                	addiw	s3,s3,16
    80004c36:	04c92783          	lw	a5,76(s2)
    80004c3a:	fcf9ede3          	bltu	s3,a5,80004c14 <sys_unlink+0x148>
    80004c3e:	69ae                	ld	s3,200(sp)
    80004c40:	bf15                	j	80004b74 <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004c42:	00004517          	auipc	a0,0x4
    80004c46:	99e50513          	addi	a0,a0,-1634 # 800085e0 <etext+0x5e0>
    80004c4a:	00001097          	auipc	ra,0x1
    80004c4e:	1e8080e7          	jalr	488(ra) # 80005e32 <panic>
    80004c52:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004c54:	00004517          	auipc	a0,0x4
    80004c58:	9a450513          	addi	a0,a0,-1628 # 800085f8 <etext+0x5f8>
    80004c5c:	00001097          	auipc	ra,0x1
    80004c60:	1d6080e7          	jalr	470(ra) # 80005e32 <panic>
    dp->nlink--;
    80004c64:	04a4d783          	lhu	a5,74(s1)
    80004c68:	37fd                	addiw	a5,a5,-1
    80004c6a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c6e:	8526                	mv	a0,s1
    80004c70:	ffffe097          	auipc	ra,0xffffe
    80004c74:	f2e080e7          	jalr	-210(ra) # 80002b9e <iupdate>
    80004c78:	bf0d                	j	80004baa <sys_unlink+0xde>
    80004c7a:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004c7c:	8526                	mv	a0,s1
    80004c7e:	ffffe097          	auipc	ra,0xffffe
    80004c82:	252080e7          	jalr	594(ra) # 80002ed0 <iunlockput>
  end_op();
    80004c86:	fffff097          	auipc	ra,0xfffff
    80004c8a:	a2c080e7          	jalr	-1492(ra) # 800036b2 <end_op>
  return -1;
    80004c8e:	557d                	li	a0,-1
    80004c90:	64ee                	ld	s1,216(sp)
}
    80004c92:	70ae                	ld	ra,232(sp)
    80004c94:	740e                	ld	s0,224(sp)
    80004c96:	616d                	addi	sp,sp,240
    80004c98:	8082                	ret
    return -1;
    80004c9a:	557d                	li	a0,-1
    80004c9c:	bfdd                	j	80004c92 <sys_unlink+0x1c6>
    iunlockput(ip);
    80004c9e:	854a                	mv	a0,s2
    80004ca0:	ffffe097          	auipc	ra,0xffffe
    80004ca4:	230080e7          	jalr	560(ra) # 80002ed0 <iunlockput>
    goto bad;
    80004ca8:	694e                	ld	s2,208(sp)
    80004caa:	69ae                	ld	s3,200(sp)
    80004cac:	bfc1                	j	80004c7c <sys_unlink+0x1b0>

0000000080004cae <sys_open>:

uint64
sys_open(void)
{
    80004cae:	7131                	addi	sp,sp,-192
    80004cb0:	fd06                	sd	ra,184(sp)
    80004cb2:	f922                	sd	s0,176(sp)
    80004cb4:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004cb6:	f4c40593          	addi	a1,s0,-180
    80004cba:	4505                	li	a0,1
    80004cbc:	ffffd097          	auipc	ra,0xffffd
    80004cc0:	416080e7          	jalr	1046(ra) # 800020d2 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004cc4:	08000613          	li	a2,128
    80004cc8:	f5040593          	addi	a1,s0,-176
    80004ccc:	4501                	li	a0,0
    80004cce:	ffffd097          	auipc	ra,0xffffd
    80004cd2:	444080e7          	jalr	1092(ra) # 80002112 <argstr>
    80004cd6:	87aa                	mv	a5,a0
    return -1;
    80004cd8:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004cda:	0a07ce63          	bltz	a5,80004d96 <sys_open+0xe8>
    80004cde:	f526                	sd	s1,168(sp)

  begin_op();
    80004ce0:	fffff097          	auipc	ra,0xfffff
    80004ce4:	958080e7          	jalr	-1704(ra) # 80003638 <begin_op>

  if(omode & O_CREATE){
    80004ce8:	f4c42783          	lw	a5,-180(s0)
    80004cec:	2007f793          	andi	a5,a5,512
    80004cf0:	cfd5                	beqz	a5,80004dac <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004cf2:	4681                	li	a3,0
    80004cf4:	4601                	li	a2,0
    80004cf6:	4589                	li	a1,2
    80004cf8:	f5040513          	addi	a0,s0,-176
    80004cfc:	00000097          	auipc	ra,0x0
    80004d00:	95c080e7          	jalr	-1700(ra) # 80004658 <create>
    80004d04:	84aa                	mv	s1,a0
    if(ip == 0){
    80004d06:	cd41                	beqz	a0,80004d9e <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004d08:	04449703          	lh	a4,68(s1)
    80004d0c:	478d                	li	a5,3
    80004d0e:	00f71763          	bne	a4,a5,80004d1c <sys_open+0x6e>
    80004d12:	0464d703          	lhu	a4,70(s1)
    80004d16:	47a5                	li	a5,9
    80004d18:	0ee7e163          	bltu	a5,a4,80004dfa <sys_open+0x14c>
    80004d1c:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004d1e:	fffff097          	auipc	ra,0xfffff
    80004d22:	d28080e7          	jalr	-728(ra) # 80003a46 <filealloc>
    80004d26:	892a                	mv	s2,a0
    80004d28:	c97d                	beqz	a0,80004e1e <sys_open+0x170>
    80004d2a:	ed4e                	sd	s3,152(sp)
    80004d2c:	00000097          	auipc	ra,0x0
    80004d30:	8ea080e7          	jalr	-1814(ra) # 80004616 <fdalloc>
    80004d34:	89aa                	mv	s3,a0
    80004d36:	0c054e63          	bltz	a0,80004e12 <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004d3a:	04449703          	lh	a4,68(s1)
    80004d3e:	478d                	li	a5,3
    80004d40:	0ef70c63          	beq	a4,a5,80004e38 <sys_open+0x18a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004d44:	4789                	li	a5,2
    80004d46:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004d4a:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004d4e:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004d52:	f4c42783          	lw	a5,-180(s0)
    80004d56:	0017c713          	xori	a4,a5,1
    80004d5a:	8b05                	andi	a4,a4,1
    80004d5c:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d60:	0037f713          	andi	a4,a5,3
    80004d64:	00e03733          	snez	a4,a4
    80004d68:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d6c:	4007f793          	andi	a5,a5,1024
    80004d70:	c791                	beqz	a5,80004d7c <sys_open+0xce>
    80004d72:	04449703          	lh	a4,68(s1)
    80004d76:	4789                	li	a5,2
    80004d78:	0cf70763          	beq	a4,a5,80004e46 <sys_open+0x198>
    itrunc(ip);
  }

  iunlock(ip);
    80004d7c:	8526                	mv	a0,s1
    80004d7e:	ffffe097          	auipc	ra,0xffffe
    80004d82:	fb2080e7          	jalr	-78(ra) # 80002d30 <iunlock>
  end_op();
    80004d86:	fffff097          	auipc	ra,0xfffff
    80004d8a:	92c080e7          	jalr	-1748(ra) # 800036b2 <end_op>

  return fd;
    80004d8e:	854e                	mv	a0,s3
    80004d90:	74aa                	ld	s1,168(sp)
    80004d92:	790a                	ld	s2,160(sp)
    80004d94:	69ea                	ld	s3,152(sp)
}
    80004d96:	70ea                	ld	ra,184(sp)
    80004d98:	744a                	ld	s0,176(sp)
    80004d9a:	6129                	addi	sp,sp,192
    80004d9c:	8082                	ret
      end_op();
    80004d9e:	fffff097          	auipc	ra,0xfffff
    80004da2:	914080e7          	jalr	-1772(ra) # 800036b2 <end_op>
      return -1;
    80004da6:	557d                	li	a0,-1
    80004da8:	74aa                	ld	s1,168(sp)
    80004daa:	b7f5                	j	80004d96 <sys_open+0xe8>
    if((ip = namei(path)) == 0){
    80004dac:	f5040513          	addi	a0,s0,-176
    80004db0:	ffffe097          	auipc	ra,0xffffe
    80004db4:	688080e7          	jalr	1672(ra) # 80003438 <namei>
    80004db8:	84aa                	mv	s1,a0
    80004dba:	c90d                	beqz	a0,80004dec <sys_open+0x13e>
    ilock(ip);
    80004dbc:	ffffe097          	auipc	ra,0xffffe
    80004dc0:	eae080e7          	jalr	-338(ra) # 80002c6a <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004dc4:	04449703          	lh	a4,68(s1)
    80004dc8:	4785                	li	a5,1
    80004dca:	f2f71fe3          	bne	a4,a5,80004d08 <sys_open+0x5a>
    80004dce:	f4c42783          	lw	a5,-180(s0)
    80004dd2:	d7a9                	beqz	a5,80004d1c <sys_open+0x6e>
      iunlockput(ip);
    80004dd4:	8526                	mv	a0,s1
    80004dd6:	ffffe097          	auipc	ra,0xffffe
    80004dda:	0fa080e7          	jalr	250(ra) # 80002ed0 <iunlockput>
      end_op();
    80004dde:	fffff097          	auipc	ra,0xfffff
    80004de2:	8d4080e7          	jalr	-1836(ra) # 800036b2 <end_op>
      return -1;
    80004de6:	557d                	li	a0,-1
    80004de8:	74aa                	ld	s1,168(sp)
    80004dea:	b775                	j	80004d96 <sys_open+0xe8>
      end_op();
    80004dec:	fffff097          	auipc	ra,0xfffff
    80004df0:	8c6080e7          	jalr	-1850(ra) # 800036b2 <end_op>
      return -1;
    80004df4:	557d                	li	a0,-1
    80004df6:	74aa                	ld	s1,168(sp)
    80004df8:	bf79                	j	80004d96 <sys_open+0xe8>
    iunlockput(ip);
    80004dfa:	8526                	mv	a0,s1
    80004dfc:	ffffe097          	auipc	ra,0xffffe
    80004e00:	0d4080e7          	jalr	212(ra) # 80002ed0 <iunlockput>
    end_op();
    80004e04:	fffff097          	auipc	ra,0xfffff
    80004e08:	8ae080e7          	jalr	-1874(ra) # 800036b2 <end_op>
    return -1;
    80004e0c:	557d                	li	a0,-1
    80004e0e:	74aa                	ld	s1,168(sp)
    80004e10:	b759                	j	80004d96 <sys_open+0xe8>
      fileclose(f);
    80004e12:	854a                	mv	a0,s2
    80004e14:	fffff097          	auipc	ra,0xfffff
    80004e18:	cee080e7          	jalr	-786(ra) # 80003b02 <fileclose>
    80004e1c:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004e1e:	8526                	mv	a0,s1
    80004e20:	ffffe097          	auipc	ra,0xffffe
    80004e24:	0b0080e7          	jalr	176(ra) # 80002ed0 <iunlockput>
    end_op();
    80004e28:	fffff097          	auipc	ra,0xfffff
    80004e2c:	88a080e7          	jalr	-1910(ra) # 800036b2 <end_op>
    return -1;
    80004e30:	557d                	li	a0,-1
    80004e32:	74aa                	ld	s1,168(sp)
    80004e34:	790a                	ld	s2,160(sp)
    80004e36:	b785                	j	80004d96 <sys_open+0xe8>
    f->type = FD_DEVICE;
    80004e38:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004e3c:	04649783          	lh	a5,70(s1)
    80004e40:	02f91223          	sh	a5,36(s2)
    80004e44:	b729                	j	80004d4e <sys_open+0xa0>
    itrunc(ip);
    80004e46:	8526                	mv	a0,s1
    80004e48:	ffffe097          	auipc	ra,0xffffe
    80004e4c:	f34080e7          	jalr	-204(ra) # 80002d7c <itrunc>
    80004e50:	b735                	j	80004d7c <sys_open+0xce>

0000000080004e52 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004e52:	7175                	addi	sp,sp,-144
    80004e54:	e506                	sd	ra,136(sp)
    80004e56:	e122                	sd	s0,128(sp)
    80004e58:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e5a:	ffffe097          	auipc	ra,0xffffe
    80004e5e:	7de080e7          	jalr	2014(ra) # 80003638 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e62:	08000613          	li	a2,128
    80004e66:	f7040593          	addi	a1,s0,-144
    80004e6a:	4501                	li	a0,0
    80004e6c:	ffffd097          	auipc	ra,0xffffd
    80004e70:	2a6080e7          	jalr	678(ra) # 80002112 <argstr>
    80004e74:	02054963          	bltz	a0,80004ea6 <sys_mkdir+0x54>
    80004e78:	4681                	li	a3,0
    80004e7a:	4601                	li	a2,0
    80004e7c:	4585                	li	a1,1
    80004e7e:	f7040513          	addi	a0,s0,-144
    80004e82:	fffff097          	auipc	ra,0xfffff
    80004e86:	7d6080e7          	jalr	2006(ra) # 80004658 <create>
    80004e8a:	cd11                	beqz	a0,80004ea6 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e8c:	ffffe097          	auipc	ra,0xffffe
    80004e90:	044080e7          	jalr	68(ra) # 80002ed0 <iunlockput>
  end_op();
    80004e94:	fffff097          	auipc	ra,0xfffff
    80004e98:	81e080e7          	jalr	-2018(ra) # 800036b2 <end_op>
  return 0;
    80004e9c:	4501                	li	a0,0
}
    80004e9e:	60aa                	ld	ra,136(sp)
    80004ea0:	640a                	ld	s0,128(sp)
    80004ea2:	6149                	addi	sp,sp,144
    80004ea4:	8082                	ret
    end_op();
    80004ea6:	fffff097          	auipc	ra,0xfffff
    80004eaa:	80c080e7          	jalr	-2036(ra) # 800036b2 <end_op>
    return -1;
    80004eae:	557d                	li	a0,-1
    80004eb0:	b7fd                	j	80004e9e <sys_mkdir+0x4c>

0000000080004eb2 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004eb2:	7135                	addi	sp,sp,-160
    80004eb4:	ed06                	sd	ra,152(sp)
    80004eb6:	e922                	sd	s0,144(sp)
    80004eb8:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004eba:	ffffe097          	auipc	ra,0xffffe
    80004ebe:	77e080e7          	jalr	1918(ra) # 80003638 <begin_op>
  argint(1, &major);
    80004ec2:	f6c40593          	addi	a1,s0,-148
    80004ec6:	4505                	li	a0,1
    80004ec8:	ffffd097          	auipc	ra,0xffffd
    80004ecc:	20a080e7          	jalr	522(ra) # 800020d2 <argint>
  argint(2, &minor);
    80004ed0:	f6840593          	addi	a1,s0,-152
    80004ed4:	4509                	li	a0,2
    80004ed6:	ffffd097          	auipc	ra,0xffffd
    80004eda:	1fc080e7          	jalr	508(ra) # 800020d2 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004ede:	08000613          	li	a2,128
    80004ee2:	f7040593          	addi	a1,s0,-144
    80004ee6:	4501                	li	a0,0
    80004ee8:	ffffd097          	auipc	ra,0xffffd
    80004eec:	22a080e7          	jalr	554(ra) # 80002112 <argstr>
    80004ef0:	02054b63          	bltz	a0,80004f26 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004ef4:	f6841683          	lh	a3,-152(s0)
    80004ef8:	f6c41603          	lh	a2,-148(s0)
    80004efc:	458d                	li	a1,3
    80004efe:	f7040513          	addi	a0,s0,-144
    80004f02:	fffff097          	auipc	ra,0xfffff
    80004f06:	756080e7          	jalr	1878(ra) # 80004658 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f0a:	cd11                	beqz	a0,80004f26 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f0c:	ffffe097          	auipc	ra,0xffffe
    80004f10:	fc4080e7          	jalr	-60(ra) # 80002ed0 <iunlockput>
  end_op();
    80004f14:	ffffe097          	auipc	ra,0xffffe
    80004f18:	79e080e7          	jalr	1950(ra) # 800036b2 <end_op>
  return 0;
    80004f1c:	4501                	li	a0,0
}
    80004f1e:	60ea                	ld	ra,152(sp)
    80004f20:	644a                	ld	s0,144(sp)
    80004f22:	610d                	addi	sp,sp,160
    80004f24:	8082                	ret
    end_op();
    80004f26:	ffffe097          	auipc	ra,0xffffe
    80004f2a:	78c080e7          	jalr	1932(ra) # 800036b2 <end_op>
    return -1;
    80004f2e:	557d                	li	a0,-1
    80004f30:	b7fd                	j	80004f1e <sys_mknod+0x6c>

0000000080004f32 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f32:	7135                	addi	sp,sp,-160
    80004f34:	ed06                	sd	ra,152(sp)
    80004f36:	e922                	sd	s0,144(sp)
    80004f38:	e14a                	sd	s2,128(sp)
    80004f3a:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f3c:	ffffc097          	auipc	ra,0xffffc
    80004f40:	fc6080e7          	jalr	-58(ra) # 80000f02 <myproc>
    80004f44:	892a                	mv	s2,a0
  
  begin_op();
    80004f46:	ffffe097          	auipc	ra,0xffffe
    80004f4a:	6f2080e7          	jalr	1778(ra) # 80003638 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f4e:	08000613          	li	a2,128
    80004f52:	f6040593          	addi	a1,s0,-160
    80004f56:	4501                	li	a0,0
    80004f58:	ffffd097          	auipc	ra,0xffffd
    80004f5c:	1ba080e7          	jalr	442(ra) # 80002112 <argstr>
    80004f60:	04054d63          	bltz	a0,80004fba <sys_chdir+0x88>
    80004f64:	e526                	sd	s1,136(sp)
    80004f66:	f6040513          	addi	a0,s0,-160
    80004f6a:	ffffe097          	auipc	ra,0xffffe
    80004f6e:	4ce080e7          	jalr	1230(ra) # 80003438 <namei>
    80004f72:	84aa                	mv	s1,a0
    80004f74:	c131                	beqz	a0,80004fb8 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f76:	ffffe097          	auipc	ra,0xffffe
    80004f7a:	cf4080e7          	jalr	-780(ra) # 80002c6a <ilock>
  if(ip->type != T_DIR){
    80004f7e:	04449703          	lh	a4,68(s1)
    80004f82:	4785                	li	a5,1
    80004f84:	04f71163          	bne	a4,a5,80004fc6 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004f88:	8526                	mv	a0,s1
    80004f8a:	ffffe097          	auipc	ra,0xffffe
    80004f8e:	da6080e7          	jalr	-602(ra) # 80002d30 <iunlock>
  iput(p->cwd);
    80004f92:	15893503          	ld	a0,344(s2)
    80004f96:	ffffe097          	auipc	ra,0xffffe
    80004f9a:	e92080e7          	jalr	-366(ra) # 80002e28 <iput>
  end_op();
    80004f9e:	ffffe097          	auipc	ra,0xffffe
    80004fa2:	714080e7          	jalr	1812(ra) # 800036b2 <end_op>
  p->cwd = ip;
    80004fa6:	14993c23          	sd	s1,344(s2)
  return 0;
    80004faa:	4501                	li	a0,0
    80004fac:	64aa                	ld	s1,136(sp)
}
    80004fae:	60ea                	ld	ra,152(sp)
    80004fb0:	644a                	ld	s0,144(sp)
    80004fb2:	690a                	ld	s2,128(sp)
    80004fb4:	610d                	addi	sp,sp,160
    80004fb6:	8082                	ret
    80004fb8:	64aa                	ld	s1,136(sp)
    end_op();
    80004fba:	ffffe097          	auipc	ra,0xffffe
    80004fbe:	6f8080e7          	jalr	1784(ra) # 800036b2 <end_op>
    return -1;
    80004fc2:	557d                	li	a0,-1
    80004fc4:	b7ed                	j	80004fae <sys_chdir+0x7c>
    iunlockput(ip);
    80004fc6:	8526                	mv	a0,s1
    80004fc8:	ffffe097          	auipc	ra,0xffffe
    80004fcc:	f08080e7          	jalr	-248(ra) # 80002ed0 <iunlockput>
    end_op();
    80004fd0:	ffffe097          	auipc	ra,0xffffe
    80004fd4:	6e2080e7          	jalr	1762(ra) # 800036b2 <end_op>
    return -1;
    80004fd8:	557d                	li	a0,-1
    80004fda:	64aa                	ld	s1,136(sp)
    80004fdc:	bfc9                	j	80004fae <sys_chdir+0x7c>

0000000080004fde <sys_exec>:

uint64
sys_exec(void)
{
    80004fde:	7121                	addi	sp,sp,-448
    80004fe0:	ff06                	sd	ra,440(sp)
    80004fe2:	fb22                	sd	s0,432(sp)
    80004fe4:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004fe6:	e4840593          	addi	a1,s0,-440
    80004fea:	4505                	li	a0,1
    80004fec:	ffffd097          	auipc	ra,0xffffd
    80004ff0:	106080e7          	jalr	262(ra) # 800020f2 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004ff4:	08000613          	li	a2,128
    80004ff8:	f5040593          	addi	a1,s0,-176
    80004ffc:	4501                	li	a0,0
    80004ffe:	ffffd097          	auipc	ra,0xffffd
    80005002:	114080e7          	jalr	276(ra) # 80002112 <argstr>
    80005006:	87aa                	mv	a5,a0
    return -1;
    80005008:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000500a:	0e07c263          	bltz	a5,800050ee <sys_exec+0x110>
    8000500e:	f726                	sd	s1,424(sp)
    80005010:	f34a                	sd	s2,416(sp)
    80005012:	ef4e                	sd	s3,408(sp)
    80005014:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005016:	10000613          	li	a2,256
    8000501a:	4581                	li	a1,0
    8000501c:	e5040513          	addi	a0,s0,-432
    80005020:	ffffb097          	auipc	ra,0xffffb
    80005024:	15a080e7          	jalr	346(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005028:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    8000502c:	89a6                	mv	s3,s1
    8000502e:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005030:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005034:	00391513          	slli	a0,s2,0x3
    80005038:	e4040593          	addi	a1,s0,-448
    8000503c:	e4843783          	ld	a5,-440(s0)
    80005040:	953e                	add	a0,a0,a5
    80005042:	ffffd097          	auipc	ra,0xffffd
    80005046:	ff2080e7          	jalr	-14(ra) # 80002034 <fetchaddr>
    8000504a:	02054a63          	bltz	a0,8000507e <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    8000504e:	e4043783          	ld	a5,-448(s0)
    80005052:	c7b9                	beqz	a5,800050a0 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005054:	ffffb097          	auipc	ra,0xffffb
    80005058:	0c6080e7          	jalr	198(ra) # 8000011a <kalloc>
    8000505c:	85aa                	mv	a1,a0
    8000505e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005062:	cd11                	beqz	a0,8000507e <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005064:	6605                	lui	a2,0x1
    80005066:	e4043503          	ld	a0,-448(s0)
    8000506a:	ffffd097          	auipc	ra,0xffffd
    8000506e:	01c080e7          	jalr	28(ra) # 80002086 <fetchstr>
    80005072:	00054663          	bltz	a0,8000507e <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    80005076:	0905                	addi	s2,s2,1
    80005078:	09a1                	addi	s3,s3,8
    8000507a:	fb491de3          	bne	s2,s4,80005034 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000507e:	f5040913          	addi	s2,s0,-176
    80005082:	6088                	ld	a0,0(s1)
    80005084:	c125                	beqz	a0,800050e4 <sys_exec+0x106>
    kfree(argv[i]);
    80005086:	ffffb097          	auipc	ra,0xffffb
    8000508a:	f96080e7          	jalr	-106(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000508e:	04a1                	addi	s1,s1,8
    80005090:	ff2499e3          	bne	s1,s2,80005082 <sys_exec+0xa4>
  return -1;
    80005094:	557d                	li	a0,-1
    80005096:	74ba                	ld	s1,424(sp)
    80005098:	791a                	ld	s2,416(sp)
    8000509a:	69fa                	ld	s3,408(sp)
    8000509c:	6a5a                	ld	s4,400(sp)
    8000509e:	a881                	j	800050ee <sys_exec+0x110>
      argv[i] = 0;
    800050a0:	0009079b          	sext.w	a5,s2
    800050a4:	078e                	slli	a5,a5,0x3
    800050a6:	fd078793          	addi	a5,a5,-48
    800050aa:	97a2                	add	a5,a5,s0
    800050ac:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    800050b0:	e5040593          	addi	a1,s0,-432
    800050b4:	f5040513          	addi	a0,s0,-176
    800050b8:	fffff097          	auipc	ra,0xfffff
    800050bc:	120080e7          	jalr	288(ra) # 800041d8 <exec>
    800050c0:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050c2:	f5040993          	addi	s3,s0,-176
    800050c6:	6088                	ld	a0,0(s1)
    800050c8:	c901                	beqz	a0,800050d8 <sys_exec+0xfa>
    kfree(argv[i]);
    800050ca:	ffffb097          	auipc	ra,0xffffb
    800050ce:	f52080e7          	jalr	-174(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050d2:	04a1                	addi	s1,s1,8
    800050d4:	ff3499e3          	bne	s1,s3,800050c6 <sys_exec+0xe8>
  return ret;
    800050d8:	854a                	mv	a0,s2
    800050da:	74ba                	ld	s1,424(sp)
    800050dc:	791a                	ld	s2,416(sp)
    800050de:	69fa                	ld	s3,408(sp)
    800050e0:	6a5a                	ld	s4,400(sp)
    800050e2:	a031                	j	800050ee <sys_exec+0x110>
  return -1;
    800050e4:	557d                	li	a0,-1
    800050e6:	74ba                	ld	s1,424(sp)
    800050e8:	791a                	ld	s2,416(sp)
    800050ea:	69fa                	ld	s3,408(sp)
    800050ec:	6a5a                	ld	s4,400(sp)
}
    800050ee:	70fa                	ld	ra,440(sp)
    800050f0:	745a                	ld	s0,432(sp)
    800050f2:	6139                	addi	sp,sp,448
    800050f4:	8082                	ret

00000000800050f6 <sys_pipe>:

uint64
sys_pipe(void)
{
    800050f6:	7139                	addi	sp,sp,-64
    800050f8:	fc06                	sd	ra,56(sp)
    800050fa:	f822                	sd	s0,48(sp)
    800050fc:	f426                	sd	s1,40(sp)
    800050fe:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005100:	ffffc097          	auipc	ra,0xffffc
    80005104:	e02080e7          	jalr	-510(ra) # 80000f02 <myproc>
    80005108:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000510a:	fd840593          	addi	a1,s0,-40
    8000510e:	4501                	li	a0,0
    80005110:	ffffd097          	auipc	ra,0xffffd
    80005114:	fe2080e7          	jalr	-30(ra) # 800020f2 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005118:	fc840593          	addi	a1,s0,-56
    8000511c:	fd040513          	addi	a0,s0,-48
    80005120:	fffff097          	auipc	ra,0xfffff
    80005124:	d50080e7          	jalr	-688(ra) # 80003e70 <pipealloc>
    return -1;
    80005128:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000512a:	0c054463          	bltz	a0,800051f2 <sys_pipe+0xfc>
  fd0 = -1;
    8000512e:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005132:	fd043503          	ld	a0,-48(s0)
    80005136:	fffff097          	auipc	ra,0xfffff
    8000513a:	4e0080e7          	jalr	1248(ra) # 80004616 <fdalloc>
    8000513e:	fca42223          	sw	a0,-60(s0)
    80005142:	08054b63          	bltz	a0,800051d8 <sys_pipe+0xe2>
    80005146:	fc843503          	ld	a0,-56(s0)
    8000514a:	fffff097          	auipc	ra,0xfffff
    8000514e:	4cc080e7          	jalr	1228(ra) # 80004616 <fdalloc>
    80005152:	fca42023          	sw	a0,-64(s0)
    80005156:	06054863          	bltz	a0,800051c6 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000515a:	4691                	li	a3,4
    8000515c:	fc440613          	addi	a2,s0,-60
    80005160:	fd843583          	ld	a1,-40(s0)
    80005164:	68a8                	ld	a0,80(s1)
    80005166:	ffffc097          	auipc	ra,0xffffc
    8000516a:	9e6080e7          	jalr	-1562(ra) # 80000b4c <copyout>
    8000516e:	02054063          	bltz	a0,8000518e <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005172:	4691                	li	a3,4
    80005174:	fc040613          	addi	a2,s0,-64
    80005178:	fd843583          	ld	a1,-40(s0)
    8000517c:	0591                	addi	a1,a1,4
    8000517e:	68a8                	ld	a0,80(s1)
    80005180:	ffffc097          	auipc	ra,0xffffc
    80005184:	9cc080e7          	jalr	-1588(ra) # 80000b4c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005188:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000518a:	06055463          	bgez	a0,800051f2 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    8000518e:	fc442783          	lw	a5,-60(s0)
    80005192:	07e9                	addi	a5,a5,26
    80005194:	078e                	slli	a5,a5,0x3
    80005196:	97a6                	add	a5,a5,s1
    80005198:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    8000519c:	fc042783          	lw	a5,-64(s0)
    800051a0:	07e9                	addi	a5,a5,26
    800051a2:	078e                	slli	a5,a5,0x3
    800051a4:	94be                	add	s1,s1,a5
    800051a6:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    800051aa:	fd043503          	ld	a0,-48(s0)
    800051ae:	fffff097          	auipc	ra,0xfffff
    800051b2:	954080e7          	jalr	-1708(ra) # 80003b02 <fileclose>
    fileclose(wf);
    800051b6:	fc843503          	ld	a0,-56(s0)
    800051ba:	fffff097          	auipc	ra,0xfffff
    800051be:	948080e7          	jalr	-1720(ra) # 80003b02 <fileclose>
    return -1;
    800051c2:	57fd                	li	a5,-1
    800051c4:	a03d                	j	800051f2 <sys_pipe+0xfc>
    if(fd0 >= 0)
    800051c6:	fc442783          	lw	a5,-60(s0)
    800051ca:	0007c763          	bltz	a5,800051d8 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    800051ce:	07e9                	addi	a5,a5,26
    800051d0:	078e                	slli	a5,a5,0x3
    800051d2:	97a6                	add	a5,a5,s1
    800051d4:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    800051d8:	fd043503          	ld	a0,-48(s0)
    800051dc:	fffff097          	auipc	ra,0xfffff
    800051e0:	926080e7          	jalr	-1754(ra) # 80003b02 <fileclose>
    fileclose(wf);
    800051e4:	fc843503          	ld	a0,-56(s0)
    800051e8:	fffff097          	auipc	ra,0xfffff
    800051ec:	91a080e7          	jalr	-1766(ra) # 80003b02 <fileclose>
    return -1;
    800051f0:	57fd                	li	a5,-1
}
    800051f2:	853e                	mv	a0,a5
    800051f4:	70e2                	ld	ra,56(sp)
    800051f6:	7442                	ld	s0,48(sp)
    800051f8:	74a2                	ld	s1,40(sp)
    800051fa:	6121                	addi	sp,sp,64
    800051fc:	8082                	ret
	...

0000000080005200 <kernelvec>:
    80005200:	7111                	addi	sp,sp,-256
    80005202:	e006                	sd	ra,0(sp)
    80005204:	e40a                	sd	sp,8(sp)
    80005206:	e80e                	sd	gp,16(sp)
    80005208:	ec12                	sd	tp,24(sp)
    8000520a:	f016                	sd	t0,32(sp)
    8000520c:	f41a                	sd	t1,40(sp)
    8000520e:	f81e                	sd	t2,48(sp)
    80005210:	fc22                	sd	s0,56(sp)
    80005212:	e0a6                	sd	s1,64(sp)
    80005214:	e4aa                	sd	a0,72(sp)
    80005216:	e8ae                	sd	a1,80(sp)
    80005218:	ecb2                	sd	a2,88(sp)
    8000521a:	f0b6                	sd	a3,96(sp)
    8000521c:	f4ba                	sd	a4,104(sp)
    8000521e:	f8be                	sd	a5,112(sp)
    80005220:	fcc2                	sd	a6,120(sp)
    80005222:	e146                	sd	a7,128(sp)
    80005224:	e54a                	sd	s2,136(sp)
    80005226:	e94e                	sd	s3,144(sp)
    80005228:	ed52                	sd	s4,152(sp)
    8000522a:	f156                	sd	s5,160(sp)
    8000522c:	f55a                	sd	s6,168(sp)
    8000522e:	f95e                	sd	s7,176(sp)
    80005230:	fd62                	sd	s8,184(sp)
    80005232:	e1e6                	sd	s9,192(sp)
    80005234:	e5ea                	sd	s10,200(sp)
    80005236:	e9ee                	sd	s11,208(sp)
    80005238:	edf2                	sd	t3,216(sp)
    8000523a:	f1f6                	sd	t4,224(sp)
    8000523c:	f5fa                	sd	t5,232(sp)
    8000523e:	f9fe                	sd	t6,240(sp)
    80005240:	cc1fc0ef          	jal	80001f00 <kerneltrap>
    80005244:	6082                	ld	ra,0(sp)
    80005246:	6122                	ld	sp,8(sp)
    80005248:	61c2                	ld	gp,16(sp)
    8000524a:	7282                	ld	t0,32(sp)
    8000524c:	7322                	ld	t1,40(sp)
    8000524e:	73c2                	ld	t2,48(sp)
    80005250:	7462                	ld	s0,56(sp)
    80005252:	6486                	ld	s1,64(sp)
    80005254:	6526                	ld	a0,72(sp)
    80005256:	65c6                	ld	a1,80(sp)
    80005258:	6666                	ld	a2,88(sp)
    8000525a:	7686                	ld	a3,96(sp)
    8000525c:	7726                	ld	a4,104(sp)
    8000525e:	77c6                	ld	a5,112(sp)
    80005260:	7866                	ld	a6,120(sp)
    80005262:	688a                	ld	a7,128(sp)
    80005264:	692a                	ld	s2,136(sp)
    80005266:	69ca                	ld	s3,144(sp)
    80005268:	6a6a                	ld	s4,152(sp)
    8000526a:	7a8a                	ld	s5,160(sp)
    8000526c:	7b2a                	ld	s6,168(sp)
    8000526e:	7bca                	ld	s7,176(sp)
    80005270:	7c6a                	ld	s8,184(sp)
    80005272:	6c8e                	ld	s9,192(sp)
    80005274:	6d2e                	ld	s10,200(sp)
    80005276:	6dce                	ld	s11,208(sp)
    80005278:	6e6e                	ld	t3,216(sp)
    8000527a:	7e8e                	ld	t4,224(sp)
    8000527c:	7f2e                	ld	t5,232(sp)
    8000527e:	7fce                	ld	t6,240(sp)
    80005280:	6111                	addi	sp,sp,256
    80005282:	10200073          	sret
    80005286:	00000013          	nop
    8000528a:	00000013          	nop
    8000528e:	0001                	nop

0000000080005290 <timervec>:
    80005290:	34051573          	csrrw	a0,mscratch,a0
    80005294:	e10c                	sd	a1,0(a0)
    80005296:	e510                	sd	a2,8(a0)
    80005298:	e914                	sd	a3,16(a0)
    8000529a:	6d0c                	ld	a1,24(a0)
    8000529c:	7110                	ld	a2,32(a0)
    8000529e:	6194                	ld	a3,0(a1)
    800052a0:	96b2                	add	a3,a3,a2
    800052a2:	e194                	sd	a3,0(a1)
    800052a4:	4589                	li	a1,2
    800052a6:	14459073          	csrw	sip,a1
    800052aa:	6914                	ld	a3,16(a0)
    800052ac:	6510                	ld	a2,8(a0)
    800052ae:	610c                	ld	a1,0(a0)
    800052b0:	34051573          	csrrw	a0,mscratch,a0
    800052b4:	30200073          	mret
	...

00000000800052ba <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800052ba:	1141                	addi	sp,sp,-16
    800052bc:	e422                	sd	s0,8(sp)
    800052be:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800052c0:	0c0007b7          	lui	a5,0xc000
    800052c4:	4705                	li	a4,1
    800052c6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800052c8:	0c0007b7          	lui	a5,0xc000
    800052cc:	c3d8                	sw	a4,4(a5)
}
    800052ce:	6422                	ld	s0,8(sp)
    800052d0:	0141                	addi	sp,sp,16
    800052d2:	8082                	ret

00000000800052d4 <plicinithart>:

void
plicinithart(void)
{
    800052d4:	1141                	addi	sp,sp,-16
    800052d6:	e406                	sd	ra,8(sp)
    800052d8:	e022                	sd	s0,0(sp)
    800052da:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052dc:	ffffc097          	auipc	ra,0xffffc
    800052e0:	bfa080e7          	jalr	-1030(ra) # 80000ed6 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800052e4:	0085171b          	slliw	a4,a0,0x8
    800052e8:	0c0027b7          	lui	a5,0xc002
    800052ec:	97ba                	add	a5,a5,a4
    800052ee:	40200713          	li	a4,1026
    800052f2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800052f6:	00d5151b          	slliw	a0,a0,0xd
    800052fa:	0c2017b7          	lui	a5,0xc201
    800052fe:	97aa                	add	a5,a5,a0
    80005300:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005304:	60a2                	ld	ra,8(sp)
    80005306:	6402                	ld	s0,0(sp)
    80005308:	0141                	addi	sp,sp,16
    8000530a:	8082                	ret

000000008000530c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000530c:	1141                	addi	sp,sp,-16
    8000530e:	e406                	sd	ra,8(sp)
    80005310:	e022                	sd	s0,0(sp)
    80005312:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005314:	ffffc097          	auipc	ra,0xffffc
    80005318:	bc2080e7          	jalr	-1086(ra) # 80000ed6 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000531c:	00d5151b          	slliw	a0,a0,0xd
    80005320:	0c2017b7          	lui	a5,0xc201
    80005324:	97aa                	add	a5,a5,a0
  return irq;
}
    80005326:	43c8                	lw	a0,4(a5)
    80005328:	60a2                	ld	ra,8(sp)
    8000532a:	6402                	ld	s0,0(sp)
    8000532c:	0141                	addi	sp,sp,16
    8000532e:	8082                	ret

0000000080005330 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005330:	1101                	addi	sp,sp,-32
    80005332:	ec06                	sd	ra,24(sp)
    80005334:	e822                	sd	s0,16(sp)
    80005336:	e426                	sd	s1,8(sp)
    80005338:	1000                	addi	s0,sp,32
    8000533a:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000533c:	ffffc097          	auipc	ra,0xffffc
    80005340:	b9a080e7          	jalr	-1126(ra) # 80000ed6 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005344:	00d5151b          	slliw	a0,a0,0xd
    80005348:	0c2017b7          	lui	a5,0xc201
    8000534c:	97aa                	add	a5,a5,a0
    8000534e:	c3c4                	sw	s1,4(a5)
}
    80005350:	60e2                	ld	ra,24(sp)
    80005352:	6442                	ld	s0,16(sp)
    80005354:	64a2                	ld	s1,8(sp)
    80005356:	6105                	addi	sp,sp,32
    80005358:	8082                	ret

000000008000535a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000535a:	1141                	addi	sp,sp,-16
    8000535c:	e406                	sd	ra,8(sp)
    8000535e:	e022                	sd	s0,0(sp)
    80005360:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005362:	479d                	li	a5,7
    80005364:	04a7cc63          	blt	a5,a0,800053bc <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005368:	00017797          	auipc	a5,0x17
    8000536c:	20878793          	addi	a5,a5,520 # 8001c570 <disk>
    80005370:	97aa                	add	a5,a5,a0
    80005372:	0187c783          	lbu	a5,24(a5)
    80005376:	ebb9                	bnez	a5,800053cc <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005378:	00451693          	slli	a3,a0,0x4
    8000537c:	00017797          	auipc	a5,0x17
    80005380:	1f478793          	addi	a5,a5,500 # 8001c570 <disk>
    80005384:	6398                	ld	a4,0(a5)
    80005386:	9736                	add	a4,a4,a3
    80005388:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    8000538c:	6398                	ld	a4,0(a5)
    8000538e:	9736                	add	a4,a4,a3
    80005390:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005394:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005398:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    8000539c:	97aa                	add	a5,a5,a0
    8000539e:	4705                	li	a4,1
    800053a0:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800053a4:	00017517          	auipc	a0,0x17
    800053a8:	1e450513          	addi	a0,a0,484 # 8001c588 <disk+0x18>
    800053ac:	ffffc097          	auipc	ra,0xffffc
    800053b0:	314080e7          	jalr	788(ra) # 800016c0 <wakeup>
}
    800053b4:	60a2                	ld	ra,8(sp)
    800053b6:	6402                	ld	s0,0(sp)
    800053b8:	0141                	addi	sp,sp,16
    800053ba:	8082                	ret
    panic("free_desc 1");
    800053bc:	00003517          	auipc	a0,0x3
    800053c0:	24c50513          	addi	a0,a0,588 # 80008608 <etext+0x608>
    800053c4:	00001097          	auipc	ra,0x1
    800053c8:	a6e080e7          	jalr	-1426(ra) # 80005e32 <panic>
    panic("free_desc 2");
    800053cc:	00003517          	auipc	a0,0x3
    800053d0:	24c50513          	addi	a0,a0,588 # 80008618 <etext+0x618>
    800053d4:	00001097          	auipc	ra,0x1
    800053d8:	a5e080e7          	jalr	-1442(ra) # 80005e32 <panic>

00000000800053dc <virtio_disk_init>:
{
    800053dc:	1101                	addi	sp,sp,-32
    800053de:	ec06                	sd	ra,24(sp)
    800053e0:	e822                	sd	s0,16(sp)
    800053e2:	e426                	sd	s1,8(sp)
    800053e4:	e04a                	sd	s2,0(sp)
    800053e6:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800053e8:	00003597          	auipc	a1,0x3
    800053ec:	24058593          	addi	a1,a1,576 # 80008628 <etext+0x628>
    800053f0:	00017517          	auipc	a0,0x17
    800053f4:	2a850513          	addi	a0,a0,680 # 8001c698 <disk+0x128>
    800053f8:	00001097          	auipc	ra,0x1
    800053fc:	f24080e7          	jalr	-220(ra) # 8000631c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005400:	100017b7          	lui	a5,0x10001
    80005404:	4398                	lw	a4,0(a5)
    80005406:	2701                	sext.w	a4,a4
    80005408:	747277b7          	lui	a5,0x74727
    8000540c:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005410:	18f71c63          	bne	a4,a5,800055a8 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005414:	100017b7          	lui	a5,0x10001
    80005418:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    8000541a:	439c                	lw	a5,0(a5)
    8000541c:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000541e:	4709                	li	a4,2
    80005420:	18e79463          	bne	a5,a4,800055a8 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005424:	100017b7          	lui	a5,0x10001
    80005428:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    8000542a:	439c                	lw	a5,0(a5)
    8000542c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000542e:	16e79d63          	bne	a5,a4,800055a8 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005432:	100017b7          	lui	a5,0x10001
    80005436:	47d8                	lw	a4,12(a5)
    80005438:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000543a:	554d47b7          	lui	a5,0x554d4
    8000543e:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005442:	16f71363          	bne	a4,a5,800055a8 <virtio_disk_init+0x1cc>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005446:	100017b7          	lui	a5,0x10001
    8000544a:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000544e:	4705                	li	a4,1
    80005450:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005452:	470d                	li	a4,3
    80005454:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005456:	10001737          	lui	a4,0x10001
    8000545a:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000545c:	c7ffe737          	lui	a4,0xc7ffe
    80005460:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd9e6f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005464:	8ef9                	and	a3,a3,a4
    80005466:	10001737          	lui	a4,0x10001
    8000546a:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000546c:	472d                	li	a4,11
    8000546e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005470:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80005474:	439c                	lw	a5,0(a5)
    80005476:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000547a:	8ba1                	andi	a5,a5,8
    8000547c:	12078e63          	beqz	a5,800055b8 <virtio_disk_init+0x1dc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005480:	100017b7          	lui	a5,0x10001
    80005484:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005488:	100017b7          	lui	a5,0x10001
    8000548c:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80005490:	439c                	lw	a5,0(a5)
    80005492:	2781                	sext.w	a5,a5
    80005494:	12079a63          	bnez	a5,800055c8 <virtio_disk_init+0x1ec>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005498:	100017b7          	lui	a5,0x10001
    8000549c:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    800054a0:	439c                	lw	a5,0(a5)
    800054a2:	2781                	sext.w	a5,a5
  if(max == 0)
    800054a4:	12078a63          	beqz	a5,800055d8 <virtio_disk_init+0x1fc>
  if(max < NUM)
    800054a8:	471d                	li	a4,7
    800054aa:	12f77f63          	bgeu	a4,a5,800055e8 <virtio_disk_init+0x20c>
  disk.desc = kalloc();
    800054ae:	ffffb097          	auipc	ra,0xffffb
    800054b2:	c6c080e7          	jalr	-916(ra) # 8000011a <kalloc>
    800054b6:	00017497          	auipc	s1,0x17
    800054ba:	0ba48493          	addi	s1,s1,186 # 8001c570 <disk>
    800054be:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800054c0:	ffffb097          	auipc	ra,0xffffb
    800054c4:	c5a080e7          	jalr	-934(ra) # 8000011a <kalloc>
    800054c8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800054ca:	ffffb097          	auipc	ra,0xffffb
    800054ce:	c50080e7          	jalr	-944(ra) # 8000011a <kalloc>
    800054d2:	87aa                	mv	a5,a0
    800054d4:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800054d6:	6088                	ld	a0,0(s1)
    800054d8:	12050063          	beqz	a0,800055f8 <virtio_disk_init+0x21c>
    800054dc:	00017717          	auipc	a4,0x17
    800054e0:	09c73703          	ld	a4,156(a4) # 8001c578 <disk+0x8>
    800054e4:	10070a63          	beqz	a4,800055f8 <virtio_disk_init+0x21c>
    800054e8:	10078863          	beqz	a5,800055f8 <virtio_disk_init+0x21c>
  memset(disk.desc, 0, PGSIZE);
    800054ec:	6605                	lui	a2,0x1
    800054ee:	4581                	li	a1,0
    800054f0:	ffffb097          	auipc	ra,0xffffb
    800054f4:	c8a080e7          	jalr	-886(ra) # 8000017a <memset>
  memset(disk.avail, 0, PGSIZE);
    800054f8:	00017497          	auipc	s1,0x17
    800054fc:	07848493          	addi	s1,s1,120 # 8001c570 <disk>
    80005500:	6605                	lui	a2,0x1
    80005502:	4581                	li	a1,0
    80005504:	6488                	ld	a0,8(s1)
    80005506:	ffffb097          	auipc	ra,0xffffb
    8000550a:	c74080e7          	jalr	-908(ra) # 8000017a <memset>
  memset(disk.used, 0, PGSIZE);
    8000550e:	6605                	lui	a2,0x1
    80005510:	4581                	li	a1,0
    80005512:	6888                	ld	a0,16(s1)
    80005514:	ffffb097          	auipc	ra,0xffffb
    80005518:	c66080e7          	jalr	-922(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000551c:	100017b7          	lui	a5,0x10001
    80005520:	4721                	li	a4,8
    80005522:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005524:	4098                	lw	a4,0(s1)
    80005526:	100017b7          	lui	a5,0x10001
    8000552a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    8000552e:	40d8                	lw	a4,4(s1)
    80005530:	100017b7          	lui	a5,0x10001
    80005534:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005538:	649c                	ld	a5,8(s1)
    8000553a:	0007869b          	sext.w	a3,a5
    8000553e:	10001737          	lui	a4,0x10001
    80005542:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005546:	9781                	srai	a5,a5,0x20
    80005548:	10001737          	lui	a4,0x10001
    8000554c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005550:	689c                	ld	a5,16(s1)
    80005552:	0007869b          	sext.w	a3,a5
    80005556:	10001737          	lui	a4,0x10001
    8000555a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000555e:	9781                	srai	a5,a5,0x20
    80005560:	10001737          	lui	a4,0x10001
    80005564:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005568:	10001737          	lui	a4,0x10001
    8000556c:	4785                	li	a5,1
    8000556e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005570:	00f48c23          	sb	a5,24(s1)
    80005574:	00f48ca3          	sb	a5,25(s1)
    80005578:	00f48d23          	sb	a5,26(s1)
    8000557c:	00f48da3          	sb	a5,27(s1)
    80005580:	00f48e23          	sb	a5,28(s1)
    80005584:	00f48ea3          	sb	a5,29(s1)
    80005588:	00f48f23          	sb	a5,30(s1)
    8000558c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005590:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005594:	100017b7          	lui	a5,0x10001
    80005598:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    8000559c:	60e2                	ld	ra,24(sp)
    8000559e:	6442                	ld	s0,16(sp)
    800055a0:	64a2                	ld	s1,8(sp)
    800055a2:	6902                	ld	s2,0(sp)
    800055a4:	6105                	addi	sp,sp,32
    800055a6:	8082                	ret
    panic("could not find virtio disk");
    800055a8:	00003517          	auipc	a0,0x3
    800055ac:	09050513          	addi	a0,a0,144 # 80008638 <etext+0x638>
    800055b0:	00001097          	auipc	ra,0x1
    800055b4:	882080e7          	jalr	-1918(ra) # 80005e32 <panic>
    panic("virtio disk FEATURES_OK unset");
    800055b8:	00003517          	auipc	a0,0x3
    800055bc:	0a050513          	addi	a0,a0,160 # 80008658 <etext+0x658>
    800055c0:	00001097          	auipc	ra,0x1
    800055c4:	872080e7          	jalr	-1934(ra) # 80005e32 <panic>
    panic("virtio disk should not be ready");
    800055c8:	00003517          	auipc	a0,0x3
    800055cc:	0b050513          	addi	a0,a0,176 # 80008678 <etext+0x678>
    800055d0:	00001097          	auipc	ra,0x1
    800055d4:	862080e7          	jalr	-1950(ra) # 80005e32 <panic>
    panic("virtio disk has no queue 0");
    800055d8:	00003517          	auipc	a0,0x3
    800055dc:	0c050513          	addi	a0,a0,192 # 80008698 <etext+0x698>
    800055e0:	00001097          	auipc	ra,0x1
    800055e4:	852080e7          	jalr	-1966(ra) # 80005e32 <panic>
    panic("virtio disk max queue too short");
    800055e8:	00003517          	auipc	a0,0x3
    800055ec:	0d050513          	addi	a0,a0,208 # 800086b8 <etext+0x6b8>
    800055f0:	00001097          	auipc	ra,0x1
    800055f4:	842080e7          	jalr	-1982(ra) # 80005e32 <panic>
    panic("virtio disk kalloc");
    800055f8:	00003517          	auipc	a0,0x3
    800055fc:	0e050513          	addi	a0,a0,224 # 800086d8 <etext+0x6d8>
    80005600:	00001097          	auipc	ra,0x1
    80005604:	832080e7          	jalr	-1998(ra) # 80005e32 <panic>

0000000080005608 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005608:	7159                	addi	sp,sp,-112
    8000560a:	f486                	sd	ra,104(sp)
    8000560c:	f0a2                	sd	s0,96(sp)
    8000560e:	eca6                	sd	s1,88(sp)
    80005610:	e8ca                	sd	s2,80(sp)
    80005612:	e4ce                	sd	s3,72(sp)
    80005614:	e0d2                	sd	s4,64(sp)
    80005616:	fc56                	sd	s5,56(sp)
    80005618:	f85a                	sd	s6,48(sp)
    8000561a:	f45e                	sd	s7,40(sp)
    8000561c:	f062                	sd	s8,32(sp)
    8000561e:	ec66                	sd	s9,24(sp)
    80005620:	1880                	addi	s0,sp,112
    80005622:	8a2a                	mv	s4,a0
    80005624:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005626:	00c52c83          	lw	s9,12(a0)
    8000562a:	001c9c9b          	slliw	s9,s9,0x1
    8000562e:	1c82                	slli	s9,s9,0x20
    80005630:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005634:	00017517          	auipc	a0,0x17
    80005638:	06450513          	addi	a0,a0,100 # 8001c698 <disk+0x128>
    8000563c:	00001097          	auipc	ra,0x1
    80005640:	d70080e7          	jalr	-656(ra) # 800063ac <acquire>
  for(int i = 0; i < 3; i++){
    80005644:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005646:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005648:	00017b17          	auipc	s6,0x17
    8000564c:	f28b0b13          	addi	s6,s6,-216 # 8001c570 <disk>
  for(int i = 0; i < 3; i++){
    80005650:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005652:	00017c17          	auipc	s8,0x17
    80005656:	046c0c13          	addi	s8,s8,70 # 8001c698 <disk+0x128>
    8000565a:	a0ad                	j	800056c4 <virtio_disk_rw+0xbc>
      disk.free[i] = 0;
    8000565c:	00fb0733          	add	a4,s6,a5
    80005660:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80005664:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005666:	0207c563          	bltz	a5,80005690 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    8000566a:	2905                	addiw	s2,s2,1
    8000566c:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    8000566e:	05590f63          	beq	s2,s5,800056cc <virtio_disk_rw+0xc4>
    idx[i] = alloc_desc();
    80005672:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005674:	00017717          	auipc	a4,0x17
    80005678:	efc70713          	addi	a4,a4,-260 # 8001c570 <disk>
    8000567c:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000567e:	01874683          	lbu	a3,24(a4)
    80005682:	fee9                	bnez	a3,8000565c <virtio_disk_rw+0x54>
  for(int i = 0; i < NUM; i++){
    80005684:	2785                	addiw	a5,a5,1
    80005686:	0705                	addi	a4,a4,1
    80005688:	fe979be3          	bne	a5,s1,8000567e <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000568c:	57fd                	li	a5,-1
    8000568e:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005690:	03205163          	blez	s2,800056b2 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    80005694:	f9042503          	lw	a0,-112(s0)
    80005698:	00000097          	auipc	ra,0x0
    8000569c:	cc2080e7          	jalr	-830(ra) # 8000535a <free_desc>
      for(int j = 0; j < i; j++)
    800056a0:	4785                	li	a5,1
    800056a2:	0127d863          	bge	a5,s2,800056b2 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    800056a6:	f9442503          	lw	a0,-108(s0)
    800056aa:	00000097          	auipc	ra,0x0
    800056ae:	cb0080e7          	jalr	-848(ra) # 8000535a <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800056b2:	85e2                	mv	a1,s8
    800056b4:	00017517          	auipc	a0,0x17
    800056b8:	ed450513          	addi	a0,a0,-300 # 8001c588 <disk+0x18>
    800056bc:	ffffc097          	auipc	ra,0xffffc
    800056c0:	fa0080e7          	jalr	-96(ra) # 8000165c <sleep>
  for(int i = 0; i < 3; i++){
    800056c4:	f9040613          	addi	a2,s0,-112
    800056c8:	894e                	mv	s2,s3
    800056ca:	b765                	j	80005672 <virtio_disk_rw+0x6a>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800056cc:	f9042503          	lw	a0,-112(s0)
    800056d0:	00451693          	slli	a3,a0,0x4

  if(write)
    800056d4:	00017797          	auipc	a5,0x17
    800056d8:	e9c78793          	addi	a5,a5,-356 # 8001c570 <disk>
    800056dc:	00a50713          	addi	a4,a0,10
    800056e0:	0712                	slli	a4,a4,0x4
    800056e2:	973e                	add	a4,a4,a5
    800056e4:	01703633          	snez	a2,s7
    800056e8:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800056ea:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800056ee:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800056f2:	6398                	ld	a4,0(a5)
    800056f4:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800056f6:	0a868613          	addi	a2,a3,168
    800056fa:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800056fc:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800056fe:	6390                	ld	a2,0(a5)
    80005700:	00d605b3          	add	a1,a2,a3
    80005704:	4741                	li	a4,16
    80005706:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005708:	4805                	li	a6,1
    8000570a:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    8000570e:	f9442703          	lw	a4,-108(s0)
    80005712:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005716:	0712                	slli	a4,a4,0x4
    80005718:	963a                	add	a2,a2,a4
    8000571a:	058a0593          	addi	a1,s4,88
    8000571e:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005720:	0007b883          	ld	a7,0(a5)
    80005724:	9746                	add	a4,a4,a7
    80005726:	40000613          	li	a2,1024
    8000572a:	c710                	sw	a2,8(a4)
  if(write)
    8000572c:	001bb613          	seqz	a2,s7
    80005730:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005734:	00166613          	ori	a2,a2,1
    80005738:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    8000573c:	f9842583          	lw	a1,-104(s0)
    80005740:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005744:	00250613          	addi	a2,a0,2
    80005748:	0612                	slli	a2,a2,0x4
    8000574a:	963e                	add	a2,a2,a5
    8000574c:	577d                	li	a4,-1
    8000574e:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005752:	0592                	slli	a1,a1,0x4
    80005754:	98ae                	add	a7,a7,a1
    80005756:	03068713          	addi	a4,a3,48
    8000575a:	973e                	add	a4,a4,a5
    8000575c:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005760:	6398                	ld	a4,0(a5)
    80005762:	972e                	add	a4,a4,a1
    80005764:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005768:	4689                	li	a3,2
    8000576a:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    8000576e:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005772:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80005776:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000577a:	6794                	ld	a3,8(a5)
    8000577c:	0026d703          	lhu	a4,2(a3)
    80005780:	8b1d                	andi	a4,a4,7
    80005782:	0706                	slli	a4,a4,0x1
    80005784:	96ba                	add	a3,a3,a4
    80005786:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000578a:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000578e:	6798                	ld	a4,8(a5)
    80005790:	00275783          	lhu	a5,2(a4)
    80005794:	2785                	addiw	a5,a5,1
    80005796:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000579a:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000579e:	100017b7          	lui	a5,0x10001
    800057a2:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800057a6:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    800057aa:	00017917          	auipc	s2,0x17
    800057ae:	eee90913          	addi	s2,s2,-274 # 8001c698 <disk+0x128>
  while(b->disk == 1) {
    800057b2:	4485                	li	s1,1
    800057b4:	01079c63          	bne	a5,a6,800057cc <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    800057b8:	85ca                	mv	a1,s2
    800057ba:	8552                	mv	a0,s4
    800057bc:	ffffc097          	auipc	ra,0xffffc
    800057c0:	ea0080e7          	jalr	-352(ra) # 8000165c <sleep>
  while(b->disk == 1) {
    800057c4:	004a2783          	lw	a5,4(s4)
    800057c8:	fe9788e3          	beq	a5,s1,800057b8 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800057cc:	f9042903          	lw	s2,-112(s0)
    800057d0:	00290713          	addi	a4,s2,2
    800057d4:	0712                	slli	a4,a4,0x4
    800057d6:	00017797          	auipc	a5,0x17
    800057da:	d9a78793          	addi	a5,a5,-614 # 8001c570 <disk>
    800057de:	97ba                	add	a5,a5,a4
    800057e0:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800057e4:	00017997          	auipc	s3,0x17
    800057e8:	d8c98993          	addi	s3,s3,-628 # 8001c570 <disk>
    800057ec:	00491713          	slli	a4,s2,0x4
    800057f0:	0009b783          	ld	a5,0(s3)
    800057f4:	97ba                	add	a5,a5,a4
    800057f6:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800057fa:	854a                	mv	a0,s2
    800057fc:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005800:	00000097          	auipc	ra,0x0
    80005804:	b5a080e7          	jalr	-1190(ra) # 8000535a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005808:	8885                	andi	s1,s1,1
    8000580a:	f0ed                	bnez	s1,800057ec <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000580c:	00017517          	auipc	a0,0x17
    80005810:	e8c50513          	addi	a0,a0,-372 # 8001c698 <disk+0x128>
    80005814:	00001097          	auipc	ra,0x1
    80005818:	c4c080e7          	jalr	-948(ra) # 80006460 <release>
}
    8000581c:	70a6                	ld	ra,104(sp)
    8000581e:	7406                	ld	s0,96(sp)
    80005820:	64e6                	ld	s1,88(sp)
    80005822:	6946                	ld	s2,80(sp)
    80005824:	69a6                	ld	s3,72(sp)
    80005826:	6a06                	ld	s4,64(sp)
    80005828:	7ae2                	ld	s5,56(sp)
    8000582a:	7b42                	ld	s6,48(sp)
    8000582c:	7ba2                	ld	s7,40(sp)
    8000582e:	7c02                	ld	s8,32(sp)
    80005830:	6ce2                	ld	s9,24(sp)
    80005832:	6165                	addi	sp,sp,112
    80005834:	8082                	ret

0000000080005836 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005836:	1101                	addi	sp,sp,-32
    80005838:	ec06                	sd	ra,24(sp)
    8000583a:	e822                	sd	s0,16(sp)
    8000583c:	e426                	sd	s1,8(sp)
    8000583e:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005840:	00017497          	auipc	s1,0x17
    80005844:	d3048493          	addi	s1,s1,-720 # 8001c570 <disk>
    80005848:	00017517          	auipc	a0,0x17
    8000584c:	e5050513          	addi	a0,a0,-432 # 8001c698 <disk+0x128>
    80005850:	00001097          	auipc	ra,0x1
    80005854:	b5c080e7          	jalr	-1188(ra) # 800063ac <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005858:	100017b7          	lui	a5,0x10001
    8000585c:	53b8                	lw	a4,96(a5)
    8000585e:	8b0d                	andi	a4,a4,3
    80005860:	100017b7          	lui	a5,0x10001
    80005864:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005866:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    8000586a:	689c                	ld	a5,16(s1)
    8000586c:	0204d703          	lhu	a4,32(s1)
    80005870:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005874:	04f70863          	beq	a4,a5,800058c4 <virtio_disk_intr+0x8e>
    __sync_synchronize();
    80005878:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000587c:	6898                	ld	a4,16(s1)
    8000587e:	0204d783          	lhu	a5,32(s1)
    80005882:	8b9d                	andi	a5,a5,7
    80005884:	078e                	slli	a5,a5,0x3
    80005886:	97ba                	add	a5,a5,a4
    80005888:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000588a:	00278713          	addi	a4,a5,2
    8000588e:	0712                	slli	a4,a4,0x4
    80005890:	9726                	add	a4,a4,s1
    80005892:	01074703          	lbu	a4,16(a4)
    80005896:	e721                	bnez	a4,800058de <virtio_disk_intr+0xa8>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005898:	0789                	addi	a5,a5,2
    8000589a:	0792                	slli	a5,a5,0x4
    8000589c:	97a6                	add	a5,a5,s1
    8000589e:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800058a0:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800058a4:	ffffc097          	auipc	ra,0xffffc
    800058a8:	e1c080e7          	jalr	-484(ra) # 800016c0 <wakeup>

    disk.used_idx += 1;
    800058ac:	0204d783          	lhu	a5,32(s1)
    800058b0:	2785                	addiw	a5,a5,1
    800058b2:	17c2                	slli	a5,a5,0x30
    800058b4:	93c1                	srli	a5,a5,0x30
    800058b6:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800058ba:	6898                	ld	a4,16(s1)
    800058bc:	00275703          	lhu	a4,2(a4)
    800058c0:	faf71ce3          	bne	a4,a5,80005878 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    800058c4:	00017517          	auipc	a0,0x17
    800058c8:	dd450513          	addi	a0,a0,-556 # 8001c698 <disk+0x128>
    800058cc:	00001097          	auipc	ra,0x1
    800058d0:	b94080e7          	jalr	-1132(ra) # 80006460 <release>
}
    800058d4:	60e2                	ld	ra,24(sp)
    800058d6:	6442                	ld	s0,16(sp)
    800058d8:	64a2                	ld	s1,8(sp)
    800058da:	6105                	addi	sp,sp,32
    800058dc:	8082                	ret
      panic("virtio_disk_intr status");
    800058de:	00003517          	auipc	a0,0x3
    800058e2:	e1250513          	addi	a0,a0,-494 # 800086f0 <etext+0x6f0>
    800058e6:	00000097          	auipc	ra,0x0
    800058ea:	54c080e7          	jalr	1356(ra) # 80005e32 <panic>

00000000800058ee <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800058ee:	1141                	addi	sp,sp,-16
    800058f0:	e422                	sd	s0,8(sp)
    800058f2:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800058f4:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800058f8:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800058fc:	0037979b          	slliw	a5,a5,0x3
    80005900:	02004737          	lui	a4,0x2004
    80005904:	97ba                	add	a5,a5,a4
    80005906:	0200c737          	lui	a4,0x200c
    8000590a:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    8000590c:	6318                	ld	a4,0(a4)
    8000590e:	000f4637          	lui	a2,0xf4
    80005912:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005916:	9732                	add	a4,a4,a2
    80005918:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    8000591a:	00259693          	slli	a3,a1,0x2
    8000591e:	96ae                	add	a3,a3,a1
    80005920:	068e                	slli	a3,a3,0x3
    80005922:	00017717          	auipc	a4,0x17
    80005926:	d8e70713          	addi	a4,a4,-626 # 8001c6b0 <timer_scratch>
    8000592a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000592c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000592e:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005930:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005934:	00000797          	auipc	a5,0x0
    80005938:	95c78793          	addi	a5,a5,-1700 # 80005290 <timervec>
    8000593c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005940:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005944:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005948:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000594c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005950:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005954:	30479073          	csrw	mie,a5
}
    80005958:	6422                	ld	s0,8(sp)
    8000595a:	0141                	addi	sp,sp,16
    8000595c:	8082                	ret

000000008000595e <start>:
{
    8000595e:	1141                	addi	sp,sp,-16
    80005960:	e406                	sd	ra,8(sp)
    80005962:	e022                	sd	s0,0(sp)
    80005964:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005966:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000596a:	7779                	lui	a4,0xffffe
    8000596c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd9f0f>
    80005970:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005972:	6705                	lui	a4,0x1
    80005974:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005978:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000597a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    8000597e:	ffffb797          	auipc	a5,0xffffb
    80005982:	99a78793          	addi	a5,a5,-1638 # 80000318 <main>
    80005986:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000598a:	4781                	li	a5,0
    8000598c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005990:	67c1                	lui	a5,0x10
    80005992:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005994:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005998:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000599c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800059a0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800059a4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800059a8:	57fd                	li	a5,-1
    800059aa:	83a9                	srli	a5,a5,0xa
    800059ac:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800059b0:	47bd                	li	a5,15
    800059b2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800059b6:	00000097          	auipc	ra,0x0
    800059ba:	f38080e7          	jalr	-200(ra) # 800058ee <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800059be:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800059c2:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800059c4:	823e                	mv	tp,a5
  asm volatile("mret");
    800059c6:	30200073          	mret
}
    800059ca:	60a2                	ld	ra,8(sp)
    800059cc:	6402                	ld	s0,0(sp)
    800059ce:	0141                	addi	sp,sp,16
    800059d0:	8082                	ret

00000000800059d2 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800059d2:	715d                	addi	sp,sp,-80
    800059d4:	e486                	sd	ra,72(sp)
    800059d6:	e0a2                	sd	s0,64(sp)
    800059d8:	f84a                	sd	s2,48(sp)
    800059da:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800059dc:	04c05663          	blez	a2,80005a28 <consolewrite+0x56>
    800059e0:	fc26                	sd	s1,56(sp)
    800059e2:	f44e                	sd	s3,40(sp)
    800059e4:	f052                	sd	s4,32(sp)
    800059e6:	ec56                	sd	s5,24(sp)
    800059e8:	8a2a                	mv	s4,a0
    800059ea:	84ae                	mv	s1,a1
    800059ec:	89b2                	mv	s3,a2
    800059ee:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800059f0:	5afd                	li	s5,-1
    800059f2:	4685                	li	a3,1
    800059f4:	8626                	mv	a2,s1
    800059f6:	85d2                	mv	a1,s4
    800059f8:	fbf40513          	addi	a0,s0,-65
    800059fc:	ffffc097          	auipc	ra,0xffffc
    80005a00:	0be080e7          	jalr	190(ra) # 80001aba <either_copyin>
    80005a04:	03550463          	beq	a0,s5,80005a2c <consolewrite+0x5a>
      break;
    uartputc(c);
    80005a08:	fbf44503          	lbu	a0,-65(s0)
    80005a0c:	00000097          	auipc	ra,0x0
    80005a10:	7e4080e7          	jalr	2020(ra) # 800061f0 <uartputc>
  for(i = 0; i < n; i++){
    80005a14:	2905                	addiw	s2,s2,1
    80005a16:	0485                	addi	s1,s1,1
    80005a18:	fd299de3          	bne	s3,s2,800059f2 <consolewrite+0x20>
    80005a1c:	894e                	mv	s2,s3
    80005a1e:	74e2                	ld	s1,56(sp)
    80005a20:	79a2                	ld	s3,40(sp)
    80005a22:	7a02                	ld	s4,32(sp)
    80005a24:	6ae2                	ld	s5,24(sp)
    80005a26:	a039                	j	80005a34 <consolewrite+0x62>
    80005a28:	4901                	li	s2,0
    80005a2a:	a029                	j	80005a34 <consolewrite+0x62>
    80005a2c:	74e2                	ld	s1,56(sp)
    80005a2e:	79a2                	ld	s3,40(sp)
    80005a30:	7a02                	ld	s4,32(sp)
    80005a32:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005a34:	854a                	mv	a0,s2
    80005a36:	60a6                	ld	ra,72(sp)
    80005a38:	6406                	ld	s0,64(sp)
    80005a3a:	7942                	ld	s2,48(sp)
    80005a3c:	6161                	addi	sp,sp,80
    80005a3e:	8082                	ret

0000000080005a40 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005a40:	711d                	addi	sp,sp,-96
    80005a42:	ec86                	sd	ra,88(sp)
    80005a44:	e8a2                	sd	s0,80(sp)
    80005a46:	e4a6                	sd	s1,72(sp)
    80005a48:	e0ca                	sd	s2,64(sp)
    80005a4a:	fc4e                	sd	s3,56(sp)
    80005a4c:	f852                	sd	s4,48(sp)
    80005a4e:	f456                	sd	s5,40(sp)
    80005a50:	f05a                	sd	s6,32(sp)
    80005a52:	1080                	addi	s0,sp,96
    80005a54:	8aaa                	mv	s5,a0
    80005a56:	8a2e                	mv	s4,a1
    80005a58:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005a5a:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005a5e:	0001f517          	auipc	a0,0x1f
    80005a62:	d9250513          	addi	a0,a0,-622 # 800247f0 <cons>
    80005a66:	00001097          	auipc	ra,0x1
    80005a6a:	946080e7          	jalr	-1722(ra) # 800063ac <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005a6e:	0001f497          	auipc	s1,0x1f
    80005a72:	d8248493          	addi	s1,s1,-638 # 800247f0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005a76:	0001f917          	auipc	s2,0x1f
    80005a7a:	e1290913          	addi	s2,s2,-494 # 80024888 <cons+0x98>
  while(n > 0){
    80005a7e:	0d305763          	blez	s3,80005b4c <consoleread+0x10c>
    while(cons.r == cons.w){
    80005a82:	0984a783          	lw	a5,152(s1)
    80005a86:	09c4a703          	lw	a4,156(s1)
    80005a8a:	0af71c63          	bne	a4,a5,80005b42 <consoleread+0x102>
      if(killed(myproc())){
    80005a8e:	ffffb097          	auipc	ra,0xffffb
    80005a92:	474080e7          	jalr	1140(ra) # 80000f02 <myproc>
    80005a96:	ffffc097          	auipc	ra,0xffffc
    80005a9a:	e6e080e7          	jalr	-402(ra) # 80001904 <killed>
    80005a9e:	e52d                	bnez	a0,80005b08 <consoleread+0xc8>
      sleep(&cons.r, &cons.lock);
    80005aa0:	85a6                	mv	a1,s1
    80005aa2:	854a                	mv	a0,s2
    80005aa4:	ffffc097          	auipc	ra,0xffffc
    80005aa8:	bb8080e7          	jalr	-1096(ra) # 8000165c <sleep>
    while(cons.r == cons.w){
    80005aac:	0984a783          	lw	a5,152(s1)
    80005ab0:	09c4a703          	lw	a4,156(s1)
    80005ab4:	fcf70de3          	beq	a4,a5,80005a8e <consoleread+0x4e>
    80005ab8:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005aba:	0001f717          	auipc	a4,0x1f
    80005abe:	d3670713          	addi	a4,a4,-714 # 800247f0 <cons>
    80005ac2:	0017869b          	addiw	a3,a5,1
    80005ac6:	08d72c23          	sw	a3,152(a4)
    80005aca:	07f7f693          	andi	a3,a5,127
    80005ace:	9736                	add	a4,a4,a3
    80005ad0:	01874703          	lbu	a4,24(a4)
    80005ad4:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005ad8:	4691                	li	a3,4
    80005ada:	04db8a63          	beq	s7,a3,80005b2e <consoleread+0xee>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005ade:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005ae2:	4685                	li	a3,1
    80005ae4:	faf40613          	addi	a2,s0,-81
    80005ae8:	85d2                	mv	a1,s4
    80005aea:	8556                	mv	a0,s5
    80005aec:	ffffc097          	auipc	ra,0xffffc
    80005af0:	f78080e7          	jalr	-136(ra) # 80001a64 <either_copyout>
    80005af4:	57fd                	li	a5,-1
    80005af6:	04f50a63          	beq	a0,a5,80005b4a <consoleread+0x10a>
      break;

    dst++;
    80005afa:	0a05                	addi	s4,s4,1
    --n;
    80005afc:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005afe:	47a9                	li	a5,10
    80005b00:	06fb8163          	beq	s7,a5,80005b62 <consoleread+0x122>
    80005b04:	6be2                	ld	s7,24(sp)
    80005b06:	bfa5                	j	80005a7e <consoleread+0x3e>
        release(&cons.lock);
    80005b08:	0001f517          	auipc	a0,0x1f
    80005b0c:	ce850513          	addi	a0,a0,-792 # 800247f0 <cons>
    80005b10:	00001097          	auipc	ra,0x1
    80005b14:	950080e7          	jalr	-1712(ra) # 80006460 <release>
        return -1;
    80005b18:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005b1a:	60e6                	ld	ra,88(sp)
    80005b1c:	6446                	ld	s0,80(sp)
    80005b1e:	64a6                	ld	s1,72(sp)
    80005b20:	6906                	ld	s2,64(sp)
    80005b22:	79e2                	ld	s3,56(sp)
    80005b24:	7a42                	ld	s4,48(sp)
    80005b26:	7aa2                	ld	s5,40(sp)
    80005b28:	7b02                	ld	s6,32(sp)
    80005b2a:	6125                	addi	sp,sp,96
    80005b2c:	8082                	ret
      if(n < target){
    80005b2e:	0009871b          	sext.w	a4,s3
    80005b32:	01677a63          	bgeu	a4,s6,80005b46 <consoleread+0x106>
        cons.r--;
    80005b36:	0001f717          	auipc	a4,0x1f
    80005b3a:	d4f72923          	sw	a5,-686(a4) # 80024888 <cons+0x98>
    80005b3e:	6be2                	ld	s7,24(sp)
    80005b40:	a031                	j	80005b4c <consoleread+0x10c>
    80005b42:	ec5e                	sd	s7,24(sp)
    80005b44:	bf9d                	j	80005aba <consoleread+0x7a>
    80005b46:	6be2                	ld	s7,24(sp)
    80005b48:	a011                	j	80005b4c <consoleread+0x10c>
    80005b4a:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005b4c:	0001f517          	auipc	a0,0x1f
    80005b50:	ca450513          	addi	a0,a0,-860 # 800247f0 <cons>
    80005b54:	00001097          	auipc	ra,0x1
    80005b58:	90c080e7          	jalr	-1780(ra) # 80006460 <release>
  return target - n;
    80005b5c:	413b053b          	subw	a0,s6,s3
    80005b60:	bf6d                	j	80005b1a <consoleread+0xda>
    80005b62:	6be2                	ld	s7,24(sp)
    80005b64:	b7e5                	j	80005b4c <consoleread+0x10c>

0000000080005b66 <consputc>:
{
    80005b66:	1141                	addi	sp,sp,-16
    80005b68:	e406                	sd	ra,8(sp)
    80005b6a:	e022                	sd	s0,0(sp)
    80005b6c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005b6e:	10000793          	li	a5,256
    80005b72:	00f50a63          	beq	a0,a5,80005b86 <consputc+0x20>
    uartputc_sync(c);
    80005b76:	00000097          	auipc	ra,0x0
    80005b7a:	59c080e7          	jalr	1436(ra) # 80006112 <uartputc_sync>
}
    80005b7e:	60a2                	ld	ra,8(sp)
    80005b80:	6402                	ld	s0,0(sp)
    80005b82:	0141                	addi	sp,sp,16
    80005b84:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005b86:	4521                	li	a0,8
    80005b88:	00000097          	auipc	ra,0x0
    80005b8c:	58a080e7          	jalr	1418(ra) # 80006112 <uartputc_sync>
    80005b90:	02000513          	li	a0,32
    80005b94:	00000097          	auipc	ra,0x0
    80005b98:	57e080e7          	jalr	1406(ra) # 80006112 <uartputc_sync>
    80005b9c:	4521                	li	a0,8
    80005b9e:	00000097          	auipc	ra,0x0
    80005ba2:	574080e7          	jalr	1396(ra) # 80006112 <uartputc_sync>
    80005ba6:	bfe1                	j	80005b7e <consputc+0x18>

0000000080005ba8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005ba8:	1101                	addi	sp,sp,-32
    80005baa:	ec06                	sd	ra,24(sp)
    80005bac:	e822                	sd	s0,16(sp)
    80005bae:	e426                	sd	s1,8(sp)
    80005bb0:	1000                	addi	s0,sp,32
    80005bb2:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005bb4:	0001f517          	auipc	a0,0x1f
    80005bb8:	c3c50513          	addi	a0,a0,-964 # 800247f0 <cons>
    80005bbc:	00000097          	auipc	ra,0x0
    80005bc0:	7f0080e7          	jalr	2032(ra) # 800063ac <acquire>

  switch(c){
    80005bc4:	47d5                	li	a5,21
    80005bc6:	0af48563          	beq	s1,a5,80005c70 <consoleintr+0xc8>
    80005bca:	0297c963          	blt	a5,s1,80005bfc <consoleintr+0x54>
    80005bce:	47a1                	li	a5,8
    80005bd0:	0ef48c63          	beq	s1,a5,80005cc8 <consoleintr+0x120>
    80005bd4:	47c1                	li	a5,16
    80005bd6:	10f49f63          	bne	s1,a5,80005cf4 <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    80005bda:	ffffc097          	auipc	ra,0xffffc
    80005bde:	f36080e7          	jalr	-202(ra) # 80001b10 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005be2:	0001f517          	auipc	a0,0x1f
    80005be6:	c0e50513          	addi	a0,a0,-1010 # 800247f0 <cons>
    80005bea:	00001097          	auipc	ra,0x1
    80005bee:	876080e7          	jalr	-1930(ra) # 80006460 <release>
}
    80005bf2:	60e2                	ld	ra,24(sp)
    80005bf4:	6442                	ld	s0,16(sp)
    80005bf6:	64a2                	ld	s1,8(sp)
    80005bf8:	6105                	addi	sp,sp,32
    80005bfa:	8082                	ret
  switch(c){
    80005bfc:	07f00793          	li	a5,127
    80005c00:	0cf48463          	beq	s1,a5,80005cc8 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005c04:	0001f717          	auipc	a4,0x1f
    80005c08:	bec70713          	addi	a4,a4,-1044 # 800247f0 <cons>
    80005c0c:	0a072783          	lw	a5,160(a4)
    80005c10:	09872703          	lw	a4,152(a4)
    80005c14:	9f99                	subw	a5,a5,a4
    80005c16:	07f00713          	li	a4,127
    80005c1a:	fcf764e3          	bltu	a4,a5,80005be2 <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005c1e:	47b5                	li	a5,13
    80005c20:	0cf48d63          	beq	s1,a5,80005cfa <consoleintr+0x152>
      consputc(c);
    80005c24:	8526                	mv	a0,s1
    80005c26:	00000097          	auipc	ra,0x0
    80005c2a:	f40080e7          	jalr	-192(ra) # 80005b66 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005c2e:	0001f797          	auipc	a5,0x1f
    80005c32:	bc278793          	addi	a5,a5,-1086 # 800247f0 <cons>
    80005c36:	0a07a683          	lw	a3,160(a5)
    80005c3a:	0016871b          	addiw	a4,a3,1
    80005c3e:	0007061b          	sext.w	a2,a4
    80005c42:	0ae7a023          	sw	a4,160(a5)
    80005c46:	07f6f693          	andi	a3,a3,127
    80005c4a:	97b6                	add	a5,a5,a3
    80005c4c:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005c50:	47a9                	li	a5,10
    80005c52:	0cf48b63          	beq	s1,a5,80005d28 <consoleintr+0x180>
    80005c56:	4791                	li	a5,4
    80005c58:	0cf48863          	beq	s1,a5,80005d28 <consoleintr+0x180>
    80005c5c:	0001f797          	auipc	a5,0x1f
    80005c60:	c2c7a783          	lw	a5,-980(a5) # 80024888 <cons+0x98>
    80005c64:	9f1d                	subw	a4,a4,a5
    80005c66:	08000793          	li	a5,128
    80005c6a:	f6f71ce3          	bne	a4,a5,80005be2 <consoleintr+0x3a>
    80005c6e:	a86d                	j	80005d28 <consoleintr+0x180>
    80005c70:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005c72:	0001f717          	auipc	a4,0x1f
    80005c76:	b7e70713          	addi	a4,a4,-1154 # 800247f0 <cons>
    80005c7a:	0a072783          	lw	a5,160(a4)
    80005c7e:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005c82:	0001f497          	auipc	s1,0x1f
    80005c86:	b6e48493          	addi	s1,s1,-1170 # 800247f0 <cons>
    while(cons.e != cons.w &&
    80005c8a:	4929                	li	s2,10
    80005c8c:	02f70a63          	beq	a4,a5,80005cc0 <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005c90:	37fd                	addiw	a5,a5,-1
    80005c92:	07f7f713          	andi	a4,a5,127
    80005c96:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005c98:	01874703          	lbu	a4,24(a4)
    80005c9c:	03270463          	beq	a4,s2,80005cc4 <consoleintr+0x11c>
      cons.e--;
    80005ca0:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005ca4:	10000513          	li	a0,256
    80005ca8:	00000097          	auipc	ra,0x0
    80005cac:	ebe080e7          	jalr	-322(ra) # 80005b66 <consputc>
    while(cons.e != cons.w &&
    80005cb0:	0a04a783          	lw	a5,160(s1)
    80005cb4:	09c4a703          	lw	a4,156(s1)
    80005cb8:	fcf71ce3          	bne	a4,a5,80005c90 <consoleintr+0xe8>
    80005cbc:	6902                	ld	s2,0(sp)
    80005cbe:	b715                	j	80005be2 <consoleintr+0x3a>
    80005cc0:	6902                	ld	s2,0(sp)
    80005cc2:	b705                	j	80005be2 <consoleintr+0x3a>
    80005cc4:	6902                	ld	s2,0(sp)
    80005cc6:	bf31                	j	80005be2 <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005cc8:	0001f717          	auipc	a4,0x1f
    80005ccc:	b2870713          	addi	a4,a4,-1240 # 800247f0 <cons>
    80005cd0:	0a072783          	lw	a5,160(a4)
    80005cd4:	09c72703          	lw	a4,156(a4)
    80005cd8:	f0f705e3          	beq	a4,a5,80005be2 <consoleintr+0x3a>
      cons.e--;
    80005cdc:	37fd                	addiw	a5,a5,-1
    80005cde:	0001f717          	auipc	a4,0x1f
    80005ce2:	baf72923          	sw	a5,-1102(a4) # 80024890 <cons+0xa0>
      consputc(BACKSPACE);
    80005ce6:	10000513          	li	a0,256
    80005cea:	00000097          	auipc	ra,0x0
    80005cee:	e7c080e7          	jalr	-388(ra) # 80005b66 <consputc>
    80005cf2:	bdc5                	j	80005be2 <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005cf4:	ee0487e3          	beqz	s1,80005be2 <consoleintr+0x3a>
    80005cf8:	b731                	j	80005c04 <consoleintr+0x5c>
      consputc(c);
    80005cfa:	4529                	li	a0,10
    80005cfc:	00000097          	auipc	ra,0x0
    80005d00:	e6a080e7          	jalr	-406(ra) # 80005b66 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005d04:	0001f797          	auipc	a5,0x1f
    80005d08:	aec78793          	addi	a5,a5,-1300 # 800247f0 <cons>
    80005d0c:	0a07a703          	lw	a4,160(a5)
    80005d10:	0017069b          	addiw	a3,a4,1
    80005d14:	0006861b          	sext.w	a2,a3
    80005d18:	0ad7a023          	sw	a3,160(a5)
    80005d1c:	07f77713          	andi	a4,a4,127
    80005d20:	97ba                	add	a5,a5,a4
    80005d22:	4729                	li	a4,10
    80005d24:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005d28:	0001f797          	auipc	a5,0x1f
    80005d2c:	b6c7a223          	sw	a2,-1180(a5) # 8002488c <cons+0x9c>
        wakeup(&cons.r);
    80005d30:	0001f517          	auipc	a0,0x1f
    80005d34:	b5850513          	addi	a0,a0,-1192 # 80024888 <cons+0x98>
    80005d38:	ffffc097          	auipc	ra,0xffffc
    80005d3c:	988080e7          	jalr	-1656(ra) # 800016c0 <wakeup>
    80005d40:	b54d                	j	80005be2 <consoleintr+0x3a>

0000000080005d42 <consoleinit>:

void
consoleinit(void)
{
    80005d42:	1141                	addi	sp,sp,-16
    80005d44:	e406                	sd	ra,8(sp)
    80005d46:	e022                	sd	s0,0(sp)
    80005d48:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005d4a:	00003597          	auipc	a1,0x3
    80005d4e:	9be58593          	addi	a1,a1,-1602 # 80008708 <etext+0x708>
    80005d52:	0001f517          	auipc	a0,0x1f
    80005d56:	a9e50513          	addi	a0,a0,-1378 # 800247f0 <cons>
    80005d5a:	00000097          	auipc	ra,0x0
    80005d5e:	5c2080e7          	jalr	1474(ra) # 8000631c <initlock>

  uartinit();
    80005d62:	00000097          	auipc	ra,0x0
    80005d66:	354080e7          	jalr	852(ra) # 800060b6 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005d6a:	00015797          	auipc	a5,0x15
    80005d6e:	7ae78793          	addi	a5,a5,1966 # 8001b518 <devsw>
    80005d72:	00000717          	auipc	a4,0x0
    80005d76:	cce70713          	addi	a4,a4,-818 # 80005a40 <consoleread>
    80005d7a:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005d7c:	00000717          	auipc	a4,0x0
    80005d80:	c5670713          	addi	a4,a4,-938 # 800059d2 <consolewrite>
    80005d84:	ef98                	sd	a4,24(a5)
}
    80005d86:	60a2                	ld	ra,8(sp)
    80005d88:	6402                	ld	s0,0(sp)
    80005d8a:	0141                	addi	sp,sp,16
    80005d8c:	8082                	ret

0000000080005d8e <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005d8e:	7179                	addi	sp,sp,-48
    80005d90:	f406                	sd	ra,40(sp)
    80005d92:	f022                	sd	s0,32(sp)
    80005d94:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005d96:	c219                	beqz	a2,80005d9c <printint+0xe>
    80005d98:	08054963          	bltz	a0,80005e2a <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005d9c:	2501                	sext.w	a0,a0
    80005d9e:	4881                	li	a7,0
    80005da0:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005da4:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005da6:	2581                	sext.w	a1,a1
    80005da8:	00003617          	auipc	a2,0x3
    80005dac:	b0860613          	addi	a2,a2,-1272 # 800088b0 <digits>
    80005db0:	883a                	mv	a6,a4
    80005db2:	2705                	addiw	a4,a4,1
    80005db4:	02b577bb          	remuw	a5,a0,a1
    80005db8:	1782                	slli	a5,a5,0x20
    80005dba:	9381                	srli	a5,a5,0x20
    80005dbc:	97b2                	add	a5,a5,a2
    80005dbe:	0007c783          	lbu	a5,0(a5)
    80005dc2:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005dc6:	0005079b          	sext.w	a5,a0
    80005dca:	02b5553b          	divuw	a0,a0,a1
    80005dce:	0685                	addi	a3,a3,1
    80005dd0:	feb7f0e3          	bgeu	a5,a1,80005db0 <printint+0x22>

  if(sign)
    80005dd4:	00088c63          	beqz	a7,80005dec <printint+0x5e>
    buf[i++] = '-';
    80005dd8:	fe070793          	addi	a5,a4,-32
    80005ddc:	00878733          	add	a4,a5,s0
    80005de0:	02d00793          	li	a5,45
    80005de4:	fef70823          	sb	a5,-16(a4)
    80005de8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005dec:	02e05b63          	blez	a4,80005e22 <printint+0x94>
    80005df0:	ec26                	sd	s1,24(sp)
    80005df2:	e84a                	sd	s2,16(sp)
    80005df4:	fd040793          	addi	a5,s0,-48
    80005df8:	00e784b3          	add	s1,a5,a4
    80005dfc:	fff78913          	addi	s2,a5,-1
    80005e00:	993a                	add	s2,s2,a4
    80005e02:	377d                	addiw	a4,a4,-1
    80005e04:	1702                	slli	a4,a4,0x20
    80005e06:	9301                	srli	a4,a4,0x20
    80005e08:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005e0c:	fff4c503          	lbu	a0,-1(s1)
    80005e10:	00000097          	auipc	ra,0x0
    80005e14:	d56080e7          	jalr	-682(ra) # 80005b66 <consputc>
  while(--i >= 0)
    80005e18:	14fd                	addi	s1,s1,-1
    80005e1a:	ff2499e3          	bne	s1,s2,80005e0c <printint+0x7e>
    80005e1e:	64e2                	ld	s1,24(sp)
    80005e20:	6942                	ld	s2,16(sp)
}
    80005e22:	70a2                	ld	ra,40(sp)
    80005e24:	7402                	ld	s0,32(sp)
    80005e26:	6145                	addi	sp,sp,48
    80005e28:	8082                	ret
    x = -xx;
    80005e2a:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005e2e:	4885                	li	a7,1
    x = -xx;
    80005e30:	bf85                	j	80005da0 <printint+0x12>

0000000080005e32 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005e32:	1101                	addi	sp,sp,-32
    80005e34:	ec06                	sd	ra,24(sp)
    80005e36:	e822                	sd	s0,16(sp)
    80005e38:	e426                	sd	s1,8(sp)
    80005e3a:	1000                	addi	s0,sp,32
    80005e3c:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005e3e:	0001f797          	auipc	a5,0x1f
    80005e42:	a607a923          	sw	zero,-1422(a5) # 800248b0 <pr+0x18>
  printf("panic: ");
    80005e46:	00003517          	auipc	a0,0x3
    80005e4a:	8ca50513          	addi	a0,a0,-1846 # 80008710 <etext+0x710>
    80005e4e:	00000097          	auipc	ra,0x0
    80005e52:	02e080e7          	jalr	46(ra) # 80005e7c <printf>
  printf(s);
    80005e56:	8526                	mv	a0,s1
    80005e58:	00000097          	auipc	ra,0x0
    80005e5c:	024080e7          	jalr	36(ra) # 80005e7c <printf>
  printf("\n");
    80005e60:	00002517          	auipc	a0,0x2
    80005e64:	1b850513          	addi	a0,a0,440 # 80008018 <etext+0x18>
    80005e68:	00000097          	auipc	ra,0x0
    80005e6c:	014080e7          	jalr	20(ra) # 80005e7c <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005e70:	4785                	li	a5,1
    80005e72:	00005717          	auipc	a4,0x5
    80005e76:	3ef72d23          	sw	a5,1018(a4) # 8000b26c <panicked>
  for(;;)
    80005e7a:	a001                	j	80005e7a <panic+0x48>

0000000080005e7c <printf>:
{
    80005e7c:	7131                	addi	sp,sp,-192
    80005e7e:	fc86                	sd	ra,120(sp)
    80005e80:	f8a2                	sd	s0,112(sp)
    80005e82:	e8d2                	sd	s4,80(sp)
    80005e84:	f06a                	sd	s10,32(sp)
    80005e86:	0100                	addi	s0,sp,128
    80005e88:	8a2a                	mv	s4,a0
    80005e8a:	e40c                	sd	a1,8(s0)
    80005e8c:	e810                	sd	a2,16(s0)
    80005e8e:	ec14                	sd	a3,24(s0)
    80005e90:	f018                	sd	a4,32(s0)
    80005e92:	f41c                	sd	a5,40(s0)
    80005e94:	03043823          	sd	a6,48(s0)
    80005e98:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005e9c:	0001fd17          	auipc	s10,0x1f
    80005ea0:	a14d2d03          	lw	s10,-1516(s10) # 800248b0 <pr+0x18>
  if(locking)
    80005ea4:	040d1463          	bnez	s10,80005eec <printf+0x70>
  if (fmt == 0)
    80005ea8:	040a0b63          	beqz	s4,80005efe <printf+0x82>
  va_start(ap, fmt);
    80005eac:	00840793          	addi	a5,s0,8
    80005eb0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005eb4:	000a4503          	lbu	a0,0(s4)
    80005eb8:	18050b63          	beqz	a0,8000604e <printf+0x1d2>
    80005ebc:	f4a6                	sd	s1,104(sp)
    80005ebe:	f0ca                	sd	s2,96(sp)
    80005ec0:	ecce                	sd	s3,88(sp)
    80005ec2:	e4d6                	sd	s5,72(sp)
    80005ec4:	e0da                	sd	s6,64(sp)
    80005ec6:	fc5e                	sd	s7,56(sp)
    80005ec8:	f862                	sd	s8,48(sp)
    80005eca:	f466                	sd	s9,40(sp)
    80005ecc:	ec6e                	sd	s11,24(sp)
    80005ece:	4981                	li	s3,0
    if(c != '%'){
    80005ed0:	02500b13          	li	s6,37
    switch(c){
    80005ed4:	07000b93          	li	s7,112
  consputc('x');
    80005ed8:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005eda:	00003a97          	auipc	s5,0x3
    80005ede:	9d6a8a93          	addi	s5,s5,-1578 # 800088b0 <digits>
    switch(c){
    80005ee2:	07300c13          	li	s8,115
    80005ee6:	06400d93          	li	s11,100
    80005eea:	a0b1                	j	80005f36 <printf+0xba>
    acquire(&pr.lock);
    80005eec:	0001f517          	auipc	a0,0x1f
    80005ef0:	9ac50513          	addi	a0,a0,-1620 # 80024898 <pr>
    80005ef4:	00000097          	auipc	ra,0x0
    80005ef8:	4b8080e7          	jalr	1208(ra) # 800063ac <acquire>
    80005efc:	b775                	j	80005ea8 <printf+0x2c>
    80005efe:	f4a6                	sd	s1,104(sp)
    80005f00:	f0ca                	sd	s2,96(sp)
    80005f02:	ecce                	sd	s3,88(sp)
    80005f04:	e4d6                	sd	s5,72(sp)
    80005f06:	e0da                	sd	s6,64(sp)
    80005f08:	fc5e                	sd	s7,56(sp)
    80005f0a:	f862                	sd	s8,48(sp)
    80005f0c:	f466                	sd	s9,40(sp)
    80005f0e:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    80005f10:	00003517          	auipc	a0,0x3
    80005f14:	81050513          	addi	a0,a0,-2032 # 80008720 <etext+0x720>
    80005f18:	00000097          	auipc	ra,0x0
    80005f1c:	f1a080e7          	jalr	-230(ra) # 80005e32 <panic>
      consputc(c);
    80005f20:	00000097          	auipc	ra,0x0
    80005f24:	c46080e7          	jalr	-954(ra) # 80005b66 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f28:	2985                	addiw	s3,s3,1
    80005f2a:	013a07b3          	add	a5,s4,s3
    80005f2e:	0007c503          	lbu	a0,0(a5)
    80005f32:	10050563          	beqz	a0,8000603c <printf+0x1c0>
    if(c != '%'){
    80005f36:	ff6515e3          	bne	a0,s6,80005f20 <printf+0xa4>
    c = fmt[++i] & 0xff;
    80005f3a:	2985                	addiw	s3,s3,1
    80005f3c:	013a07b3          	add	a5,s4,s3
    80005f40:	0007c783          	lbu	a5,0(a5)
    80005f44:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005f48:	10078b63          	beqz	a5,8000605e <printf+0x1e2>
    switch(c){
    80005f4c:	05778a63          	beq	a5,s7,80005fa0 <printf+0x124>
    80005f50:	02fbf663          	bgeu	s7,a5,80005f7c <printf+0x100>
    80005f54:	09878863          	beq	a5,s8,80005fe4 <printf+0x168>
    80005f58:	07800713          	li	a4,120
    80005f5c:	0ce79563          	bne	a5,a4,80006026 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    80005f60:	f8843783          	ld	a5,-120(s0)
    80005f64:	00878713          	addi	a4,a5,8
    80005f68:	f8e43423          	sd	a4,-120(s0)
    80005f6c:	4605                	li	a2,1
    80005f6e:	85e6                	mv	a1,s9
    80005f70:	4388                	lw	a0,0(a5)
    80005f72:	00000097          	auipc	ra,0x0
    80005f76:	e1c080e7          	jalr	-484(ra) # 80005d8e <printint>
      break;
    80005f7a:	b77d                	j	80005f28 <printf+0xac>
    switch(c){
    80005f7c:	09678f63          	beq	a5,s6,8000601a <printf+0x19e>
    80005f80:	0bb79363          	bne	a5,s11,80006026 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    80005f84:	f8843783          	ld	a5,-120(s0)
    80005f88:	00878713          	addi	a4,a5,8
    80005f8c:	f8e43423          	sd	a4,-120(s0)
    80005f90:	4605                	li	a2,1
    80005f92:	45a9                	li	a1,10
    80005f94:	4388                	lw	a0,0(a5)
    80005f96:	00000097          	auipc	ra,0x0
    80005f9a:	df8080e7          	jalr	-520(ra) # 80005d8e <printint>
      break;
    80005f9e:	b769                	j	80005f28 <printf+0xac>
      printptr(va_arg(ap, uint64));
    80005fa0:	f8843783          	ld	a5,-120(s0)
    80005fa4:	00878713          	addi	a4,a5,8
    80005fa8:	f8e43423          	sd	a4,-120(s0)
    80005fac:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005fb0:	03000513          	li	a0,48
    80005fb4:	00000097          	auipc	ra,0x0
    80005fb8:	bb2080e7          	jalr	-1102(ra) # 80005b66 <consputc>
  consputc('x');
    80005fbc:	07800513          	li	a0,120
    80005fc0:	00000097          	auipc	ra,0x0
    80005fc4:	ba6080e7          	jalr	-1114(ra) # 80005b66 <consputc>
    80005fc8:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005fca:	03c95793          	srli	a5,s2,0x3c
    80005fce:	97d6                	add	a5,a5,s5
    80005fd0:	0007c503          	lbu	a0,0(a5)
    80005fd4:	00000097          	auipc	ra,0x0
    80005fd8:	b92080e7          	jalr	-1134(ra) # 80005b66 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005fdc:	0912                	slli	s2,s2,0x4
    80005fde:	34fd                	addiw	s1,s1,-1
    80005fe0:	f4ed                	bnez	s1,80005fca <printf+0x14e>
    80005fe2:	b799                	j	80005f28 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80005fe4:	f8843783          	ld	a5,-120(s0)
    80005fe8:	00878713          	addi	a4,a5,8
    80005fec:	f8e43423          	sd	a4,-120(s0)
    80005ff0:	6384                	ld	s1,0(a5)
    80005ff2:	cc89                	beqz	s1,8000600c <printf+0x190>
      for(; *s; s++)
    80005ff4:	0004c503          	lbu	a0,0(s1)
    80005ff8:	d905                	beqz	a0,80005f28 <printf+0xac>
        consputc(*s);
    80005ffa:	00000097          	auipc	ra,0x0
    80005ffe:	b6c080e7          	jalr	-1172(ra) # 80005b66 <consputc>
      for(; *s; s++)
    80006002:	0485                	addi	s1,s1,1
    80006004:	0004c503          	lbu	a0,0(s1)
    80006008:	f96d                	bnez	a0,80005ffa <printf+0x17e>
    8000600a:	bf39                	j	80005f28 <printf+0xac>
        s = "(null)";
    8000600c:	00002497          	auipc	s1,0x2
    80006010:	70c48493          	addi	s1,s1,1804 # 80008718 <etext+0x718>
      for(; *s; s++)
    80006014:	02800513          	li	a0,40
    80006018:	b7cd                	j	80005ffa <printf+0x17e>
      consputc('%');
    8000601a:	855a                	mv	a0,s6
    8000601c:	00000097          	auipc	ra,0x0
    80006020:	b4a080e7          	jalr	-1206(ra) # 80005b66 <consputc>
      break;
    80006024:	b711                	j	80005f28 <printf+0xac>
      consputc('%');
    80006026:	855a                	mv	a0,s6
    80006028:	00000097          	auipc	ra,0x0
    8000602c:	b3e080e7          	jalr	-1218(ra) # 80005b66 <consputc>
      consputc(c);
    80006030:	8526                	mv	a0,s1
    80006032:	00000097          	auipc	ra,0x0
    80006036:	b34080e7          	jalr	-1228(ra) # 80005b66 <consputc>
      break;
    8000603a:	b5fd                	j	80005f28 <printf+0xac>
    8000603c:	74a6                	ld	s1,104(sp)
    8000603e:	7906                	ld	s2,96(sp)
    80006040:	69e6                	ld	s3,88(sp)
    80006042:	6aa6                	ld	s5,72(sp)
    80006044:	6b06                	ld	s6,64(sp)
    80006046:	7be2                	ld	s7,56(sp)
    80006048:	7c42                	ld	s8,48(sp)
    8000604a:	7ca2                	ld	s9,40(sp)
    8000604c:	6de2                	ld	s11,24(sp)
  if(locking)
    8000604e:	020d1263          	bnez	s10,80006072 <printf+0x1f6>
}
    80006052:	70e6                	ld	ra,120(sp)
    80006054:	7446                	ld	s0,112(sp)
    80006056:	6a46                	ld	s4,80(sp)
    80006058:	7d02                	ld	s10,32(sp)
    8000605a:	6129                	addi	sp,sp,192
    8000605c:	8082                	ret
    8000605e:	74a6                	ld	s1,104(sp)
    80006060:	7906                	ld	s2,96(sp)
    80006062:	69e6                	ld	s3,88(sp)
    80006064:	6aa6                	ld	s5,72(sp)
    80006066:	6b06                	ld	s6,64(sp)
    80006068:	7be2                	ld	s7,56(sp)
    8000606a:	7c42                	ld	s8,48(sp)
    8000606c:	7ca2                	ld	s9,40(sp)
    8000606e:	6de2                	ld	s11,24(sp)
    80006070:	bff9                	j	8000604e <printf+0x1d2>
    release(&pr.lock);
    80006072:	0001f517          	auipc	a0,0x1f
    80006076:	82650513          	addi	a0,a0,-2010 # 80024898 <pr>
    8000607a:	00000097          	auipc	ra,0x0
    8000607e:	3e6080e7          	jalr	998(ra) # 80006460 <release>
}
    80006082:	bfc1                	j	80006052 <printf+0x1d6>

0000000080006084 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006084:	1101                	addi	sp,sp,-32
    80006086:	ec06                	sd	ra,24(sp)
    80006088:	e822                	sd	s0,16(sp)
    8000608a:	e426                	sd	s1,8(sp)
    8000608c:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000608e:	0001f497          	auipc	s1,0x1f
    80006092:	80a48493          	addi	s1,s1,-2038 # 80024898 <pr>
    80006096:	00002597          	auipc	a1,0x2
    8000609a:	69a58593          	addi	a1,a1,1690 # 80008730 <etext+0x730>
    8000609e:	8526                	mv	a0,s1
    800060a0:	00000097          	auipc	ra,0x0
    800060a4:	27c080e7          	jalr	636(ra) # 8000631c <initlock>
  pr.locking = 1;
    800060a8:	4785                	li	a5,1
    800060aa:	cc9c                	sw	a5,24(s1)
}
    800060ac:	60e2                	ld	ra,24(sp)
    800060ae:	6442                	ld	s0,16(sp)
    800060b0:	64a2                	ld	s1,8(sp)
    800060b2:	6105                	addi	sp,sp,32
    800060b4:	8082                	ret

00000000800060b6 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800060b6:	1141                	addi	sp,sp,-16
    800060b8:	e406                	sd	ra,8(sp)
    800060ba:	e022                	sd	s0,0(sp)
    800060bc:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800060be:	100007b7          	lui	a5,0x10000
    800060c2:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800060c6:	10000737          	lui	a4,0x10000
    800060ca:	f8000693          	li	a3,-128
    800060ce:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800060d2:	468d                	li	a3,3
    800060d4:	10000637          	lui	a2,0x10000
    800060d8:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800060dc:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800060e0:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800060e4:	10000737          	lui	a4,0x10000
    800060e8:	461d                	li	a2,7
    800060ea:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800060ee:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    800060f2:	00002597          	auipc	a1,0x2
    800060f6:	64658593          	addi	a1,a1,1606 # 80008738 <etext+0x738>
    800060fa:	0001e517          	auipc	a0,0x1e
    800060fe:	7be50513          	addi	a0,a0,1982 # 800248b8 <uart_tx_lock>
    80006102:	00000097          	auipc	ra,0x0
    80006106:	21a080e7          	jalr	538(ra) # 8000631c <initlock>
}
    8000610a:	60a2                	ld	ra,8(sp)
    8000610c:	6402                	ld	s0,0(sp)
    8000610e:	0141                	addi	sp,sp,16
    80006110:	8082                	ret

0000000080006112 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006112:	1101                	addi	sp,sp,-32
    80006114:	ec06                	sd	ra,24(sp)
    80006116:	e822                	sd	s0,16(sp)
    80006118:	e426                	sd	s1,8(sp)
    8000611a:	1000                	addi	s0,sp,32
    8000611c:	84aa                	mv	s1,a0
  push_off();
    8000611e:	00000097          	auipc	ra,0x0
    80006122:	242080e7          	jalr	578(ra) # 80006360 <push_off>

  if(panicked){
    80006126:	00005797          	auipc	a5,0x5
    8000612a:	1467a783          	lw	a5,326(a5) # 8000b26c <panicked>
    8000612e:	eb85                	bnez	a5,8000615e <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006130:	10000737          	lui	a4,0x10000
    80006134:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80006136:	00074783          	lbu	a5,0(a4)
    8000613a:	0207f793          	andi	a5,a5,32
    8000613e:	dfe5                	beqz	a5,80006136 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006140:	0ff4f513          	zext.b	a0,s1
    80006144:	100007b7          	lui	a5,0x10000
    80006148:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000614c:	00000097          	auipc	ra,0x0
    80006150:	2b4080e7          	jalr	692(ra) # 80006400 <pop_off>
}
    80006154:	60e2                	ld	ra,24(sp)
    80006156:	6442                	ld	s0,16(sp)
    80006158:	64a2                	ld	s1,8(sp)
    8000615a:	6105                	addi	sp,sp,32
    8000615c:	8082                	ret
    for(;;)
    8000615e:	a001                	j	8000615e <uartputc_sync+0x4c>

0000000080006160 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006160:	00005797          	auipc	a5,0x5
    80006164:	1107b783          	ld	a5,272(a5) # 8000b270 <uart_tx_r>
    80006168:	00005717          	auipc	a4,0x5
    8000616c:	11073703          	ld	a4,272(a4) # 8000b278 <uart_tx_w>
    80006170:	06f70f63          	beq	a4,a5,800061ee <uartstart+0x8e>
{
    80006174:	7139                	addi	sp,sp,-64
    80006176:	fc06                	sd	ra,56(sp)
    80006178:	f822                	sd	s0,48(sp)
    8000617a:	f426                	sd	s1,40(sp)
    8000617c:	f04a                	sd	s2,32(sp)
    8000617e:	ec4e                	sd	s3,24(sp)
    80006180:	e852                	sd	s4,16(sp)
    80006182:	e456                	sd	s5,8(sp)
    80006184:	e05a                	sd	s6,0(sp)
    80006186:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006188:	10000937          	lui	s2,0x10000
    8000618c:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000618e:	0001ea97          	auipc	s5,0x1e
    80006192:	72aa8a93          	addi	s5,s5,1834 # 800248b8 <uart_tx_lock>
    uart_tx_r += 1;
    80006196:	00005497          	auipc	s1,0x5
    8000619a:	0da48493          	addi	s1,s1,218 # 8000b270 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    8000619e:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800061a2:	00005997          	auipc	s3,0x5
    800061a6:	0d698993          	addi	s3,s3,214 # 8000b278 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800061aa:	00094703          	lbu	a4,0(s2)
    800061ae:	02077713          	andi	a4,a4,32
    800061b2:	c705                	beqz	a4,800061da <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800061b4:	01f7f713          	andi	a4,a5,31
    800061b8:	9756                	add	a4,a4,s5
    800061ba:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800061be:	0785                	addi	a5,a5,1
    800061c0:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800061c2:	8526                	mv	a0,s1
    800061c4:	ffffb097          	auipc	ra,0xffffb
    800061c8:	4fc080e7          	jalr	1276(ra) # 800016c0 <wakeup>
    WriteReg(THR, c);
    800061cc:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    800061d0:	609c                	ld	a5,0(s1)
    800061d2:	0009b703          	ld	a4,0(s3)
    800061d6:	fcf71ae3          	bne	a4,a5,800061aa <uartstart+0x4a>
  }
}
    800061da:	70e2                	ld	ra,56(sp)
    800061dc:	7442                	ld	s0,48(sp)
    800061de:	74a2                	ld	s1,40(sp)
    800061e0:	7902                	ld	s2,32(sp)
    800061e2:	69e2                	ld	s3,24(sp)
    800061e4:	6a42                	ld	s4,16(sp)
    800061e6:	6aa2                	ld	s5,8(sp)
    800061e8:	6b02                	ld	s6,0(sp)
    800061ea:	6121                	addi	sp,sp,64
    800061ec:	8082                	ret
    800061ee:	8082                	ret

00000000800061f0 <uartputc>:
{
    800061f0:	7179                	addi	sp,sp,-48
    800061f2:	f406                	sd	ra,40(sp)
    800061f4:	f022                	sd	s0,32(sp)
    800061f6:	ec26                	sd	s1,24(sp)
    800061f8:	e84a                	sd	s2,16(sp)
    800061fa:	e44e                	sd	s3,8(sp)
    800061fc:	e052                	sd	s4,0(sp)
    800061fe:	1800                	addi	s0,sp,48
    80006200:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006202:	0001e517          	auipc	a0,0x1e
    80006206:	6b650513          	addi	a0,a0,1718 # 800248b8 <uart_tx_lock>
    8000620a:	00000097          	auipc	ra,0x0
    8000620e:	1a2080e7          	jalr	418(ra) # 800063ac <acquire>
  if(panicked){
    80006212:	00005797          	auipc	a5,0x5
    80006216:	05a7a783          	lw	a5,90(a5) # 8000b26c <panicked>
    8000621a:	e7c9                	bnez	a5,800062a4 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000621c:	00005717          	auipc	a4,0x5
    80006220:	05c73703          	ld	a4,92(a4) # 8000b278 <uart_tx_w>
    80006224:	00005797          	auipc	a5,0x5
    80006228:	04c7b783          	ld	a5,76(a5) # 8000b270 <uart_tx_r>
    8000622c:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80006230:	0001e997          	auipc	s3,0x1e
    80006234:	68898993          	addi	s3,s3,1672 # 800248b8 <uart_tx_lock>
    80006238:	00005497          	auipc	s1,0x5
    8000623c:	03848493          	addi	s1,s1,56 # 8000b270 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006240:	00005917          	auipc	s2,0x5
    80006244:	03890913          	addi	s2,s2,56 # 8000b278 <uart_tx_w>
    80006248:	00e79f63          	bne	a5,a4,80006266 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000624c:	85ce                	mv	a1,s3
    8000624e:	8526                	mv	a0,s1
    80006250:	ffffb097          	auipc	ra,0xffffb
    80006254:	40c080e7          	jalr	1036(ra) # 8000165c <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006258:	00093703          	ld	a4,0(s2)
    8000625c:	609c                	ld	a5,0(s1)
    8000625e:	02078793          	addi	a5,a5,32
    80006262:	fee785e3          	beq	a5,a4,8000624c <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006266:	0001e497          	auipc	s1,0x1e
    8000626a:	65248493          	addi	s1,s1,1618 # 800248b8 <uart_tx_lock>
    8000626e:	01f77793          	andi	a5,a4,31
    80006272:	97a6                	add	a5,a5,s1
    80006274:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80006278:	0705                	addi	a4,a4,1
    8000627a:	00005797          	auipc	a5,0x5
    8000627e:	fee7bf23          	sd	a4,-2(a5) # 8000b278 <uart_tx_w>
  uartstart();
    80006282:	00000097          	auipc	ra,0x0
    80006286:	ede080e7          	jalr	-290(ra) # 80006160 <uartstart>
  release(&uart_tx_lock);
    8000628a:	8526                	mv	a0,s1
    8000628c:	00000097          	auipc	ra,0x0
    80006290:	1d4080e7          	jalr	468(ra) # 80006460 <release>
}
    80006294:	70a2                	ld	ra,40(sp)
    80006296:	7402                	ld	s0,32(sp)
    80006298:	64e2                	ld	s1,24(sp)
    8000629a:	6942                	ld	s2,16(sp)
    8000629c:	69a2                	ld	s3,8(sp)
    8000629e:	6a02                	ld	s4,0(sp)
    800062a0:	6145                	addi	sp,sp,48
    800062a2:	8082                	ret
    for(;;)
    800062a4:	a001                	j	800062a4 <uartputc+0xb4>

00000000800062a6 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800062a6:	1141                	addi	sp,sp,-16
    800062a8:	e422                	sd	s0,8(sp)
    800062aa:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800062ac:	100007b7          	lui	a5,0x10000
    800062b0:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800062b2:	0007c783          	lbu	a5,0(a5)
    800062b6:	8b85                	andi	a5,a5,1
    800062b8:	cb81                	beqz	a5,800062c8 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    800062ba:	100007b7          	lui	a5,0x10000
    800062be:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800062c2:	6422                	ld	s0,8(sp)
    800062c4:	0141                	addi	sp,sp,16
    800062c6:	8082                	ret
    return -1;
    800062c8:	557d                	li	a0,-1
    800062ca:	bfe5                	j	800062c2 <uartgetc+0x1c>

00000000800062cc <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800062cc:	1101                	addi	sp,sp,-32
    800062ce:	ec06                	sd	ra,24(sp)
    800062d0:	e822                	sd	s0,16(sp)
    800062d2:	e426                	sd	s1,8(sp)
    800062d4:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800062d6:	54fd                	li	s1,-1
    800062d8:	a029                	j	800062e2 <uartintr+0x16>
      break;
    consoleintr(c);
    800062da:	00000097          	auipc	ra,0x0
    800062de:	8ce080e7          	jalr	-1842(ra) # 80005ba8 <consoleintr>
    int c = uartgetc();
    800062e2:	00000097          	auipc	ra,0x0
    800062e6:	fc4080e7          	jalr	-60(ra) # 800062a6 <uartgetc>
    if(c == -1)
    800062ea:	fe9518e3          	bne	a0,s1,800062da <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800062ee:	0001e497          	auipc	s1,0x1e
    800062f2:	5ca48493          	addi	s1,s1,1482 # 800248b8 <uart_tx_lock>
    800062f6:	8526                	mv	a0,s1
    800062f8:	00000097          	auipc	ra,0x0
    800062fc:	0b4080e7          	jalr	180(ra) # 800063ac <acquire>
  uartstart();
    80006300:	00000097          	auipc	ra,0x0
    80006304:	e60080e7          	jalr	-416(ra) # 80006160 <uartstart>
  release(&uart_tx_lock);
    80006308:	8526                	mv	a0,s1
    8000630a:	00000097          	auipc	ra,0x0
    8000630e:	156080e7          	jalr	342(ra) # 80006460 <release>
}
    80006312:	60e2                	ld	ra,24(sp)
    80006314:	6442                	ld	s0,16(sp)
    80006316:	64a2                	ld	s1,8(sp)
    80006318:	6105                	addi	sp,sp,32
    8000631a:	8082                	ret

000000008000631c <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000631c:	1141                	addi	sp,sp,-16
    8000631e:	e422                	sd	s0,8(sp)
    80006320:	0800                	addi	s0,sp,16
  lk->name = name;
    80006322:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006324:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006328:	00053823          	sd	zero,16(a0)
}
    8000632c:	6422                	ld	s0,8(sp)
    8000632e:	0141                	addi	sp,sp,16
    80006330:	8082                	ret

0000000080006332 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006332:	411c                	lw	a5,0(a0)
    80006334:	e399                	bnez	a5,8000633a <holding+0x8>
    80006336:	4501                	li	a0,0
  return r;
}
    80006338:	8082                	ret
{
    8000633a:	1101                	addi	sp,sp,-32
    8000633c:	ec06                	sd	ra,24(sp)
    8000633e:	e822                	sd	s0,16(sp)
    80006340:	e426                	sd	s1,8(sp)
    80006342:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006344:	6904                	ld	s1,16(a0)
    80006346:	ffffb097          	auipc	ra,0xffffb
    8000634a:	ba0080e7          	jalr	-1120(ra) # 80000ee6 <mycpu>
    8000634e:	40a48533          	sub	a0,s1,a0
    80006352:	00153513          	seqz	a0,a0
}
    80006356:	60e2                	ld	ra,24(sp)
    80006358:	6442                	ld	s0,16(sp)
    8000635a:	64a2                	ld	s1,8(sp)
    8000635c:	6105                	addi	sp,sp,32
    8000635e:	8082                	ret

0000000080006360 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006360:	1101                	addi	sp,sp,-32
    80006362:	ec06                	sd	ra,24(sp)
    80006364:	e822                	sd	s0,16(sp)
    80006366:	e426                	sd	s1,8(sp)
    80006368:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000636a:	100024f3          	csrr	s1,sstatus
    8000636e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006372:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006374:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006378:	ffffb097          	auipc	ra,0xffffb
    8000637c:	b6e080e7          	jalr	-1170(ra) # 80000ee6 <mycpu>
    80006380:	5d3c                	lw	a5,120(a0)
    80006382:	cf89                	beqz	a5,8000639c <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006384:	ffffb097          	auipc	ra,0xffffb
    80006388:	b62080e7          	jalr	-1182(ra) # 80000ee6 <mycpu>
    8000638c:	5d3c                	lw	a5,120(a0)
    8000638e:	2785                	addiw	a5,a5,1
    80006390:	dd3c                	sw	a5,120(a0)
}
    80006392:	60e2                	ld	ra,24(sp)
    80006394:	6442                	ld	s0,16(sp)
    80006396:	64a2                	ld	s1,8(sp)
    80006398:	6105                	addi	sp,sp,32
    8000639a:	8082                	ret
    mycpu()->intena = old;
    8000639c:	ffffb097          	auipc	ra,0xffffb
    800063a0:	b4a080e7          	jalr	-1206(ra) # 80000ee6 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800063a4:	8085                	srli	s1,s1,0x1
    800063a6:	8885                	andi	s1,s1,1
    800063a8:	dd64                	sw	s1,124(a0)
    800063aa:	bfe9                	j	80006384 <push_off+0x24>

00000000800063ac <acquire>:
{
    800063ac:	1101                	addi	sp,sp,-32
    800063ae:	ec06                	sd	ra,24(sp)
    800063b0:	e822                	sd	s0,16(sp)
    800063b2:	e426                	sd	s1,8(sp)
    800063b4:	1000                	addi	s0,sp,32
    800063b6:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800063b8:	00000097          	auipc	ra,0x0
    800063bc:	fa8080e7          	jalr	-88(ra) # 80006360 <push_off>
  if(holding(lk))
    800063c0:	8526                	mv	a0,s1
    800063c2:	00000097          	auipc	ra,0x0
    800063c6:	f70080e7          	jalr	-144(ra) # 80006332 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800063ca:	4705                	li	a4,1
  if(holding(lk))
    800063cc:	e115                	bnez	a0,800063f0 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800063ce:	87ba                	mv	a5,a4
    800063d0:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800063d4:	2781                	sext.w	a5,a5
    800063d6:	ffe5                	bnez	a5,800063ce <acquire+0x22>
  __sync_synchronize();
    800063d8:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    800063dc:	ffffb097          	auipc	ra,0xffffb
    800063e0:	b0a080e7          	jalr	-1270(ra) # 80000ee6 <mycpu>
    800063e4:	e888                	sd	a0,16(s1)
}
    800063e6:	60e2                	ld	ra,24(sp)
    800063e8:	6442                	ld	s0,16(sp)
    800063ea:	64a2                	ld	s1,8(sp)
    800063ec:	6105                	addi	sp,sp,32
    800063ee:	8082                	ret
    panic("acquire");
    800063f0:	00002517          	auipc	a0,0x2
    800063f4:	35050513          	addi	a0,a0,848 # 80008740 <etext+0x740>
    800063f8:	00000097          	auipc	ra,0x0
    800063fc:	a3a080e7          	jalr	-1478(ra) # 80005e32 <panic>

0000000080006400 <pop_off>:

void
pop_off(void)
{
    80006400:	1141                	addi	sp,sp,-16
    80006402:	e406                	sd	ra,8(sp)
    80006404:	e022                	sd	s0,0(sp)
    80006406:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006408:	ffffb097          	auipc	ra,0xffffb
    8000640c:	ade080e7          	jalr	-1314(ra) # 80000ee6 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006410:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006414:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006416:	e78d                	bnez	a5,80006440 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006418:	5d3c                	lw	a5,120(a0)
    8000641a:	02f05b63          	blez	a5,80006450 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000641e:	37fd                	addiw	a5,a5,-1
    80006420:	0007871b          	sext.w	a4,a5
    80006424:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006426:	eb09                	bnez	a4,80006438 <pop_off+0x38>
    80006428:	5d7c                	lw	a5,124(a0)
    8000642a:	c799                	beqz	a5,80006438 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000642c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006430:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006434:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006438:	60a2                	ld	ra,8(sp)
    8000643a:	6402                	ld	s0,0(sp)
    8000643c:	0141                	addi	sp,sp,16
    8000643e:	8082                	ret
    panic("pop_off - interruptible");
    80006440:	00002517          	auipc	a0,0x2
    80006444:	30850513          	addi	a0,a0,776 # 80008748 <etext+0x748>
    80006448:	00000097          	auipc	ra,0x0
    8000644c:	9ea080e7          	jalr	-1558(ra) # 80005e32 <panic>
    panic("pop_off");
    80006450:	00002517          	auipc	a0,0x2
    80006454:	31050513          	addi	a0,a0,784 # 80008760 <etext+0x760>
    80006458:	00000097          	auipc	ra,0x0
    8000645c:	9da080e7          	jalr	-1574(ra) # 80005e32 <panic>

0000000080006460 <release>:
{
    80006460:	1101                	addi	sp,sp,-32
    80006462:	ec06                	sd	ra,24(sp)
    80006464:	e822                	sd	s0,16(sp)
    80006466:	e426                	sd	s1,8(sp)
    80006468:	1000                	addi	s0,sp,32
    8000646a:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000646c:	00000097          	auipc	ra,0x0
    80006470:	ec6080e7          	jalr	-314(ra) # 80006332 <holding>
    80006474:	c115                	beqz	a0,80006498 <release+0x38>
  lk->cpu = 0;
    80006476:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000647a:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    8000647e:	0310000f          	fence	rw,w
    80006482:	0004a023          	sw	zero,0(s1)
  pop_off();
    80006486:	00000097          	auipc	ra,0x0
    8000648a:	f7a080e7          	jalr	-134(ra) # 80006400 <pop_off>
}
    8000648e:	60e2                	ld	ra,24(sp)
    80006490:	6442                	ld	s0,16(sp)
    80006492:	64a2                	ld	s1,8(sp)
    80006494:	6105                	addi	sp,sp,32
    80006496:	8082                	ret
    panic("release");
    80006498:	00002517          	auipc	a0,0x2
    8000649c:	2d050513          	addi	a0,a0,720 # 80008768 <etext+0x768>
    800064a0:	00000097          	auipc	ra,0x0
    800064a4:	992080e7          	jalr	-1646(ra) # 80005e32 <panic>
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
