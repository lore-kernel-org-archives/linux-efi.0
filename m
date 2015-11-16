From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 01/12] mm/memblock: add MEMBLOCK_NOMAP attribute to memblock memory table
Date: Mon, 16 Nov 2015 21:33:47 +0100
Message-ID: <35E90006-1E43-4483-8B18-7123E12E68FF@linaro.org>
References: <1447698757-8762-1-git-send-email-ard.biesheuvel@linaro.org> <1447698757-8762-2-git-send-email-ard.biesheuvel@linaro.org> <20151116185859.GF8644@n2100.arm.linux.org.uk> <CAKv+Gu-COD0eSWqaTfV_QgCDEiBg5Af8FDVx+TMiYuVkqgTrvw@mail.gmail.com> <20151116194914.GK8644@n2100.arm.linux.org.uk>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151116194914.GK8644-l+eeeJia6m9vn6HldHNs0ANdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ryan Harkin <ryan.harkin-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>
List-Id: linux-efi@vger.kernel.org



> On 16 nov. 2015, at 20:49, Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org> wrote:
> 
>> On Mon, Nov 16, 2015 at 08:09:38PM +0100, Ard Biesheuvel wrote:
>> The main difference is that memblock_is_memory() still returns true
>> for the region. This is useful in some cases, e.g., to decide which
>> attributes to use when mapping.
> 
> Ok, so we'd need to switch to using memblock_is_map_memory() instead
> for pfn_valid() then.

Indeed, as is implemented by 10/12

> -- 
> FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
> according to speedtest.net.
