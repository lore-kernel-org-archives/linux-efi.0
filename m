From: Mimi Zohar <zohar@linux.ibm.com>
Subject: Re: [PATCH v3 1/2] ima: fix build error redeclaration of enumerator
Date: Thu, 14 Feb 2019 21:45:34 -0500
Message-ID: <1550198734.4107.53.camel@linux.ibm.com>
References: <20190213221625.7551-1-anders.roxell@linaro.org>
         <1550165329.3980.8.camel@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1550165329.3980.8.camel@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Anders Roxell <anders.roxell@linaro.org>, dmitry.kasatkin@gmail.com, jmorris@namei.org, serge@hallyn.com, ard.biesheuvel@linaro.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de
Cc: linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, platform-driver-x86@vger.kernel.org, Andy Shevchenko <andy.shevchenko@gmail.com>
List-Id: linux-efi@vger.kernel.org

On Thu, 2019-02-14 at 12:28 -0500, Mimi Zohar wrote:
> On Wed, 2019-02-13 at 23:16 +0100, Anders Roxell wrote:
> > Commit a893ea15d764 ("tpm: move tpm_chip definition to
> > include/linux/tpm.h") introduced a build error when both ima and efi is
> > enabled. What happens is that both headers (ima.h and efi.h) defines the
> > same 'NONE' constant, and it broke when they started getting included
> > from the same file.
> > 
> > In file included from ../security/integrity/ima/ima_fs.c:30:
> > ../security/integrity/ima/ima.h:176:7: error: redeclaration of enumerator "NONE"
> >   hook(NONE)   \
> >        ^~~~
> > ../security/integrity/ima/ima.h:188:34: note: in definition of macro "__ima_hook_enumify"
> >  #define __ima_hook_enumify(ENUM) ENUM,
> >                                   ^~~~
> > ../security/integrity/ima/ima.h:191:2: note: in expansion of macro "__ima_hooks"
> >   __ima_hooks(__ima_hook_enumify)
> >   ^~~~~~~~~~~
> > In file included from ../arch/arm64/include/asm/acpi.h:15,
> >                  from ../include/acpi/acpi_io.h:7,
> >                  from ../include/linux/acpi.h:47,
> >                  from ../include/linux/tpm.h:26,
> >                  from ../security/integrity/ima/ima.h:25,
> >                  from ../security/integrity/ima/ima_fs.c:30:
> > ../include/linux/efi.h:1723:2: note: previous definition of "NONE" was here
> >   NONE,
> >   ^~~~
> > make[4]: *** [../scripts/Makefile.build:277: security/integrity/ima/ima_fs.o] Error 1
> > 
> > Rework to prefix the ima enum with 'IMA_*'.
> > 
> > Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> > Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
> 
> Ok, this looks reasonable, but will have a minor clash with Gustavo's
> "security: mark expected switch fall-throughs and add a missing
> break".

This patch correctly didn't modify the IMA policy keywords, just the
enumeration, but now the <securityfs> policy file incorrectly displays
the "ima_" prefixed names.

Instead of maintaining an enumeration and the corresponding
stringified version of the enumeration, there is a single list with
two macros.  One of these macros needs to be modified.  Instead of
modifying the the hook names directly, I would probably modify the
enumeration macro.

#define __ima_hook_enumify(ENUM)        ENUM,

enum ima_hooks {
        __ima_hooks(__ima_hook_enumify)
};

and

#define __ima_hook_stringify(str)       (#str),

static const char *const func_tokens[] = {
        __ima_hooks(__ima_hook_stringify)
};

Mimi
