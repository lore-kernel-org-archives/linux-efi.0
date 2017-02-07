From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 3/7] efi: Add SHIM and image security database GUID definitions
Date: Tue, 07 Feb 2017 09:23:10 +0000
Message-ID: <27407.1486459390@warthog.procyon.org.uk>
References: <20170207075219.GB24528@gmail.com> <1486380166-31868-1-git-send-email-ard.biesheuvel@linaro.org> <1486380166-31868-4-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170207075219.GB24528@gmail.com>
Content-ID: <27406.1486459390.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: dhowells@redhat.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, matt@codeblueprint.co.uk, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Josh Boyer <jwboyer@fedoraproject.org>
List-Id: linux-efi@vger.kernel.org

Ingo Molnar <mingo@kernel.org> wrote:

> That's not a valid SOB chain: the SOB of the author of the patch (David Howells) 
> must come first.
> 
> I changed it to:
> 
>   Signed-off-by: David Howells <dhowells@redhat.com>
>   Acked-by: Josh Boyer <jwboyer@fedoraproject.org>
>   Cc: Matt Fleming <matt@codeblueprint.co.uk>
>   Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> 
> Please holler if that's not OK.

Actually, it should be authored by Josh Boyer.  Somehow the authorship got
lost.

David
