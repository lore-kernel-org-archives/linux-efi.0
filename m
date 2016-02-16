From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] x86/efi: skip bgrt init for kexec reboot
Date: Tue, 16 Feb 2016 14:48:12 +0000
Message-ID: <20160216144812.GF2769@codeblueprint.co.uk>
References: <20160127112044.GA2961@dhcp-128-65.nay.redhat.com>
 <20160203214200.GA15110@dhcp-128-65.nay.redhat.com>
 <20160203225333.GA31246@codeblueprint.co.uk>
 <20160204100329.GA2586@codeblueprint.co.uk>
 <20160204110903.GA2977@dhcp-128-65.nay.redhat.com>
 <20160204115656.GB2586@codeblueprint.co.uk>
 <20160205004115.GA3651@dhcp-128-65.nay.redhat.com>
 <20160211160931.GL4134@codeblueprint.co.uk>
 <20160212124542.GA7051@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160212124542.GA7051@dhcp-128-65.nay.redhat.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Dave Young <dyoung@redhat.com>
Cc: linux-efi@vger.kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>, linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Josh Triplett <josh@joshtriplett.org>, Matthew Garrett <mjg59@srcf.ucam.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 12 Feb, at 08:45:42PM, Dave Young wrote:
> 
> Yes, rethink about this issue, how about something like below:

Let's put a pin this idea. I've got another approach that I want to
explore a little first. I'll send the patches out soon.
