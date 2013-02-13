From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
Date: Wed, 13 Feb 2013 09:51:13 -0800
Message-ID: <511BD291.1040003@schaufler-ca.com>
References: <dee64752-850c-4d78-b703-f47a985bc13e@email.android.com>      <CAGXu5jLAufTRm=sDST0br_WEkn4o0Hpjv2jDP2Na=cCvuM+MGg@mail.gmail.com>      <1360355671.18083.18.camel@x230.lan>      <CAGXu5jKo2PfMBO4A0ZgQcrPuj8OHNaff+CjAesOAWkZc0vB9+Q@mail.gmail.com>      <51157C9C.6030501@zytor.com> <20130208230655.GB28990@pd.tnic>      <1360366012.18083.21.camel@x230.lan> <5115A4CC.3080102@zytor.com>      <1360373383.18083.23.camel@x230.lan>      <CAGXu5j+xvJ3L5ejxtZ-Jw3F6rV7OsrE0_HZCGu_er0rH2_PwKA@mail.gmail.com>      <20130209092925.GA17728@pd.tnic> <1360422712.18083.24.camel@x230.lan>     <511AE2CC.5040705@zytor.com> <1360733962.18083.30.camel@x230.lan>    <511B2EB9.5070406@zytor.com> <1360736860.18083.33.camel@x230.lan>   <511B33BC.9080307@zytor.com> <1360737709.18083.36.camel@x230.lan>  <511
 BCB6E.8080102@zytor.com> <1360776399.18083.39.camel@x230.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1360776399.18083.39.camel@x230.lan>
Sender: linux-security-module-owner@vger.kernel.org
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 2/13/2013 9:26 AM, Matthew Garrett wrote:
> On Wed, 2013-02-13 at 09:20 -0800, H. Peter Anvin wrote:
>
>> Problem:
>>
>> Someone adds SYS_CAP_RAWIO to some places it definitely does not
>> belong.
>>
>> Solution:
>>
>> Break all the *appropriate* (as defined)uses of SYS_CAP_RAWIO?
> Problem:
>
> CAP_SYS_RAWIO has been used in a bunch of arguably inappropriate plac=
es.
> Removing CAP_SYS_RAWIO from the set of possible capabilities on a sys=
tem
> will prevent userspace from doing things that userspace should be
> permitted to do. Removing CAP_SYS_RAWIO from the places that it
> currently exists will allow userspace to do too much. Replacing
> CAP_SYS_RAWIO with CAP_SYS_ADMIN will prevent userspace from doing
> things that it can currently do.
>
> Solution:
>
> Admit that CAP_SYS_RAWIO is fucked up beyond rescue. Add a new
> capability with well-defined semantics.

You can't add a new capability where there is an existing capability
that can be remotely argued to be appropriate.

If you tried to "fix" CAP_SYS_RAWIO and/or CAP_SYS_ADMIN you'd end
up with hundreds of capabilities.

Your particular problem is *not* so important that you get a
capability all to yourself.


> N=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDr=EF=BF=BD=EF=BF=BDy=EF=
=BF=BD=EF=BF=BD=EF=BF=BDb=EF=BF=BDX=EF=BF=BD=EF=BF=BD=C7=A7v=EF=BF=BD^=EF=
=BF=BD)=DE=BA{.n=EF=BF=BD+=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD{=EF=BF=BD=
=EF=BF=BD=EF=BF=BD.=EF=BF=BD+r=EF=BF=BD=EF=BF=BDn=EF=BF=BD=E8=A7=B6=17=EF=
=BF=BD=EF=BF=BD=DC=A8}=EF=BF=BD=EF=BF=BD=EF=BF=BD=C6=A0z=EF=BF=BD&j:+v=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=07=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDzZ+=EF=BF=
=BD=EF=BF=BD+zf=EF=BF=BD=EF=BF=BD=EF=BF=BDh=EF=BF=BD=EF=BF=BD=EF=BF=BD~=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDi=EF=BF=BD=EF=BF=BD=EF=BF=BDz=EF=BF=
=BD=1E=EF=BF=BDw=EF=BF=BD=EF=BF=BD=EF=BF=BD?=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD&=EF=BF=BD)=DF=A2=1Bfl=3D=3D=3D

--
To unsubscribe from this list: send the line "unsubscribe linux-securit=
y-module" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
