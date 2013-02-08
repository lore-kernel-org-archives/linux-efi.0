From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
Date: Fri, 8 Feb 2013 13:02:15 -0800
Message-ID: <CAGXu5jKo2PfMBO4A0ZgQcrPuj8OHNaff+CjAesOAWkZc0vB9+Q@mail.gmail.com>
References: <20130208191213.GA25081@www.outflux.net>
	<00780235-deac-4f80-b936-867834e05661@email.android.com>
	<CAGXu5jJnLY6Qp3J6HBpVg-AdUGdKYm-e4wErZO3=NuRo04ajvg@mail.gmail.com>
	<5115553A.5000708@zytor.com>
	<CAGXu5j+_mGzR+72YqORhErMUY1aF1H2urczZ8SwuJHZK-oZL6g@mail.gmail.com>
	<dee64752-850c-4d78-b703-f47a985bc13e@email.android.com>
	<CAGXu5jLAufTRm=sDST0br_WEkn4o0Hpjv2jDP2Na=cCvuM+MGg@mail.gmail.com>
	<1360355671.18083.18.camel@x230.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1360355671.18083.18.camel@x230.lan>
Sender: linux-security-module-owner@vger.kernel.org
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Feb 8, 2013 at 12:34 PM, Matthew Garrett
<matthew.garrett@nebula.com> wrote:
> On Fri, 2013-02-08 at 12:28 -0800, Kees Cook wrote:
>
>> Maybe a capability isn't the right way to go, I'm not sure. I'll lea=
ve
>> that to Matthew. Whatever the flag, it should be an immutable state =
of
>> the boot. Though, it probably makes sense as a cap just so that
>> non-secure-boot systems can still remove it from containers, etc.
>
> There was interest in ensuring that this wasn't something special-cas=
ed
> to UEFI Secure Boot, so using a capability seemed like the most
> straightforward way - it's fundamentally a restriction on what an
> otherwise privileged user is able to do, so it seemed like it fit the
> model. But I'm not wed to it in the slightest, and in fact it causes
> problems for some userspace (anything that drops all capabilities
> suddenly finds itself unable to do something that it expects to be ab=
le
> to do), so if anyone has any suggestions for a better approach=85

I don't find it unreasonable to drop all caps and lose access to
sensitive things. :) That's sort of the point, really. I think a cap
is the best match. It seems like it should either be a cap or a
namespace flag, but the latter seems messy.

-Kees

--
Kees Cook
Chrome OS Security
--
To unsubscribe from this list: send the line "unsubscribe linux-securit=
y-module" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
