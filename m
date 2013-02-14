From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
Date: Wed, 13 Feb 2013 16:44:57 -0800
Message-ID: <511C3389.5090604@schaufler-ca.com>
References: <dee64752-850c-4d78-b703-f47a985bc13e@email.android.com>      <CAGXu5jLAufTRm=sDST0br_WEkn4o0Hpjv2jDP2Na=cCvuM+MGg@mail.gmail.com>      <1360355671.18083.18.camel@x230.lan>      <CAGXu5jKo2PfMBO4A0ZgQcrPuj8OHNaff+CjAesOAWkZc0vB9+Q@mail.gmail.com>      <51157C9C.6030501@zytor.com> <20130208230655.GB28990@pd.tnic>      <1360366012.18083.21.camel@x230.lan> <5115A4CC.3080102@zytor.com>      <1360373383.18083.23.camel@x230.lan>      <CAGXu5j+xvJ3L5ejxtZ-Jw3F6rV7OsrE0_HZCGu_er0rH2_PwKA@mail.gmail.com>      <20130209092925.GA17728@pd.tnic> <1360422712.18083.24.camel@x230.lan>     <511AE2CC.5040705@zytor.com> <1360733962.18083.30.camel@x230.lan>    <511B2EB9.5070406@zytor.com> <1360736860.18083.33.camel@x230.lan>   <511B33BC.9080307@zytor.com> <1360737709.18083.36.camel@x230.lan>  <511
 BCB6E.8080102@zytor.com> <1360776399.18083.39.camel@x230.lan> <511BD291.1040003@schaufler-ca.com> <511C1325.5060601@zytor.com> <511C1A94.8020804@schaufler-ca.com> <511C2F0C.3060803@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <511C2F0C.3060803@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, Borislav Petkov <bp@alien8.de>, Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Casey Schaufler <casey@schaufler-ca.com>
List-Id: linux-efi@vger.kernel.org

On 2/13/2013 4:25 PM, H. Peter Anvin wrote:
> On 02/13/2013 02:58 PM, Casey Schaufler wrote:
>>> This is exactly the kind of thinking which has led to the capability
>>> system being so bloody useless.
>> The reason the capability system is "bloody useless" is
>> that no one wants to update the core system applications to
>> use it in favor of good old fashioned worked for dad and
>> works for me too superuser.
>>
> Because, in large part because a bunch of the capabilities are so close
> to equivalent to "superuser" that the distinction is meaningless... so
> why go through the hassle?  (This is especially so since it was a *long*
> time before the filesystem had any notion of capabilities, and so you
> had to make your app run as root anyway before you could drop the
> capabilities... and some of the people who tried failed spectacularly
> and opened up new security holes.)

Yes. I know. I was one of the people who wrote the P1003.1e/2c spec.
I implemented a rootless Unix system. The infamous sendmail capability
blowup was not my code, but it was my fault. In the Linux world we have
had a terrible problem with no one implementing the next step because
no one is eager to have the next bit because you can't do everything
without that next step.

>> I understand that you want capabilities to be associated with
>> resources. That is *not* what we have, and arguing that its
>> what we should have is pointless because Linux does not even
>> have a concept of resources.
>>
> OK, fine, call it "activities".  This is still distinct from "usage
> models", and that's where we're just broken.
>
> I may look into seeing if there is any sane way we can use the existing
> API to define hierarchical capabilities, which at least should let us
> split existing capabilities just like we used capabilities to split root.

If you want that sort of granularity throw yourself on the SELinux
bandwagon. Fine grained capabilities are insane and unmanageable
and will only lead to tears. Security is despised because of the
notion that making systems impossible to use is a good thing.

>
> 	-hpa
>
>
