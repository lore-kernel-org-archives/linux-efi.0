From: Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH V2 01/10] Secure boot: Add new capability
Date: Sat, 20 Oct 2012 10:02:32 +0100
Message-ID: <1350723752.2393.3.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
	 <1348152065-31353-2-git-send-email-mjg@redhat.com>
	 <1350692142.14835.46.camel@linux-s257.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1350692142.14835.46.camel@linux-s257.site>
Sender: linux-security-module-owner@vger.kernel.org
To: joeyli <jlee@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
List-Id: linux-efi@vger.kernel.org

On Sat, 2012-10-20 at 08:15 +0800, joeyli wrote:
> Hi Matt, 
> 
> Sorry for bother you!
> 
> I didn't see this Matthew's patchset merged in EFI git tree. Do you have
> plan to merge it? Or those patches need wait different subsystem leaders
> merge.

I don't think it makes sense for the secure boot patch series to go
through the EFI tree as it touches a lot of other subsystems.



