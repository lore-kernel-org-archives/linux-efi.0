From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH 5/7] efi: Get the secure boot status [ver #3]
Date: Thu, 24 Nov 2016 11:41:27 -0800
Message-ID: <1480016487.2444.18.camel@HansenPartnership.com>
References: <147990561294.7576.6464430479448167484.stgit@warthog.procyon.org.uk>
         <147990565051.7576.9673287945782426886.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <147990565051.7576.9673287945782426886.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 2016-11-23 at 12:54 +0000, David Howells wrote:
> Get the firmware's secure-boot status in the kernel boot wrapper and 
> stash it somewhere that the main kernel image can find.
> 
> The efi_get_secureboot() function is extracted from the arm stub and 
> (a) generalised so that it can be called from x86 and (b) made to use
> efi_call_runtime() so that it can be run in mixed-mode.
> 
> Suggested-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Since you seem to be using this to mean "is the platform locked down?",
this looks to be no longer complete in the UEFI 2.6 world.  If
DeployedMode == 0, even if SecureBoot == 1 and SetupMode == 0, you can
remove the platform key by writing 1 to AuditMode and gain control of
the secure variables.  The lock down state becomes DeployedMode == 1,
SecureBoot == 1 and SetupMode == 0

See the diagram on page 1817

http://www.uefi.org/sites/default/files/resources/UEFI%20Spec%202_6.pdf

James
