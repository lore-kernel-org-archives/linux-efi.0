From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v3 4/4] KVM: VMX: Simplify segment_base
Date: Mon, 20 Feb 2017 08:56:35 -0800
Message-ID: <CALCETrV4JqVfHQhz4EuFKfHXK=zABsmwZpgz4ijz89O8v4GdfA@mail.gmail.com>
References: <20170214194259.75960-1-thgarnie@google.com> <20170214194259.75960-4-thgarnie@google.com>
 <CALMp9eT_G_Mhsk1k7Xc8L+bnpFwTUoC=ae4LhB1ppqKynKEQ9g@mail.gmail.com>
 <CAJcbSZESdSQncHeKNVzHO90W7UJUKxKGy-h+rM82OhBc-Nh=cg@mail.gmail.com>
 <CALMp9eQAZchjpgmqP1=qj-FXka8+Xbwqiu3xDz9KoLQ60nh-UQ@mail.gmail.com> <CAJcbSZEkqFPVNzygmAjkyxNssZxnJTYBYuMbvjms+3ZGcCY_sQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <kernel-hardening-return-6783-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <CAJcbSZEkqFPVNzygmAjkyxNssZxnJTYBYuMbvjms+3ZGcCY_sQ@mail.gmail.com>
To: Thomas Garnier <thgarnie@google.com>
Cc: Jim Mattson <jmattson@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Paul Gortmaker <paul.gortmaker@windriver.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Jiri Kosina <jikos@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Rusty Russell <rusty@rustcorp.com.au>, Peter Zijlstra <peterz@infradead.org>, Christian Borntraeger <borntraeger@de.ibm.com>, "Luis R . Rodriguez" <mcgrof@kernel.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Feb 17, 2017 at 2:01 PM, Thomas Garnier <thgarnie@google.com> wrote=
:
> On Fri, Feb 17, 2017 at 1:00 PM, Jim Mattson <jmattson@google.com> wrote:
>> On Fri, Feb 17, 2017 at 12:11 PM, Thomas Garnier <thgarnie@google.com> w=
rote:
>>> On Fri, Feb 17, 2017 at 9:49 AM, Jim Mattson <jmattson@google.com> wrot=
e:
>>>>
>>>> Can we use the read-only GDT here? When expanding the virtual address
>>>> for 64-bit system descriptors, isn't it sufficient to check (d->s =3D=
=3D 0
>>>> && d->type !=3D 0)?
>>>
>>> We can use the readonly GDT but I think doesn't matter one or the
>>> other here. We have to check specific types for LDT or TSS, other
>>> values describe other entries (cf Intel volume 3, 3.5) (for example 14
>>> & 15 on 64-bits are for trap & interrupt gates).
>>
>> According to volume 3 of the SDM, section 3.5.2:
>>
>> The following system descriptors expand to 16 bytes:
>> =E2=80=94 Call gate descriptors (see Section 5.8.3.1, =E2=80=9CIA-32e Mo=
de Call Gates=E2=80=9D)
>> =E2=80=94 IDT gate descriptors (see Section 6.14.1, =E2=80=9C64-Bit Mode=
 IDT=E2=80=9D)
>> =E2=80=94 LDT and TSS descriptors (see Section 7.2.3, =E2=80=9CTSS Descr=
iptor in 64-bit mode=E2=80=9D).
>>
>> All legal system descriptor types (except for 0: Upper 8 bytes of an 16-=
byte
>> descriptor) should get the high 32 bits of the base address from the nex=
t 8-byte
>> descriptor.
>>
>
> Ok, then I will test an updated version next week.
>

I'm going to send out some preliminary patches that just get rid of
this problem entirely.
