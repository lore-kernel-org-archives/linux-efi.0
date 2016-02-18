From: "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH 1/2] ACPICA: Tables: Add function to remove ACPI tables
Date: Thu, 18 Feb 2016 21:15:28 +0100
Message-ID: <CAJZ5v0hAmCKc8Qn7sKQhdGhoAXH=zmXubx295K_Nbm9npOYzBw@mail.gmail.com>
References: <1455723910-16710-1-git-send-email-matt@codeblueprint.co.uk>
	<1455723910-16710-2-git-send-email-matt@codeblueprint.co.uk>
	<1AE640813FDE7649BE1B193DEA596E883BB4D2A6@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E883BB4D2A6@SHSMSX101.ccr.corp.intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: "Zheng, Lv" <lv.zheng@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>
Cc: Dave Young <dyoung@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "kexec@lists.infradead.org" <kexec@lists.infradead.org>, "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>, Josh Triplett <josh@joshtriplett.org>, Borislav Petkov <bp@alien8.de>, Matthew Garrett <mjg59@srcf.ucam.org>, Vivek Goyal <vgoyal@redhat.com>
List-Id: linux-efi@vger.kernel.org

On Thu, Feb 18, 2016 at 3:34 AM, Zheng, Lv <lv.zheng@intel.com> wrote:
> Hi,
>
>> From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-
>> owner@vger.kernel.org] On Behalf Of Matt Fleming
> [Lv Zheng]
> First, is it possible for you to submit an ACPICA patch instead of a Linux patch.
> The reasoning for doing this can be found at:
> https://acpica.org/Licensing

Actually, the reason is that, as a rule, the process for ACPICA
patches is that they first go to upstream ACPICA and they are acquired
by Linux from there.

While there are some exceptions from that process, there also are good
reasons for that process to be followed, including the licensing one
mentioned by Lv.

All that said, Matt, if you agree that the patch can be applied under
the BSD license, I think we can offer help with converting it to the
upstream ACPICA coding conventions and applying it there.  Lv, would
you be able to take care of that?

Thanks,
Rafael
