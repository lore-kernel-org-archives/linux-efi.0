From: Maniaxx <tripleshiftone@gmail.com>
Subject: Re: PROBLEM: Kernel panic on EFI BGRT early init code (kernel
 4.11/4.12rc2) [regression]
Date: Sun, 4 Jun 2017 04:45:57 +0200
Message-ID: <d52020a7-21f8-0594-679d-54325235ca9f@gmail.com>
References: <86c36f9b-f633-3354-d676-7693f35dae0d@gmail.com>
 <20170526012342.GA3096@dhcp-128-65.nay.redhat.com>
 <a32eea98-9576-1ee7-c27a-b165204d825f@gmail.com>
 <20170527051427.GA3492@dhcp-128-65.nay.redhat.com>
 <20170527053457.GB3492@dhcp-128-65.nay.redhat.com>
 <df8e83f9-9362-b5b5-462d-b11980baac01@gmail.com>
 <20170601015621.GA4306@dhcp-128-65.nay.redhat.com>
 <e6d656c0-c76b-42c3-8413-0198efb8a33a@gmail.com>
 <20170602025155.GA3637@dhcp-128-65.nay.redhat.com>
 <c1505b0e-8136-86d3-e6ab-019c17106e5b@gmail.com>
 <4b651aea-0fcc-4f70-cf39-3a46393d2e28@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <4b651aea-0fcc-4f70-cf39-3a46393d2e28@gmail.com>
Content-Language: en-US
Sender: linux-acpi-owner@vger.kernel.org
To: linux-acpi@vger.kernel.org
Cc: linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

I've reverted 66dbe99cfe30e113d2e571e68b9b6a1a8985a157 from 
linux-git-4.11.r1.gaf8b4c0323e1 and it boots properly now indeed.

I've asked for some more BGRT dumps to get more image addresses:
https://bbs.archlinux.org/viewtopic.php?pid=1715699#p1715699

