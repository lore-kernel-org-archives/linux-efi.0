From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] x86, efi: add efi_whitelist_table to use all efi
 variable storage
Date: Tue, 3 Dec 2013 05:04:50 +0000
Message-ID: <20131203050450.GA30967@srcf.ucam.org>
References: <528DD3E0.3050606@jp.fujitsu.com>
 <1385064722.12107.1.camel@x230>
 <528E9EB2.3060808@jp.fujitsu.com>
 <1385078632.12107.3.camel@x230>
 <528EF87D.4050300@jp.fujitsu.com>
 <528EF9CE.2070305@jp.fujitsu.com>
 <1385142450.2884.1.camel@x230>
 <529D4DF5.80502@jp.fujitsu.com>
 <25e63f3b748741998d2b3e04bbc53064@BN1PR05MB423.namprd05.prod.outlook.com>
 <529D62C0.2080400@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <529D62C0.2080400@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "matt.fleming@intel.com" <matt.fleming@intel.com>, "jlee@suse.com" <jlee@suse.com>, "matt@console-pimps.org" <matt@console-pimps.org>, "richard@nod.at" <richard@nod.at>, "cxie@redhat.com" <cxie@redhat.com>
List-Id: linux-efi@vger.kernel.org

On Tue, Dec 03, 2013 at 01:49:04PM +0900, Yasuaki Ishimatsu wrote:

> What boot service is the "boot services" in these sentences?

The environment prior to ExitBootServices() being called.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
