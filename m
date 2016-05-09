From: Jon Masters <jcm@redhat.com>
Subject: Re: [RFC PATCH v2 07/10] efi: load SSTDs from EFI variables
Date: Mon, 9 May 2016 00:13:22 -0400
Message-ID: <da0e65ef-7c04-e274-2f15-a50daa8c4c8c@redhat.com>
References: <1461105548-20618-1-git-send-email-octavian.purdila@intel.com>
 <1461105548-20618-8-git-send-email-octavian.purdila@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461105548-20618-8-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Octavian Purdila <octavian.purdila@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Mark Brown <broonie@kernel.org>, Wolfram Sang <wsa@the-dreams.de>
Cc: Joel Becker <jlbec@evilplan.org>, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org, irina.tirdea@intel.com
List-Id: linux-efi@vger.kernel.org

Hi Octavian,

Apologies for missing this earlier, just catching up on this thread...

On 04/19/2016 06:39 PM, Octavian Purdila wrote:

> This patch allows SSDTs to be loaded from EFI variables. It works by
> specifying the EFI variable name containing the SSDT to be loaded. All
> variables with the same name (regardless of the vendor GUID) will be
> loaded.

This sounds very useful during development. However, and using EFI
variables isn't so terrible, but I am concerned that this should be
standardized through ASWG and at least involve certain other OS vendors
so that the variable (GUID) can be captured somewhere. If not in the
spec itself, then it should be captured as an external ACPI resource on
the UEFI website with a clear pointer to the exact IDs to be used.

Can you confirm that's the intention? i.e. that you're allowing a
command line option for specifying the ID now because you intend to go
ensure that there is a standard one that everyone will use later?

I should check (but maybe you know) if the kernel is automatically
tainted by this codepath as well?

Thanks,

Jon.

-- 
Computer Architect | Sent from my Fedora powered laptop
