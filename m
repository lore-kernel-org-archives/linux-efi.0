From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 2/6] arm/efi: Allow invocation of arbitrary runtime services [ver #2]
Date: Wed, 23 Nov 2016 11:51:09 +0000
Message-ID: <6258.1479901869@warthog.procyon.org.uk>
References: <CAKv+Gu92VwUo=1Fh39r1WxNWo-mQRLx8sDby+rGcero8oyi-WA@mail.gmail.com> <147986054870.13790.8640536414645705863.stgit@warthog.procyon.org.uk> <147986056324.13790.12670822944798392730.stgit@warthog.procyon.org.uk> <5320.1479893643@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu92VwUo=1Fh39r1WxNWo-mQRLx8sDby+rGcero8oyi-WA@mail.gmail.com>
Content-ID: <6257.1479901869.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: dhowells@redhat.com, Lukas Wunner <lukas@wunner.de>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, keyrings@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> > What I've changed the ARM and ARM64 things to is:
> >
> >         #define efi_call_runtime(f, ...)        ((efi_##f##_t *)sys_table_arg->runtime->f)(__VA_ARGS__)
> >
> 
> Could we please instead fix the definition of efi_runtime_services_t,
> given that we have typedefs already for all its members?

Okay, I've pulled in your patch and removed the cast.

I would like to provide wrapper static inlines for things like
efi_get_variable() to get the parameter checking, but the sys_table_arg
behind-the-scenes parameter is tricky to deal with in that case.

David
