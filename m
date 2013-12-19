From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC PATCH 00/14] Support timezone of ACPI TAD and EFI TIME
Date: Thu, 19 Dec 2013 06:59:55 -0800
Message-ID: <52B309EB.90300@zytor.com>
References: <1387439053-8711-1-git-send-email-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1387439053-8711-1-git-send-email-jlee@suse.com>
Sender: linux-acpi-owner@vger.kernel.org
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Alessandro Zummo <a.zummo@towertech.it>, Matt Fleming <matt@console-pimps.org>, Matthew Garrett <matthew.garrett@nebula.com>
Cc: Elliott@hp.com, samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>, werner@suse.com, trenn@suse.de, JBeulich@suse.com, linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com, x86@kernel.org, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, linux-acpi@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>
List-Id: linux-efi@vger.kernel.org

On 12/18/2013 11:43 PM, Lee, Chun-Yi wrote:
> This patchset add the timezone support of ACPI TAD and EFI TIME, it
> also add codes for adjusting system time base on the timezone value
> from EFI TIME services when system boot.

EFI time is something we used to support and ripped out, because it
doesn't work well, *at all*.

I am hyper-skeptical to reintroducing them, and *definitely* will veto
reintroducing them on a system which has PNP0B0x devices present.

	-hpa

