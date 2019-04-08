From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v8 2/5] arm64: replace -pg with CC_FLAGS_FTRACE in efi Makefiles
Date: Mon, 8 Apr 2019 22:49:13 +0200
Message-ID: <CAKv+Gu-DWL=gxw0gcjByrVOZsFSV1htoev5iiT++k=D3rf4WdA@mail.gmail.com>
References: <20190208150826.44EBC68DD2@newverein.lst.de> <20190208151011.0807668DD3@newverein.lst.de>
 <20190408152309.GJ6139@lakrids.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190408152309.GJ6139@lakrids.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: Torsten Duwe <duwe@lst.de>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Julien Thierry <julien.thierry@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Ingo Molnar <mingo@redhat.com>, Arnd Bergmann <arnd@arndb.de>, AKASHI Takahiro <takahiro.akashi@linaro.org>, Amit Daniel Kachhap <amit.kachhap@arm.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, live-patching@vger.kernel.org, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 8 Apr 2019 at 17:23, Mark Rutland <mark.rutland@arm.com> wrote:
>
> On Fri, Feb 08, 2019 at 04:10:11PM +0100, Torsten Duwe wrote:
> >   In preparation for arm64 supporting ftrace built on other compiler
> >   options, let's have makefiles remove the $(CC_FLAGS_FTRACE)
> >   flags, whatever these may be, rather than assuming '-pg'.
> >   While at it, fix arm32 as well.
> >
> >   There should be no functional change as a result of this patch.
> >
> > Signed-off-by: Torsten Duwe <duwe@suse.de>
>
> Ard, would you be happy if we were to take this via the arm64 tree?
>
> Assuming so, can we have your ack?
>

Sure

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
