From: Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 02/10] efi: Constify GetVariable() / SetVariable()
 signatures
Date: Tue, 3 Jan 2017 06:17:13 +0100
Message-ID: <6e0b78da-2e46-f437-a7a4-488d3ff330b2@suse.com>
References: <cover.1483318593.git.lukas@wunner.de>
 <bd030e11cd114fb1d568b21eddfc1fa75cd42e5e.1483318593.git.lukas@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <bd030e11cd114fb1d568b21eddfc1fa75cd42e5e.1483318593.git.lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 02/01/17 11:24, Lukas Wunner wrote:
> GetVariable() / SetVariable() is typically called with immutable
> VendorGuid and VariableName arguments.  SetVariable() is also often
> called with an immutable Data argument.  However declaring these const
> in the caller results in a compiler warning since they're not marked
> const in the function signatures.  Rectify that, in keeping with the EFI
> spec which marks these arguments "IN".
> 
> Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Cc: David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
> Cc: Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>
> Signed-off-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>

Xen parts:

Acked-by: Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>


Juergen
