From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH v2 2/2] x86/xen/efi: Init only efi struct members used by
 Xen
Date: Thu, 22 Jun 2017 15:25:28 -0400
Message-ID: <54b02bd1-b3a7-9154-f007-32bf4c27f553@oracle.com>
References: <1498128697-12943-1-git-send-email-daniel.kiper@oracle.com>
 <1498128697-12943-3-git-send-email-daniel.kiper@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1498128697-12943-3-git-send-email-daniel.kiper@oracle.com>
Sender: stable-owner@vger.kernel.org
To: Daniel Kiper <daniel.kiper@oracle.com>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, stable@vger.kernel.org, xen-devel@lists.xenproject.org
Cc: jgross@suse.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, matt@codeblueprint.co.uk, ard.biesheuvel@linaro.org, andrew.cooper3@citrix.com
List-Id: linux-efi@vger.kernel.org

On 06/22/2017 06:51 AM, Daniel Kiper wrote:
> Current approach, wholesale efi struct initialization from efi_xen, is not
> good. Usually if new member is defined then it is properly initialized in
> drivers/firmware/efi/efi.c but not in arch/x86/xen/efi.c. As I saw it happened
> a few times until now. So, let's initialize only efi struct members used by
> Xen to avoid such issues in the future.
>
> Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
> Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
