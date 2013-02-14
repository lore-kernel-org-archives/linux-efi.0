From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] efi: Clear EFI_RUNTIME_SERVICES rather than EFI_BOOT
 by "noefi" boot parameter
Date: Wed, 13 Feb 2013 17:20:30 -0800
Message-ID: <511C3BDE.5060503@zytor.com>
References: <511C2C04.2070108@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <511C2C04.2070108@jp.fujitsu.com>
Sender: stable-owner@vger.kernel.org
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, linux EFI ml <linux-efi@vger.kernel.org>, Matt Fleming <matt.fleming@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-stable ml <stable@vger.kernel.org>, linux x86 ml <x86@kernel.org>, David Airlie <airlied@linux.ie>, Corentin Chary <corentincj@iksaif.net>, Matthew Garrett <mjg59@srcf.ucam.org>, Dave Jiang <dave.jiang@intel.com>, Olof Johansson <olof@lixom.net>, Peter Jones <pjones@redhat.com>, Colin Ian King <colin.king@canonical.com>, Steve Langasek <steve.langasek@canonical.com>, Tony Luck <tony.luck@intel.com>, Konrad Rzeszutek Wilk <konrad@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
List-Id: linux-efi@vger.kernel.org

On 02/13/2013 04:12 PM, Satoru Takeuchi wrote:
> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> 
> There was a serious problem in samsung-laptop that its platform driver is
> designed to run under BIOS and running under EFI can cause the machine to
> become bricked or can cause Machine Check Exceptions.
> 

Matt, unless you object I'll pick this one up as urgent, please take the
cleanup patch in normal order.

	-hpa
