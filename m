From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 5/8] efi: Get the secure boot status [ver #6]
Date: Mon, 23 Jan 2017 22:11:43 +0000
Message-ID: <6306.1485209503@warthog.procyon.org.uk>
References: <20170123212642.GA2766@codeblueprint.co.uk> <20170116144954.GB27351@codeblueprint.co.uk> <20170111143304.GA29649@codeblueprint.co.uk> <148120020832.5854.5448601415491330495.stgit@warthog.procyon.org.uk> <148120024570.5854.10638278395097394138.stgit@warthog.procyon.org.uk> <7948.1484148443@warthog.procyon.org.uk> <794.1484581158@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170123212642.GA2766@codeblueprint.co.uk>
Content-ID: <6305.1485209502.1@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: dhowells@redhat.com, ard.biesheuvel@linaro.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-arm-kernel@lists.infradead.org, "H. Peter Anvin" <hpa@zytor.com>, Peter Jones <pjones@redhat.com>
List-Id: linux-efi@vger.kernel.org

Matt Fleming <matt@codeblueprint.co.uk> wrote:

> >  (4) extract_kernel() calls sanitize_boot_params() which would otherwise clear
> >      the secure-boot flag.
>  
> The ->sentinel flag should be clear (because you zero'd boot_params on
> alloc), so the code inside of sanitize_boot_params() should never
> trigger for the secure boot case.

But it *does* trigger, otherwise I wouldn't've noticed this.

David
