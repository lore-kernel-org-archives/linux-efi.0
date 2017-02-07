From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 3/7] efi: Add SHIM and image security database GUID
 definitions
Date: Tue, 7 Feb 2017 08:52:20 +0100
Message-ID: <20170207075219.GB24528@gmail.com>
References: <1486380166-31868-1-git-send-email-ard.biesheuvel@linaro.org>
 <1486380166-31868-4-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1486380166-31868-4-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: matt@codeblueprint.co.uk, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Josh Boyer <jwboyer@fedoraproject.org>
List-Id: linux-efi@vger.kernel.org


* Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> From: David Howells <dhowells@redhat.com>
> 
> Add the definitions for shim and image security database, both of which
> are used widely in various Linux distros.
> 
> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Cc: Matt Fleming <matt@codeblueprint.co.uk>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

That's not a valid SOB chain: the SOB of the author of the patch (David Howells) 
must come first.

I changed it to:

  Signed-off-by: David Howells <dhowells@redhat.com>
  Acked-by: Josh Boyer <jwboyer@fedoraproject.org>
  Cc: Matt Fleming <matt@codeblueprint.co.uk>
  Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Please holler if that's not OK.

Thanks,

	Ingo
