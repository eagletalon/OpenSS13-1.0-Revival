/*
 *	Prison shuttle -- prision shuttle control computer
 *
 *	TODO: Allow prision shuttle Z level to be adjusted more easily (marker on map)
 */

#define PRISON_SHUTTLE_Z 8			// Z level of the prison station


obj/machinery/computer/prison_shuttle
	name = "prison shuttle"
	icon = 'shuttle.dmi'
	icon_state = "shuttlecom"


	// Take off verb
	// Move the shuttle (and all objects in it) between station and prison Z level

	verb/take_off()
		set src in oview(1)

		if ((usr.stat || usr.restrained()))
			return
		src.add_fingerprint(usr)

		if (prison_entered)						// shuttle is at station
			var/A = locate(/area/shuttle)
			for(var/turf/T in A)
				if (T.z == 1)
					for(var/atom/movable/AM in T)
						AM.z = PRISON_SHUTTLE_Z
					var/turf/U = locate(T.x, T.y, PRISON_SHUTTLE_Z) 	// move to prison level
					U.oxygen = T.oxygen
					U.oldoxy = T.oldoxy
					U.tmpoxy = T.tmpoxy
					U.poison = T.poison
					U.oldpoison = T.oldpoison
					U.tmppoison = T.tmppoison
					U.co2 = T.co2
					U.oldco2 = T.oldco2
					U.tmpco2 = T.tmpco2
					del(T)
			prison_entered = null
		else if (!( prison_entered ))			// shuttle is at prision
			if (ticker.shuttle_location != 1)	// make sure emergency shuttle isn't at station
				var/A = locate(/area/shuttle_prison)
				for(var/turf/T in A)
					if (T.z == PRISON_SHUTTLE_Z)
						for(var/atom/movable/AM in T)
							AM.z = 1
						var/turf/U = locate(T.x, T.y, 1)	// move to station level
						U.oxygen = T.oxygen
						U.oldoxy = T.oldoxy
						U.tmpoxy = T.tmpoxy
						U.poison = T.poison
						U.oldpoison = T.oldpoison
						U.tmppoison = T.tmppoison
						U.co2 = T.co2
						U.oldco2 = T.oldco2
						U.tmpco2 = T.tmpco2
						del(T)
				prison_entered = 1
			else
				usr << "\blue There is an obstructing shuttle!"


	// Restabalize verb
	// Set all shuttle locations to standard atmosphere settings

	verb/restabalize()
		set src in oview(1)
		if ((usr.stat || usr.restrained()))
			return
		viewers(null, null) << "\red <B>Restabilizing prison shuttle atmosphere!</B>"
		var/A = locate(/area/shuttle_prison)
		for(var/obj/move/T in A)
			T.firelevel = 0
			T.oxygen = O2STANDARD
			T.oldoxy = O2STANDARD
			T.tmpoxy = O2STANDARD
			T.poison = 0
			T.oldpoison = 0
			T.tmppoison = 0
			T.co2 = 0
			T.oldco2 = 0
			T.tmpco2 = 0
			T.sl_gas = 0
			T.osl_gas = 0
			T.tsl_gas = 0
			T.n2 = N2STANDARD
			T.on2 = N2STANDARD
			T.tn2 = N2STANDARD
			T.temp = T20C
			T.otemp = T20C
			T.ttemp = T20C

		viewers(null, null) << "\red <B>Prison shuttle Restabilized!</B>"
		src.add_fingerprint(usr)
